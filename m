Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab3DWV2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 17:28:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33850 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab3DWV2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:28:18 -0400
Date: Tue, 23 Apr 2013 14:28:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH] relay: fix timer madness
Message-Id: <20130423142816.908a0a141bf41cc0dbf0cd01@linux-foundation.org>
In-Reply-To: <517245A4.7050601@huawei.com>
References: <517245A4.7050601@huawei.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Apr 2013 15:37:08 +0800 "zhangwei(Jovi)" <jovi.zhangwei@huawei.com> wrote:

> Hi,
> 
> Ingo, Steven, I get this patch from 3.4 preempt-rt patch set, It seems that this patch
> fix relayfs bug not only for rt kernel, but also for mainline.
> 
> When I'm using below ktap script to tracing all event tracepoints, without this patch,
> the system will hang in few seconds, the patch indeed fix the problem as the changelog pointed.
> 
> 	function eventfun (e) {
>         	printf("%d %d\t%s\t%s", cpu(), pid(), execname(), e.annotate)
> 	}
> 
> 	kdebug.probe("tp:", eventfun)
> 
> 	kdebug.probe_end(function () {
>         	printf("probe end\n")
> 	})
> 
> 
> This patch is old, I can found the original patch discussion in 2007.
> 	http://marc.info/?l=linux-kernel&m=118544794717162&w=2
> (In that mail thread, the patch didn't fix that problem, but it fix the problem I encountered now)
> 
> I hope you can remember this :)
> 
> so why we didn't commit this patch into mainline? any concern?
> 
> Thanks.
> 
> ------------------------------------->
> Subject: relay: fix timer madness
> From: Ingo Molnar <mingo@elte.hu>
> 
> remove timer calls (!!!) from deep within the tracing infrastructure.
> This was totally bogus code that can cause lockups and worse.
> Poll the buffer every 2 jiffies for now.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

(This version of the patch should have your signed-off-by)

> @@ -604,15 +609,6 @@ size_t relay_switch_subbuf(struct rchan_
>  		buf->subbufs_produced++;
>  		buf->dentry->d_inode->i_size += buf->chan->subbuf_size -
>  			buf->padding[old_subbuf];
> -		smp_mb();
> -		if (waitqueue_active(&buf->read_wait))
> -			/*
> -			 * Calling wake_up_interruptible() from here
> -			 * will deadlock if we happen to be logging
> -			 * from the scheduler (trying to re-grab
> -			 * rq->lock), so defer it.
> -			 */
> -			__mod_timer(&buf->timer, jiffies + 1);
>  	}

We've "fixed" the printk-inside-runqueue-lock deadlocks via icky
hackery in wake_up_klogd().  I guess we could do it the same way here. 
But the two approaches are conceptually very similar and this version
in relay.c is much simpler.


