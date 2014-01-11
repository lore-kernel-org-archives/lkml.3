Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbaAKJu4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 04:50:56 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:57685 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbaAKJuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 04:50:51 -0500
Date: Sat, 11 Jan 2014 01:50:45 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: akpm@linux-foundation.org, pavel@ucw.cz, joe@perches.com,
        keescook@chromium.org, geert@linux-m68k.org, jkosina@suse.cz,
        viro@zeniv.linux.org.uk, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/vsprintf: add %pT format specifier
Message-ID: <20140111095045.GD10038@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <201401092151.FIB00084.SJFOLVOMQHtFOF@I-love.SAKURA.ne.jp>
 <20140110160430.526efb3ea91783fe8a32fec5@linux-foundation.org>
 <201401111028.DEG34385.FVHtLOFMQJFSOO@I-love.SAKURA.ne.jp>
 <20140110175730.102b8250.akpm@linux-foundation.org>
 <201401111209.IEG82331.OtVQLFOFHMOSFJ@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201401111209.IEG82331.OtVQLFOFHMOSFJ@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011109-0928-0000-0000-0000054B7C6E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 11, 2014 at 12:09:46PM +0900, Tetsuo Handa wrote:
> Andrew Morton wrote:
> > In the absence of step 3, steps 1 and 2 are rather pointless churn.
> > 
> > So I think it would be better to merge (into mainline) steps 1 and 3
> > first and at the same time.  Then start thinking about step 2.
> 
> Unfortunately we can't.
> Step 2 depends on step 1 for avoiding compile time errors.
> Step 3 depends on step 2 for avoiding run time errors.
> 
>   Step 1: (targeted to 3.14-rc1)
>     Add "%pT" format specifier and commcpy() wrapper function.
> 
>   Step 2: (started after step 1 is reflected to other git trees)
>     Replace printk("%s", current->comm) with printk("%pT", NULL).
>     Replace printk("%s", p->comm) with printk("%pT", p).
>     Replace strcpy(buf, p->comm) with commcpy(buf, p).
> 
>   Step 3: (started after step 2 is reflected to other git trees)
>     Add rcu_read_lock()/rcu_read_unlock() into commcpy().
>     Modify set_task_comm() etc. to replace ->comm using RCU.
> 
> If step 3 is merged into mainline before step 2 complete, those who are not
> using "%pT" or commcpy() might crash due to reading RCU protected ->comm
> without rcu_read_lock()/rcu_read_unlock().
> 
> 
> Let me confirm, Paul.
> 
>   I'm trying to change task_struct->comm to use RCU.
>   At step 3, I'm planning to do
> 
>   static inline void *commcpy(void *buf, const struct task_struct *tsk)
>   {
>   	rcu_read_lock();
>   	memcpy(buf, tsk->comm, TASK_COMM_LEN);
>   	rcu_read_unlock();
>   	return buf;
>   }
> 
>   and let set_task_comm() wait for readers using synchronize_rcu() or
>   call_rcu().
> 
>   Given that commcpy() can be called from any context, are synchronize_rcu()
>   and call_rcu() sufficient for waiting for commcpy() users?

Yep, that should work.

							Thanx, Paul

