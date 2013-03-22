Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932904Ab3CVL3o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 07:29:44 -0400
Received: from queue01b.mail.zen.net.uk ([212.23.3.242]:43379 "EHLO
	queue01b.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932165Ab3CVL3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 07:29:43 -0400
X-Greylist: delayed 2405 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Mar 2013 07:29:43 EDT
Message-ID: <1363949290.3528.37.camel@linaro1.home>
Subject: [BUG] mod/file2alias: build error in devicetable-offsets.c [was:
 asm/types.h Header file wont get generated while building uImage ?]
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: LAK <linux-arm-kernel@lists.infradead.org>, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>, Andreas Schwab <schwab@linux-m68k.org>
Date: Fri, 22 Mar 2013 10:48:10 +0000
In-Reply-To: <CA+V-a8vYsBLVH-3Bm35Sv9K9ZMTcMB4_P_V3kBjyuEKDozPi5w@mail.gmail.com>
References: <CA+V-a8vYsBLVH-3Bm35Sv9K9ZMTcMB4_P_V3kBjyuEKDozPi5w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost03-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-08 at 13:31 +0530, Prabhakar Lad wrote:
> Usually for building uImage I follow this steps,
> 1: do a clean distclean
> 2: make ARCH=arm CROSS_COMPILE=xxx   xxxdefconfig
> 3: make ARCH=arm CROSS_COMPILE=xxx  uImage
> 
> This used to work until 3.8, for 3.9 I see the following error:
> 
>   HOSTCC  scripts/genksyms/parse.tab.o
> In file included from include/linux/types.h:5:0,
>                  from include/linux/mod_devicetable.h:11,
>                  from scripts/mod/devicetable-offsets.c:2:
> include/uapi/linux/types.h:4:23: fatal error: asm/types.h: No such
> file or directory
> compilation terminated.
> 
> Well this get fixed if do  make ARCH=arm
> CROSS_COMPILE=arm-none-linux-gnueabi- headers_install
> and the build the uImage.

I am seeing a similar problem.

This appears to be introduced by commit 6543becf (mod/file2alias: make
modalias generation safe for cross compiling). More specifically a race
condition between the generation of devicetable-offsets.h and the
generation of asm/types.h by scripts/Makefile.asm-generic.

For builds which succeed I see this order:

  WRAP    arch/arm/include/generated/asm/types.h
  [...]
  GEN     include/generated/asm-offsets.h

and for those which fail:

  CC      scripts/mod/devicetable-offsets.s
  In file included from include/linux/types.h:5:0,
                   from include/linux/mod_devicetable.h:11,
                   from scripts/mod/devicetable-offsets.c:2:
  include/uapi/linux/types.h:4:23: fatal error: asm/types.h: No such file or directory
  [...]
  WRAP    arch/arm/include/generated/asm/types.h

These makefile and scripts are a bit beyond my immediate understanding
so can't suggest a fix.

-- 
Tixy


