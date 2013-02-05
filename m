Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab3BEInH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 03:43:07 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:62494 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab3BEInD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 03:43:03 -0500
Date: Tue, 5 Feb 2013 09:42:55 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>
Cc: Arto Merilainen <amerilainen@nvidia.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5,RESEND 2/8] gpu: host1x: Add syncpoint wait and
 interrupts
Message-ID: <20130205084255.GB20437@avionic-0098.mockup.avionic-design.de>
References: <1358250244-9678-1-git-send-email-tbergstrom@nvidia.com>
 <1358250244-9678-3-git-send-email-tbergstrom@nvidia.com>
 <20130204103032.GB27443@avionic-0098.mockup.avionic-design.de>
 <51108A94.3060501@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TakKZr9L6Hm6aLOc"
Content-Disposition: inline
In-Reply-To: <51108A94.3060501@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:oARUuKhp6u8iOkOwRSWbyCQu1gBj3VHqZdspMUTz/+h
 /4R5oZOgz0J0gJKezcrGB/nEWp80+fTbAqm08ytxXB0P9OUBSC
 uFkkAwblXxIMCOne8KnMFWujQ1uWlEOrPnJO6PIyvs763hN8B2
 zfY9yOsLydEnDvcMJd7X0mjXmmu3OgFmm/dS68Xl0/oowTUwpa
 ooOJYEJLI8hHg5boqzGVP46S4HncAn13JcowiuPEqIZmn68u0R
 amNtlNonfVPxWGnsdeE0FubolIe7t4OlkDzLkJXAjmlsixsOCR
 C3XBLVGz3MFdozJede5BgBU3dOLp+sMDQfjsIzjyFUACbYvn2A
 TNkjcAyFiQfVSr0iKozBZ9tKSW3MAIS3EDiZT8pqQcGQ/TqIws
 2gbFSMDoIfHf03Rxd3zGj/WMWzPmIFn6LU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TakKZr9L6Hm6aLOc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 04, 2013 at 08:29:08PM -0800, Terje Bergstr=C3=B6m wrote:
> On 04.02.2013 02:30, Thierry Reding wrote:
> >> diff --git a/drivers/gpu/host1x/dev.h b/drivers/gpu/host1x/dev.h
> >> index d8f5979..8376092 100644
> >> --- a/drivers/gpu/host1x/dev.h
> >> +++ b/drivers/gpu/host1x/dev.h
> >> @@ -17,11 +17,12 @@
> >>  #ifndef HOST1X_DEV_H
> >>  #define HOST1X_DEV_H
> >>
> >> +#include <linux/platform_device.h>
> >>  #include "syncpt.h"
> >> +#include "intr.h"
> >>
> >>  struct host1x;
> >>  struct host1x_syncpt;
> >> -struct platform_device;
> >=20
> > Why include platform_device.h here?
>=20
> host1x_get_host() actually needs that, so this #include should've also
> been in previous patch.

No need to if you pass struct device * instead. You might need
linux/device.h instead, though.

> >> +     void (*set_syncpt_threshold)(
> >> +             struct host1x_intr *, u32 id, u32 thresh);
> >> +     void (*enable_syncpt_intr)(struct host1x_intr *, u32 id);
> >> +     void (*disable_syncpt_intr)(struct host1x_intr *, u32 id);
> >> +     void (*disable_all_syncpt_intrs)(struct host1x_intr *);
> >=20
> > Can disable_all_syncpt_intrs() not be implemented generically using the
> > number of syncpoints as exposed by host1x_device_info and the
> > .disable_syncpt_intr() function?
>=20
> disable_all_syncpt_intrs() disables all interrupts in one write (or one
> per 32 sync points), so it's more efficient.

Yes, I noticed that and failed to remove this comment.

> >> +{
> >> +     struct host1x_intr_syncpt *sp =3D
> >> +             container_of(work, struct host1x_intr_syncpt, work);
> >> +     host1x_syncpt_thresh_fn(sp);
> >=20
> > Couldn't we inline the host1x_syncpt_thresh_fn() implementation here?
> > Why do we need to go through an external function declaration?
>=20
> If I move syncpt_thresh_work() to intr.c from intr_hw.c, I could do
> that. That'd simplify the interrupt path.

I like simplification. =3D)

