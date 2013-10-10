Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab3JJC0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 22:26:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:14843 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318Ab3JJC0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 22:26:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1068,1371106800"; 
   d="scan'208";a="416952608"
Subject: Re: [PATCH] xhci-hub.c: handle command_trb that may be link TRB
From: Xiao Jin <jin.xiao@intel.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
        a.p.zijlstra@chello.nl, rusty@rustcorp.com.au,
        william.douglas@intel.com, sboyd@codeaurora.org, jslaby@suse.cz
In-Reply-To: <20131009201846.GA8222@xanatos>
References: <1381282956.9531.14.camel@xiaojin>
	 <20131009201846.GA8222@xanatos>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Oct 2013 10:37:33 +0800
Message-ID: <1381372653.9531.120.camel@xiaojin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sarah,

Thanks for the reminding. The kernel base of the patch is k3.10, I
didn't notice k3.12 commit ec7e43e2d98173483866fe2e4e690143626b659c at
that time. I will backport the patch from k3.12 for use.

As you mentioned in another email, we meet with dpm timeout when xhci
suspend, the root cause are what the patch aimed to solve. FYI.

On Wed, 2013-10-09 at 13:18 -0700, Sarah Sharp wrote:
> Hi Xiao,
> 
> Thanks for taking the time to submit this patch.  Comments below.
> 
> On Wed, Oct 09, 2013 at 09:42:36AM +0800, Xiao Jin wrote:
> > From: xiao jin <jin.xiao@intel.com>
> > Date: Wed, 9 Oct 2013 09:38:45 +0800
> > Subject: [PATCH] xhci-hub.c: handle command_trb that may be link TRB
> 
> I won't be able to apply your patch  because it has these extra lines in
> the body ^^^.  I suspect you used `git format-patch` to produce this,
> and then tried to copy-paste it into your mail client?  You can't do
> that, because your mail client will probably word-wrap your patch, and
> possibly turn tabs into spaces.  You need to use `git send-email`
> instead to send your patches.
> 
> > When xhci stop device, it's possible cmd_ring enqueue point to
> > link TRB after queue the last but one stop endpoint. We must
> > handle the command_trb point to the next segment trb. Otherwise
> > xhci stop devie will timeout because command_trb can't match
> > with cmd_ring dequeue.
> > 
> > The patch is to let command_trb point to the next segment trb if
> > cmd_ring enqueue point to link TRB.
> > 
> > Signed-off-by: xiao jin <jin.xiao@intel.com>
> > ---
> >  drivers/usb/host/xhci-hub.c |    7 +++++++
> >  1 files changed, 7 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
> > index 1d35459..4872640 100644
> > --- a/drivers/usb/host/xhci-hub.c
> > +++ b/drivers/usb/host/xhci-hub.c
> > @@ -287,6 +287,13 @@ static int xhci_stop_device(struct xhci_hcd *xhci, int slot_id, int suspend)
> >  			xhci_queue_stop_endpoint(xhci, slot_id, i, suspend);
> >  	}
> >  	cmd->command_trb = xhci->cmd_ring->enqueue;
> > +	/* Enqueue pointer can be left pointing to the link TRB,
> > +	 * we must handle that
> > +	 */
> > +	if (TRB_TYPE_LINK_LE32(cmd->command_trb->link.control))
> > +		cmd->command_trb =
> > +			xhci->cmd_ring->enq_seg->next->trbs;
> > +
> >  	list_add_tail(&cmd->cmd_list, &virt_dev->cmd_list);
> >  	xhci_queue_stop_endpoint(xhci, slot_id, 0, suspend);
> >  	xhci_ring_cmd_db(xhci);
> 
> What kernel version or tree is it against?  I ask because there's
> already a fix in the 3.12-rc4 kernel for this:
> 
> static int xhci_stop_device(struct xhci_hcd *xhci, int slot_id, int suspend)
> {
> ...
>         spin_lock_irqsave(&xhci->lock, flags);
>         for (i = LAST_EP_INDEX; i > 0; i--) {
>                 if (virt_dev->eps[i].ring && virt_dev->eps[i].ring->dequeue)
>                         xhci_queue_stop_endpoint(xhci, slot_id, i, suspend);
>         }
>         cmd->command_trb = xhci_find_next_enqueue(xhci->cmd_ring);
> ...
> 
> Where xhci_find_next_enqueue is defined as:
> 
> union xhci_trb *xhci_find_next_enqueue(struct xhci_ring *ring)
> {
>         /* Enqueue pointer can be left pointing to the link TRB,
>          * we must handle that
>          */
>         if (TRB_TYPE_LINK_LE32(ring->enqueue->link.control))
>                 return ring->enq_seg->next->trbs;
>         return ring->enqueue;
> }
> 
> That was added in commit ec7e43e2d98173483866fe2e4e690143626b659c "xhci:
> Ensure a command structure points to the correct trb on the command
> ring"  It's in (or should be in soon) the stable kernels as well.
> 
> Sarah Sharp


