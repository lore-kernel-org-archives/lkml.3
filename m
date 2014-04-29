Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895AbaD2JV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 05:21:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:48041 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbaD2JVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 05:21:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,950,1389772800"; 
   d="scan'208";a="425284072"
Date: Tue, 29 Apr 2014 17:21:42 -0400
From: Zhuang Jin Can <jin.can.zhuang@intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: dwc3: debugfs: add snapshot to dump requests trbs
 events
Message-ID: <20140429212142.GA25710@intel.com>
Reply-To: jin.can.zhuang@intel.com
References: <20140428204923.GC12185@intel.com>
 <20140428155536.GE30292@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140428155536.GE30292@saruman.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 10:55:36AM -0500, Felipe Balbi wrote:
> On Mon, Apr 28, 2014 at 04:49:23PM -0400, Zhuang Jin Can wrote:
> > Adds a debugfs file "snapshot" to dump dwc3 requests, trbs and events.
> 
> you need to explain what are you trying to provide to our users here.
> 
> What "problem" are you trying to solve ?
> 
The interface enables users to easily peek into requests, trbs and
events to know the current transfer state of each request.
If an transfer is stuck, user can use the interface to check why it's
stuck (e.g. Is it because a gadget doesn't queued the request? Or it's
queued but it's not primed to the controller? Or It's primed to the
controller but the TRBs and events indicate the transfer never completes?).
User can immediately narrow down the issue without enabling verbose log or
reproduce the issue again. It's helpful when we need to deal with some
hard-to-reproduce bugs or timing sensitive bugs can't be reproduced with
verbose log enabled.

> > As ep0 requests are more complex than others. It's not included in this
> > patch.
> 
> For ep0, you could at least print the endpoint phase we are currently
> in and if we have requests in flight or not.
> 
Agree. Will add it in [PATCH v2].

