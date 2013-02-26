Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815Ab3BZUdn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 15:33:43 -0500
Received: from mail.servus.at ([193.170.194.20]:38752 "EHLO mail.servus.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035Ab3BZUdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 15:33:41 -0500
Message-ID: <512D1C12.4080109@oberhumer.com>
Date: Tue, 26 Feb 2013 21:33:22 +0100
From: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
Organization: oberhumer.com
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Kyungsik Lee <kyungsik.lee@lge.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, x86@kernel.org,
        celinux-dev@lists.celinuxforum.org, Nicolas Pitre <nico@fluxnic.net>,
        Nitin Gupta <nitingupta910@gmail.com>,
        Richard Purdie <rpurdie@openedhand.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>, David Sterba <dsterba@suse.cz>,
        Richard Cochran <richardcochran@gmail.com>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        Egon Alter <egon.alter@gmx.net>, hyojun.im@lge.com, chan.jeong@lge.com,
        raphael.andy.lee@gmail.com
Subject: Re: [RFC PATCH v2 0/4] Add support for LZ4-compressed kernel
References: <1361859870-15751-1-git-send-email-kyungsik.lee@lge.com>
In-Reply-To: <1361859870-15751-1-git-send-email-kyungsik.lee@lge.com>
Content-Type: multipart/mixed;
 boundary="------------010100070101020909000305"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010100070101020909000305
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 2013-02-26 07:24, Kyungsik Lee wrote:
> Hi,
> 
> [...]
> 
> Through the benchmark, it was found that -Os Compiler flag for
> decompress.o brought better decompression performance in most of cases
> (ex, different compiler and hardware spec.) in ARM architecture.
> 
> Lastly, CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS is not always the best
> option even though it is supported. The decompression speed can be
> slightly slower in some cases.
> 
> This patchset is based on 3.8.
> 
> Any comments are appreciated.

Did you actually *try* the new LZO version and the patch (which is attached
once again) as explained in https://lkml.org/lkml/2013/2/3/367 ?

Because the new LZO version is faster than LZ4 in my testing, at least
when comparing apples with apples and enabling unaligned access in
BOTH versions:

armv7 (Cortex-A9), Linaro gcc-4.6 -O3, Silesia test corpus, 256 kB block-size:

                   compression speed   decompression speed

  LZO-2012    :          44 MB/sec          117 MB/sec     no unaligned access
  LZO-2013-UA :          47 MB/sec          167 MB/sec     Unaligned Access
  LZ4 r88  UA :          46 MB/sec          154 MB/sec     Unaligned Access

~Markus


> 
> Thanks,
> Kyungsik
> 
> 
> Benchmark Results(PATCH v2)
> Compiler: Linaro ARM gcc 4.6.2
> 1. ARMv7, 1.5GHz based board
>    Kernel: linux 3.4
>    Uncompressed Kernel Size: 14MB
>         Compressed Size  Decompression Speed
>    LZO  6.7MB            21.1MB/s
>    LZ4  7.3MB            29.1MB/s, 45.6MB/s(UA)
> 2. ARMv7, 1.7GHz based board
>    Kernel: linux 3.7
>    Uncompressed Kernel Size: 14MB
>         Compressed Size  Decompression Speed
>    LZO  6.0MB            34.1MB/s
>    LZ4  6.5MB            86.7MB/s
> UA: Unaligned memory Access support
> 
> 
> Change log: v2
> - Clean up code
> - Enable unaligned access for ARM v6 and above with
>   CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> - Add lz4_decompress() for faster decompression with
>   uncompressed output size
> - Use lz4_decompress() for LZ4-compressed kernel during
>   boot-process
> - Apply -Os to decompress.o to improve decompress
>   performance during boot-up process
> 
> 
> Kyungsik Lee (4):
>   decompressor: Add LZ4 decompressor module
>   lib: Add support for LZ4-compressed kernel
>   arm: Add support for LZ4-compressed kernel
>   x86: Add support for LZ4-compressed kernel
> 
>  arch/arm/Kconfig                      |   1 +
>  arch/arm/boot/compressed/.gitignore   |   1 +
>  arch/arm/boot/compressed/Makefile     |   6 +-
>  arch/arm/boot/compressed/decompress.c |   4 +
>  arch/arm/boot/compressed/piggy.lz4.S  |   6 +
>  arch/x86/Kconfig                      |   1 +
>  arch/x86/boot/compressed/Makefile     |   5 +-
>  arch/x86/boot/compressed/misc.c       |   4 +
>  include/linux/decompress/unlz4.h      |  10 +
>  include/linux/lz4.h                   |  48 +++++
>  init/Kconfig                          |  13 +-
>  lib/Kconfig                           |   7 +
>  lib/Makefile                          |   2 +
>  lib/decompress.c                      |   5 +
>  lib/decompress_unlz4.c                | 190 +++++++++++++++++++
>  lib/lz4/Makefile                      |   1 +
>  lib/lz4/lz4_decompress.c              | 331 ++++++++++++++++++++++++++++++++++
>  lib/lz4/lz4defs.h                     |  93 ++++++++++
>  scripts/Makefile.lib                  |   5 +
>  usr/Kconfig                           |   9 +
>  20 files changed, 739 insertions(+), 3 deletions(-)
>  create mode 100644 arch/arm/boot/compressed/piggy.lz4.S
>  create mode 100644 include/linux/decompress/unlz4.h
>  create mode 100644 include/linux/lz4.h
>  create mode 100644 lib/decompress_unlz4.c
>  create mode 100644 lib/lz4/Makefile
>  create mode 100644 lib/lz4/lz4_decompress.c
>  create mode 100644 lib/lz4/lz4defs.h
> 


-- 
Markus Oberhumer, <markus@oberhumer.com>, http://www.oberhumer.com/

--------------010100070101020909000305
Content-Type: text/x-patch;
 name="lib-lzo-huge-LZO-decompression-speedup-on-ARM.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="lib-lzo-huge-LZO-decompression-speedup-on-ARM.patch"

commit 8745b927fcfcd6953ada9bd1220a73083db5948a
Author: Markus F.X.J. Oberhumer <markus@oberhumer.com>
Date:   Mon Feb 4 02:26:14 2013 +0100

    lib/lzo: huge LZO decompression speedup on ARM by using unaligned access
    
    Signed-off-by: Markus F.X.J. Oberhumer <markus@oberhumer.com>

diff --git a/lib/lzo/lzo1x_decompress_safe.c b/lib/lzo/lzo1x_decompress_safe.c
index 569985d..e3edc5f 100644
--- a/lib/lzo/lzo1x_decompress_safe.c
+++ b/lib/lzo/lzo1x_decompress_safe.c
@@ -72,9 +72,11 @@ copy_literal_run:
 						COPY8(op, ip);
 						op += 8;
 						ip += 8;
+#  if !defined(__arm__)
 						COPY8(op, ip);
 						op += 8;
 						ip += 8;
+#  endif
 					} while (ip < ie);
 					ip = ie;
 					op = oe;
