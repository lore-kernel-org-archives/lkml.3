Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106AbaEFPDD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 11:03:03 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:41370 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbaEFPDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 11:03:01 -0400
MIME-Version: 1.0
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D0F70D180@AcuExch.aculab.com>
References: <1399380554-3746-1-git-send-email-geert@linux-m68k.org>
	<063D6719AE5E284EB5DD2968C1650D6D0F70D180@AcuExch.aculab.com>
Date: Tue, 6 May 2014 17:02:59 +0200
X-Google-Sender-Auth: viNmZH5nLVfuBA2I1fNIBiErZiA
Message-ID: <CAMuHMdWFLT7iAJOnrh8-x3F1P1v0v+=acz_BjX-37JcSBDL4wQ@mail.gmail.com>
Subject: Re: [PATCH/RFC] usb: gadget: CONFIG_USB_S3C_HSOTG should depend on HAS_DMA
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Laight <David.Laight@aculab.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Tue, May 6, 2014 at 3:17 PM, David Laight <David.Laight@aculab.com> wrote:
>> If NO_DMA=y:
>>
>> drivers/built-in.o: In function `s3c_hsotg_map_dma':
>> s3c-hsotg.c:(.text+0x375b2c): undefined reference to `usb_gadget_map_request'
>> drivers/built-in.o: In function `s3c_hsotg_unmap_dma':
>> s3c-hsotg.c:(.text+0x376a32): undefined reference to `usb_gadget_unmap_request'
>> make[3]: *** [vmlinux] Error 1
>>
>> Note that all callers of s3c_hsotg_map_dma()/s3c_hsotg_unmap_dma() are
>> protected by a call into the using_dma() checking function:
>>
>> static inline bool using_dma(struct s3c_hsotg *hsotg)
>> {
>>         return false;   /* support is not complete */
>> }
>>
>> but not all versions of gcc manage to optimize the check away, causing a
>> link error.
>
> A have seen gcc optimise away a call, but leave the undefined symbol
> in the symbol table.
> That might be what is happening here.

Indeed, the unused functions s3c_hsotg_{,un}map_dma() are still there,
but the calls to them have been optimized away.

Marking s3c_hsotg_{,un}map_dma() inline fixes that. I'll send a new patch
doing that, as it's a bit silly to require "depends on HAS_DMA" for a driver
which has DMA disabled.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
