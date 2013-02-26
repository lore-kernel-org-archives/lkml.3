Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab3BZGYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 01:24:46 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:59225 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab3BZGYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 01:24:44 -0500
X-AuditID: 9c93016f-b7b46ae000007f43-c1-512c5527883d
From: Kyungsik Lee <kyungsik.lee@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, x86@kernel.org,
        celinux-dev@lists.celinuxforum.org
Cc: Nicolas Pitre <nico@fluxnic.net>, Nitin Gupta <nitingupta910@gmail.com>,
        "Markus F.X.J. Oberhumer" <markus@oberhumer.com>,
        Richard Purdie <rpurdie@openedhand.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>, David Sterba <dsterba@suse.cz>,
        Richard Cochran <richardcochran@gmail.com>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        Egon Alter <egon.alter@gmx.net>, hyojun.im@lge.com, chan.jeong@lge.com,
        raphael.andy.lee@gmail.com, Kyungsik Lee <kyungsik.lee@lge.com>
Subject: [RFC PATCH v2 0/4] Add support for LZ4-compressed kernel
Date: Tue, 26 Feb 2013 15:24:26 +0900
Message-Id: <1361859870-15751-1-git-send-email-kyungsik.lee@lge.com>
X-Mailer: git-send-email 1.8.1.1
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

First of all, Thank you for the comments and emails from the community.

Here is the second version of support for LZ4-compressed kernel.
In this version, lz4_decompress() has been added. In case of knowing
the uncompressed data size, this function can be used to decompress
more faster.

Through the benchmark, it was found that -Os Compiler flag for
decompress.o brought better decompression performance in most of cases
(ex, different compiler and hardware spec.) in ARM architecture.

Lastly, CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS is not always the best
option even though it is supported. The decompression speed can be
slightly slower in some cases.

This patchset is based on 3.8.

Any comments are appreciated.

Thanks,
Kyungsik


Benchmark Results(PATCH v2)
Compiler: Linaro ARM gcc 4.6.2
1. ARMv7, 1.5GHz based board
   Kernel: linux 3.4
   Uncompressed Kernel Size: 14MB
        Compressed Size  Decompression Speed
   LZO  6.7MB            21.1MB/s
   LZ4  7.3MB            29.1MB/s, 45.6MB/s(UA)
2. ARMv7, 1.7GHz based board
   Kernel: linux 3.7
   Uncompressed Kernel Size: 14MB
        Compressed Size  Decompression Speed
   LZO  6.0MB            34.1MB/s
   LZ4  6.5MB            86.7MB/s
UA: Unaligned memory Access support


Change log: v2
- Clean up code
- Enable unaligned access for ARM v6 and above with
  CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
- Add lz4_decompress() for faster decompression with
  uncompressed output size
- Use lz4_decompress() for LZ4-compressed kernel during
  boot-process
- Apply -Os to decompress.o to improve decompress
  performance during boot-up process


Kyungsik Lee (4):
  decompressor: Add LZ4 decompressor module
  lib: Add support for LZ4-compressed kernel
  arm: Add support for LZ4-compressed kernel
  x86: Add support for LZ4-compressed kernel

 arch/arm/Kconfig                      |   1 +
 arch/arm/boot/compressed/.gitignore   |   1 +
 arch/arm/boot/compressed/Makefile     |   6 +-
 arch/arm/boot/compressed/decompress.c |   4 +
 arch/arm/boot/compressed/piggy.lz4.S  |   6 +
 arch/x86/Kconfig                      |   1 +
 arch/x86/boot/compressed/Makefile     |   5 +-
 arch/x86/boot/compressed/misc.c       |   4 +
 include/linux/decompress/unlz4.h      |  10 +
 include/linux/lz4.h                   |  48 +++++
 init/Kconfig                          |  13 +-
 lib/Kconfig                           |   7 +
 lib/Makefile                          |   2 +
 lib/decompress.c                      |   5 +
 lib/decompress_unlz4.c                | 190 +++++++++++++++++++
 lib/lz4/Makefile                      |   1 +
 lib/lz4/lz4_decompress.c              | 331 ++++++++++++++++++++++++++++++++++
 lib/lz4/lz4defs.h                     |  93 ++++++++++
 scripts/Makefile.lib                  |   5 +
 usr/Kconfig                           |   9 +
 20 files changed, 739 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm/boot/compressed/piggy.lz4.S
 create mode 100644 include/linux/decompress/unlz4.h
 create mode 100644 include/linux/lz4.h
 create mode 100644 lib/decompress_unlz4.c
 create mode 100644 lib/lz4/Makefile
 create mode 100644 lib/lz4/lz4_decompress.c
 create mode 100644 lib/lz4/lz4defs.h

-- 
1.8.1.1

