Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab3BDWkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 17:40:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51670 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755215Ab3BDWkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 17:40:43 -0500
Date: Tue, 5 Feb 2013 09:40:33 +1100
From: NeilBrown <neilb@suse.de>
To: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: Re: [RFC PATCH] Input: gpio_keys: Fix suspend/resume press event
 lost
Message-ID: <20130205094033.7ab830fb@notabene.brown>
In-Reply-To: <510A70D7.8060109@ti.com>
References: <1358774114-8281-1-git-send-email-ivan.khoronzhuk@ti.com>
	<20130121235718.GB16638@core.coreip.homeip.net>
	<20130122162434.5bcf3e14@notabene.brown>
	<5106A39A.5010402@ti.com>
	<20130129055122.2dcb9dd9@notabene.brown>
	<510A70D7.8060109@ti.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/SKOKOpNq/AeSl2f7aq80vLL"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/SKOKOpNq/AeSl2f7aq80vLL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 31 Jan 2013 15:25:43 +0200 "ivan.khoronzhuk" <ivan.khoronzhuk@ti.co=
m>
wrote:

> On 01/28/2013 08:51 PM, NeilBrown wrote:
> > On Mon, 28 Jan 2013 18:13:14 +0200 "ivan.khoronzhuk" <ivan.khoronzhuk@t=
i.com>
> > wrote:
> >
> >> On 01/22/2013 07:24 AM, NeilBrown wrote:
> >>> On Mon, 21 Jan 2013 15:57:18 -0800 Dmitry Torokhov
> >>> <dmitry.torokhov@gmail.com> wrote:
> >>>
> >>>> Hi Ivan,
> >>>>
> >>>> On Mon, Jan 21, 2013 at 03:15:14PM +0200, Ivan Khoronzhuk wrote:
> >>>>> Rebased on linux_omap/master.
> >>>>>
> >>>>> During suspend/resume the key press can be lost if time of resume
> >>>>> sequence is significant.
> >>>>>
> >>>>> If press event cannot be remembered then the driver can read the
> >>>>> current button state only in time of interrupt handling. But in some
> >>>>> cases when time between IRQ and IRQ handler is significant we can
> >>>>> read incorrect state. As a particular case, when device is in suspe=
nd
> >>>>> we press wakupable key and up it back in a jiffy, the interrupt
> >>>>> handler read the state of up but the interrupt source is press inde=
ed.
> >>>>> As a result, in a OS like android, we resume then suspend right away
> >>>>> because the key state is not changed.
> >>>>>
> >>>>> This patch add to gpio_keys framework opportunity to recover lost of
> >>>>> press key event at resuming. The variable "key_pressed" from
> >>>>> gpio_button_data structure is not used for gpio keys, it is only us=
ed
> >>>>> for gpio irq keys, so it is logically used to remember press lost
> >>>>> while resuming.
> >>>> The same could happen if you delay processing of interrupt long enou=
gh
> >>>> during normal operation. If key is released by the time you get arou=
nd
> >>>> to reading it you will not see a key press.
> >>>>
> >>>> To me this sounds like you need to speed up your resume process so t=
hat
> >>>> you can start serving interrupts quicker.
> >>>>
> >>> Agreed.  When I was looking at this I found that any genuine button p=
ress
> >>> would have at least 70msec between press and release, while the devic=
e could
> >>> wake up to the point of being able to handle interrupts in about 14ms=
ec.
> >>> That is enough of a gap to make it pointless to try to 'fix' the code.
> >>>
> >>> With enough verbose debugging enabled that 14msec can easily grow to
> >>> hundreds, but then if  you have debugging enabled to can discipline y=
ourself
> >>> to hold the button for longer.
> >>>
> >>> Ivan: What sort of delay are you seeing between the button press and =
the
> >>> interrupt routine running?  And can you measure how long the button is
> >>> typically down for?
> >>>
> >>> NeilBrown
> >> In my case I have the delay between the button press and the ISR
> >> about 145ms. If the button down for 120ms the IRQ press event is
> >> lost and if 160ms event is captured. I cannot speed up resume
> >> process enough to guarantee correct work, so I wrote this fix.
> >>
> >
> > 145ms does sound like a long time.
> > You should be able to get precise timings by putting a printk in various
> > parts of the code and ensuring the kernel logs are getting precise time=
stamps.
> >
> > Then you could see if the delay is between resume starting and the ISR
> > running, or between the ISR and the gpio_work_func getting scheduled.
> >
> > I assume that you don't have ->debounce_interval set....
> >
> > If the ISR is running soon enough, it might be possible to read the GPI=
O from
> > the ISR - I think that would be a cleaner solution.
> >
> > If not, then you will need something that interpolates an extra key pre=
ss.
> > In that case I would suggest my original patch - it seems simpler than =
yours
> > and doesn't make a special case out of suspend.  As Dmitry said, any de=
lay
> > could cause a problem.
> > My patch simply ensures that there is at least one button event for each
> > interrupt by generating an extra event for the inverse of the current b=
utton
> > position.  If that state had already been noticed, the input subsystem =
will
> > filter the extra event out so it won't be visible elsewhere.
> >
> > For reference, my original patch is below.
> >
> > NeilBrown
> >
> > [PATCH] Input: gpio_keys - ensure we don't miss key-presses during resu=
me.
> >
> > If the latency of resume means we don't poll the key status until
> > after it has been released, we can lose the keypress which woke the
> > device.
> >
> > So on each interrupt, record that a press is pending, and in that
> > case, report both the up and down event, ordered such that the second
> > event is that one that reflects the current state.
> >
> > One event will normally be swallowed by the input layer if there was
> > no change, but the result will be that every interrupt will produce at
> > least one event.
> >
> > Signed-off-by: NeilBrown <neilb@suse.de>
> >
> > diff --git a/drivers/input/keyboard/gpio_keys.c
> > b/drivers/input/keyboard/gpio_keys.c index 62bfce4..961e5e1 100644
> > --- a/drivers/input/keyboard/gpio_keys.c
> > +++ b/drivers/input/keyboard/gpio_keys.c
> > @@ -40,6 +40,7 @@ struct gpio_button_data {
> >   	spinlock_t lock;
> >   	bool disabled;
> >   	bool key_pressed;
> > +	bool pending;
> >   };
> >  =20
> >   struct gpio_keys_drvdata {
> > @@ -335,6 +336,14 @@ static void gpio_keys_gpio_report_event(struct gpi=
o_button_data *bdata) if (state)
> >   			input_event(input, type, button->code, button->value); } else {
> > +		if (type =3D=3D EV_KEY && bdata->pending) {
> > +			/* Before reporting the observed state, report the
> > +			 * alternate to be sure that a change is seen.
> > +			 */
> > +			bdata->pending =3D 0;
> > +			input_event(input, type, button->code, !state);
> > +			input_sync(input);
> > +		}
> >   		input_event(input, type, button->code, !!state);
> >   	}Yes it si
> >   	input_sync(input);
> > @@ -361,6 +370,7 @@ static irqreturn_t gpio_keys_gpio_isr(int irq, void=
 *dev_id)
