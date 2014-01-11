Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880AbaAKDKh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 22:10:37 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:51120 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbaAKDKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 22:10:35 -0500
X-Nat-Received: from [202.181.97.72]:59446 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1389409789.24071
To: akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com
Cc: pavel@ucw.cz, joe@perches.com, keescook@chromium.org, geert@linux-m68k.org,
        jkosina@suse.cz, viro@zeniv.linux.org.uk, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/vsprintf: add %pT format specifier
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201401092151.FIB00084.SJFOLVOMQHtFOF@I-love.SAKURA.ne.jp>
	<20140110160430.526efb3ea91783fe8a32fec5@linux-foundation.org>
	<201401111028.DEG34385.FVHtLOFMQJFSOO@I-love.SAKURA.ne.jp>
	<20140110175730.102b8250.akpm@linux-foundation.org>
In-Reply-To: <20140110175730.102b8250.akpm@linux-foundation.org>
Message-Id: <201401111209.IEG82331.OtVQLFOFHMOSFJ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 11 Jan 2014 12:09:46 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 10012014 #7296163, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> In the absence of step 3, steps 1 and 2 are rather pointless churn.
> 
> So I think it would be better to merge (into mainline) steps 1 and 3
> first and at the same time.  Then start thinking about step 2.

Unfortunately we can't.
Step 2 depends on step 1 for avoiding compile time errors.
Step 3 depends on step 2 for avoiding run time errors.

  Step 1: (targeted to 3.14-rc1)
    Add "%pT" format specifier and commcpy() wrapper function.

  Step 2: (started after step 1 is reflected to other git trees)
    Replace printk("%s", current->comm) with printk("%pT", NULL).
    Replace printk("%s", p->comm) with printk("%pT", p).
    Replace strcpy(buf, p->comm) with commcpy(buf, p).

  Step 3: (started after step 2 is reflected to other git trees)
    Add rcu_read_lock()/rcu_read_unlock() into commcpy().
    Modify set_task_comm() etc. to replace ->comm using RCU.

If step 3 is merged into mainline before step 2 complete, those who are not
using "%pT" or commcpy() might crash due to reading RCU protected ->comm
without rcu_read_lock()/rcu_read_unlock().


Let me confirm, Paul.

  I'm trying to change task_struct->comm to use RCU.
  At step 3, I'm planning to do

  static inline void *commcpy(void *buf, const struct task_struct *tsk)
  {
  	rcu_read_lock();
  	memcpy(buf, tsk->comm, TASK_COMM_LEN);
  	rcu_read_unlock();
  	return buf;
  }

  and let set_task_comm() wait for readers using synchronize_rcu() or
  call_rcu().

  Given that commcpy() can be called from any context, are synchronize_rcu()
  and call_rcu() sufficient for waiting for commcpy() users?

Regards.
