Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750969Ab3HSP4w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 11:56:52 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59458 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab3HSP4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 11:56:50 -0400
Message-ID: <5212403E.9070304@wwwdotorg.org>
Date: Mon, 19 Aug 2013 09:56:46 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Alexandre Courbot <gnurou@gmail.com>
CC: Alexandre Courbot <acourbot@nvidia.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tomasz Figa <tomasz.figa@gmail.com>, Dave Martin <Dave.Martin@arm.com>,
        Joseph Lo <josephl@nvidia.com>, Jassi Brar <jassisinghbrar@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/5] ARM: add basic Trusted Foundations support
References: <1376360992-1508-1-git-send-email-acourbot@nvidia.com> <1376360992-1508-2-git-send-email-acourbot@nvidia.com> <520BF835.5080309@wwwdotorg.org> <CAAVeFuJ9tgXRf+QZRK5K8O2X=mKxUZtFgTsB06r4huQrDwZx2A@mail.gmail.com>
In-Reply-To: <CAAVeFuJ9tgXRf+QZRK5K8O2X=mKxUZtFgTsB06r4huQrDwZx2A@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2013 02:37 AM, Alexandre Courbot wrote:
> On Thu, Aug 15, 2013 at 6:35 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 08/12/2013 08:29 PM, Alexandre Courbot wrote:
>>> Trusted Foundations is a TrustZone-based secure monitor for ARM that
>>> can be invoked  using a consistent smc-based API on all supported
>>> platforms. This patch adds initial basic support for Trusted
>>> Foundations using the ARM firmware API. Current features are limited
>>> to the ability to boot secondary processors.
>>
>>> diff --git a/Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundations.txt b/Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundations.txt
>>
>>> +Trusted Foundations
>>> +
>>> +Boards that use the Trusted Foundations secure monitor can signal its
>>> +presence by declaring a node compatible with "tl,trusted-foundations"
>>> +(the name and location of the node does not matter).
>>> +
>>> +Required properties:
>>> +- compatible : "tl,trusted-foundations"
>>
>>> +- version : Must contain the version number string of the Trusted Foundation
>>> +     firmware.
>>
>> Can the version be queried at run-time from the firmware itself?
> 
> I'm afraid there is not, unfortunately. :/
> 
>> If not, I wonder if we shouldn't instead encode the version number into
>> the compatible value.
> 
> Why? This would make the node harder to find and would also complicate
> the case where a given firmware handler can support a given range of
> versions (which is what I expect will happen).

I guess that would be painful. There are probably a lot more valid
version numbers for a SW firmware interface than there are for a HW IP
block interface, so it makes less sense to encoded the version into the
compatible value, at least in cases where the interface is "similar
enough"; we can add some kind of basic version number into the
compatible values for radically different interfaces if they appear in
the future.

>>> diff --git a/arch/arm/firmware/Kconfig b/arch/arm/firmware/Kconfig
>>
>>> +config ARCH_SUPPORTS_TRUSTED_FOUNDATIONS
>>> +     bool
>>
>> Shouldn't that be "config ARCH_SUPPORTS_FIRMWARE", since presumably in
>> the future there will be more entries in the menu, and hence we want the
>> menu to appear if any of those entries are useful?
> 
> The things is that because you support one firmware does not mean you
> will support then all. Only some set of architectures will support
> firmware X, and another set (maybe not inclusive) will support
> firmware Y. We do not want to allow selecting firmware Y if the kernel
> does not support any of the architectures that may make use of it.
> 
>>> +
>>> +menu "Firmware options"
>>> +     depends on ARCH_SUPPORTS_TRUSTED_FOUNDATIONS
>>
>> Or perhaps that comment is more appropriate for that "depends".
> 
> Here the idea is to not show the "Firmware options" menu if the kernel
> does not include support for any architecture that uses them. As more
> firmwares get added, the depends line should expand into something
> like "depends on ARCH_SUPPORTS_FIRMWARE_X || ARCH_SUPPORTS_FIRMWARE_Y
> || ...
> 
> Maybe there's a better way to express this?

Is there a need for a menu at all? I suppose it might group things
nicely. If so, how about:

config ARCH_SUPPORTS_FIRMWARE
	bool

config ARCH_SUPPORTS_TRUSTED_FOUNDATIONS
	bool
	select ARCH_SUPPORTS_FIRMWARE

config ARCH_SUPPORTS_SOME_OTHER_FW
	bool
	select ARCH_SUPPORTS_FIRMWARE

menu "Firmware options"
	depends on ARCH_SUPPORTS_FIRMWARE

That's probably slightly easier to read than a huge "depends" statement
in the menu stanza, and ARCH_SUPPORTS_FIRMWARE might be a useful to
build in support for any core firmware utility code.
