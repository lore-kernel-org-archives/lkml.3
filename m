Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758452AbaCTP5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 11:57:49 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:64434 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbaCTP5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 11:57:46 -0400
Date: Thu, 20 Mar 2014 16:57:33 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Matt Porter <mporter@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Christian Daudt <bcm@fixthebug.org>,
        Grant Likely <grant.likely@linaro.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        Linux Doc List <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 2/5] pwm: kona: Introduce Kona PWM controller support
Message-ID: <20140320155732.GB25092@ulmo>
References: <1394655346-30048-1-git-send-email-tim.kryger@linaro.org>
 <1394655346-30048-3-git-send-email-tim.kryger@linaro.org>
 <20140318215231.GH5917@mithrandir>
 <CAAYSxhri0evgrbCPew6-MTXVmpzm7Oa6TpmJTSGZpTcV=876HQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V0207lvV8h4k8FAm"
Content-Disposition: inline
In-Reply-To: <CAAYSxhri0evgrbCPew6-MTXVmpzm7Oa6TpmJTSGZpTcV=876HQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--V0207lvV8h4k8FAm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 18, 2014 at 04:47:36PM -0700, Tim Kryger wrote:
> On Tue, Mar 18, 2014 at 2:52 PM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
> > On Wed, Mar 12, 2014 at 01:15:43PM -0700, Tim Kryger wrote:
> > [...]
> >> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> >> index 22f2f28..1fd42af 100644
> >> --- a/drivers/pwm/Kconfig
> >> +++ b/drivers/pwm/Kconfig
> >> @@ -62,6 +62,16 @@ config PWM_ATMEL_TCB
> >>         To compile this driver as a module, choose M here: the module
> >>         will be called pwm-atmel-tcb.
> >>
> >> +config PWM_BCM_KONA
> >> +     tristate "Kona PWM support"
> >> +     depends on ARCH_BCM_MOBILE
> >> +     default y
> >
> > No "default y", please.
>=20
> Even though it depends on ARCH_BCM_MOBILE?  It seems like a reasonable
> default.

Well, that's only true until somebody decides to turn that dependency
into something like:

	depends on ARCH_BCM_MOBILE || COMPILE_TEST

> These SoCs target mobile phones which almost always have a backlight
> controlled by the PWM.

And you can easily turn it on in bcm_defconfig and/or multi_v7_defconfig
if you want it enabled "by default".

> >> diff --git a/drivers/pwm/pwm-bcm-kona.c b/drivers/pwm/pwm-bcm-kona.c
[...]
> >> +
> >> +     /* There is polarity support in HW but it is easier to manage in=
 SW */
> >> +     if (pwm->polarity =3D=3D PWM_POLARITY_INVERSED)
> >> +             duty_ns =3D period_ns - duty_ns;
> >
> > No, this is wrong. You're not actually changing the *polarity* here.
>=20
> Please elaborate.  I don't understand what is wrong here.

Perhaps the comment for enum pwm_polarity in include/linux/pwm.h makes
this more obvious. What you do here is invert the duty cycle, rather
than the polarity. While it is true that the result is the same for
things like LEDs or backlight (because the signal power remains the
same), but there's a slight difference to what the PWM signal looks
like.

> Does polarity influence the output while a PWM is disabled?

Yes, there is apparently hardware where the polarity causes the PWM pin
to be 1 when the PWM is disabled. But that's really a separate issue.

