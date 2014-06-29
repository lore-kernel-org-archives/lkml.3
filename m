Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbaF2TrQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 15:47:16 -0400
Received: from mail.eperm.de ([89.247.134.16]:47488 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315AbaF2TrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 15:47:15 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, aris@redhat.com, aquini@redhat.com
Subject: Re: [crypto] BUG: unable to handle kernel paging request at ffff88000bb88000
Date: Sun, 29 Jun 2014 21:45:48 +0200
Message-ID: <42550233.Kxs179MjQV@myon.chronox.de>
User-Agent: KMail/4.12.5 (Linux/3.14.8-200.fc20.x86_64; KDE/4.12.5; x86_64; ; )
In-Reply-To: <20140629145246.GA9134@localhost>
References: <20140629145246.GA9134@localhost>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 29. Juni 2014, 22:52:46 schrieb Fengguang Wu:

Hi Fengguang,

> Greetings,
> 
> 0day kernel testing robot got the below dmesg and the first bad commit is

May I ask whether there is anything special in your kernel config?

This very bug should have been triggered already in all previous code levels! 
I am seriously wondering why this bug was not triggered before -- does kalloc 
somehow allocates more memory than you requested? And only your specific 
kernel config made kalloc to allocate the exact amount of memory that was 
requested?

The background can be summarized by the following: the scratchpad->temp buffer 
(i.e. the memory location immediately before the tfm variable upon which the 
kernel crashed) is the buffer that the BCC function operates on. BCC operates 
blockwise. drbg_statelen(drbg) is sufficient when the DRBG state length is a 
multiple of the block size. For AES192 (and maybe other ciphers) this is not 
correct and the length for temp is insufficient (yes, that also means for such 
ciphers, the final output of all BCC rounds are truncated before used to 
update the state of the DRBG!!).

The DRBG code that triggered the bug defined the buffer to be drbg_statelen() 
in size. As described, the bug therefore triggered with the AES192 cipher. The 
patch is simply to enlarge the buffer by blocklen. This ensures that we have 
no memory corruption.

An official patch is created and released shortly.

More and more I look into and work with SP800-90A, I feel that at least the 
CTR DRBG and to a lesser degree the Hash DRBG have severe shortcomings. 
Throwing away information derived from the seed by the aforementioned 
truncation is definitely not wise. This truncation is in addition to other 
very odd operations on the seed definitely result in a loss of entropy IMHO.

Though, thanks a lot for the bug report and your testing.

-- 
Ciao
Stephan
