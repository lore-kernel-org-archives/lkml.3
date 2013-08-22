Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab3HVCv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 22:51:59 -0400
Received: from intranet.asianux.com ([58.214.24.6]:20784 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242Ab3HVCv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 22:51:58 -0400
X-Spam-Score: -101.0
Message-ID: <521574A5.30308@asianux.com>
Date: Thu, 22 Aug 2013 10:17:09 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: bsingharora@gmail.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/delayacct.c: check NULL for member variable 'delays'
 in all extern functions.
References: <5212D703.5080405@asianux.com> <20130821151025.77673f0f3cad748a80086a16@linux-foundation.org>
In-Reply-To: <20130821151025.77673f0f3cad748a80086a16@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2013 06:10 AM, Andrew Morton wrote:
> On Tue, 20 Aug 2013 10:40:03 +0800 Chen Gang <gang.chen@asianux.com> wrote:
> 
>> The member variable 'delays' may be NULL, so need check NULL before use
>> it for all extern functions, just like __delayacct_tsk_init() and
>> __delayacct_add_tsk() have already done.
> 
> If task.delays is NULL, the kernel will oops.  I don't recall seeing
> such oops reports hence I suspect that you missed some check somewhere.
> 
> For example, delayacct_blkio_start() checks current->delays before
> calling __delayacct_blkio_start(), so why retest current->delays in
> __delayacct_blkio_start()?
> 
> 

Hmm... Can we assume "__*" extern function is treated as "should not be
used by outside" ?

If so, the original implementation have done (check NULL before use it
for all extern functions), just like your valuable example, thanks.


Hmm... and better to remove the useless code in __delayacct_add_tsk(),
which the related wrapper function has done, the diff is below:

------------------------------diff begin--------------------------------

diff --git a/kernel/delayacct.c b/kernel/delayacct.c
index d473988..da8b153 100644
--- a/kernel/delayacct.c
+++ b/kernel/delayacct.c
@@ -108,12 +108,6 @@ int __delayacct_add_tsk(struct taskstats *d, struct task_struct *tsk)
 	struct timespec ts;
 	cputime_t utime, stime, stimescaled, utimescaled;
 
-	/* Though tsk->delays accessed later, early exit avoids
-	 * unnecessary returning of other data
-	 */
-	if (!tsk->delays)
-		goto done;
-
 	tmp = (s64)d->cpu_run_real_total;
 	task_cputime(tsk, &utime, &stime);
 	cputime_to_timespec(utime + stime, &ts);

------------------------------diff end----------------------------------

If this diff is OK, I will send related patch for it.


Thanks.
-- 
Chen Gang