> >> +static int kona_pwmc_enable(struct pwm_chip *chip, struct pwm_device =
*pwm)
> >> +{
> >> +     struct kona_pwmc *kp =3D dev_get_drvdata(chip->dev);
> >> +     int ret;
> >> +
> >> +     /*
> >> +      * The PWM framework does not clear the enable bit in the flags =
if an
> >> +      * error is returned from a PWM driver's enable function so it m=
ust be
> >> +      * cleared here if any trouble is encountered.
> >> +      */
> >> +
> >> +     ret =3D clk_prepare_enable(kp->clk);
> >> +     if (ret < 0) {
> >> +             dev_err(chip->dev, "failed to enable clock: %d\n", ret);
> >> +             clear_bit(PWMF_ENABLED, &pwm->flags);
> >
> > You're not supposed to touch these. This is a bug in the core, and it
> > should be fixed in the core.
>=20
> Okay.  I'll drop the clear_bit lines from this patch.

I was sort of hoping you would post a patch which fixes this in the core
instead of just dropping those lines here and ignoring the issue. That
would've earned you bonus points. =3D)

> >> +             return ret;
> >> +     }
> >> +
> >> +     ret =3D kona_pwmc_config(chip, pwm, pwm->duty_cycle, pwm->period=
);
> >> +     if (ret < 0) {
> >> +             clk_disable_unprepare(kp->clk);
> >> +             clear_bit(PWMF_ENABLED, &pwm->flags);
> >> +             return ret;
> >> +     }
> >
> > Why are you doing this? .config() should be setting everything up
> > according to the given duty cycle and period and .enable() should only
> > be enabling a specific channel. Please don't conflate the two.
>=20
> The hardware only supports a configure operation.
>=20
> Thus disable has to be simulated by configuring zero duty.
>=20
> During an enable operation we have to program the last configuration.

My worry is that by calling one public function from another you'll be
mixing contexts. For instance, with the PWMF_ENABLED issue you mention
one solution to fix this in the core would be to delay setting the flag
until the driver's .enable() implementation actually succeeded. If such
an implementation was chosen, then your driver would be broken, because
PWMF_ENABLED wouldn't be set when .enable() is called, and therefore
calling the kona_pwmc_config() wouldn't have any effect.

> >> +static void kona_pwmc_disable(struct pwm_chip *chip, struct pwm_devic=
e *pwm)
> >> +{
> >> +     struct kona_pwmc *kp =3D dev_get_drvdata(chip->dev);
> >> +     unsigned int chan =3D pwm->hwpwm;
> >> +
> >> +     /*
> >> +      * The "enable" bits in the control register only affect when se=
ttings
> >> +      * start to take effect so the only real way to disable the PWM =
output
> >> +      * is to program a zero duty cycle.
> >> +      */
> >
> > What's wrong about waiting for the settings to take effect? There's
> > nothing about disable that says it should happen *immediately*.
>=20
> The current code does wait for the settings to take effect.
>=20
> Can you clarify what you mean?

Things are starting to get confusing here. Looking at the register
definitions, there's PWM_CONTROL_ENABLE_SHIFT(chan), which I suspect
controls whether or not a channel is enabled (if that's not the case
then please add a comment that explains what it does).

But a little further up you said that the hardware does only support a
configure operation and not an enable/disable.

The comment above further confuses me. What I read from it is that you
can in fact disable a channel by clearing the "enable" bit in the
control register. But the reason why you don't do it that way is because
that change won't take effect until "settings start to take effect". So
in order to disable the PWM immediately you resort to writing a 0 duty
cycle.

Perhaps I misunderstood, in which case it might be good to revise that
comment to be more explicit or accurate.

Thierry

--V0207lvV8h4k8FAm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTKw/sAAoJEN0jrNd/PrOh10gP/RZlv3PqBJjCj+yesybpbVNz
79Q+DOnAlBEx797Dgcba76hXamcLNmRfmjk5KQm+YsWyAJ6Kuye+6ppZKJxGgoqL
R5rR4/Bp4stwBxVpSvv7nnntqiTXq/1Jo+dS0rlziQSJcowljoEWx/1D1twzJMDG
37kBsgOff8vpYXuNgb8l6twqPH5eiFRkl2yn3m98grWJCu3klmCGdzMlYfHALDlX
78Wkj6tnisr2FPrlihPRm047LFFT8sGLVrmjnFI8LnbIOwSop5HAWuBOosZJ0GcC
IuimwoPD9ZJAn0rq8IRLr6sA0H6Nj8Bo2KnE3+ERWNLZhvPk6cNz2hHBkAnxowAk
7aw/bmqe+Nm0ygfoEOfUnLtjUyeprkyRQlABAKtPq6nOIXgH2p8rNr7QE2cSxQ1M
mgvZfQ7UQQAXVsOBS++1l8FK9I/a/d3TMu6Tk+vqYiN6XLm7DcIt8XIb/Iw9fbBh
WY+GtDHl9Ot7+sSQeBAL4ucV2u6y+PBs8hKcYSlkVtrc7Zz4TcFBwKwQ/VXAvcRl
TjkyTHpkVOcQtAtAcZ5z0cnKpKIwDFBHnvPIeG69qsjCZH46A7zhTzkHocvizk7Y
Ucxh10RA1ig15zrQvIktxnf2l0pOVzBoN7Xz61aymPm7KCOMbbWcy8TPo2g330/c
IM59JS2HKJ8qIt22FS4z
=dytp
-----END PGP SIGNATURE-----

--V0207lvV8h4k8FAm--
