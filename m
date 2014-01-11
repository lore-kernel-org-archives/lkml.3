Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbaAKB4Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 20:56:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34259 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbaAKB4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 20:56:11 -0500
Date: Fri, 10 Jan 2014 17:57:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: pavel@ucw.cz, joe@perches.com, keescook@chromium.org, geert@linux-m68k.org,
        jkosina@suse.cz, viro@zeniv.linux.org.uk, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/vsprintf: add %pT format specifier
Message-Id: <20140110175730.102b8250.akpm@linux-foundation.org>
In-Reply-To: <201401111028.DEG34385.FVHtLOFMQJFSOO@I-love.SAKURA.ne.jp>
References: <201401092151.FIB00084.SJFOLVOMQHtFOF@I-love.SAKURA.ne.jp>
	<20140110160430.526efb3ea91783fe8a32fec5@linux-foundation.org>
	<201401111028.DEG34385.FVHtLOFMQJFSOO@I-love.SAKURA.ne.jp>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Jan 2014 10:28:51 +0900 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> wrote:

> Andrew Morton wrote:
> > On Thu, 9 Jan 2014 21:52:00 +0900 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> wrote:
> > 
> > > This patch introduces %pT format specifier for printing task_struct->comm.
> > > Currently %pT does not provide consistency. I'm planning to change to use RCU
> > > in the future. By using RCU, the comm name read from task_struct->comm will be
> > > guaranteed to be consistent. But before modifying set_task_comm() to use RCU,
> > > we need to kill direct ->comm users who do not use get_task_comm().
> > 
> > On reflection...
> > 
> > It isn't obvious that this patch is sufficiently beneficial until we
> > have that RCU code in place.
> > 
> > So I could retain this patch in -mm until we have that all sorted out. 
> > And I'll have to avoid merging %pT users into mainline in the
> > meanwhile!
> > 
> > Am I wrong?  The patch seems fairly pointless as a standalone thing?
> > 
> 
>   Step 1: (targeted to 3.14-rc1)
>     Add "%pT" format specifier and commcpy() wrapper function.
> 
>   Step 2: (started after step 1 is reflected to other git trees)
>     Replace printk("%s", p->comm) with printk("%pT", p).
>     Replace strcpy(buf, p->comm) with commcpy(buf, p).
> 
>   Step 3: (started after step 2 is reflected to other git trees)
>     Add rcu_read_lock()/rcu_read_unlock() into commcpy().
>     Modify set_task_comm() etc. to replace ->comm using RCU.

In the absence of step 3, steps 1 and 2 are rather pointless churn.

So I think it would be better to merge (into mainline) steps 1 and 3
first and at the same time.  Then start thinking about step 2.

