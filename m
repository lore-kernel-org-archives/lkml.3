Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab3BPD47 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 22:56:59 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:34874 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab3BPD45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 22:56:57 -0500
MIME-Version: 1.0
In-Reply-To: <20130214173127.GC4007@core.coreip.homeip.net>
References: <1360723347-28701-1-git-send-email-sjg@chromium.org>
	<1360723347-28701-7-git-send-email-sjg@chromium.org>
	<20130213200232.GB22031@core.coreip.homeip.net>
	<CAPnjgZ2-QV36Ro_G32kcHStpj0SCC_gDoeCPqjN-h6bsBTSGvQ@mail.gmail.com>
	<20130214173127.GC4007@core.coreip.homeip.net>
Date: Fri, 15 Feb 2013 19:56:56 -0800
X-Google-Sender-Auth: DpdZ443N38u5w7Owe6Q2cGO78Lc
Message-ID: <CAPnjgZ2aPJdn8jcSjdYmUoqgh2Z8oVCoCZFfmV5g5NQ80seB0w@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] Input: Add ChromeOS EC keyboard driver
From: Simon Glass <sjg@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Luigi Semenzato <semenzato@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Felipe Balbi <balbi@ti.com>, Sourav Poddar <sourav.poddar@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Mike A. Chan" <mikechan@google.com>,
        Jun Nakajima <jun.nakajima@intel.com>,
        Tom Keel <thomas.keel@intel.com>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Thu, Feb 14, 2013 at 9:31 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Wed, Feb 13, 2013 at 10:45:07PM -0800, Simon Glass wrote:
>> >>
>> >> +config KEYBOARD_CROS_EC
>> >> +     tristate "ChromeOS EC keyboard"
>> >> +     select INPUT_MATRIXKMAP
>> >> +     select MFD_CROS_EC
>> >
>> > Is this select safe? I.e. does MFD_CROS_EC depend on anything else?
>>
>> I'll remove it, since it isn't required, and it's true that it does
>> need other things.
>
> Instead of droppign the dependency completely I think it should "depens
> on MFD_CROS_EC"

OK, done.

>
>> >> +
>> >> +static void cros_ec_keyb_close(struct input_dev *dev)
>> >> +{
>> >> +     struct cros_ec_keyb *ckdev = input_get_drvdata(dev);
>> >> +
>> >> +     blocking_notifier_chain_unregister(&ckdev->ec->event_notifier,
>> >> +                                        &ckdev->notifier);
>> >> +     blocking_notifier_chain_unregister(&ckdev->ec->wake_notifier,
>> >> +                                        &ckdev->wake_notifier);
>> >
>> > Why is this done via a notifier instead of regular resume method?
>>
>> Because we only call the notifer in resume when we were not waking on
>> a keyboard event. We use it to flush the keyboard. It was a late
>> change so there might be a better way, but this driver does not have a
>> resume handler.
>
> Right and the question is why does not it have resume handler and why
> you inventing your own resume infrastructure instead of using the
> standard one.

I will fix that.

>
>> >> +
>> >> +static int cros_ec_keyb_probe(struct platform_device *pdev)
>> >> +{
>> >> +     struct cros_ec_device *ec = dev_get_drvdata(pdev->dev.parent);
>> >> +     struct device *dev = ec->dev;
>> >> +     struct cros_ec_keyb *ckdev = NULL;
>> >> +     struct input_dev *idev = NULL;
>> >> +     struct device_node *np;
>> >> +     int err;
>> >> +
>> >> +     np = of_find_matching_node(NULL, cros_ec_kbc_of_match);
>> >
>> > And if we don't find it?
>>
>> Added error checking.
>>
>> >
>> >> +
>> >> +     ckdev = kzalloc(sizeof(*ckdev), GFP_KERNEL);
>> >> +     if (!ckdev) {
>> >> +             dev_err(dev, "cannot allocate memory for ckdev\n");
>> >> +             return -ENOMEM;
>> >> +     }
>> >> +     pdev->dev.of_node = np;
>> >
>> > Huh? I'd expect the platform device be fully set up (including DT data)
>> > before the driver is called.
>>
>> This is a child of the mfd driver cros_ec, so I don't think that
>> works. Or maybe I'm just not sure how to plumb it in so it is
>> automatic. Or maybe I just need to add the id to the device info
>> below?
>
> Who creates this device? Whoever does this should set up the
> pdev->dev.of_node. This is not this driver's responsibility.
>
> And then you add the id to the table below and matching is done
> automatically.

OK I see - it comes from mfd and it is easy enough to make it do the
right thing.

Thanks for your comments and patience. I will send a new patch.

Regards,
Simon

>
> Thanks.
>
> --
> Dmitry
