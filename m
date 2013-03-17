Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801Ab3CQXEj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 19:04:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57371 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755698Ab3CQXEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 19:04:37 -0400
Message-ID: <51464C00.5090107@zytor.com>
Date: Sun, 17 Mar 2013 16:04:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Linux Arch Mailing List <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Using __int128 on 64-bit architectures
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

How desirable/portable is it to use __int128 on non-x86 64-bit
architectures to get a 64*64 -> 128 bit multiply?  On x86-64 this works
extremely well, but I'm worried about that needlessly breaking on other
architectures.

In particular, it looks opportune to use a scaling-by-multiply instead
of a multiply-divide on lines 253 and 269 of kernel/time.c:

   243  unsigned int jiffies_to_msecs(const unsigned long j)
   244  {
   245  #if HZ <= MSEC_PER_SEC && !(MSEC_PER_SEC % HZ)
   246          return (MSEC_PER_SEC / HZ) * j;
   247  #elif HZ > MSEC_PER_SEC && !(HZ % MSEC_PER_SEC)
   248          return (j + (HZ / MSEC_PER_SEC) - 1)/(HZ / MSEC_PER_SEC);
   249  #else
   250  # if BITS_PER_LONG == 32
   251          return (HZ_TO_MSEC_MUL32 * j) >> HZ_TO_MSEC_SHR32;
   252  # else
   253          return (j * HZ_TO_MSEC_NUM) / HZ_TO_MSEC_DEN;
   254  # endif
   255  #endif
   256  }
   257  EXPORT_SYMBOL(jiffies_to_msecs);
   258
   259  unsigned int jiffies_to_usecs(const unsigned long j)
   260  {
   261  #if HZ <= USEC_PER_SEC && !(USEC_PER_SEC % HZ)
   262          return (USEC_PER_SEC / HZ) * j;
   263  #elif HZ > USEC_PER_SEC && !(HZ % USEC_PER_SEC)
   264          return (j + (HZ / USEC_PER_SEC) - 1)/(HZ / USEC_PER_SEC);
   265  #else
   266  # if BITS_PER_LONG == 32
   267          return (HZ_TO_USEC_MUL32 * j) >> HZ_TO_USEC_SHR32;
   268  # else
   269          return (j * HZ_TO_USEC_NUM) / HZ_TO_USEC_DEN;
   270  # endif
   271  #endif
   272  }


	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

