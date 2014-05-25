Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422AbaEYSjw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 14:39:52 -0400
Received: from smtprelay0220.hostedemail.com ([216.40.44.220]:54792 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751071AbaEYSjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 14:39:51 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3867:3868:3870:3871:3872:3874:4321:5007:7652:8660:9038:10004:10400:10848:11026:11232:11658:11914:12043:12296:12517:12519:12740:13069:13148:13161:13229:13230:13311:13357:21067,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bead38_1b92b5b22db41
X-Filterd-Recvd-Size: 2806
Message-ID: <1401043188.22191.16.camel@joe-AO725>
Subject: Re: [PATCH 7/6] ipc/sem.c: add a printk_once for
 semctl(GETNCNT/GETZCNT)
From: Joe Perches <joe@perches.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, 1vier1@web.de
Date: Sun, 25 May 2014 11:39:48 -0700
In-Reply-To: <1401042063-24666-1-git-send-email-manfred@colorfullife.com>
References: <1401042063-24666-1-git-send-email-manfred@colorfullife.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-05-25 at 20:21 +0200, Manfred Spraul wrote:
> The actual Linux implementation for semctl(GETNCNT) and semctl(GETZCNT)
> always (since 0.99.10) reported a thread as sleeping on all semaphores
> that are listed in the semop() call.
> The documented behavior (both in the Linux man page and in the Single Unix
> Specification) is that a task should be reported on exactly one semaphore:
> The semaphore that caused the thread to got to sleep.
> 
> This patch adds a printk_once() that is triggered if a thread hits
> the relevant case.
[]
> diff --git a/ipc/sem.c b/ipc/sem.c
[]
> @@ -1000,6 +1000,18 @@ static int check_qop(struct sem_array *sma, int semnum, struct sem_queue *q,
>  {
>  	struct sembuf *sop = q->blocking;
>  
> +	/*
> +	 * Linux always (since 0.99.10) reported a task as sleeping on all
> +	 * semaphores. This violates SUS, therefore it was changed to the
> +	 * standard compliant behavior.
> +	 * Give the administrators a chance to notice that an application
> +	 * might misbehave because it relies on the Linux behavior.
> +	 */
> +	printk_once(KERN_INFO "semctl(GETNCNT/GETZCNT) is since 3.16 Single " \
> +				"Unix Specification compliant.\n" \
> +				"The task %d triggered the difference, " \
> +				"watch for misbehavior.", current->pid);

Unnecessary line continuations.
Missing terminating newline after "misbehavior"
Ideally coalesced or broken at linebreaks like:

	pr_info_once("semctl(GETNCNT/GETZCNT) is Single Unix Specification compliant since kernel v3.16\n"
		     "Task %d triggered the difference, watch for misbehavior\n",
		     current->pid);

>  	if (sop->sem_num != semnum)
>  		return 0;
>  

Should the printk_once (which could be pr_info_once or _ratelimited
or maybe even emitted at KERN_DEBUG) be done only when
the return is 1?


