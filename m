Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472AbaEKXC2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 19:02:28 -0400
Received: from mail.eperm.de ([89.247.134.16]:43481 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428AbaEKXC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 19:02:27 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: arch_random_refill
Date: Mon, 12 May 2014 01:01:58 +0200
Message-ID: <21542339.0lFnPSyGRS@myon.chronox.de>
User-Agent: KMail/4.12.5 (Linux/3.14.3-200.fc20.x86_64; KDE/4.12.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

some time back when the RDRAND instruction was debated, a patch was offered 
for driver/char/random.c that in essence turned /dev/random into a frontend 
for RDRAND in case that instruction was available. The patch kind of 
monopolized the noise sources such that if a user space "random number hog" 
pulled data from /dev/random endlessly, the (almost) only noise source was 
RDRAND. As that patch treated RDRAND to provide entropy, the blocking behavior 
went away for /dev/random.

That patch did not sit well with some developers and it got finally changed 
such that the output of RDRAND is now just XORed with the output of the 
"classic" /dev/random behavior -- /dev/random is still blocking. 

With the current development cycle for 3.15, the function arch_random_refill 
is added as presented in [1]. It now uses RDSEED instead of RDRAND. Yet, the 
way this function is called in random_read seems (as I have no system with an 
RDSEED, I cannot test) to show the very same behavior as the aforementioned 
RDRAND patch: the blocking behavior of /dev/random will be gone and RDSEED 
will monopolize the noise sources in case of a user space hog.

Note, I do not see an issue with the patch that adds RDSEED as part of 
add_interrupt_randomness outlined in [2]. The reason is that this patch does 
not monopolizes the noise sources.

I do not want to imply that Intel (or any other chip manufacturer that will 
hook into arch_random_refill) intentionally provides bad entropy (and this 
email shall not start a discussion about entropy again), but I would like to 
be able to only use noise sources that I can fully audit. As it is with 
hardware, I am not able to see what it is doing.

Thus, may I ask that arch_random_refill is revised such that it will not 
monopolize the noise sources? If somebody wants that, he can easily use rngd.

[1] https://lkml.org/lkml/2014/3/4/968

[2] https://lkml.org/lkml/2014/3/4/934

Thanks
Stephan
-- 
| Cui bono? |
