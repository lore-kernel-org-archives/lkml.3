Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbaEJGLe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 02:11:34 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:12263 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbaEJGLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 02:11:33 -0400
X-AuditID: cbfee61a-b7f2b6d000006c4d-33-536dc313dd97
From: Weijie Yang <weijie.yang@samsung.com>
To: "'Minchan Kim'" <minchan@kernel.org>, "'Joonsoo Kim'" <js1304@gmail.com>
Cc: "'Weijie Yang'" <weijie.yang.kh@gmail.com>,
        "'Davidlohr Bueso'" <davidlohr@hp.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Seth Jennings'" <sjennings@variantweb.net>,
        "'Nitin Gupta'" <ngupta@vflare.org>,
        "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Bob Liu'" <bob.liu@oracle.com>,
        "'Dan Streetman'" <ddstreet@ieee.org>,
        "'Heesub Shin'" <heesub.shin@samsung.com>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux-MM'" <linux-mm@kvack.org>
References: <000001cf6816$d538c370$7faa4a50$%yang@samsung.com>
 <20140505152014.GA8551@cerebellum.variantweb.net>
 <1399312844.2570.28.camel@buesod1.americas.hpqcorp.net>
 <20140505134615.04cb627bb2784cabcb844655@linux-foundation.org>
 <1399328550.2646.5.camel@buesod1.americas.hpqcorp.net>
 <000001cf69c9$5776f330$0664d990$%yang@samsung.com>
 <20140507085743.GA31680@bbox>
 <CAL1ERfOXNrfKqMVs-Yz8yJjKKU3L5fjUEOb0Aeyqc37py-BWEg@mail.gmail.com>
 <CAAmzW4Pn2VUEnQ8FyOaBffqfUiHt6ocLEEvyaJrSKmTjaNp_wQ@mail.gmail.com>
 <20140508062418.GF5282@bbox>
In-reply-to: <20140508062418.GF5282@bbox>
Subject: RE: [PATCH] zram: remove global tb_lock by using lock-free CAS
Date: Sat, 10 May 2014 14:10:08 +0800
Message-id: <000001cf6c16$afe73800$0fb5a800$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9qhhLDMTEFKuWKQYKkOudnCiVKBABjSsvA
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jQV3hw7nBBqsmyFvMWb+GzaLr1FQW
	iyX3hS0utO1msTg4ewmTxcy9c1ktLu+aw2Zxb81/VotlX9+zW2xomcVusfbzY3aLT0cfsVk8
	OfGfxYHXY+esu+weu7btZPJ4OuEgk8emVZ1sHps+TWL3ODHjN4vHx6e3WDz6tqxi9Lj+rchj
	56fNrB6fN8kFcEdx2aSk5mSWpRbp2yVwZXxa1c9cMFmy4uDH+gbGTuEuRk4OCQETiQ+v7rBD
	2GISF+6tZ+ti5OIQEpjOKDHt922whJDAH0aJxX0ZIDabgLbE3f6NrCC2iICHxJLPO1lBGpgF
	zjNLPP78jAmiewWLxPkFC1lAqjgFNCWmrj/NBGILC7hLTG3bARZnEVCVmHL5DhuIzStgJ/Ho
	dysThC0o8WPyPbAaZgE9iY9/bjNC2PISm9e8Ze5i5AA6VV3i0V9diCOMJOZf/AZVIi6x8cgt
	lgmMQrOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4Qp9J7WBc
	2WBxiFGAg1GJh7fgbU6wEGtiWXFl7iFGCQ5mJRHeFQdzg4V4UxIrq1KL8uOLSnNSiw8xSnOw
	KInzHmi1DhQSSE8sSc1OTS1ILYLJMnFwSjUwLnjncXB/QPi2qJ3HF3S//ZL2+2yoOcPDG8eX
	sDfxq20L/M25nLFKmVnkoY6koMZxqd5TGrP/NM6az81SZOMaOnfGtOPJc34yTlp81MSeYWMi
	t6hIh1ny/+k+FwUO+BukxQfk+sw25twjNlU+QPZ/dXHL02M+ru6M9dv4w7bc1tym95bf/JSo
	EktxRqKhFnNRcSIArx4Y6MwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 8, 2014 at 2:24 PM, Minchan Kim <minchan@kernel.org> wrote:
> On Wed, May 07, 2014 at 11:52:59PM +0900, Joonsoo Kim wrote:
>> >> Most popular use of zram is the in-memory swap for small embedded system
>> >> so I don't want to increase memory footprint without good reason although
>> >> it makes synthetic benchmark. Alhought it's 1M for 1G, it isn't small if we
>> >> consider compression ratio and real free memory after boot
>>
>> We can use bit spin lock and this would not increase memory footprint for 32 bit
>> platform.
>
> Sounds like a idea.
> Weijie, Do you mind testing with bit spin lock?

Yes, I re-test them.
This time, I test each case 10 times, and take the average(KS/s).
(the test machine and method are same like previous mail's)

Iozone test result:

      Test       BASE     CAS   spinlock   rwlock  bit_spinlock
--------------------------------------------------------------
 Initial write  1381094   1425435   1422860   1423075   1421521
       Rewrite  1529479   1641199   1668762   1672855   1654910
          Read  8468009  11324979  11305569  11117273  10997202
       Re-read  8467476  11260914  11248059  11145336  10906486
  Reverse Read  6821393   8106334   8282174   8279195   8109186
   Stride read  7191093   8994306   9153982   8961224   9004434
   Random read  7156353   8957932   9167098   8980465   8940476
Mixed workload  4172747   5680814   5927825   5489578   5972253
  Random write  1483044   1605588   1594329   1600453   1596010
        Pwrite  1276644   1303108   1311612   1314228   1300960
         Pread  4324337   4632869   4618386   4457870   4500166

Fio test result:

    Test     base     CAS    spinlock    rwlock  bit_spinlock
-------------------------------------------------------------
seq-write   933789   999357   1003298    995961   1001958
 seq-read  5634130  6577930   6380861   6243912   6230006
   seq-rw  1405687  1638117   1640256   1633903   1634459
  rand-rw  1386119  1614664   1617211   1609267   1612471


The base is v3.15.0-rc3, the others are per-meta entry lock.
Every optimization method shows higher performance than the base, however,
it is hard to say which method is the most appropriate.

To bit_spinlock, the modified code is mainly like this:

+#define ZRAM_FLAG_SHIFT 16
+
enum zram_pageflags {
 	/* Page consists entirely of zeros */
-	ZRAM_ZERO,
+	ZRAM_ZERO = ZRAM_FLAG_SHIFT + 1,
+	ZRAM_ACCESS,
 
 	__NR_ZRAM_PAGEFLAGS,
 };
 
 /* Allocated for each disk page */
 struct table {
 	unsigned long handle;
-	u16 size;	/* object size (excluding header) */
-	u8 flags;
+	unsigned long value;
 } __aligned(4);

The lower ZRAM_FLAG_SHIFT bits of table.value is size, the higher bits
is for zram_pageflags. By this means, it doesn't increase any memory
overhead on both 32-bit and 64-bit system.

Any complaint or suggestions are welcomed.

>>
>> Thanks.
>>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> the body to majordomo@kvack.org.  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
> --
> Kind regards,
> Minchan Kim