> >> +static irqreturn_t syncpt_thresh_cascade_isr(int irq, void *dev_id)
> >> +{
> >> +     struct host1x *host1x =3D dev_id;
> >> +     struct host1x_intr *intr =3D &host1x->intr;
> >> +     unsigned long reg;
> >> +     int i, id;
> >> +
> >> +     for (i =3D 0; i < host1x->info.nb_pts / BITS_PER_LONG; i++) {
> >> +             reg =3D host1x_sync_readl(host1x,
> >> +                             HOST1X_SYNC_SYNCPT_THRESH_CPU0_INT_STATU=
S +
> >> +                             i * REGISTER_STRIDE);
> >> +             for_each_set_bit(id, &reg, BITS_PER_LONG) {
> >> +                     struct host1x_intr_syncpt *sp =3D
> >> +                             intr->syncpt + (i * BITS_PER_LONG + id);
> >> +                     host1x_intr_syncpt_thresh_isr(sp);
> >=20
> > Have you considered mimicking the IRQ API and name this something like
> > host1x_intr_syncpt_thresh_handle() and name the actual ISR just
> > syncpt_thresh_isr()? Not so important but it makes things a bit clearer
> > in my opinion.
>=20
> This gets a bit confusing, because we have an ISR that calls a function
> that is also called ISR. I've kept "isr" in names of both to emphasize
> that this is running in interrupt context. I'm open to renaming these to
> make it clearer.
>=20
> Did you refer to chained IRQ handler in linux/irq.h when you mentioned
> IRQ API as reference for naming?

What I had in mind was more along the lines of kernel/irq/chip.c, which
has a bunch of handlers for various types of interrupts, such as
handle_nested_irq() or handle_simple_irq().

Hence my proposal to rename host1x_intr_syncpt_thresh_isr() to
host1x_intr_syncpt_handle() because it handles the interrupt from a
single syncpoint and syncpt_thresh_cascade_isr() to syncpt_thresh_isr()
to keep it shorter.

Another variant would be host1x_syncpt_irq() for the top-level handler
and something host1x_handle_syncpt() to handle individual syncpoints. I
like this one best, but this is pure bike-shedding and there's nothing
technically wrong with the names you chose, so I can't really object if
you want to stick to them.

> >> +                     queue_work(intr->wq, &sp->work);
> >=20
> > Should the call to queue_work() perhaps be moved into
> > host1x_intr_syncpt_thresh_isr().
>=20
> I'm not sure, either way would be ok to me. The current structure allows
> host1x_intr_syncpt_thresh_isr() to only take one parameter
> (host1x_intr_syncpt). If we move queue_work, we'd also need to pass
> host1x_intr.

I think I'd still prefer to have all the code in one function because it
make subsequent modification easier and less error-prone.

> >> +static void host1x_intr_init_host_sync(struct host1x_intr *intr)
> >> +{
> >> +     struct host1x *host1x =3D intr_to_host1x(intr);
> >> +     int i, err;
> >> +
> >> +     host1x_sync_writel(host1x, 0xffffffffUL,
> >> +             HOST1X_SYNC_SYNCPT_THRESH_INT_DISABLE);
> >> +     host1x_sync_writel(host1x, 0xffffffffUL,
> >> +             HOST1X_SYNC_SYNCPT_THRESH_CPU0_INT_STATUS);
> >> +
> >> +     for (i =3D 0; i < host1x->info.nb_pts; i++)
> >> +             INIT_WORK(&intr->syncpt[i].work, syncpt_thresh_cascade_f=
n);
> >> +
> >> +     err =3D devm_request_irq(&host1x->dev->dev, intr->syncpt_irq,
> >> +                             syncpt_thresh_cascade_isr,
> >> +                             IRQF_SHARED, "host1x_syncpt", host1x);
> >> +     WARN_ON(IS_ERR_VALUE(err));
> >=20
> > Do we really want to continue in this case?
>=20
> Hmm, we'd need to actually return an error code. There's not much the
> driver can do without syncpt interrupts.

Yeah, in that case I think we should bail out. It's not like we're
expecting any failures. If the interrupt cannot be requested, something
must seriously be wrong and we should tell users about it so that it can
be fixed. Trying to continue on a best effort basis isn't useful here, I
think.

> >> +int host1x_intr_add_action(struct host1x_intr *intr, u32 id, u32 thre=
sh,
> >> +                     enum host1x_intr_action action, void *data,
> >> +                     void *_waiter,
> >> +                     void **ref)
> >=20
> > Why do you pass in _waiter as void * and not struct host1x_waitlist *?
>=20
> struct host1x_waitlist is defined inside intr.c, so I've chosen to pass
> void *. I could naturally just forward declare host1x_waitlist in intr.h
> and change the allocation and add_action to use that.

Yes, that's definitely better.

> > I think I've said this before. The interface doesn't seem optimal to me
> > here. Passing in an enumeration to choose which action to perform looks
> > difficult to work with (not to mention the symbols are rather long and
> > therefore result in ugly code).
> >=20
> > Maybe doing this by passing around a pointer to a handler function would
> > be nicer. However since I haven't really used this yet, I can't really
> > tell. So maybe we should just merge the implementation as-is for now. We
> > can always clean it up later.
>=20
> We're using the enum also to index into arrays. We do it so that we can
> remove all the completed waiters from the wait_head, and insert them
> into lists per action type. This way we can run all actions in priority
> order: first action_submit_complete, then action_wakeup, and then
> action_wakeup_interruptible.
>=20
> Now, we're recently noticed that the priority order is actually wrong.
> The first priority should be to wake up non-interruptible tasks, then
> interruptible tasks. Cleaning up memory of completed submits should be
> lower priority.
>=20
> I've considered this part as something private to host1x driver and it's
> not really meant to be called f.ex. from DRM. But, as you seem to have a
> need to have an asynchronous wait for a fence, we'd need to figure
> something out for that.

Okay, let's keep it as-is for now and see how it can be improved later
when we have an actual use-case for using it externally.

> >> +void *host1x_intr_alloc_waiter(void)
> >> +{
> >> +     return kzalloc(sizeof(struct host1x_waitlist), GFP_KERNEL);
> >> +}
> >=20
> > I'm not sure why this is separate from host1x_syncpt_wait() since it is
> > only used inside that function and the waiter returned never leaves the
> > scope of that function, so it might be better to allocate it directly
> > in host1x_syncpt_wait() instead.
> >=20
> > Actually, it looks like the waiter doesn't ever leave scope, so you may
> > even want to allocate it on the stack.
>=20
> In patch 3, at submit time we first allocate waiter, then take
> submit_lock, write submit to channel, and add the waiter while having
> the lock. I did this so that I host1x_intr_add_action() can always
> succeed. Otherwise I'd need to write another code path to handle the
> case where we wrote a job to channel, but we're not able to add a
> submit_complete action to it.

Okay. In that case why not allocate it on the stack in the first place
so you don't have to bother with allocations (and potential failure) at
all? The variable doesn't leave the function scope, so there shouldn't
be any issues, right?

Or if that doesn't work it would still be preferable to allocate memory
in host1x_syncpt_wait() directly instead of going through the wrapper.

> >> +void host1x_intr_put_ref(struct host1x_intr *intr, u32 id, void *ref)
> >=20
> > Here again, you pass in the waiter via a void *. Why's that?
>=20
> host1x_waitlist is hidden inside intr.c.

I don't think that's necessary here. I'd rather have the compiler check
for types rather than hide the structure.

> >> +int host1x_intr_init(struct host1x_intr *intr, u32 irq_sync)
> >=20
> > Maybe you should keep the type of the irq_sync here so that it properly
> > propagates to the call to devm_request_irq().
>=20
> I'm not sure what you mean. Do you mean that I should use unsigned int,
> as that's the type used in devm_request_irq()?

Yes.

> >> +void host1x_intr_stop(struct host1x_intr *intr)
> >> +{
> >> +     unsigned int id;
> >> +     struct host1x *host1x =3D intr_to_host1x(intr);
> >> +     struct host1x_intr_syncpt *syncpt;
> >> +     u32 nb_pts =3D host1x_syncpt_nb_pts(intr_to_host1x(intr));
> >> +
> >> +     mutex_lock(&intr->mutex);
> >> +
> >> +     host1x->intr_op.disable_all_syncpt_intrs(intr);
> >=20
> > I haven't commented on this everywhere, but I think this could benefit
> > from a wrapper that forwards this to the intr_op. The same goes for the
> > sync_op.
>=20
> You mean something like "host1x_disable_all_syncpt_intrs"?

Yes. I think that'd be useful for each of the op functions. Perhaps you
could even pass in a struct host1x * to make calls more uniform.

> >> +/*
> >> + * Main entrypoint for syncpoint value waits.
> >> + */
> >> +int host1x_syncpt_wait(struct host1x_syncpt *sp,
> >> +                     u32 thresh, long timeout, u32 *value)
> >> +{
> > [...]
> >> +}
> >> +EXPORT_SYMBOL(host1x_syncpt_wait);
> >=20
> > This doesn't only seem to be the main entrypoint, but it's basically the
> > only way to currently wait for syncpoints. One actual use-case where
> > this might turn out to be a problem is video capturing. The problem is
> > that using this API you can't very well asynchronously capture frames.
> > So eventually I think we need a way to allow a generic handler to be
> > attached to syncpoints so that you can have this handler continuously
> > invoked after each frame is captured and just pass the buffer back to
> > userspace.
>=20
> Yep, so far all asynchronous waits have been done in user space. We
> would probably allow attaching a handler to a syncpt value, so that we'd
> call that handler once a value is reached. In effect, similar to a
> wake_up event that is now added via host1x_intr_add_action, but simpler.
> That'd mean that the handler needs to be re-added after each frame.
>=20
> We could also add the handler as persistent if re-adding would be a
> problem. That'd require some new wiring and I'll have to think how to
> implement that.

Yes, that sounds like what I had in mind. Again, no need to worry about
it now. We can cross that bridge when we come to it.

Thierry

--TakKZr9L6Hm6aLOc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJREMYPAAoJEN0jrNd/PrOhPu0QAJTPWFgC7mqZbDpwTQmH9zEj
1ZSoiMkziacYVbHcvm4Lc4Tu4VYqKy6tN5wSa5P4WD6hpm1Ab2WztbZstgx4fHON
gfbVEMm5wVy2zPcgGPnKJB+7TJCmnTD+zWHsPL1PLRDbi5h4GsDrXw62AfdPkGNj
UZf5bYvAR3UOEcpzJa+7XPE2eaDVMXAutezNJmKKUGm33Km+V7a1JI6gP/I+YoS9
sXa16SOa47b8BgBXSOfFDq/SFLinWoOBgrsTyKEhKl2+zqqgH+yKspx7qdVY0WGS
D8pD0iZ1SLRuoExA56CoFShQ3V0zgAnyAhzWMh2rfN0dmlZxf1IRNYOFVxkhy+pa
ZS7LRjgDOyCKQrgoa/UF/EoHwQP3vgeF2pQ1NLj1PNUkMlvlr73mRZDVCEFXJ+l+
N6PPA6hVAi7ipBFAHAFHgCUMoN5tC6FNu7o0feI1B3qj/JY5/13RRxh46G1sVfIf
tDhTcAxMDD5GZz8qmCTQsAHO2s50PUSlxpxSfGw4IOi08mL9kfh/l+XPfCB6o1g4
F7yozLM12oct/iNPCChoXsslB1wrHTVwPNErA8dE2E4dxIW2mdA/l8a0q4i47x7l
tcH8z7odIkFQpeapWVmWiMjgi6sJ8HULXS4xhgPnbExju9qAq9y2504XGeIEHFFx
dqATVAi4V70ZlnPkGDjq
=8kZK
-----END PGP SIGNATURE-----

--TakKZr9L6Hm6aLOc--
