Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135Ab3JKH1H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 03:27:07 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:62137 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351Ab3JKH1E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 03:27:04 -0400
MIME-Version: 1.0
In-Reply-To: <5257A0C0.8000701@ti.com>
References: <1381402195-29257-1-git-send-email-kishon@ti.com>
	<20131010141949.GA13277@kahuna>
	<52579723.6080209@ti.com>
	<CAGo_u6odWJ9UKwgaVu2YZzZKuYbveBoGDf99L=rJoK1-9KJ0SA@mail.gmail.com>
	<5257A05B.2070906@ti.com>
	<5257A0C0.8000701@ti.com>
Date: Fri, 11 Oct 2013 02:27:02 -0500
X-Google-Sender-Auth: TJn5X7kQu56yLIA42sdRGAI5KrQ
Message-ID: <CAGo_u6q-5v05nou+WSw_scWgUDHYXMELtaMGXu7Vk2Wx4pNqog@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: dts: omap5-uevm: remove always_on, boot_on from smps10_out1
From: Nishanth Menon <nm@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Mark Rutland <mark.rutland@arm.com>, dt list <devicetree@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pawel Moll <pawel.moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Benoit Cousson <bcousson@baylibre.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 1:54 AM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> On Friday 11 October 2013 12:23 PM, Kishon Vijay Abraham I wrote:
>> Hi,
>>
>> On Friday 11 October 2013 12:00 PM, Nishanth Menon wrote:
>>> On Fri, Oct 11, 2013 at 1:13 AM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
>>>>
>>>>> regulator-boot-on indicates that PMIC enables it by default as part of
>>>>> OTP or some internal behavior -> Looking at the measurements done on
>>>>> uEVM and OTP information -> regulator-boot-on should be kept here.
>>>>
>>>> No. Actually I don’t want PMIC to enable it by default. I want the palmas-usb
>>>> driver to handle it.
>>>> Enabling it by default makes palmas-usb to detect VBUS interrupt. This should
>>>> ideally be detected only when you connect a host cable.
>>>> Btw I didn't exactly get why you want regulator-boot-on should be kept here.
>>>
>>> binding description states:
>>> - regulator-boot-on: bootloader/firmware enabled regulator
>>> Further info: include/linux/regulator/machine.h
>>> * @boot_on: Set if the regulator is enabled when the system is initially
>>> *           started.  If the regulator is not enabled by the hardware or
>>> *           bootloader then it will be enabled when the constraints are
>>> *           applied.
>>>
>>> What that means is that it is enabled by firmware/bootloader (in our
>>> case One Time Program {OTP} inside Palmas) when the system switches on
>>> even before the kernel starts. and we know SMPS10 is autoenabled by
>>> Palmas OTP configuration even before first instruction in A15
>>> executes.
>>
>> Not sure about that. Please note SMPS10 has two outputs OUT1 and OUT2 and I
>> tend to think that it might be OUT2 that's getting enabled by the OTP.
>>>
>>> I think you misunderstand this to mean that you'd like the regulator
>>> to be *switched on* automatically at kernel boot by regulator
>>> framework - there is no reasoning why we'd want such a binding since
>>> we'd expect drivers to do their job of requesting and enabling
>>> regulators on need..
>>
>> The comment you just quoted tells it enables the regulator if its not enabled
>> by hardware. "If the regulator is not enabled by the hardware or bootloader
>> then it will be enabled when the constraints are applied." At-least that's what
>> I understood from that comment.
>>
>> Also from our experiments it doesn't look like SMPS10_OUT1 is enabled by the
>> OTP and it gets enabled when we have *regulator-boot-on* constraints.
>
> btw.. I think this is the code in regulator fw that's responsible for enabling..
>
>         /* If the constraints say the regulator should be on at this point
>          * and we have control then make sure it is enabled.
>          */
>         if ((rdev->constraints->always_on || rdev->constraints->boot_on) &&
>             ops->enable) {
>                 ret = ops->enable(rdev);
>                 if (ret < 0) {
>                         rdev_err(rdev, "failed to enable\n");
>                         goto out;
>                 }
>         }

Drat, you are right, I did not really dig deep. thanks for correcting
my understanding here.

I propose the following change in binding as it seems completely
misleading to me.

diff --git a/Documentation/devicetree/bindings/regulator/regulator.txt
b/Documentation/devicetree/bindings/regulator/regulator.txt
index 2bd8f09..d999f096 100644
--- a/Documentation/devicetree/bindings/regulator/regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/regulator.txt
@@ -8,7 +8,9 @@ Optional properties:
 - regulator-min-microamp: smallest current consumers may set
 - regulator-max-microamp: largest current consumers may set
 - regulator-always-on: boolean, regulator should never be disabled
-- regulator-boot-on: bootloader/firmware enabled regulator
+- regulator-boot-on: regulator is enabled when the system is initially started.
+  If the regulator is not enabled by the hardware or bootloader then it will be
+  enabled when the constraints are applied.
 - regulator-allow-bypass: allow the regulator to go into bypass mode
 - <name>-supply: phandle to the parent supply/regulator node
 - regulator-ramp-delay: ramp delay for regulator(in uV/uS)
