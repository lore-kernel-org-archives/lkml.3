Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbaFMVTQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 17:19:16 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:43762 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbaFMVTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 17:19:15 -0400
MIME-Version: 1.0
In-Reply-To: <1402689965-19397-1-git-send-email-jwerner@chromium.org>
References: <1402689965-19397-1-git-send-email-jwerner@chromium.org>
From: Rob Herring <robherring2@gmail.com>
Date: Fri, 13 Jun 2014 16:11:30 -0500
Message-ID: <CAL_JsqL-K4i54ysugCKSw-aO-9pvnYgZfJ=NdBAot=mwffxmyA@mail.gmail.com>
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 3:06 PM, Julius Werner <jwerner@chromium.org> wrote:
> This patch adds documentation describing a device tree binding for the
> coreboot firmware project (www.coreboot.org). It is meant to be
> dynamically added during boot and contains address definitions for the
> coreboot table (a list of variable-sized descriptors providing
> information about various compile- and run-time generated firmware
> parameters) and the CBMEM area (the structure containing most run-time
> resident memory regions set up by coreboot).
>
> These definitions allow kernel drivers to easily access data contained
> in and pointed to by these regions (such as coreboot's in-memory log).
> (An example implementation can be seen at http://crosreview.com/203371,
> which will be submitted at a later point.)

This is just to export a fixed log to userspace (like a DMI table) or
the kernel will actually use the data in some way? Based on the link,
it looks like the former to me.

> Signed-off-by: Julius Werner <jwerner@chromium.org>
> ---
>  .../devicetree/bindings/firmware/coreboot.txt      | 28 ++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/firmware/coreboot.txt
>
> diff --git a/Documentation/devicetree/bindings/firmware/coreboot.txt b/Documentation/devicetree/bindings/firmware/coreboot.txt
> new file mode 100644
> index 0000000..89d7bf3
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/firmware/coreboot.txt
> @@ -0,0 +1,28 @@
> +COREBOOT firmware information
> +
> +The device tree node to communicate the location of coreboot's memory-resident
> +bookkeeping structures to the kernel. Since coreboot itself cannot boot a
> +device-tree-based kernel (yet), this node needs to be inserted by a
> +second-stage bootloader (a coreboot "payload").
> +
> +Required properties:
> + - compatible: Should be "coreboot"
> + - reg: Address and length of the following two memory regions, in order:
> +       1.) The coreboot table. This is a list of variable-sized descriptors
> +       that contain various compile- and run-time generated firmware
> +       parameters. It is identified by the magic string "LBIO" in its first
> +       four bytes. See coreboot's src/include/boot/coreboot_tables.h for
> +       details.
> +       2.) The CBMEM area. This is a downward-growing memory region used by
> +       coreboot to dynamically allocate data structures that remain resident.
> +       It may or may not include the coreboot table as one of its members. It
> +       is identified by a root node descriptor with the magic number
> +       0xc0389479 that resides in the topmost 8 bytes of the area. See
> +       coreboot's src/lib/dynamic_cbmem.c for details.

Don't you need need to keep the kernel from allocating this memory by
using one of the reserved memory mechanisms? The recently added one
should be able to specific what the memory is reserved for IIRC.

> +
> +Example:
> +       firmware {

/firmware is already used IIRC. What if you have other firmware such
as Trustzone?

> +               compatible = "coreboot";
> +               reg = <0xfdfea000 0x264>,
> +                     <0xfdfea000 0x16000>;
> +       };
> --
> 1.8.3.2
>