> >   	BUG_ON(irq !=3D bdata->irq);
> >  =20
> > +	bdata->pending =3D true;
> >   	if (bdata->timer_debounce)
> >   		mod_timer(&bdata->timer,
> >   			jiffies + msecs_to_jiffies(bdata->timer_debounce));
>=20
> The delay is between resume starting and the ISR running,
> It is measured with oscilloscope between signal on button pin and
> before irq enabling. And I doubly checked it by printk() right in
> the ISR. So I cannot read the button state right in the ISR.

Wow.  That is a big delay then.

>=20
> Your patch is simpler but it doesn't take into account one situation.
> It is unlikely but what if the event is lost at 16:00 and reproduced
> at 17:30, in some cases it is better to lose the event than recover it
> out of time.

Is that at all a realistic scenario?  Interrupts disabled for 90 minutes!  =
If
that happened you would have more to worry about than one stray button press
(which is still a valid button press, but is a bit late).

I think you are over-complicating things.  Just keep it simple:  Generate at
least one button event on every interrupt.

NeilBrown

--Sig_/SKOKOpNq/AeSl2f7aq80vLL
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBURA44Tnsnt1WYoG5AQIdAhAAl5NB0myAiUW4J5Jy+FOKLifa9sLEnasM
orDJBgTxGlT3+A8Vr9hhwpo/X0CDfGlmhfS1qmnSKUzcleyNp8ErUaGqFoDooQ/A
IQJoY8H4rWwAG7iOCPOYM95i1H2SlmD7bzEs/odXvxiZrCsoZxDo7Kt7xU8yM2lI
miv4itiDbebWoaWUqZ8qLk1Hhc6H9Al/5/rG/8cULkXN+4CQ94F0w/ej2sxociqM
untS2in/RBq+pWPlxuBpaLumbpwGjd3G4uRSPttSEfqqh8v61GLCm7Y5GkgNLGHE
mVuRqzNlIJgIXfjFpgzcGQlpZUZOW7m3Z6Jjf+0AAdcXpegs2CQ1evoTvPAioZLG
Ly9kTYyNZFNr91KOLp3fFA8FQ1Wvo6i+dmnlzH41vX488Kt0SpoEZI9QuJJ8aPHw
gkUUshVQvhf5CnyBjJrBv6P0IiPsobN+SIMw2Bp/YJCpp5byRrWFLkjh16i0KgHc
3UgsNyZT8qxiIEjBui5KKrgDHt5t6ERxnEWdYv7R54RG0KThMcNnyC2uYU71ZuOi
E3D1ESTQcN119KuTA6wznkeVwGIMBI5DLrSZ7iwcK1L1wonIvYceEncNToTBAv3+
huiUY1R+o0IcUSE+w/rK7mXUwaXnMSfYSgOHZxktl+h0wdtng//VQGnkX8RfI1Bs
4KHabXZx9yw=
=m1AV
-----END PGP SIGNATURE-----

--Sig_/SKOKOpNq/AeSl2f7aq80vLL--
