Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab3JAOUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 10:20:13 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49884 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004Ab3JAOUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 10:20:10 -0400
Date: Tue, 1 Oct 2013 09:19:58 -0500
From: Felipe Balbi <balbi@ti.com>
To: Andreas Larsson <andreas@gaisler.com>
CC: <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <software@gaisler.com>
Subject: Re: [PATCH] usb: gadget: Add UDC driver for Aeroflex Gaisler GRUSBDC
Message-ID: <20131001141958.GQ1476@radagast>
Reply-To: <balbi@ti.com>
References: <1376316310-27989-1-git-send-email-andreas@gaisler.com>
 <20130918171506.GQ21559@radagast>
 <524A8927.6090500@gaisler.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9r3HF47jptiQlX4s"
Content-Disposition: inline
In-Reply-To: <524A8927.6090500@gaisler.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--9r3HF47jptiQlX4s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 01, 2013 at 10:34:47AM +0200, Andreas Larsson wrote:
> >>+/* #define VERBOSE_DEBUG */
> >
> >we don't want this, we want verbose debug to be selectable on Kconfig,
> >which already is ;-)
>=20
> I was only aware of CONFIG_USB_GADGET_DEBUG leading to DEBUG being
> defined, not that any Kconfig turned on VERBOSE_DEBUG. Where is this
> happening?

you're right there :-) My bad. Do you mind adding a patch which sets
VERBOSE_DEBUG when building drivers/usb/gadget/ directory ?
drivers/usb/dwc3/ has an example, if you need ;-)

Or I can patch that myself, if you prefer. works both ways.

> >>+#include "gr_udc.h"
> >>+
> >>+#define	DRIVER_NAME	"gr_udc"
> >>+#define	DRIVER_DESC	"Aeroflex Gaisler GRUSBDC USB Peripheral Controlle=
r"
> >>+
> >>+static const char driver_name[] =3D DRIVER_NAME;
> >>+static const char driver_desc[] =3D DRIVER_DESC;
> >>+
> >>+#define gr_read32(x) (ioread32be((x)))
> >>+#define gr_write32(x, v) (iowrite32be((v), (x)))
> >>+
> >>+/* USB speed and corresponding string calculated from status register =
value */
> >>+#define GR_SPEED(status) \
> >>+	((status & GR_STATUS_SP) ? USB_SPEED_FULL : USB_SPEED_HIGH)
> >>+#define GR_SPEED_STR(status) usb_speed_string(GR_SPEED(status))
> >>+
> >>+/* Size of hardware buffer calculated from epctrl register value */
> >>+#define GR_BUFFER_SIZE(epctrl)					      \
> >>+	((((epctrl) & GR_EPCTRL_BUFSZ_MASK) >> GR_EPCTRL_BUFSZ_POS) * \
> >>+	 GR_EPCTRL_BUFSZ_SCALER)
> >>+
> >>+/* -------------------------------------------------------------------=
--- */
> >>+/* Debug printout functionality */
> >>+
> >>+static const char * const gr_modestring[] =3D {"control", "iso", "bulk=
", "int"};
> >>+
> >>+static const char *gr_ep0state_string(enum gr_ep0state state)
> >>+{
> >>+	static const char *const names[] =3D {
> >>+		[GR_EP0_DISCONNECT] =3D "disconnect",
> >>+		[GR_EP0_SETUP] =3D "setup",
> >>+		[GR_EP0_IDATA] =3D "idata",
> >>+		[GR_EP0_ODATA] =3D "odata",
> >>+		[GR_EP0_ISTATUS] =3D "istatus",
> >>+		[GR_EP0_OSTATUS] =3D "ostatus",
> >>+		[GR_EP0_STALL] =3D "stall",
> >>+		[GR_EP0_SUSPEND] =3D "suspend",
> >>+	};
> >>+
> >>+	if (state < 0 || state >=3D ARRAY_SIZE(names))
> >>+		return "UNKNOWN";
> >>+
> >>+	return names[state];
> >>+}
> >>+
> >>+#ifdef VERBOSE_DEBUG
> >>+
> >>+#define BPRINTF(buf, left, fmt, args...)			\
> >>+	do {							\
> >>+		int ret =3D snprintf(buf, left, fmt, ## args);	\
> >>+		buf +=3D ret;					\
> >>+		left -=3D ret;					\
> >>+	} while (0)
> >
> >nack, use dev_vdbg() instead.
> >
> >>+static void gr_dbgprint_request(const char *str, struct gr_ep *ep,
> >>+				struct gr_request *req)
> >>+{
> >>+	char buffer[100];
> >
> >NAK^10000000
> >
> >use kernel facilities instead. printk() and all its friends already
> >print to a ring buffer.
>=20
> Alright. The concern was that repeatedly calling printk for multiple
> parts of the same message could lead to intermixing with other unrelated
> printouts.

hmm, there are two ways to look at this.

a) we have KERN_CONT to continue printing messages
b) you might prefer using debugfs and seq_puts() for dumping large(-ish)
amounts of debugging data ;-)