> > Signed-off-by: Zhuang Jin Can <jin.can.zhuang@intel.com>
> > ---
> >  drivers/usb/dwc3/core.h    |    4 +
> >  drivers/usb/dwc3/debugfs.c |  192 ++++++++++++++++++++++++++++++++++++++++++++
> >  drivers/usb/dwc3/gadget.h  |   41 ++++++++++
> >  3 files changed, 237 insertions(+)
> > 
> > diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
> > index 57332e3..9d04ddd 100644
> > --- a/drivers/usb/dwc3/core.h
> > +++ b/drivers/usb/dwc3/core.h
> > @@ -849,6 +849,10 @@ struct dwc3_event_devt {
> >  	u32	type:4;
> >  	u32	reserved15_12:4;
> >  	u32	event_info:9;
> > +
> > +#define DEVT_EVTINFO_SUPERSPEED	(1 << 4)
> > +#define DEVT_EVTINFO_HIRD(n)	(((n) & (0xf << 5)) >> 5)
> > +
> >  	u32	reserved31_25:7;
> >  } __packed;
> >  
> > diff --git a/drivers/usb/dwc3/debugfs.c b/drivers/usb/dwc3/debugfs.c
> > index 9ac37fe..078d147 100644
> > --- a/drivers/usb/dwc3/debugfs.c
> > +++ b/drivers/usb/dwc3/debugfs.c
> > @@ -618,6 +618,191 @@ static const struct file_operations dwc3_link_state_fops = {
> >  	.release		= single_release,
> >  };
> >  
> > +static void dwc3_dump_requests(struct seq_file *s, struct list_head *head,
> > +					const char *list_name)
> > +{
> > +	struct dwc3_request	*req;
> > +
> > +	if (list_empty(head)) {
> > +		seq_printf(s, "list %s is empty\n", list_name);
> > +		return;
> > +	}
> > +
> > +	seq_printf(s, "list %s:\n", list_name);
> > +	list_for_each_entry(req, head, list) {
> > +		struct usb_request *request = &req->request;
> > +
> > +		seq_printf(s, "usb_request@0x%p: buf@0x%p(dma@0x%pad), len=%d\n",
> > +			request, request->buf, &request->dma,
> > +			request->length);
> > +
> > +		if (req->queued)
> > +			seq_printf(s, "\tstatus=%d: actual=%d; start_slot=%u: trb@0x%p(dma@0x%pad)\n",
> > +				request->status, request->actual,
> > +				req->start_slot, req->trb,
> > +				&req->trb_dma);
> > +	}
> > +}
> > +
> > +static void dwc3_dump_trbs(struct seq_file *s, struct dwc3_ep *dep)
> > +{
> > +	struct dwc3_trb	*trb;
> > +	int i;
> > +
> > +	seq_printf(s, "busy_slot = %u, free_slot = %u\n",
> > +				dep->busy_slot & DWC3_TRB_MASK,
> > +				dep->free_slot & DWC3_TRB_MASK);
> > +
> > +	for (i = 0; i < DWC3_TRB_NUM; i++) {
> > +		trb = &dep->trb_pool[i];
> > +		if (i == (dep->busy_slot & DWC3_TRB_MASK)) {
> 
> I really dislike these Yoda Conditionals. Fix this up.
> 
Agree. Will fix it in [PATCH v2].

> > +			seq_puts(s, "busy_slot--|\n");
> > +			seq_puts(s, "           \\\n");
> > +		}
> > +		if (i == (dep->free_slot & DWC3_TRB_MASK)) {
> > +			seq_puts(s, "free_slot--|\n");
> > +			seq_puts(s, "           \\\n");
> > +		}
> > +		seq_printf(s, "trb[%02d](dma@0x%pad): %08x(bpl), %08x(bph), %08x(size), %08x(ctrl)\n",
> 
> I'm not sure you need to print out the TRB address. bpl, bph, size and
> ctrl are desired though.
> 
printing out the TRB DMA address helps user to locate the start TRB of a
request. I admit that we can achive the same purose using the "start_slot"
of the request. I'll remove it in [PATCH v2].

> > +			i, &dep->trb_pool_dma + i * sizeof(*trb),
> > +			trb->bpl, trb->bph, trb->size, trb->ctrl);
> 
> this will be pretty difficult to parse by a human. I would rather see
> you creating one directory per TRB (and also one directory per
> endpoint) which holds the details for that entity, so that it looks
> like:
> 
> dwc3
> |-- current_state	(or perhaps a better name, but snapshot isn't very good either)
Actually, it's hard to find a perfect name. "current_state" or "snapshot" doesn't
make too much difference to me. If "current_state" makes more sense to you, I
can change to use this name. Or let me know if you have a better suggestion.

>     |-- ep2
>     |   |-- direction
>     |   |-- maxpacket
>     |   |-- number
>     |   |-- state
>     |   |-- stream_capable
>     |   |-- type
>     |   |-- trbs
>     |   |   |-- trb0
>     |   |   |   |-- bph
>     |   |   |   |-- bpl
>     |   |   |   |-- ctrl
>     |   |   |   |-- size
>     |   |   |-- trb1
>     |   |   |   |-- bph
>     |   |   |   |-- bpl
>     |   |   |   |-- ctrl
>     |   |   |   |-- size
>     |   |   |-- trb2
>     |   |   |   |-- bph
>     |   |   |   |-- bpl
>     |   |   |   |-- ctrl
>     |   |   |   |-- size
>     |   |   |-- trb3
>     |   |   |   |-- bph
>     |   |   |   |-- bpl
>     |   |   |   |-- ctrl
>     |   |   |   |-- size
>     .   .   .
>     .   .   .
>     .   .   .
>     |   |-- request0
>     |   |   |-- direction
>     |   |   |-- mapped
>     |   |   |-- queued
>     |   |   |-- trb0	(symlink to actual trb directory)
>     |   |   |-- ep2		(symlink to actual ep2 directory)
>     |   |   |-- usbrequest
>     |   |       |-- actual
>     |   |       |-- length
>     |   |       |-- no_interrupt
>     |   |       |-- num_mapped_sgs
>     |   |       |-- num_sgs
>     |   |       |-- short_not_ok
>     |   |       |-- status
>     |   |       |-- stream_id
>     |   |       |-- zero
>     |   |-- request1
>     |   |   |-- direction
>     |   |   |-- mapped
>     |   |   |-- queued
>     |   |   |-- trb1	(symlink to actual trb directory)
>     |   |   |-- ep2		(symlink to actual ep2 directory)
>     |   |   |-- usbrequest
>     |   |       |-- actual
>     |   |       |-- length
>     |   |       |-- no_interrupt
>     |   |       |-- num_mapped_sgs
>     |   |       |-- num_sgs
>     |   |       |-- short_not_ok
>     |   |       |-- status
>     |   |       |-- stream_id
>     |   |       |-- zero
>     .   .   .   .
>     .   .   .   .
>     .   .   .   .
> 
> 
> and so forth. That way we get a structured view of everything the
> controller and the driver are managing.
> 
The patch intends to dump the most important RUNTIME information the driver is
dealing with the controller, STATIC information is not valuable here as we can
get them before running. I consider information like "direction", "maxpactsize",
"types" are STATIC, as they're not going to change once they are configured.
Dumping everying is not the intention of the patch. (Sorry that the name
"snapshot" confused you and I didn't describe the intention well).

So are you suggesting to organize the information in multiple debugfs
directories and files or just to print information with appropriate indents so that
users can easily read it? IMO, organizing them in multiple files makes
it impossible for the user to lock dwc3->lock and get information
atomically. The problem of reading them separately is that it won't give
you the consistent information regarding the current transfer state.

> > +static void dwc3_dump_dev_event(struct seq_file *s,
> > +			const struct dwc3_event_devt *event)
> > +{
> > +	seq_puts(s, "[0]DEV ");
> > +	seq_printf(s, "[1:7]%s ",
> > +		event->device_event == DWC3_EVENT_TYPE_DEV ? "TYPE_DEV" :
> > +		event->device_event == DWC3_EVENT_TYPE_CARKIT ? "TYPE_CARKIT" :
> > +		event->device_event == DWC3_EVENT_TYPE_I2C ? "TYPE_CARKIT" :
> > +		"TYPE_UNKOWN");
> > +	seq_printf(s, "[8:11]%s ", dwc3_gadget_event_string(event->type));
> > +
> > +	if (event->type == DWC3_DEVICE_EVENT_LINK_STATUS_CHANGE ||
> > +		event->type == DWC3_DEVICE_EVENT_HIBER_REQ) {
> > +
> > +		seq_printf(s, "[16:20]%s %s ",
> > +			dwc3_link_state_string(
> > +				event->event_info & DEVT_EVTINFO_SUPERSPEED,
> > +				event->event_info & DWC3_LINK_STATE_MASK),
> > +				event->event_info & DEVT_EVTINFO_SUPERSPEED ?
> > +				"SS" : "HS");
> > +
> > +		if (!(event->event_info & DEVT_EVTINFO_SUPERSPEED))
> > +			seq_printf(s, "[21:24]HIRD %u ",
> > +				DEVT_EVTINFO_HIRD(event->event_info));
> > +	}
> > +}
> > +
> > +static void dwc3_dump_ep_event(struct seq_file *s,
> > +			const struct dwc3_event_depevt *event)
> > +{
> > +	seq_puts(s, "[0]EP ");
> > +	seq_printf(s, "[1:5]ep%d ", event->endpoint_number);
> > +	seq_printf(s, "[6:9]%s ",
> > +		dwc3_ep_event_string(event->endpoint_event));
> > +
> > +	switch (event->endpoint_event) {
> > +	case DWC3_DEPEVT_XFERCOMPLETE:
> > +	case DWC3_DEPEVT_XFERINPROGRESS:
> > +		if (event->status & DEPEVT_STATUS_BUSERR)
> > +			seq_puts(s, "[12]BUSERR ");
> > +		if (event->status & DEPEVT_STATUS_SHORT)
> > +			seq_puts(s, "[13]SHORT ");
> > +		if (event->status & DEPEVT_STATUS_IOC)
> > +			seq_puts(s, "[14]IOC ");
> > +		if (event->status & DEPEVT_STATUS_LST)
> > +			seq_puts(s, "[15]LST ");
> > +		break;
> > +	case DWC3_DEPEVT_XFERNOTREADY:
> > +		if ((event->status & 0x3) == 1)
> > +			seq_puts(s, "[12:13]Data_Stage ");
> > +		else if ((event->status & 0x3) == 2)
> > +			seq_puts(s, "[12:13]Status_Stage ");
> > +		if (event->status & DEPEVT_STATUS_TRANSFER_ACTIVE)
> > +			seq_puts(s, "[15]XferActive ");
> > +		else
> > +			seq_puts(s, "[15]XferNotActive ");
> > +		break;
> > +	case DWC3_DEPEVT_EPCMDCMPLT:
> > +		if (event->status & BIT(0))
> > +			seq_puts(s, "[12:15]Invalid Transfer Resource ");
> > +		break;
> > +	default:
> > +		seq_puts(s, "[12:15]UNKOWN ");
> > +	}
> > +	seq_printf(s, "[16:31]PARAM 0x%04x ", event->parameters);
> > +}
> > +
> > +static void dwc3_dump_event_buf(struct seq_file *s,
> > +			struct dwc3_event_buffer *evt)
> > +{
> > +	union dwc3_event	event;
> > +	int			i;
> > +
> > +	seq_printf(s, "evt->buf@0x%p(dma@0x%pad), length=%u, lpos=%u, count=%u, flags=%s\n",
> > +		evt->buf, &evt->dma,
> > +		evt->length, evt->lpos, evt->count,
> > +		evt->flags & DWC3_EVENT_PENDING ? "pending" : "0");
> > +
> > +	for (i = 0; i < evt->length; i += 4) {
> > +		event.raw = *(u32 *) (evt->buf + i);
> > +		if (i == evt->lpos) {
> > +			seq_puts(s, "lpos-------|\n");
> > +			seq_puts(s, "           \\\n");
> > +		}
> > +		seq_printf(s, "event[%d]: %08x ", i, event.raw);
> > +
> > +		if (event.type.is_devspec)
> > +			dwc3_dump_dev_event(s, &event.devt);
> > +		else
> > +			dwc3_dump_ep_event(s, &event.depevt);
> > +		seq_puts(s, "\n");
> > +	}
> 
> how well have you tested this ? I'm not entirely sure you should be
> reading the event buffer at any time you want, though I might be wrong.
> 
> It's still a bit easier to reproduce part of the event handling here. I
> think it's best to make a choice of caching the last 5 events in a ring
> buffer and provide a helper for IRQ handlers to push events into the
> ring buffer, then from here you just iterate over that ring buffer
> instead of accessing our actual event buffer.
> 
Thanks Paul Zimmerman and you for reminding me that fact that controller
may write to the event buffers when we're reading them.

Instead of trying to make things perfect and complex, the interface is just
to dump the events while leaving the responsibilty to developers to judge
if the events are reliable.
Developer should be able to sense if the data is reliable depending on when he
dumps the data. If a transfer is stuck and controller doesn't generate anymore
events, then the data is reliable, and this is the main senario this patch wants
to handle. If a transfer is stuck but controller keeps generating events due to
other transfers, there's nothing we can do about it, as the new events will
quickly overwrite the ring, and developer will know the events are not valuable.
If you dump the events when all transfers are still on-going, it just provides
you some a history of the events to sense how it looks like, and you
know the data might not be reliable. And this usage is not really helpful
for debugging or not used at all, as you should have no intereset to
check the events if everythings goes well.
I think above is acceptable for debugging purpose, it's simple without
introducing any overhead or timing effect.

> Also note that we can hold up to 64 events in our event buffer so this
> call could take a looooooot of time to complete and you probably don't
> need all that information anyway because you can get them by just
> enabling VERBOSE_DEBUG on dwc3 and capturing the entire driver behavior
> on dmesg.
> 
Even though a user may be scared by the lots of events, when a failure happens,
he actually wants to read as many events as he can to see what happened
before the failure. 5 events is not enough, user can at most only see one
or two transfers through these 5 events or nothing if the last few
events are generated from other transfers which are unrelated to the
failure. The time to dump the events doesn't matter as it's for debugging and
most often usage is after a transfer is stuck.

> > +static int dwc3_snapshot_show(struct seq_file *s, void *unused)
> > +{
> > +	struct dwc3		*dwc = s->private;
> > +	unsigned long		flags;
> > +	int			i;
> > +
> > +	spin_lock_irqsave(&dwc->lock, flags);
> > +	for (i = 2; i < DWC3_ENDPOINTS_NUM; i++) {
> 
> some platforms don't have all 32 physical endpoints, we just had a bug
> fix for that, see commit 32702e9.
> 
Will fix it as below:
	for (i = 2; i < DWC3_ENDPOINTS_NUM; i++) {
		struct dwc3_ep	*dep = dwc->eps[i];

		if (!dep || !(dep->flags & DWC3_EP_ENABLED))
			continue;
		
> > +		struct dwc3_ep	*dep = dwc->eps[i];
> > +
> > +		if (!(dep->flags & DWC3_EP_ENABLED))
> > +			continue;
> > +
> > +		seq_printf(s, "[%s]\n", dep->name);
> > +		dwc3_dump_requests(s, &dep->request_list, "request_list");
> > +		dwc3_dump_requests(s, &dep->req_queued, "req_queued");
> > +		if (!list_empty(&dep->req_queued))
> > +			dwc3_dump_trbs(s, dep);
> > +		seq_puts(s, "\n");
> > +	}
> > +
> > +	for (i = 0; i < dwc->num_event_buffers; i++)
> > +		dwc3_dump_event_buf(s, dwc->ev_buffs[i]);
> > +	spin_unlock_irqrestore(&dwc->lock, flags);
> > +
> > +	return 0;
> > +}
> > +
> > +static int dwc3_snapshot_open(struct inode *inode, struct file *file)
> > +{
> > +	return single_open(file, dwc3_snapshot_show, inode->i_private);
> > +}
> > +
> > +static const struct file_operations dwc3_snapshot_fops = {
> > +	.open			= dwc3_snapshot_open,
> > +	.read			= seq_read,
> > +	.llseek			= seq_lseek,
> > +	.release		= single_release,
> > +};
> > +
> >  int dwc3_debugfs_init(struct dwc3 *dwc)
> >  {
> >  	struct dentry		*root;
> > @@ -672,6 +857,13 @@ int dwc3_debugfs_init(struct dwc3 *dwc)
> >  			ret = -ENOMEM;
> >  			goto err1;
> >  		}
> > +
> > +		file = debugfs_create_file("snapshot", S_IRUGO, root,
> > +				dwc, &dwc3_snapshot_fops);
> > +		if (!file) {
> > +			ret = -ENOMEM;
> > +			goto err1;
> > +		}
> >  	}
> >  
> >  	return 0;
> > diff --git a/drivers/usb/dwc3/gadget.h b/drivers/usb/dwc3/gadget.h
> > index a0ee75b..f589323 100644
> > --- a/drivers/usb/dwc3/gadget.h
> > +++ b/drivers/usb/dwc3/gadget.h
> > @@ -120,6 +120,8 @@ static inline const char *dwc3_gadget_event_string(u8 event)
> >  		return "Link Status Change";
> >  	case DWC3_DEVICE_EVENT_WAKEUP:
> >  		return "WakeUp";
> > +	case DWC3_DEVICE_EVENT_HIBER_REQ:
> > +		return "Hibernation Request";
> 
> this should be in a separate patch.
> 
Agree. Will add it in a another patch.

> >  	case DWC3_DEVICE_EVENT_EOPF:
> >  		return "End-Of-Frame";
> >  	case DWC3_DEVICE_EVENT_SOF:
> > @@ -159,4 +161,43 @@ static inline const char *dwc3_ep_event_string(u8 event)
> >  	return "UNKNOWN";
> >  }
> >  
> > +/**
> > + * dwc3_link_state_string - returns link state
> > + * @link_state: the link state code
> > + */
> > +static inline const char *dwc3_link_state_string(u8 is_ss, u8 link_state)
> > +{
> > +	switch (link_state) {
> > +	case DWC3_LINK_STATE_U0:
> > +		return is_ss ? "U0" : "L0";
> > +	case DWC3_LINK_STATE_U1:
> > +		return "U1";
> > +	case DWC3_LINK_STATE_U2:
> > +		return is_ss ? "U2" : "L1";
> > +	case DWC3_LINK_STATE_U3:
> > +		return is_ss ? "U3" : "L2";
> > +	case DWC3_LINK_STATE_SS_DIS:
> > +		return is_ss ? "SS.Disabled" : "L3";
> > +	case DWC3_LINK_STATE_RX_DET:
> > +		return is_ss ? "Rx.Detect" : "Early_Suspend";
> > +	case DWC3_LINK_STATE_SS_INACT:
> > +		return "SS.Inactive";
> > +	case DWC3_LINK_STATE_POLL:
> > +		return "Poll";
> > +	case DWC3_LINK_STATE_RECOV:
> > +		return "Recovery";
> > +	case DWC3_LINK_STATE_HRESET:
> > +		return "HRESET";
> > +	case DWC3_LINK_STATE_CMPLY:
> > +		return "Compliance";
> > +	case DWC3_LINK_STATE_LPBK:
> > +		return "Loopback";
> > +	case DWC3_LINK_STATE_RESET:
> > +		return "Reset";
> > +	case DWC3_LINK_STATE_RESUME:
> > +		return "Resume";
> > +	}
> 
> should be part of a separate patch, also I recently added my version of
> this, see the archives (although I didn't care for differentiating U0
> from L0 depending on speed, but that's not really a big deal IMO).
> 
Agree. I'll remove this change and rebase on your change.

Thanks
Jincan



