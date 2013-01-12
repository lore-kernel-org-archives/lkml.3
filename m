Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab3ALRqe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 12:46:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884Ab3ALRqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 12:46:33 -0500
Date: Sat, 12 Jan 2013 18:46:07 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Michel Lespinasse <walken@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, David Howells <dhowells@redhat.com>,
        Salman Qazi <sqazi@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rwlock_t unfairness and tasklist_lock
Message-ID: <20130112174607.GB22338@redhat.com>
References: <CANN689HRmVTLCjNL9c=JqhWy5F5vwr=A7coo3TVKLZGSVUpQjw@mail.gmail.com> <alpine.LFD.2.02.1301111522150.7475@ionos> <20130112033346.GA11712@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130112033346.GA11712@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11, Michel Lespinasse wrote:
>
> So I looked again at getpriority() since that's what I had used for my
> DOS test code, and it looks like everything there is already protected
> by RCU or smaller granularity locks and refcounts. Patch attached to
> remove this tasklist_lock usage.

And probably the change in getpriority() is fine, but ...

> @@ -189,7 +189,6 @@ SYSCALL_DEFINE3(setpriority, int, which, int, who, int, niceval)
>  		niceval = 19;
>
>  	rcu_read_lock();
> -	read_lock(&tasklist_lock);
>  	switch (which) {
>  		case PRIO_PROCESS:
>  			if (who)
> @@ -226,7 +225,6 @@ SYSCALL_DEFINE3(setpriority, int, which, int, who, int, niceval)
>  			break;
>  	}
>  out_unlock:
> -	read_unlock(&tasklist_lock);

you also changed setpriority(), this should be documented at least ;)

OK. Even without this change, say, sys_setpriority(PRIO_PGRP) can obviously
race with fork(), so this change probably is not bad.

Oleg.

