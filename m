Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbaBTEHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 23:07:25 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:44535 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbaBTEHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 23:07:22 -0500
MIME-Version: 1.0
In-Reply-To: <1392821911.17130.63.camel@iivanov-dev>
References: <1392729681-21022-1-git-send-email-iivanov@mm-sol.com>
	<CA+bK7J7D1bgehNMaMtWWggZ5KDBfZ8LK0bEYUARmc8OD3wa89Q@mail.gmail.com>
	<1392821911.17130.63.camel@iivanov-dev>
Date: Wed, 19 Feb 2014 20:07:21 -0800
Message-ID: <CA+bK7J5LrV-Dh1tNhEwhJ4y+XbkDeQkwVWoUYFX46X9uV1HdUQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] usb: chipidea: msm: Clean and fix glue layer driver
From: Tim Bird <tbird20d@gmail.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Peter Chen <Peter.Chen@freescale.com>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Brown <davidb@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks very much.  I will try out the things you mention and let you
know if I make progress.
 -- Tim


On Wed, Feb 19, 2014 at 6:58 AM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:
>
> Hi Tim,
>
> On Tue, 2014-02-18 at 22:21 -0800, Tim Bird wrote:
>> Ivan,
>>
>> I'm having tremendous problems getting this driver to initialize.  For
>> some reason, I can't get the driver to actually transition the
>> hardware into peripheral mode.  At first I was getting a lot of probe
>> deferrals, based on not finding the regulators early enough in the
>> boot, and I thought it was an issue with the gadget drivers loading
>> before the driver could complete its setup.  However, I switched
>> everything to loading via modules, and now have less probe deferrals,
>> but I still can't get the driver to activate.
>
> My understanding for gadget drivers is that you can have only one
> of them active in particular time. When compiled in kernel you can
> chose only one of them, also you can have only one module (function)
> loaded.
>
>
>>   I see zero interrupts.
>
> Right, I think that we will not see interrupts until we have
> SPMI drivers which could control PMIC chip, PMIC is responsible
> to do ID line detection and generate IRQ to APQ/MSM chip.
>
>> In particular the routine hw_device_state (which turns on interrupts
>> in the controller) is never called, because I can't get
>> msm_otg_start_peripheral to actually kick the hardware.
>>
>
> OTG state machine is not used at all. This phy-"otg" driver is
> working only in "peripheral" mode, because of missing PMIC
> communication.
>
> The only callback which you could see to be executed is
> struct usb_otg::set_peripheral(), when you load gadget driver.
>
>
> <snip>
>
> (Would you mind sharing your config?).
>
> Sure. Attached.
>
>
>> I tried configuring the qcom,otg-control for user controlled mode
>> setting (via debugfs),
>
> Never testes this. It was there before.
>
>>
>> My kernel is based on an internal Sony 3.13-rc6 kernel with clock and
>> regulator patches applied, as well as your phy-msm-usb.c patches from
>> November and your chipidea patches from yesterday.
>
> You will need also 4th chipidea patch[1]. I have dropped it, because
> I will like to upstream PHY driver changes first. They are depended
> anyway.
>
> To reduce dependency to other drivers, I could recommend you to
> use Zero gadget driver. It should be enough to test USB stack,
> where APQ device will be peripheral and development workstation
> will be a host[2].
>
>
> # cat zero.sh
> #!/bin/sh
> cd /lib/modules/$(uname -r)/kernel/drivers/usb/gadget
> insmod ./libcomposite.ko
> insmod ./usb_f_ss_lb.ko
> insmod ./g_zero.ko
>
>
>> [   22.454287] [<c022afd8>] (warn_slowpath_common+0x68/0x88) from
>> [<c022b08c>] (warn_slowpath_fmt+0x30/0x40)
>> [   22.463060] [<c022b08c>] (warn_slowpath_fmt+0x30/0x40) from
>> [<bf005024>] (msm_otg_probe+0x24/0x904 [phy_msm_usb])
>> [   22.472703] [<bf005024>] (msm_otg_probe+0x24/0x904 [phy_msm_usb])
>
> This is know non-fatal issue. I will try to see how to fix it.
>
>
> Regards,
> Ivan
>
> [1] usb: chipidea: msm: Use USB PHY API to control PHY state
> [2] http://www.linux-usb.org/usbtest/
>
>



-- 
 -- Tim Bird
Senior Software Engineer, Sony Mobile
Architecture Group Chair, CE Workgroup, Linux Foundation
