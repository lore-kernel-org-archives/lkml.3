Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbaELV72 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 17:59:28 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:55006 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaELV71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 17:59:27 -0400
Message-ID: <1399931959.2648.36.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [patch 3/3] futex: Prevent attaching to kernel threads
From: Davidlohr Bueso <davidlohr@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Darren Hart <darren@dvhart.com>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Clark Williams <williams@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Roland McGrath <roland@hack.frob.com>,
        Carlos ODonell <carlos@redhat.com>, Jakub Jelinek <jakub@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Date: Mon, 12 May 2014 14:59:19 -0700
In-Reply-To: <20140512201701.194824402@linutronix.de>
References: <20140512190438.314125476@linutronix.de>
	 <20140512201701.194824402@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-12 at 20:45 +0000, Thomas Gleixner wrote:
> We happily allow userspace to declare a random kernel thread to be the
> owner of a user space PI futex.
> 
> Found while analysing the fallout of Dave Jones syscall fuzzer.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: stable@vger.kernel.org
> ---
>  kernel/futex.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> Index: linux-2.6/kernel/futex.c
> ===================================================================
> --- linux-2.6.orig/kernel/futex.c
> +++ linux-2.6/kernel/futex.c
> @@ -682,6 +682,8 @@ static struct task_struct * futex_find_g
>         p = find_task_by_vpid(pid);
>         if (p)
>                 get_task_struct(p);
> +       else
> +               p = NULL;
>  
>         rcu_read_unlock();
>  
> @@ -814,6 +816,11 @@ lookup_pi_state(u32 uval, struct futex_h
>         if (!p)
>                 return -ESRCH;
>  
> +       if (!p->mm) {
> +               put_task_struct(p);
> +               return -EPERM;
> +       }

It might make sense to check the mm inside futex_find_get_task(), and
simply never take the refcount if NULL.

Thanks,
Davidlohr

