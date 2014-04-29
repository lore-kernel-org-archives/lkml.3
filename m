Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163AbaD2QKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 12:10:52 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33257 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbaD2QKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 12:10:50 -0400
Date: Tue, 29 Apr 2014 11:10:42 -0500
From: Felipe Balbi <balbi@ti.com>
To: Zhuang Jin Can <jin.can.zhuang@intel.com>
CC: Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: debugfs: add snapshot to dump requests trbs
 events
Message-ID: <20140429161042.GD633@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140428204923.GC12185@intel.com>
 <20140428155536.GE30292@saruman.home>
 <20140429212142.GA25710@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a2FkP9tdjPU2nyhF"
Content-Disposition: inline
In-Reply-To: <20140429212142.GA25710@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--a2FkP9tdjPU2nyhF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Apr 29, 2014 at 05:21:42PM -0400, Zhuang Jin Can wrote:
> On Mon, Apr 28, 2014 at 10:55:36AM -0500, Felipe Balbi wrote:
> > On Mon, Apr 28, 2014 at 04:49:23PM -0400, Zhuang Jin Can wrote:
> > > Adds a debugfs file "snapshot" to dump dwc3 requests, trbs and events.
> >=20
> > you need to explain what are you trying to provide to our users here.
> >=20
> > What "problem" are you trying to solve ?
> >=20
> The interface enables users to easily peek into requests, trbs and
> events to know the current transfer state of each request.
> If an transfer is stuck, user can use the interface to check why it's
> stuck (e.g. Is it because a gadget doesn't queued the request? Or it's
> queued but it's not primed to the controller? Or It's primed to the
> controller but the TRBs and events indicate the transfer never completes?=
).
> User can immediately narrow down the issue without enabling verbose log or
> reproduce the issue again. It's helpful when we need to deal with some
> hard-to-reproduce bugs or timing sensitive bugs can't be reproduced with
> verbose log enabled.

this should be part of the commit log in some shape or form.

> > > As ep0 requests are more complex than others. It's not included in th=
is
> > > patch.
> >=20
> > For ep0, you could at least print the endpoint phase we are currently
> > in and if we have requests in flight or not.
> >=20
> Agree. Will add it in [PATCH v2].

tks

> > > +			seq_puts(s, "busy_slot--|\n");
> > > +			seq_puts(s, "           \\\n");
> > > +		}
> > > +		if (i =3D=3D (dep->free_slot & DWC3_TRB_MASK)) {
> > > +			seq_puts(s, "free_slot--|\n");
> > > +			seq_puts(s, "           \\\n");
> > > +		}
> > > +		seq_printf(s, "trb[%02d](dma@0x%pad): %08x(bpl), %08x(bph), %08x(s=
ize), %08x(ctrl)\n",
> >=20
> > I'm not sure you need to print out the TRB address. bpl, bph, size and
> > ctrl are desired though.
> >=20
> printing out the TRB DMA address helps user to locate the start TRB of a
> request. I admit that we can achive the same purose using the "start_slot"
> of the request. I'll remove it in [PATCH v2].

thanks

> > > +			i, &dep->trb_pool_dma + i * sizeof(*trb),
> > > +			trb->bpl, trb->bph, trb->size, trb->ctrl);
> >=20
> > this will be pretty difficult to parse by a human. I would rather see
> > you creating one directory per TRB (and also one directory per
> > endpoint) which holds the details for that entity, so that it looks
> > like:
> >=20
> > dwc3
> > |-- current_state	(or perhaps a better name, but snapshot isn't very go=
od either)
> Actually, it's hard to find a perfect name. "current_state" or "snapshot"=
 doesn't
> make too much difference to me. If "current_state" makes more sense to yo=
u, I
> can change to use this name. Or let me know if you have a better suggesti=
on.

