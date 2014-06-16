Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbaFPNag (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:30:36 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:54311 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbaFPNad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:30:33 -0400
MIME-Version: 1.0
In-Reply-To: <CAODwPW9tRM8kxBVg3apkec2K1rahuENk_b_BD_0jvXON7JzeaA@mail.gmail.com>
References: <1402689965-19397-1-git-send-email-jwerner@chromium.org>
 <CAL_JsqL-K4i54ysugCKSw-aO-9pvnYgZfJ=NdBAot=mwffxmyA@mail.gmail.com> <CAODwPW9tRM8kxBVg3apkec2K1rahuENk_b_BD_0jvXON7JzeaA@mail.gmail.com>
From: Rob Herring <robherring2@gmail.com>
Date: Mon, 16 Jun 2014 08:30:12 -0500
Message-ID: <CAL_Jsq+rGLFcOcs8Rmr8NntbPhGBG+F7yAF0YQ-Rm-UsmmTLSA@mail.gmail.com>
Subject: Re: [PATCH] firmware: Add device tree binding for coreboot
To: Julius Werner <jwerner@chromium.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
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

On Fri, Jun 13, 2014 at 4:58 PM, Julius Werner <jwerner@chromium.org> wrote:
>> This is just to export a fixed log to userspace (like a DMI table) or
>> the kernel will actually use the data in some way? Based on the link,
>> it looks like the former to me.
>
> I could imagine both. The link is an in-kernel driver that exposes a
> log through a sysfs node (in a way that has already been established
> on x86 systems, which find the location through EBDA or ACPI entries
> instead). We are also using a user-space tool that reads the address
> from /proc/device-tree and accesses it through /dev/mem. The areas can
> contain many interesting entries (like the location of an early
> framebuffer set up by the firmware), so I could also imagine use cases
> where the kernel makes use of it directly.

I can be argued that the boot interface is DT and any configuration
data should be put there in a common way. We don't really need yet
another boot mechanism as we already have:

UEFI + FDT
UEFI + ACPI
"standard" bootloaders (e.g. u-boot, grub, barebox, etc.) + FDT

Allowing every bootloader to define its own boot interfaces would only
result in a mess for both code and testing. I don't want to get into a
debate about this now as it is not too relevant to this patch, but
just want to highlight the resistance you will face going down this
path.

>> Don't you need need to keep the kernel from allocating this memory by
>> using one of the reserved memory mechanisms? The recently added one
>> should be able to specific what the memory is reserved for IIRC.
>
> Our bootloader is carving the location out of the /memory node and
> adding it to the device tree reserve map. As far as I know, that only
> contains a list of raw start and size entries. At any rate, I think
> it's useful (and in line with other bindings) to add a more explicit
> node like this (if only to make it easier accessible through
> /proc/device-tree).

Understand there are 3 different memory reservation bindings. The
original "/memreserve/" method is indeed limited. What I think you
should use is the binding documented in
Documentation/devicetree/bindings/reserved-memory/reserved-memory.txt.
So you could do something like this:

        reserved-memory {
                #address-cells = <1>;
                #size-cells = <1>;
                ranges;

                /* global autoconfigured region for contiguous allocations */
                linux,cma {
                        compatible = "shared-dma-pool";
                        reusable;
                        size = <0x4000000>;
                        alignment = <0x2000>;
                        linux,cma-default;
                };

                coreboot_reserved: coreboot@fdfea000 {
                      compatible = "coreboot";
                      reg = <0xfdfea000 0x264>,
                          <0xfdfea000 0x16000>;
                };


>> /firmware is already used IIRC. What if you have other firmware such
>> as Trustzone?
>
> I'm not quite sure how Trusted Foundations works and whether it would
> even make sense to use it in parallel to coreboot, but it seems to be
> using the /firmware/trusted-foundations subnode so that should be
> fine. "firmware" seems to be used by other firmware implementations
> (like "samsung,secure-firmware") which are similar in nature to and
> mutually exclusive with coreboot, so I thought the node makes sense.
> (The kernel should use the compatible string to find it anyway, so a
> future name clash would not be world-ending.)

They are not mutually exclusive. What runs in secure world or not is
entirely independent of non-secure boot. You may not care about it,
but other platforms could.

Rob
