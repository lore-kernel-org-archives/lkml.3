Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161129AbaJ3RKM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 13:10:12 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:36554 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934682AbaJ3RKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 13:10:08 -0400
MIME-Version: 1.0
In-Reply-To: <20141030134517.GB19802@ulmo.nvidia.com>
References: <1414535277-15645-1-git-send-email-abrestic@chromium.org>
	<1414535277-15645-5-git-send-email-abrestic@chromium.org>
	<20141029122738.GE28356@ulmo.nvidia.com>
	<CAL1qeaF53VUEcn6OruxjufEXnPxyoqp4=sLUuhvJcrpGH=707A@mail.gmail.com>
	<20141030134517.GB19802@ulmo.nvidia.com>
Date: Thu, 30 Oct 2014 10:10:06 -0700
X-Google-Sender-Auth: fBfl05tCOjPgDgog8SWTXjj0BkM
Message-ID: <CAL1qeaEgyROk2dHbAOCUBJwCFegXH3_Yhr3reWdOrUXHvJ2cdg@mail.gmail.com>
Subject: Re: [PATCH RESEND V4 4/9] pinctrl: tegra-xusb: Add USB PHY support
From: Andrew Bresticker <abrestic@chromium.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 6:45 AM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Wed, Oct 29, 2014 at 12:43:36PM -0700, Andrew Bresticker wrote:
>> >> diff --git a/drivers/pinctrl/pinctrl-tegra-xusb.c b/drivers/pinctrl/pinctrl-tegra-xusb.c
> [...]
>> >> +
>> >> +     for (i = 0; i < TEGRA_XUSB_USB3_PHYS; i++) {
>> >> +             if (phy == padctl->phys[TEGRA_XUSB_PADCTL_USB3_P0 + i])
>> >> +                     break;
>> >
>> > You could simply return i here and then BUG_ON unconditionally.
>> >
>> >> +     }
>> >> +     BUG_ON(i == TEGRA_XUSB_USB3_PHYS);
>> >> +
>> >> +     return i;
>> >> +}
>> >
>> > Actually, thinking about it some more, perhaps making this a WARN_ON()
>> > and returning an error so that we can continue and propagate the error
>> > would be more useful. BUG_ON() will completely hang the kernel with no
>> > way out but rebooting. WARN_ON() will give a hint about something being
>> > wrong and returning an error will allow the kernel to continue to run,
>> > which might be the only way to diagnose and fix the problem, even if it
>> > means that USB 3.0 support will be disabled.
>>
>> I felt like BUG_ON is more appropriate here.  Hitting this case means
>> there's a bug in the PHY core or a driver has passed a bogus pointer
>> and the stack dump produced by the BUG_ON should make it obvious as to
>> what the issue is.  I don't feel too strongly about it though.
>
> The problem with BUG_ON() is that you won't be able to go any further.
> So if this were to happen on a device with no serial you might not even
> get to a point where you actually see an error message. Handling this
> more gracefully by propagating the error code and failing .probe() does
> not seem overly complicated and the WARN_ON() output will hopefully
> still be noticed (it probably will be after the user can't get USB to
> work).

Ok.

>> >> @@ -936,6 +2098,18 @@ static int tegra_xusb_padctl_probe(struct platform_device *pdev)
>> >>               goto unregister;
>> >>       }
>> >>
>> >> +     INIT_WORK(&padctl->mbox_req_work, tegra_xusb_phy_mbox_work);
>> >> +     padctl->mbox_client.dev = &pdev->dev;
>> >> +     padctl->mbox_client.tx_block = true;
>> >> +     padctl->mbox_client.tx_tout = 0;
>> >> +     padctl->mbox_client.rx_callback = tegra_xusb_phy_mbox_rx;
>> >> +     padctl->mbox_chan = mbox_request_channel(&padctl->mbox_client, 0);
>> >> +     if (IS_ERR(padctl->mbox_chan)) {
>> >> +             err = PTR_ERR(padctl->mbox_chan);
>> >> +             dev_err(&pdev->dev, "failed to request mailbox: %d\n", err);
>> >> +             goto unregister;
>> >> +     }
>> >
>> > I think this should be done before the registering the PHY provider so
>> > that we don't expose one (even for only a very short time) before we
>> > haven't made sure that it can be used.
>> >
>> > Also, this effectively makes the mailbox mandatory, which means that the
>> > above code is going to break on older DTBs. So I think we have no choice
>> > but to make mailbox (and hence XUSB) support optional.
>>
>> I understand the need for binding stability, but it's not like these
>> bindings have been around for very long (a release or two?) and this
>> series has existed for almost the same amount of time.  Are there
>> really any DTBs out there that are going to break because of this?
>
> Every DTB created from a kernel version that has the original binding
> but not the one modified as part of this series is going to break. Last
> time I checked there weren't any exceptions to this rule. Note, though,
> that the rule is that existing functionality must not break. That is,
> SATA and PCIe should remain functional, so it should be fine if you just
> don't register any of the USB PHYs when the request for a mailbox
> channel fails. Something along these lines should do it:
>
>         padctl->mbox_chan = mbox_request_channel(...);
>         if (!IS_ERR(padctl->mbox_chan)) {
>                 err = tegra_xusb_padctl_setup_usb(...);
>                 ...
>         }

Ok.

>> >> diff --git a/include/soc/tegra/xusb.h b/include/soc/tegra/xusb.h
>> >> index cfe211d..149434f 100644
>> >> --- a/include/soc/tegra/xusb.h
>> >> +++ b/include/soc/tegra/xusb.h
>> >> @@ -10,6 +10,13 @@
>> >>  #ifndef __SOC_TEGRA_XUSB_H__
>> >>  #define __SOC_TEGRA_XUSB_H__
>> >>
>> >> +#define TEGRA_XUSB_USB3_PHYS 2
>> >> +#define TEGRA_XUSB_UTMI_PHYS 3
>> >> +#define TEGRA_XUSB_HSIC_PHYS 2
>> >> +#define TEGRA_XUSB_NUM_USB_PHYS (TEGRA_XUSB_USB3_PHYS + TEGRA_XUSB_UTMI_PHYS + \
>> >> +                              TEGRA_XUSB_HSIC_PHYS)
>> >> +#define TEGRA_XUSB_NUM_PHYS (TEGRA_XUSB_NUM_USB_PHYS + 2) /* + SATA & PCIe */
>> >
>> > These are really XUSB pad controller specific defines, why does anyone
>> > else need to know this?
>>
>> They're not pad controller specific.  They're also used in the xHCI host driver.
>
> I keep thinking that there should be a way around this. Of course if
> both the XHCI and mailbox drivers were merged, then there'd be no need
> to expose this publicly at all.

I'm not sure what you mean.  They're SoC-specific constants that need
to be shared amongst multiple drivers.  It would make sense to place
them in a shared header, does it not?