the name is important as we will have to deal with it for the next 50
years. We also need to think about someone starting out on dwc3 5 years
=66rom now or a QA engineer in whatever OEM trying to provide details of
the failure for the development team. It needs to be well thought out.

I don't have a better idea but snapshot gives me the idea that we will
end up with a copy of everything which we can revisit at any time and
that's not true. If we read this file twice there's no guarantee it'll
contain the same information.

> >     |-- ep2
> >     |   |-- direction
> >     |   |-- maxpacket
> >     |   |-- number
> >     |   |-- state
> >     |   |-- stream_capable
> >     |   |-- type
> >     |   |-- trbs
> >     |   |   |-- trb0
> >     |   |   |   |-- bph
> >     |   |   |   |-- bpl
> >     |   |   |   |-- ctrl
> >     |   |   |   |-- size
> >     |   |   |-- trb1
> >     |   |   |   |-- bph
> >     |   |   |   |-- bpl
> >     |   |   |   |-- ctrl
> >     |   |   |   |-- size
> >     |   |   |-- trb2
> >     |   |   |   |-- bph
> >     |   |   |   |-- bpl
> >     |   |   |   |-- ctrl
> >     |   |   |   |-- size
> >     |   |   |-- trb3
> >     |   |   |   |-- bph
> >     |   |   |   |-- bpl
> >     |   |   |   |-- ctrl
> >     |   |   |   |-- size
> >     .   .   .
> >     .   .   .
> >     .   .   .
> >     |   |-- request0
> >     |   |   |-- direction
> >     |   |   |-- mapped
> >     |   |   |-- queued
> >     |   |   |-- trb0	(symlink to actual trb directory)
> >     |   |   |-- ep2		(symlink to actual ep2 directory)
> >     |   |   |-- usbrequest
> >     |   |       |-- actual
> >     |   |       |-- length
> >     |   |       |-- no_interrupt
> >     |   |       |-- num_mapped_sgs
> >     |   |       |-- num_sgs
> >     |   |       |-- short_not_ok
> >     |   |       |-- status
> >     |   |       |-- stream_id
> >     |   |       |-- zero
> >     |   |-- request1
> >     |   |   |-- direction
> >     |   |   |-- mapped
> >     |   |   |-- queued
> >     |   |   |-- trb1	(symlink to actual trb directory)
> >     |   |   |-- ep2		(symlink to actual ep2 directory)
> >     |   |   |-- usbrequest
> >     |   |       |-- actual
> >     |   |       |-- length
> >     |   |       |-- no_interrupt
> >     |   |       |-- num_mapped_sgs
> >     |   |       |-- num_sgs
> >     |   |       |-- short_not_ok
> >     |   |       |-- status
> >     |   |       |-- stream_id
> >     |   |       |-- zero
> >     .   .   .   .
> >     .   .   .   .
> >     .   .   .   .
> >=20
> >=20
> > and so forth. That way we get a structured view of everything the
> > controller and the driver are managing.
> >=20
> The patch intends to dump the most important RUNTIME information the driv=
er is
> dealing with the controller, STATIC information is not valuable here as w=
e can
> get them before running. I consider information like "direction", "maxpac=
tsize",
> "types" are STATIC, as they're not going to change once they are configur=
ed.

they are still important and easy enough to print out. Sometimes
direction is the key information for a debug session. For example if a
Bulk OUT transaction of length 2000 never completes we *know* the reason
why.

We know OUT endpoints can't handle transfers which are not aligned to
wMaxPacketSize.

