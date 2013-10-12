Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab3JLTEn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 15:04:43 -0400
Received: from mail.eperm.de ([89.247.134.16]:40295 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613Ab3JLTEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 15:04:42 -0400
From: Stephan Mueller <smueller@chronox.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Sandy Harris <sandyinchina@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and /dev/random
Date: Sat, 12 Oct 2013 21:04:35 +0200
Message-ID: <1868914.MfDRAbAfK8@tauon>
User-Agent: KMail/4.11.2 (Linux/3.11.3-201.fc19.x86_64; KDE/4.11.2; x86_64; ; )
In-Reply-To: <20131012032835.GC30680@thunk.org>
References: <2579337.FPgJGgHYdz@tauon> <CACXcFm=qdv9ktjYDGo+L=ssh+tCs7vVniznNpXyWVTBSB1CMRg@mail.gmail.com> <20131012032835.GC30680@thunk.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 11. Oktober 2013, 23:28:35 schrieb Theodore Ts'o:

Hi Theodore,

>Hi Stephan,
>
>I haven't had a chance to look at your paper in detail, yet, but a
>quick scan has found a huge red flag for me that puts the rest of your
>analysis in severe doubt for me.
>
>You say that you got really good results and perfect statistical
>entropy on a number of platforms, including on an MIPS embedded
>system.  You also say that you are harvesting jitter by using
>get_cycles() yes?
>
>Well, on the MIPS platform, here is the definition of get_cycles:
>
>static inline cycles_t get_cycles(void)
>{
>	return 0;
>}

There are multiple catches to this issue:

- First, if the time gathering function does not work or is to coarse, 
the function jent_entropy_init() returns an error. As outlined in 
jitterentropy(3), the result of this function must be honored before 
using the RNG.

- Second, the time stamp function of jent_get_nstime uses 
__getnstimeofday in case get_cycles returns zero (see implementation of 
jent_get_nstime()). On MIPS systems with missing get_cycles, the RNG 
would use the __getnstimeofday() as get_cycles returns 0. When using the 
RNG in user space, it calls clock_gettime(CLOCK_REALTIME) that is backed 
by the same timer of__getnstimeofday on MIPS.

Please consider the use of the jent_entropy_init function in the two 
patches for /dev/random and kernel crypto API:

/dev/random:

+               /* we are uninitialized, try to initialize */
+               if(jent_entropy_init())
+               {
+                       /* there is no CPU Jitter, disable the entropy 
collector */
+                       r->jent_enable = 0;
+                       return;
+               }


kernel crypto API:

static int __init jent_drng_init(void)
{
...
        ret = jent_entropy_init();
        if(ret)
        {
                printk(DRIVER_NAME ": Initialization failed with host 
not compliant with requirements: %d\n", ret);
                return -EFAULT;
        }

>
>So if you are getting great entropy results when in effect you
>couldn't possibly be harvesting any jitter at all, then something is
>really, Really, REALLY wrong with your tests.
>
>One might be that you are just getting great statistical results
>because of the whitening step.  This is why I have very little faith

There is *no* whitening function (cryptographic or otherwise) involved 
in the generation of random data. All is done by harvesting time deltas 
and align them appropriately. This is the sole reason why the heart of 
the RNG is only 30 lines of code.

I have added arguments about broken time stamp collections in section 
4.3 of the documentation in [2]. These anti tests clearly show that 
broken time stamps would be immediately visible and not disguised by 
some whitening function.

Note, the testing of the 200+ systems is tone by measuring the jitter of 
the core of the RNG. The measurement is logically similar to measure the 
different add_*_randomness functions for random.c. Thus, even the logic 
to arrange the timing values to a random value bit stream does not 
affect the measurements.

>in statistical tests of randomness, given that they will return
>perfect results for the following "random number generator"
>
>	AES_ENCRYPT(i++, NSA_KEY)
>
>Regards,
>
>					- Ted


Ciao
Stephan
