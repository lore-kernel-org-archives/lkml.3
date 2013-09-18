Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330Ab3IRJFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 05:05:22 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:33655 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab3IRJFT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 05:05:19 -0400
MIME-Version: 1.0
In-Reply-To: <201309181020.15245@pali>
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com>
 <201309172128.42514@pali> <20130918014942.GD19817@radagast> <201309181020.15245@pali>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Wed, 18 Sep 2013 11:04:58 +0200
Message-ID: <CAAwP0s1Ou7Nrq7GhnHX71TFCrTFg=nqUh+GsAJhN8DjZGsF4QQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] usb: musb: Call atomic_notifier_call_chain when
 status is changed
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Cc: Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, freemangordon@abv.bg,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Pavel Machek <pavel@ucw.cz>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 10:20 AM, Pali Rohár <pali.rohar@gmail.com> wrote:
> On Wednesday 18 September 2013 03:49:42 Felipe Balbi wrote:
>> On Tue, Sep 17, 2013 at 09:28:42PM +0200, Pali Rohár wrote:
>> > On Tuesday 17 September 2013 18:08:35 Felipe Balbi wrote:
>> > > On Tue, Sep 17, 2013 at 06:05:15PM +0200, Pali Rohár wrote:
>> > > > On Tuesday 17 September 2013 17:48:59 you wrote:
>> > > > > On Sun, Sep 08, 2013 at 10:50:36AM +0200, Pali Rohár wrote:
>> > > > > > More power supply drivers depends on vbus events and
>> > > > > > without it they not working. Power supply drivers
>> > > > > > using usb_register_notifier, so to deliver events
>> > > > > > it is needed to call atomic_notifier_call_chain.
>> > > > > >
>> > > > > > So without atomic notifier power supply driver
>> > > > > > isp1704 not retrieving vbus status and reporting
>> > > > > > bogus values to userspace and also to board
>> > > > > > platform data functions. Without proper data
>> > > > > > charger drivers trying to charge battery also when
>> > > > > > charger is disconnected or do not start charging
>> > > > > > when wallcharger connects.
>> > > > > >
>> > > > > > Atomic notifier in musb driver was used before v3.5
>> > > > > > and was replaced with omap mailbox. This patch
>> > > > > > adding atomic_notifier_call_chain call from
>> > > > > > function omap_musb_set_mailbox.
>> > > > > >
>> > > > > > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
>> > > > > > ---
>> > > > > >
>> > > > > >  drivers/usb/musb/omap2430.c       |    3 +++
>> > > > > >  drivers/usb/phy/phy-twl4030-usb.c |    2 ++
>> > > > > >  2 files changed, 5 insertions(+)
>> > > > > >
>> > > > > > diff --git a/drivers/usb/musb/omap2430.c
>> > > > > > b/drivers/usb/musb/omap2430.c index f44e8b5..5c40252
>> > > > > > 100644 --- a/drivers/usb/musb/omap2430.c
>> > > > > > +++ b/drivers/usb/musb/omap2430.c
>> > > > > > @@ -305,6 +305,9 @@ static void
>> > > > > > omap_musb_set_mailbox(struct omap2430_glue *glue)
>> > > > > >
>> > > > > >     default:
>> > > > > >             dev_dbg(dev, "ID float\n");
>> > > > > >
>> > > > > >     }
>> > > > > >
>> > > > > > +
>> > > > > > +   atomic_notifier_call_chain(&musb->xceiv->notifier,
>> > > > > > +                   musb->xceiv->last_event, NULL);
>> > > > >
>> > > > > let's add a wrapper for this:
>> > > > >
>> > > > > static inline int usb_phy_notify(struct usb phy *x,
>> > > > > unsigned val, void *v) {
>> > > > >
>> > > > >       return atomic_notifier_call_chain(&x->notifier, val,
>> > > > >       v);
>> > > > >
>> > > > > }
>> > > >
>> > > > Where to add this wrapper? To omap2430.c? or some
>> > > > include file?
>> > >
>> > > <linux/usb/phy.h>
>> > >
>> > > > On Tuesday 17 September 2013 17:49:17 Felipe Balbi wrote:
>> > > > > On Sun, Sep 08, 2013 at 10:50:36AM +0200, Pali Rohár wrote:
>> > > > > > diff --git a/drivers/usb/phy/phy-twl4030-usb.c
>> > > > > > b/drivers/usb/phy/phy-twl4030-usb.c index
>> > > > > > 8f78d2d..efe6155 100644
>> > > > > > --- a/drivers/usb/phy/phy-twl4030-usb.c
>> > > > > > +++ b/drivers/usb/phy/phy-twl4030-usb.c
>> > > > > > @@ -705,6 +705,8 @@ static int
>> > > > > > twl4030_usb_probe(struct platform_device *pdev)
>> > > > > >
>> > > > > >     if (device_create_file(&pdev->dev,
>> > > > > >     &dev_attr_vbus))
>> > > > > >
>> > > > > >             dev_warn(&pdev->dev, "could not create sysfs
>> > > > > >             file\n");
>> > > > > >
>> > > > > > +   ATOMIC_INIT_NOTIFIER_HEAD(&twl->phy.notifier);
>> > > > >
>> > > > > BTW, this is a bugfix, send separately.
>> > > >
>> > > > What to send separately?
>> > > >
>> > > > This full patch 1/4 is bugfix. And I did not understand
>> > > > what you want. Maybe it could be easier for you to
>> > > > apply this small 3+2 lines patch how you need.
>> > >
>> > > This hunk here (initializaing notifier head) is a separate
>> > > bug fix and needs its own patch.
>> >
>> > So will you do that? Or it is needed to resend this one line
>> > hunk again in new email again?
>>
>> new patch, new email
>
> Guys, WHY ARE YOU SO STUPID AND ARROGANT?
>
> Sorry but, need to copy full isolated patch/hunk from one mail to
> another is hassling. So what you want from me? Do all those non
> sense working only because yesterday you had bad day? Or what?
>
> Everything needed with described information was in first mail.
> Also second hunk has full isolated "git diff" output, so it is for
> you really big problem to copy it? Or you did not see that patch?
>
> I really did not understand what you wanted from me.
>
> ============================
> ==== BEGINNING OF PATCH ====
> ============================
>
> This is bugfix and sending this patch separately from all other patches.
> This patch is visibly isolated from all others and could be readable also
> by disabled people. For other handicapped people I suggest to increase
> font size and other text settings in program which view this patch.
> For visually impaired people I suggest to use some text-to-speech software.
>
> This is small 2 lines patch, diff starting after next visible break.
>
> This patch initializing notifier head in tw4030 usb code which is missing.
> Initialization code is needed for using any atomic_notifier_* functions.
>
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
>
> ===========================
> ==== BEGINNING OF DIFF ====
> ===========================
>
> diff --git a/drivers/usb/phy/phy-twl4030-usb.c b/drivers/usb/phy/phy-twl4030-usb.c
> index 8f78d2d..efe6155 100644
> --- a/drivers/usb/phy/phy-twl4030-usb.c
> +++ b/drivers/usb/phy/phy-twl4030-usb.c
> @@ -705,6 +705,8 @@ static int twl4030_usb_probe(struct platform_device *pdev)
>         if (device_create_file(&pdev->dev, &dev_attr_vbus))
>                 dev_warn(&pdev->dev, "could not create sysfs file\n");
>
> +       ATOMIC_INIT_NOTIFIER_HEAD(&twl->phy.notifier);
> +
>         /* Our job is to use irqs and status from the power module
>          * to keep the transceiver disabled when nothing's connected.
>          *
>
> ======================
> ==== END OF PATCH ====
> ======================
>
> PS: This is end of email and patch is above ^^^^
>

Hi Pali,

There is no need to be rude.

Felipe asked you to do the split since he believes that the notifier
chain call for musb xceiv and the twl->phy notifier head init should
be done in two separate patches.

I agree with him since is better to separate bugfixs from new features
for different reasons. For example if is found that a feature has to
be reverted, then this won't revert a bugfix causing a regression.
Also, it is easier to review and the bugfix patch can be cherry-picked
by stable kernels.

You said that to copy isolated patch/hunk from one mail to another is
hassling so why do you want Felipe to do that? He like most most
sub-system maintainers is very busy so if we want the kernel to scale
we have to help them to make their live easier.

So,  I don't understand from where your anger comes for just the need
to split your patch in two and send correct patches with git
send-email so Felipe can apply easily with git am mbox or whatever
worfklow he has.

This is not the first time you contribute to the kernel so you know
that the above patch s not only not in the correct format to be
applied but also has a very offensive commit changelog that is not
suitable for the kernel.

Take a deep breath, grab a mug of coffee and then just split your
patches and repost as v2, I'm sure you spent more time writing that
angry email that what it would have taken to do it properly ;-)

> --
> Pali Rohár
> pali.rohar@gmail.com

Best regards,
Javier
