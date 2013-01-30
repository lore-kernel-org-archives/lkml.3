Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab3A3Pkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 10:40:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422Ab3A3Pkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 10:40:42 -0500
Date: Wed, 30 Jan 2013 10:40:33 -0500
From: Don Zickus <dzickus@redhat.com>
To: Mike Lykov <combr@yandex.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, kirill@shutemov.name
Subject: Re: [BUG?] false positive in soft lockup detector while unlzma
 initramfs on slow cpu
Message-ID: <20130130154033.GE98867@redhat.com>
References: <5107D1D3.6040105@yandex.ru>
 <20130129153348.GR98867@redhat.com>
 <5108EA4B.7030003@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5108EA4B.7030003@yandex.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 01:39:23PM +0400, Mike Lykov wrote:
> 29.01.2013 19:33, Don Zickus пишет:
> 
> >The softlockup mechanism works scheduling a high priority task that kicks
> >the softlockups.  If the unzip thread is taking too long, it could
> >accidentally trip the detection.
> 
> Inyerestingly, that a decompress of lzma -4 takes longer time than
> decompress lzma -9, and it stated in man lzma(1):
> "  On  the  same hardware, the decompression speed is approximately
> a constant number of bytes of compressed data per second.  In other
> words, the better the compression, the faster the  decompression
> will  usually  be. "
> 
> I tested it on target computer by hand:
> 
> lzma -4 compressed: time unlzma initram-alt-p6rel3-4.cpio.lzma
> 20.94user 1.47system 0:22:45elapsed 99%CPU (...19424maxresidents)k
> 
> lzma -9 compressed: time unlzma initram-alt-p6rel3-9.cpio.lzma
> 19.49user 1.92system 0:21:44elapsed 99%CPU (...241488maxresidents)k
> 
> So, it cannot "take too long" because not-working faster than working.
> Apparently time not matter, but algorithm complexity?
> 
> >>2. How to change watchdog_thresh parameter at boot without patching
> >>sources? If it necessary (with it side effects) maybe implement it
> >>as commandline parameter or config compile time parameter?
> >
> >I attached a patch below that allows you to set it a boot time.  Let me
> >know if this works for you, then I can clean it up and post it properly.
> 
> It not works for me. I apply this patch, build, use ("int
> __read_mostly watchdog_thresh = 10;"  as in original)
> command line:
> 
> [    0.000000] Kernel command line:
> initrd=initram-alt-p6rel3-9.cpio.lzma console=uart,io,0x240,115200n8
> kernel.watchdog_thresh=30

I have never seen usage like 'kernel.watchdog_thresh=30'.  Could you try
'watchdog_thresh=30' instead?

I also attached another patch as suggested by Andrew to add a
touch_softlockup_watchdog in the unlzma routine.  Probably makes things
run a little slower.  Compiled tested only.

Cheers,
Don

diff --git a/lib/decompress_unlzma.c b/lib/decompress_unlzma.c
index 32adb73..313f4fa 100644
--- a/lib/decompress_unlzma.c
+++ b/lib/decompress_unlzma.c
@@ -36,6 +36,7 @@
 #endif /* STATIC */
 
 #include <linux/decompress/mm.h>
+#include <linux/nmi.h>
 
 #define	MIN(a, b) (((a) < (b)) ? (a) : (b))
 
@@ -648,6 +649,7 @@ STATIC inline int INIT unlzma(unsigned char *buf, int in_len,
 		}
 		if (rc.buffer_size <= 0)
 			goto exit_3;
+		touch_softlockup_watchdog();
 	}
 
 	if (posp)