> Dumping everying is not the intention of the patch. (Sorry that the name

so ? I'm making a suggestion to improve the patch. Dumping only the
information you judged necessary during your debug sessions with no
consideration for other users isn't generally a good practice. I'm
trying to help you improve the patch so that it can be accepted.

Note that dumping all of that information out of a single file isn't
very nice either and it'll be difficult to parse, even for humans.

> So are you suggesting to organize the information in multiple debugfs
> directories and files or just to print information with appropriate inden=
ts so that

multiple directories.

> users can easily read it? IMO, organizing them in multiple files makes
> it impossible for the user to lock dwc3->lock and get information
> atomically. The problem of reading them separately is that it won't give
> you the consistent information regarding the current transfer state.

it depends on where you hold the lock. Also, now that I think of it, it
really seems like what you want is tracepoints on this driver, rather
than dumping a whole bunch of information out of a single read to a
single file. The kernel has a very nice tracing infrastructure and I'd
be really happy to read a patch adding support for that in this driver.

> > > +static void dwc3_dump_dev_event(struct seq_file *s,
> > > +			const struct dwc3_event_devt *event)
> > > +{
> > > +	seq_puts(s, "[0]DEV ");
> > > +	seq_printf(s, "[1:7]%s ",
> > > +		event->device_event =3D=3D DWC3_EVENT_TYPE_DEV ? "TYPE_DEV" :
> > > +		event->device_event =3D=3D DWC3_EVENT_TYPE_CARKIT ? "TYPE_CARKIT" :
> > > +		event->device_event =3D=3D DWC3_EVENT_TYPE_I2C ? "TYPE_CARKIT" :
> > > +		"TYPE_UNKOWN");
> > > +	seq_printf(s, "[8:11]%s ", dwc3_gadget_event_string(event->type));
> > > +
> > > +	if (event->type =3D=3D DWC3_DEVICE_EVENT_LINK_STATUS_CHANGE ||
> > > +		event->type =3D=3D DWC3_DEVICE_EVENT_HIBER_REQ) {
> > > +
> > > +		seq_printf(s, "[16:20]%s %s ",
> > > +			dwc3_link_state_string(
> > > +				event->event_info & DEVT_EVTINFO_SUPERSPEED,
> > > +				event->event_info & DWC3_LINK_STATE_MASK),
> > > +				event->event_info & DEVT_EVTINFO_SUPERSPEED ?
> > > +				"SS" : "HS");
> > > +
> > > +		if (!(event->event_info & DEVT_EVTINFO_SUPERSPEED))
> > > +			seq_printf(s, "[21:24]HIRD %u ",
> > > +				DEVT_EVTINFO_HIRD(event->event_info));
> > > +	}
> > > +}
> > > +
> > > +static void dwc3_dump_ep_event(struct seq_file *s,
> > > +			const struct dwc3_event_depevt *event)
> > > +{
> > > +	seq_puts(s, "[0]EP ");
> > > +	seq_printf(s, "[1:5]ep%d ", event->endpoint_number);
> > > +	seq_printf(s, "[6:9]%s ",
> > > +		dwc3_ep_event_string(event->endpoint_event));
> > > +
> > > +	switch (event->endpoint_event) {
> > > +	case DWC3_DEPEVT_XFERCOMPLETE:
> > > +	case DWC3_DEPEVT_XFERINPROGRESS:
> > > +		if (event->status & DEPEVT_STATUS_BUSERR)
> > > +			seq_puts(s, "[12]BUSERR ");
> > > +		if (event->status & DEPEVT_STATUS_SHORT)
> > > +			seq_puts(s, "[13]SHORT ");
> > > +		if (event->status & DEPEVT_STATUS_IOC)
> > > +			seq_puts(s, "[14]IOC ");
> > > +		if (event->status & DEPEVT_STATUS_LST)
> > > +			seq_puts(s, "[15]LST ");
> > > +		break;
> > > +	case DWC3_DEPEVT_XFERNOTREADY:
> > > +		if ((event->status & 0x3) =3D=3D 1)
> > > +			seq_puts(s, "[12:13]Data_Stage ");
> > > +		else if ((event->status & 0x3) =3D=3D 2)
> > > +			seq_puts(s, "[12:13]Status_Stage ");
> > > +		if (event->status & DEPEVT_STATUS_TRANSFER_ACTIVE)
> > > +			seq_puts(s, "[15]XferActive ");
> > > +		else
> > > +			seq_puts(s, "[15]XferNotActive ");
> > > +		break;
> > > +	case DWC3_DEPEVT_EPCMDCMPLT:
> > > +		if (event->status & BIT(0))
> > > +			seq_puts(s, "[12:15]Invalid Transfer Resource ");
> > > +		break;
> > > +	default:
> > > +		seq_puts(s, "[12:15]UNKOWN ");
> > > +	}
> > > +	seq_printf(s, "[16:31]PARAM 0x%04x ", event->parameters);
> > > +}
> > > +
> > > +static void dwc3_dump_event_buf(struct seq_file *s,
> > > +			struct dwc3_event_buffer *evt)
> > > +{
> > > +	union dwc3_event	event;
> > > +	int			i;
> > > +
> > > +	seq_printf(s, "evt->buf@0x%p(dma@0x%pad), length=3D%u, lpos=3D%u, c=
ount=3D%u, flags=3D%s\n",
> > > +		evt->buf, &evt->dma,
> > > +		evt->length, evt->lpos, evt->count,
> > > +		evt->flags & DWC3_EVENT_PENDING ? "pending" : "0");
> > > +
> > > +	for (i =3D 0; i < evt->length; i +=3D 4) {
> > > +		event.raw =3D *(u32 *) (evt->buf + i);
> > > +		if (i =3D=3D evt->lpos) {
> > > +			seq_puts(s, "lpos-------|\n");
> > > +			seq_puts(s, "           \\\n");
> > > +		}
> > > +		seq_printf(s, "event[%d]: %08x ", i, event.raw);
> > > +
> > > +		if (event.type.is_devspec)
> > > +			dwc3_dump_dev_event(s, &event.devt);
> > > +		else
> > > +			dwc3_dump_ep_event(s, &event.depevt);
> > > +		seq_puts(s, "\n");
> > > +	}
> >=20
> > how well have you tested this ? I'm not entirely sure you should be
> > reading the event buffer at any time you want, though I might be wrong.
> >=20
> > It's still a bit easier to reproduce part of the event handling here. I
> > think it's best to make a choice of caching the last 5 events in a ring
> > buffer and provide a helper for IRQ handlers to push events into the
> > ring buffer, then from here you just iterate over that ring buffer
> > instead of accessing our actual event buffer.
> >=20
> Thanks Paul Zimmerman and you for reminding me that fact that controller
> may write to the event buffers when we're reading them.
>=20
> Instead of trying to make things perfect and complex, the interface is ju=
st
> to dump the events while leaving the responsibilty to developers to judge
> if the events are reliable.

That's a crappy interface then. Why would anybody use anything they
can't trust ?

> Developer should be able to sense if the data is reliable depending on wh=
en he
> dumps the data. If a transfer is stuck and controller doesn't generate an=
ymore

or Developer might spend more time looking at somehting that doesn't
make sense and trying to figure out if the current trace is valid then
the time spent actually understanding the problem.

Logs are suppose to aid debugging and if the data isn't trustworthy we
will have developers spending time debugging the logs themselves. Sorry,
but I won't accept that.

> events, then the data is reliable, and this is the main senario this patc=
h wants
> to handle. If a transfer is stuck but controller keeps generating events =
due to

that you already get with Verbose debug anyway and you get *all* that
data with a simple dmesg.

> other transfers, there's nothing we can do about it, as the new events wi=
ll
> quickly overwrite the ring, and developer will know the events are not va=
luable.

and there goes a debug session down the drain, it turned out to be a
waste of time after all.

> If you dump the events when all transfers are still on-going, it just pro=
vides
> you some a history of the events to sense how it looks like, and you
> know the data might not be reliable. And this usage is not really helpful
> for debugging or not used at all, as you should have no intereset to
> check the events if everythings goes well.
> I think above is acceptable for debugging purpose, it's simple without
> introducing any overhead or timing effect.

wait, what ? everytime you read that file you hold the controller lock
god knows for how long and you say it doesn't introduce any timing
effect ?

Verbose logs have a lower overhead than what you're suggesting here.

> > Also note that we can hold up to 64 events in our event buffer so this
> > call could take a looooooot of time to complete and you probably don't
> > need all that information anyway because you can get them by just
> > enabling VERBOSE_DEBUG on dwc3 and capturing the entire driver behavior
> > on dmesg.
> >=20
> Even though a user may be scared by the lots of events, when a failure ha=
ppens,
> he actually wants to read as many events as he can to see what happened
> before the failure. 5 events is not enough, user can at most only see one
> or two transfers through these 5 events or nothing if the last few
> events are generated from other transfers which are unrelated to the
> failure. The time to dump the events doesn't matter as it's for debugging=
 and
> most often usage is after a transfer is stuck.

right, so if the transfer is stuch there are no extra generated anyway.

And I continue to say that all of this information is already available
by enabling VERBOSE_DEBUG for this driver.

If you want to capture logs without VERBOSE_DEBUG tracepoints sound like
the way to go.

> > > +static int dwc3_snapshot_show(struct seq_file *s, void *unused)
> > > +{
> > > +	struct dwc3		*dwc =3D s->private;
> > > +	unsigned long		flags;
> > > +	int			i;
> > > +
> > > +	spin_lock_irqsave(&dwc->lock, flags);
> > > +	for (i =3D 2; i < DWC3_ENDPOINTS_NUM; i++) {
> >=20
> > some platforms don't have all 32 physical endpoints, we just had a bug
> > fix for that, see commit 32702e9.
> >=20
> Will fix it as below:
> 	for (i =3D 2; i < DWC3_ENDPOINTS_NUM; i++) {

no dude, iterate for IN eps and for OUT eps separately. We already have
dwc->num_in_eps and dwc->num_out_eps

ps: use tracepoints.

--=20
balbi

--a2FkP9tdjPU2nyhF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTX88CAAoJEIaOsuA1yqREgQIP/3Rc/MyGKgLwWtqFhoj0Z0MN
FKABSjD1diePEIL5HM4nEQukIUiyTIrU5f+wfB8JihDprt4Nz10REYaa3uJPXWuV
nPGL8mMK/muTqNCBFzyRsSLKzA67UX6opZ9vh5N+c2KchF+DZzgmT+nKePZYigkM
WyOERnaViwNh5auJb0MMTyqbvef/4aGlcQWJVZTiIBWDf5rtFiOELbLAYnhcwn8r
RKBPAlFy4EhdNvRzzKgYB+Rib7CTY7uINKxvy2n3YyT+lAKo0yNmCxZHrraryjZ8
Cbv98CaagOEiq2VQbHoFteFobU5K/Ln7C4cU+3Axk9yYtS+gC2DZInKiS+ACMEtN
/rsnJL5ucRlh/Jbno8ihvlAPqcerLTAcIz8QKTgdL+NDXT/QhjEF+2UT8iPf7BT1
e7iKmkTN95gAkXFFxlIulPXQ7ccircTI87m+Rd+TcKR1VkS5yL4jJYq5GNKeJ7I5
dAf185uai0x2TcNN9XV6VRE8/jDzaB2MdTLtuVGp1zcmhyZ4UluG4IRKl6vTsiIR
+2vCkV5nuyZR6bBg9Ey6Zvb3Iq0McOE37qAIXYY+/lULm5JMbP02n5vAQs6ybaJE
wExcg41Ig2h7vCK3CffrfOxKL2F+2QmR7wGaQM7tCzfJeB9PbqgiNkI/gvO4VnSa
FDgG/qa9gqfE1EZTNrUM
=qpEA
-----END PGP SIGNATURE-----

--a2FkP9tdjPU2nyhF--
