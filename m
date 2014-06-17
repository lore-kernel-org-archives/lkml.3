Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964993AbaFQRad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 13:30:33 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:38021 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964772AbaFQRaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 13:30:30 -0400
MIME-Version: 1.0
In-Reply-To: <539F570C.2000507@wwwdotorg.org>
References: <1402689965-19397-1-git-send-email-jwerner@chromium.org>
 <CAL_JsqL-K4i54ysugCKSw-aO-9pvnYgZfJ=NdBAot=mwffxmyA@mail.gmail.com>
 <CAODwPW9tRM8kxBVg3apkec2K1rahuENk_b_BD_0jvXON7JzeaA@mail.gmail.com>
 <CAL_Jsq+rGLFcOcs8Rmr8NntbPhGBG+F7yAF0YQ-Rm-UsmmTLSA@mail.gmail.com> <539F570C.2000507@wwwdotorg.org>
From: Rob Herring <robherring2@gmail.com>
Date: Tue, 17 Jun 2014 12:30:09 -0500
Message-ID: <CAL_JsqJ1eMb9CprhuzzhKyN0PYVjxviWjoefR_9ypxhFT0FgBg@mail.gmail.com>
Subject: Re: [PATCH] firmware: Add device tree binding for coreboot
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Julius Werner <jwerner@chromium.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <stephen.r.warren@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olofj@chromium.org>,
        Stefan Reinauer <stefan.reinauer@coreboot.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 3:43 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 06/16/2014 07:30 AM, Rob Herring wrote:
>> On Fri, Jun 13, 2014 at 4:58 PM, Julius Werner <jwerner@chromium.org> wrote:
> ...
>>> Rob Herring wrote:
>>>> Don't you need need to keep the kernel from allocating this memory by
>>>> using one of the reserved memory mechanisms? The recently added one
>>>> should be able to specific what the memory is reserved for IIRC.
>>>
>>> Our bootloader is carving the location out of the /memory node and
>>> adding it to the device tree reserve map. As far as I know, that only
>>> contains a list of raw start and size entries. At any rate, I think
>>> it's useful (and in line with other bindings) to add a more explicit
>>> node like this (if only to make it easier accessible through
>>> /proc/device-tree).
>>
>> Understand there are 3 different memory reservation bindings. The
>> original "/memreserve/" method is indeed limited. What I think you
>> should use is the binding documented in
>> Documentation/devicetree/bindings/reserved-memory/reserved-memory.txt.
>> So you could do something like this:
>>
>>         reserved-memory {
>>                 #address-cells = <1>;
>>                 #size-cells = <1>;
>>                 ranges;
>>
>>                 /* global autoconfigured region for contiguous allocations */
>>                 linux,cma {
>>                         compatible = "shared-dma-pool";
>>                         reusable;
>>                         size = <0x4000000>;
>>                         alignment = <0x2000>;
>>                         linux,cma-default;
>>                 };
>>
>>                 coreboot_reserved: coreboot@fdfea000 {
>>                       compatible = "coreboot";
>>                       reg = <0xfdfea000 0x264>,
>>                           <0xfdfea000 0x16000>;
>>                 };
>>
>
> I thought that the /reserved-memory node was more so that the
> (preferred?) location of firmware images or data buffers used by HW
> accelerators could be communicated to the kernel. This feels like pure data.

That was the initial use, but I think this case fits well. PPC may
have some other uses already. I haven't looked.

> The coreboot binding seems to be more about defining an interface to a
> particular firmware (this feels like semantics), which as a side-effect
> needs to communicate the location of certain data.

The DT is only defining it's presence and location. Knowledge of what
the data is is (optionally) in the kernel.

> If /reserved-memory is used to communicate the address of the memory
> regions, I think we still need a /firmware/coreboot node to indicate the
> semantics of the reserved memory region, and point at the phandle of the
> region. As such, it seems simpler just to put the addresses in the
> coreboot node's reg property. The only exception I see to that argument
> is if putting the region in /reserved-memory automatically carves that
> region out of the memory the kernel will allocate from. That would
> simplify the bootloader, since it wouldn't have to fiddle with the
> /memory node and do the carveout itself.

The semantics are defined by a compatible property which the
/reserved-memory binding has. Knowledge of what is in that range is in
the kernel, not the DT. And yes, either /memreserve/ or
/reserved-memory is needed to prevent kernel allocations.

I'm not tied to /reserved-memory, but I just want a consistent way to
describe random blocks of static data in memory. DMI tables are
another similar example. We've already got some scattered usage of
/firmware. There's also /psci for PSCI. UEFI is using /chosen for its
tables (probably for good reason since the tables are needed early and
need to be simple to parse).

Rob
