Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab3BFQkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 11:40:49 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:58841 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447Ab3BFQks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 11:40:48 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <monstr@monstr.eu>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        dahinds@users.sourceforge.net
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16 with generic iowrite(read)8/16(be)
Date: Thu, 07 Feb 2013 01:34:37 +0100
Message-ID: <11273481.VQZWGoSGBC@wuerfel>
User-Agent: KMail/4.10 rc3 (Linux/3.8.0-3-generic; KDE/4.9.98; x86_64; ; )
In-Reply-To: <CAHTX3d+XZ6VJDVYKHhg33Z+O8Koo99Yq--W8qitcSe543dWUuA@mail.gmail.com>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com> <CACxGe6tjyx3GTgNgMRtvwhrFsTGizkeTqY_N6=2gdQjvMSD8Ug@mail.gmail.com> <CAHTX3d+XZ6VJDVYKHhg33Z+O8Koo99Yq--W8qitcSe543dWUuA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:xHqQsyzAtlHFvARv81t721noFVD3vMFhJb+hr1RcryB
 qQzciXxQSTZpc6KiypUigqn7iI61KIodgaCsVsbYdkhBLNOU3d
 d2QtQj4NP2wInghFLiB6e9A1kjXZliLCrhqaJdQZtsRT+JqIOv
 smNcONUUrJ54J9IL/OKF8YmDjIZjvuxrxFyB5elWNkNG9Ob58C
 kdqtpriTxudHf6oLZ9Lco2kdE+DBIcFD9JVebkcIYMGVZV3t2k
 5uNw0Bv5aNoajO0NInFawys4/zIv31Dd0alkKCivXbAeYui9np
 hhj4zOqJFFL4eReliimEXnSswwRJWwgimAzVr9fbWn5HeM+2HP
 0JlW0GF4sag6qXlrz+cM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 February 2013 17:21:37 Michal Simek wrote:

> I have looked at the patches from more practical side and I have tested it on
> microblaze big endian in 16bit mode and I have found that sysace driver
> stop to work.
> After that I have looked at ioread/iowrite microblaze implementation
> and implementation of that functions is wrong.
> I have fixed it but looking at using asm-generic/io.h for microblaze.
> 
> I will do more tests and let you know.

Well, I think they are only wrong in the way that they ignore
endianess. You can fix that by changing them to be identical
to the in_le/in_be families.

However, I would also recommend changing your __raw_* accessors
to inline assembly functions rather than pointer dereferences,
because we have had problems in the past where gcc (when faced
with undefined C) silently turned 32-bit accesses into multiples
of byte accesses, which can be fatal for MMIO. The asm-generic
version obviously cannot get this right.

The PCI I/O space handling, as mentioned, is completely broken
on microblaze, and you can either use the approach from asm-generic
when you set PCI_IOBASE match your isa_io_base.

	Arnd
