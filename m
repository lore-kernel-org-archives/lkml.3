Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab3BDCDC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 21:03:02 -0500
Received: from mail.servus.at ([193.170.194.20]:38812 "EHLO mail.servus.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785Ab3BDCDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 21:03:00 -0500
X-Greylist: delayed 1533 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 Feb 2013 21:02:59 EST
Message-ID: <510F16C9.2060901@oberhumer.com>
Date: Mon, 04 Feb 2013 03:02:49 +0100
From: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
Organization: oberhumer.com
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.12) Gecko/20130105 Thunderbird/10.0.12
MIME-Version: 1.0
To: Johannes Stezenbach <js@sig21.net>
CC: Nicolas Pitre <nico@fluxnic.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kyungsik Lee <kyungsik.lee@lge.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, x86@kernel.org,
        Nitin Gupta <nitingupta910@gmail.com>,
        Richard Purdie <rpurdie@openedhand.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>, hyojun.im@lge.com,
        chan.jeong@lge.com, gunho.lee@lge.com, minchan.kim@lge.com,
        namhyung.kim@lge.com, raphael.andy.lee@gmail.com,
        CE Linux Developers List <celinux-dev@lists.celinuxforum.org>
Subject: Re: [RFC PATCH 0/4] Add support for LZ4-compressed kernels
References: <1359179447-31118-1-git-send-email-kyungsik.lee@lge.com> <20130128142510.68092e10.akpm@linux-foundation.org> <alpine.LFD.2.02.1301282320430.6300@xanadu.home> <20130130102353.GA8925@sig21.net>
In-Reply-To: <20130130102353.GA8925@sig21.net>
Content-Type: multipart/mixed;
 boundary="------------070809040108010008050209"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070809040108010008050209
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 2013-01-30 11:23, Johannes Stezenbach wrote:
> On Mon, Jan 28, 2013 at 11:29:14PM -0500, Nicolas Pitre wrote:
>> On Mon, 28 Jan 2013, Andrew Morton wrote:
>>
>>> On Sat, 26 Jan 2013 14:50:43 +0900
>>> Kyungsik Lee <kyungsik.lee@lge.com> wrote:
>>>
>>>> This patchset is for supporting LZ4 compressed kernel and initial ramdisk on
>>>> the x86 and ARM architectures.
>>>>
>>>> According to http://code.google.com/p/lz4/, LZ4 is a very fast lossless
>>>> compression algorithm and also features an extremely fast decoder.
>>>>
>>>> Kernel Decompression APIs are based on implementation by Yann Collet
>>>> (http://code.google.com/p/lz4/source/checkout).
>>>> De/compression Tools are also provided from the site above.
>>>>
>>>> The initial test result on ARM(v7) based board shows that the size of kernel
>>>> with LZ4 compressed is 8% bigger than LZO compressed  but the decompressing
>>>> speed is faster(especially under the enabled unaligned memory access).
>>>>
>>>> Test: 3.4 based kernel built with many modules
>>>> Uncompressed kernel size: 13MB
>>>> lzo: 6.3MB, 301ms
>>>> lz4: 6.8MB, 251ms(167ms, with enabled unaligned memory access)
>>>
>>> What's this "with enabled unaligned memory access" thing?  You mean "if
>>> the arch supports CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS"?  If so,
>>> that's only x86, which isn't really in the target market for this
>>> patch, yes?
>>
>> I'm guessing this is referring to commit 5010192d5a.
>>
>>> It's a lot of code for a 50ms boot-time improvement.  Does anyone have
>>> any opinions on whether or not the benefits are worth the cost?
>>
>> Well, we used to have only one compressed format.  Now we have nearly 
>> half a dozen, with the same worthiness issue between themselves.  
>> Either we keep it very simple, or we make it very flexible.  The former 
>> would argue in favor of removing some of the existing formats, the later 
>> would let this new format in.
> 
> This reminded me to check the status of the lzo update and it
> seems it got lost?
> http://lkml.org/lkml/2012/10/3/144

The proposed LZO update currently lives in the linux-next tree.

I had tried several times during the last 12 months to provide an update
of the kernel LZO version, but community interest seemed low and I
basically got no feedback about performance improvements - which made
we wonder if people actually care.

At least akpm did approve the LZO update for inclusion into 3.7, but the code
still has not been merged into the main tree.
  > On 2012-10-09 21:26, Andrew Morton wrote:
  > [...]
  > The changes look OK to me.  Please ask Stephen to include the tree in
  > linux-next, for a 3.7 merge.

Well, this probably means I have done a rather poor marketing. Anyway, as
people seem to love *synthetic* benchmarks I'm finally posting some timings
(including a brand new ARM unaligned version - this is just a quick hack which
probably still can get optimized further).

Hopefully publishing these numbers will help arousing more interest. :-)

Cheers,
Markus


x86_64 (Sandy Bridge), gcc-4.6 -O3, Silesia test corpus, 256 kB block-size:

                   compression speed   decompression speed

  LZO-2005    :         150 MB/sec          468 MB/sec
  LZO-2012    :         434 MB/sec         1210 MB/sec

i386 (Sandy Bridge), gcc-4.6 -O3, Silesia test corpus, 256 kB block-size:

                   compression speed   decompression speed

  LZO-2005    :         143 MB/sec          409 MB/sec
  LZO-2012    :         372 MB/sec         1121 MB/sec

armv7 (Cortex-A9), Linaro gcc-4.6 -O3, Silesia test corpus, 256 kB block-size:

                   compression speed   decompression speed

  LZO-2005    :          27 MB/sec           84 MB/sec
  LZO-2012    :          44 MB/sec          117 MB/sec
  LZO-2013-UA :          47 MB/sec          167 MB/sec

Legend:

  LZO-2005    : LZO version in current 3.8 rc6 kernel (which is based on
                   the LZO 2.02 release from 2005)
  LZO-2012    : updated LZO version available in linux-next
  LZO-2013-UA : updated LZO version available in linux-next plus
                   ARM Unaligned Access patch (attached below)


> (Cc: added, I hope Markus still cares and someone could
> eventually take his patch once he resends it.)
> 
> Johannes
> 

-- 
Markus Oberhumer, <markus@oberhumer.com>, http://www.oberhumer.com/




--------------070809040108010008050209
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




--------------070809040108010008050209--
