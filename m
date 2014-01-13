Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413AbaAMD0T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 22:26:19 -0500
Received: from numascale.com ([213.162.240.84]:57913 "EHLO numascale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362AbaAMD0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 22:26:13 -0500
X-Greylist: delayed 2312 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Jan 2014 22:26:13 EST
Message-ID: <52D353C8.4000000@numascale.com>
Date: Mon, 13 Jan 2014 10:47:36 +0800
From: Daniel J Blueman <daniel@numascale.com>
Organization: Numascale AS
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Waiman Long <Waiman.Long@hp.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 4/4] qrwlock: Use smp_store_release() in write_unlock()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel21.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Get-Message-Sender-Via: cpanel21.proisp.no: authenticated_id: daniel@numascale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 9 January 2014 01:10:03 UTC+8, Waiman Long  wrote:
 > This patch modifies the queue_write_unlock() function to use the
 > new smp_store_release() function in another pending patch. It also
 > removes the temporary implementation of smp_load_acquire() and
 > smp_store_release() function in qrwlock.c.
 >
 > This patch should only be merged if PeterZ's linux-arch patch patch
 > was merged.
 >
 > Signed-off-by: Waiman Long <Waiman.Long@hp.com>
 > Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
 > ---
 >  include/asm-generic/qrwlock.h |    4 +---
 >  kernel/locking/qrwlock.c      |   34 ----------------------------------
 >  2 files changed, 1 insertions(+), 37 deletions(-)
 >
 > diff --git a/include/asm-generic/qrwlock.h 
b/include/asm-generic/qrwlock.h
 > index 2b9a7b4..4d4bd04 100644
 > --- a/include/asm-generic/qrwlock.h
 > +++ b/include/asm-generic/qrwlock.h
 > @@ -179,9 +179,7 @@ static inline void queue_write_unlock(struct 
qrwlock *lock)
 >  	/*
 >  	 * Make sure that none of the critical section will be leaked out.
 >  	 */
 > -	smp_mb__before_clear_bit();
 > -	ACCESS_ONCE(lock->cnts.writer) = 0;
 > -	smp_mb__after_clear_bit();
 > +	smp_store_release(&lock->cnts.writer, 0)

This will fail compilation, so probably needs further testing with 
Peter's load_acquire/store_release barrier patches.

Thanks,
   Daniel
-- 
Daniel J Blueman
Principal Software Engineer, Numascale