@@ -159,9 +161,11 @@ copy_literal_run:
 					COPY8(op, m_pos);
 					op += 8;
 					m_pos += 8;
+#  if !defined(__arm__)
 					COPY8(op, m_pos);
 					op += 8;
 					m_pos += 8;
+#  endif
 				} while (op < oe);
 				op = oe;
 				if (HAVE_IP(6)) {
diff --git a/lib/lzo/lzodefs.h b/lib/lzo/lzodefs.h
index 5a4beb2..b230601 100644
--- a/lib/lzo/lzodefs.h
+++ b/lib/lzo/lzodefs.h
@@ -12,8 +12,14 @@
  */
 
 
+#if 1 && defined(__arm__) && ((__LINUX_ARM_ARCH__ >= 6) || defined(__ARM_FEATURE_UNALIGNED))
+#define CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS 1
+#define COPY4(dst, src)	\
+		* (u32 *) (void *) (dst) = * (const u32 *) (const void *) (src)
+#else
 #define COPY4(dst, src)	\
 		put_unaligned(get_unaligned((const u32 *)(src)), (u32 *)(dst))
+#endif
 #if defined(__x86_64__)
 #define COPY8(dst, src)	\
 		put_unaligned(get_unaligned((const u64 *)(src)), (u64 *)(dst))




--------------010100070101020909000305--