> >>+static void gr_finish_request(struct gr_ep *ep, struct gr_request *req,
> >>+			      int status)
> >>+{
> >>+	struct gr_udc *dev;
> >>+
> >>+	list_del_init(&req->queue);
> >>+
> >>+	if (likely(req->req.status =3D=3D -EINPROGRESS))
> >>+		req->req.status =3D status;
> >>+	else
> >>+		status =3D req->req.status;
> >>+
> >>+	dev =3D ep->dev;
> >>+	usb_gadget_unmap_request(&dev->gadget, &req->req, ep->is_in);
> >>+	gr_free_dma_desc_chain(dev, req);
> >>+
> >>+	if (ep->is_in) /* For OUT, actual gets updated by the work handler */
> >>+		req->req.actual =3D req->req.length;
> >>+
> >>+	if (!status) {
> >>+		if (ep->is_in)
> >>+			gr_dbgprint_request("SENT", ep, req);
> >>+		else
> >>+			gr_dbgprint_request("RECV", ep, req);
> >>+	}
> >>+
> >>+	/* Prevent changes to ep->queue during callback */
> >>+	ep->callback =3D 1;
> >>+	if (req =3D=3D dev->ep0reqo && !status) {
> >>+		if (req->setup)
> >>+			gr_ep0_setup(dev, req);
> >>+		else
> >>+			dev_err(dev->dev,
> >>+				"Unexpected non setup packet on ep0in\n");
> >>+	} else if (req->req.complete) {
> >>+		unsigned long flags;
> >>+
> >>+		/* Complete should be called with irqs disabled */
> >>+		local_irq_save(flags);
> >
> >I guess it'd be better if you called this with spin_lock_irqsave()
> >called before, then you can remove local_irq_save from here.
>=20
> That would increase the amount of time interrupts are disabled quite a
> lot, so I would prefer not to.

that's what every other UDC driver is doing. I don't think you need to
worry about that. Can you run some benchmarks with both constructs just
so I can have peace of mind ?

> >>+		spin_unlock(&dev->lock);
> >>+
> >>+		req->req.complete(&ep->ep, &req->req);
> >>+
> >>+		spin_lock(&dev->lock);
> >>+		local_irq_restore(flags);
> >>+	}
> >>+	ep->callback =3D 0;
> >>+
> >>+	/* Catch up possible prevented ep handling during completion callback=
 */
> >>+	if (!ep->stopped)
> >>+		schedule_work(&dev->work);
> >
> >this workqueue is awkward, what's up with that ?
>=20
> The reason for the scheduling here is that during the completion call
> the handling of endpoint events needs to be stopped. This is
> accomplished by the ep->callback flag. When that is done we might have
> ep events that needs to be taken care of.
>=20
> The same situation arises after unhalting an endpoint further down. All
> potential handling of that endpoint was on pause during halt, and thus
> the work handler needs to be scheduled to catch up.

not so sure. Other UDC drivers also support EP halt and they don't need
the workqueue at all.

> >>+/* Call with non-NULL dev to do a devm-allocation */
> >>+static struct usb_request *__gr_alloc_request(struct device *dev,
> >>+					      struct usb_ep *_ep,
> >>+					      gfp_t gfp_flags)
> >>+{
> >>+	struct gr_request *req;
> >>+
> >>+	if (dev)
> >>+		req =3D devm_kzalloc(dev, sizeof(*req), gfp_flags);
> >>+	else
> >>+		req =3D kzalloc(sizeof(*req), gfp_flags);
> >
> >why would "dev" ever be NULL ?
>=20
> When the gadget allocates a request it will free it explicitely later
> on. Thus there is no need for any devm allocation. Therefore, the calls
> from the gadget to gr_alloc_request then calls this function with a NULL
> argument so that non-devm allocation is done in that case.

then couldn't you just stick with direct kzalloc() instead of trying to
use devm_kzalloc() for allocating requests ?

That's the righ way to handle usb_request lifetime anyway; leave it to
the gadget driver. If that gadget driver doesn't free the usb_requests
it allocated, we want the memory leak as an indication of a buggy
gadget driver.

> >>+	epctrl =3D gr_read32(&ep->regs->epctrl);
> >>+	if (halt) {
> >>+		/* Set HALT */
> >>+		gr_write32(&ep->regs->epctrl, epctrl | GR_EPCTRL_EH);
> >>+		ep->stopped =3D 1;
> >>+		if (wedge)
> >>+			ep->wedged =3D 1;
> >>+	} else {
> >>+		gr_write32(&ep->regs->epctrl, epctrl & ~GR_EPCTRL_EH);
> >>+		ep->stopped =3D 0;
> >>+		ep->wedged =3D 0;
> >>+
> >>+		/* Things might have been queued up in the meantime */
> >>+		if (!ep->dma_start)
> >>+			gr_start_dma(ep);
> >>+
> >>+		/* Ep handling might have been hindered during halt */
> >>+		schedule_work(&ep->dev->work);
>=20
> Here is the second place where we need to schedule work as mentioned
> above.

that's fine, but we still have other gadget drivers which don't take the
route of a workqueue after unhalting the endpoint.

If the endpoint is halted, why do you even have anything to process at
all for this endpoint ? nothing should have been queued, right ?

And if you did queue requests while EP was halted, you could just
restart your EP queue right here, instead of scheduling a work_struct to
do that for you.

> >>+	}
> >>+
> >>+	return retval;
> >>+}
> >>+
> >>+/* Must be called with dev->lock held */
> >>+static inline void gr_set_ep0state(struct gr_udc *dev, enum gr_ep0stat=
e value)
> >>+{
> >>+	if (dev->ep0state !=3D value)
> >>+		VDBG("STATE:  ep0state=3D%s\n",
> >>+		     gr_ep0state_string(value));
> >
> >dev_vdbg()
> >
> >>+	dev->ep0state =3D value;
> >>+}
> >>+
> >>+/*
> >>+ * Should only be called when endpoints can not generate interrupts.
> >>+ *
> >>+ * Must be called with dev->lock held.
> >>+ */
> >>+static void gr_disable_interrupts_and_pullup(struct gr_udc *dev)
> >>+{
> >>+	gr_write32(&dev->regs->control, 0);
> >>+	wmb(); /* Make sure that we do not deny one of our interrupts */
> >>+	dev->irq_enabled =3D 0;
> >>+}
> >>+
> >>+/*
> >>+ * Stop all device activity and disable data line pullup.
> >>+ *
> >>+ * Must be called with dev->lock held.
> >>+ */
> >>+static void gr_stop_activity(struct gr_udc *dev)
> >>+{
> >>+	struct gr_ep *ep;
> >>+
> >>+	list_for_each_entry(ep, &dev->ep_list, ep_list)
> >>+		gr_ep_nuke(ep);
> >>+
> >>+	gr_disable_interrupts_and_pullup(dev);
> >>+
> >>+	gr_set_ep0state(dev, GR_EP0_DISCONNECT);
> >>+	usb_gadget_set_state(&dev->gadget, USB_STATE_ATTACHED);
> >
> >ATTACHED ??
>=20
> Maybe NOTATTACHED is clearer, even if it is the same state in all
> respects.

for the sake of being clear, yes :-)

> >>+static irqreturn_t gr_irq(int irq, void *_dev)
> >>+{
> >>+	struct gr_udc *dev =3D _dev;
> >>+
> >>+	if (!dev->irq_enabled)
> >>+		return IRQ_NONE;
> >>+
> >>+	schedule_work(&dev->work);
> >
> >why do you need this ? We have threaded IRQ handlers. Why a workqueue ?
>=20
> As mentioned above, to to be able to schedule work after pausing
> endpoint handling during a completion callback call or during an
> endpoint halt.

doesn't look like you need that work_struct at all. Handle your IRQ
directly and for the pieces you need to do after ClearHalt, re-factor
that to a separate function which you call conditionally on
->set_halt().

> Thank you for the feedback!

no problem ;-)

--=20
balbi

--9r3HF47jptiQlX4s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSStoOAAoJEIaOsuA1yqRE3y8QALH4EXMKXI5tMwDHGDIe6f71
4fVHgyQTqRP4RrIrKITm7yB+4PjT5pcjkbTGkSty1XbC3irOtlE9WJaEpz0i1RfW
JStm9OEYCikna48Y6nba7sp9GxTL/p/b0jiP8EHh8fkeOtOJJv1OHitOa8K7d/Te
OJu6BaU0L0AfPwCyYCOp4871lQyPEunqg86W414EH/IX1ShD8h4jLLjLqH36z4Ln
uoto/Gzefc9Dbz4+o2tCNPYagx8iZeUCMC3ppHIfxyNjPUDJAyBYEB7c1v3894y1
bjKhojDF5sVs886e1k0G1nnuy2d2ec2ec+VhxZLky2dVk5OKFKG5XfX1Yz0KcdBF
XFn5Bw96qluVY0LJ7zpkfPutUQJycbMhDM7govyuKP1ppZZUhfR18BF6dqlvgQ0h
TQuDXXX5Bf56+g0opaqwJBkhJR7O8Tc/kPhCXU8lGtetdDCn2txMAmlBES0pVacT
CW1cdmwvZMUqCRPkhSWioNPbwovv26BcCRKImdLbep455cp63H2ZHRuL59OvNGiH
lBw4Z38EWkMsCNyml8SyvAO6rRo38g8+C5+uXM3VVcSJbky/AN2tg6orH+luhuIo
k97cbNc0M7jAJ1BAdyQ9wS01KvEKeQs0KNs2TNnLF1pQT3aqD6SXOZoCDMKRSuAh
YjTDHId9VeYpM9AoaZd/
=9VwZ
-----END PGP SIGNATURE-----

--9r3HF47jptiQlX4s--
