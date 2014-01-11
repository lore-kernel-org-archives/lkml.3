Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbaAKB3w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 20:29:52 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:57227 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbaAKB3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 20:29:49 -0500
X-Nat-Received: from [202.181.97.72]:64267 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1389403734.27726
To: akpm@linux-foundation.org
Cc: pavel@ucw.cz, joe@perches.com, keescook@chromium.org, geert@linux-m68k.org,
        jkosina@suse.cz, viro@zeniv.linux.org.uk, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/vsprintf: add %pT format specifier
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201401092151.FIB00084.SJFOLVOMQHtFOF@I-love.SAKURA.ne.jp>
	<20140110160430.526efb3ea91783fe8a32fec5@linux-foundation.org>
In-Reply-To: <20140110160430.526efb3ea91783fe8a32fec5@linux-foundation.org>
Message-Id: <201401111028.DEG34385.FVHtLOFMQJFSOO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 11 Jan 2014 10:28:51 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 10012014 #7296163, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 9 Jan 2014 21:52:00 +0900 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> wrote:
> 
> > This patch introduces %pT format specifier for printing task_struct->comm.
> > Currently %pT does not provide consistency. I'm planning to change to use RCU
> > in the future. By using RCU, the comm name read from task_struct->comm will be
> > guaranteed to be consistent. But before modifying set_task_comm() to use RCU,
> > we need to kill direct ->comm users who do not use get_task_comm().
> 
> On reflection...
> 
> It isn't obvious that this patch is sufficiently beneficial until we
> have that RCU code in place.
> 
> So I could retain this patch in -mm until we have that all sorted out. 
> And I'll have to avoid merging %pT users into mainline in the
> meanwhile!
> 
> Am I wrong?  The patch seems fairly pointless as a standalone thing?
> 

  Step 1: (targeted to 3.14-rc1)
    Add "%pT" format specifier and commcpy() wrapper function.

  Step 2: (started after step 1 is reflected to other git trees)
    Replace printk("%s", p->comm) with printk("%pT", p).
    Replace strcpy(buf, p->comm) with commcpy(buf, p).

  Step 3: (started after step 2 is reflected to other git trees)
    Add rcu_read_lock()/rcu_read_unlock() into commcpy().
    Modify set_task_comm() etc. to replace ->comm using RCU.

This patch and commcpy() patch ( https://lkml.org/lkml/2014/1/10/217 ) are
targeted to be merged into 3.14-rc1. This is because we can start writing
patches to use "%pT" or commcpy() only after other git trees have rebased
using 3.14-rc1. After all direct ->comm readers are replaced to use "%pT" or
commcpy(), I can start ->comm modifying functions to use RCU.
