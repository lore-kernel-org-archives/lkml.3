Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbaEZPsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 11:48:23 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:44932 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbaEZPsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 11:48:22 -0400
Message-ID: <1401119298.3000.3.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 7/6] ipc/sem.c: add a printk_once for
 semctl(GETNCNT/GETZCNT)
From: Davidlohr Bueso <davidlohr@hp.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, 1vier1@web.de
Date: Mon, 26 May 2014 08:48:18 -0700
In-Reply-To: <1401042063-24666-1-git-send-email-manfred@colorfullife.com>
References: <1401042063-24666-1-git-send-email-manfred@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
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
> 
> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
> Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>

Acked-by: Davidlohr Bueso <davidlohr@hp.com>

With some minor suggestions below.

> Cc: Michael Kerrisk <mtk.manpages@gmail.com>
> ---
>  ipc/sem.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/ipc/sem.c b/ipc/sem.c
> index 9106321..3cc2f7b6 100644
> --- a/ipc/sem.c
> +++ b/ipc/sem.c
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
                                           ^^ %u (->pid is unsigned)

It would also be useful to print ->comm. I hate having to lookup the
process name with just the pid.


