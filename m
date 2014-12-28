Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869AbaL1ScT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 13:32:19 -0500
Received: from smtp25.services.sfr.fr ([93.17.128.119]:16850 "EHLO
	smtp25.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbaL1ScR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 13:32:17 -0500
X-Greylist: delayed 447 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Dec 2014 13:32:16 EST
Authentication-Results: sfrmc.priv.atos.fr; dkim=none (no signature);
	dkim-adsp=none (no policy) header.from=mpeg.blue@free.fr
X-SFR-UUID: 20141228182443581.8DE057000055@msfrf2516.sfr.fr
Message-ID: <54A04AEB.1070502@free.fr>
Date: Sun, 28 Dec 2014 19:24:43 +0100
From: Mason <mpeg.blue@free.fr>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:34.0) Gecko/20100101
	Firefox/34.0 SeaMonkey/2.31
MIME-Version: 1.0
To: Linux ARM <linux-arm-kernel@lists.infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Memory copy between Linux-managed RAM and other RAM
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

I'm working on a Cortex-A9 SoC equipped with 2 GB of RAM.

However, Linux is only given a fraction (typically 256 MB) of the RAM
to manage (via the mem= bootparam) while the rest is managed using
"OS-agnostic software". This "other memory" is meant to be shared
between different hardware blocks of the SoC.

We have a custom "memory_copy" kernel module, to copy between
"Linux-managed RAM" and "SoC-wide RAM". However, the performance
of this routine is... disappointingly underwhelming (8.5 MB/s).

Taking a closer look at the implementation, I spotted some
inefficiencies.

1) data is first copied (in chunks) to a temporary kernel buffer

2) for each word, a hardware remap is setup, then the word
is copied, then the hardware remap is reset. (This hardware
remap technique dates back to when we used MIPS.)

I thought I could both make the implementation simpler, and boost
the performance.

A) I used ioremap to have Linux map the "SoC-wide RAM" physical
addresses to virtual addresses that can be used in the module.

B) I then use copy_{to,from}_user directly between the user-space
buffer and the "SoC-wide RAM".

This approach is ~20x faster than the original.

My main question is:

Is this safe/guaranteed to work all the time? (as long as the
"SoC-wide RAM" is indeed RAM, not MM registers)


Secondary thoughts/questions:

We have routines for accesses in units of {8,16,32} bits.
Since we're dealing with memory, I don't think the width
of the accesses is important, right? (for correctness)

AFAIU, ioremap maps as MT_DEVICE, i.e. uncached, no WC,
all memory optimizations disabled, etc. There might be
some performance improvements by using cached accesses,
and manually flushing when the copy is done.

Also, I don't know if copy_{to,from}_user is optimized
using SIMD/NEON? Maybe there is some perf left on the
table there?

Regards.
