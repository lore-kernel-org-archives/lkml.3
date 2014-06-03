Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829AbaFCPPH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 11:15:07 -0400
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:46455 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932225AbaFCPPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 11:15:05 -0400
X-Greylist: delayed 469 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Jun 2014 11:15:05 EDT
Message-ID: <538DE49F.7040904@akamai.com>
Date: Tue, 03 Jun 2014 11:07:11 -0400
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        "acme@ghostprotocols.net" <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>
Subject: Re: eventpoll __list_del_entry corruption
References: <5370EBE9.6@oracle.com> <20140515181102.GH11096@twins.programming.kicks-ass.net>
In-Reply-To: <20140515181102.GH11096@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2014 02:11 PM, Peter Zijlstra wrote:
> On Mon, May 12, 2014 at 11:42:33AM -0400, Sasha Levin wrote:
>> Hi all,
>>
>> While fuzzing with trinity inside a KVM tools guest running the latest -next
>> kernel I've stumbled on the following spew. Maybe related to the very recent
>> change in freeing on task exit?
>>
> 
> While fuzzing to reproduce; I hit this one, is it a known one or should
> I go poke the right people about it?
> 
> ---
> [ 5823.689985] ------------[ cut here ]------------
> [ 5823.690004] WARNING: CPU: 3 PID: 2508 at /usr/src/linux-2.6/lib/list_debug.c:59 __list_del_entry+0xa1/0xd0()
> [ 5823.690004] list_del corruption. prev->next should be ffff880131111de0, but was 6b6b6b6b6b6b6b6b
> [ 5823.690004] Modules linked in:
> [ 5823.690004] CPU: 3 PID: 2508 Comm: trinity-main Not tainted 3.15.0-rc5-01700-g505011124ad0-dirty #1072
> [ 5823.690004] Hardware name: Supermicro X8DTN/X8DTN, BIOS 4.6.3 01/08/2010
> [ 5823.690004]  0000000000000009 ffff880432709ca8 ffffffff81681aa2 ffff880432709cf0
> [ 5823.690004]  ffff880432709ce0 ffffffff8109807c ffff880131111de0 ffff880131111dc8
> [ 5823.690004]  0000000000000286 ffff8800b9dd5618 ffff88023699b720 ffff880432709d40
> [ 5823.690004] Call Trace:
> [ 5823.690004]  [<ffffffff81681aa2>] dump_stack+0x4e/0x7a
> [ 5823.690004]  [<ffffffff8109807c>] warn_slowpath_common+0x8c/0xc0
> [ 5823.690004]  [<ffffffff8109816c>] warn_slowpath_fmt+0x4c/0x50
> [ 5823.690004]  [<ffffffff810ec8bf>] ? do_raw_spin_lock+0x13f/0x160
> [ 5823.690004]  [<ffffffff8138c661>] __list_del_entry+0xa1/0xd0
> [ 5823.690004]  [<ffffffff8138c69d>] list_del+0xd/0x30
> [ 5823.690004]  [<ffffffff810dfa71>] remove_wait_queue+0x31/0x50
> [ 5823.690004]  [<ffffffff812152aa>] ep_unregister_pollwait.isra.9+0x6a/0xb0
> [ 5823.690004]  [<ffffffff81215268>] ? ep_unregister_pollwait.isra.9+0x28/0xb0
> [ 5823.690004]  [<ffffffff8121531f>] ep_remove+0x2f/0xe0
> [ 5823.690004]  [<ffffffff81215705>] eventpoll_release_file+0x65/0xa0
> [ 5823.690004]  [<ffffffff811cf259>] __fput+0x1d9/0x1e0
> [ 5823.690004]  [<ffffffff811cf2ae>] ____fput+0xe/0x10
> [ 5823.690004]  [<ffffffff810b91f4>] task_work_run+0xc4/0xe0
> [ 5823.690004]  [<ffffffff8109a544>] do_exit+0x2d4/0xa90
> [ 5823.690004]  [<ffffffff813825c4>] ? lockdep_sys_exit_thunk+0x35/0x67
> [ 5823.690004]  [<ffffffff8109ae2c>] do_group_exit+0x4c/0xc0
> [ 5823.690004]  [<ffffffff8109aeb7>] SyS_exit_group+0x17/0x20
> [ 5823.690004]  [<ffffffff8168a2c2>] system_call_fastpath+0x16/0x1b
> [ 5823.690004] ---[ end trace 515b7fa3169c0906 ]---
> 


Hi Peter,

If its possible to reproduce maybe we can apply the following debug
patch to at least have a clue about which wait queue has gotten
corrupted. The bug could also be isolated to the epoll core too (ie
not specific to a particular wait queue), but I think its worth a
shot...

Thanks,

-Jason


diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index af90312..e8d5ea7 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -237,6 +237,9 @@ struct eppoll_entry {
 
 	/* The wait queue head that linked the "wait" wait queue item */
 	wait_queue_head_t *whead;
+
+	/* DEBUG: save address of ep_ptable_queue_proc() caller */
+	unsigned long poll_wait_addr;
 };
 
 /* Wrapper struct used by poll queueing */
@@ -513,6 +516,21 @@ static void ep_poll_safewake(wait_queue_head_t *wq)
 	put_cpu();
 }
 
+static void check_pwq(struct eppoll_entry *pwq)
+{
+	unsigned long flags;
+	struct list_head *prev, *entry;
+
+	spin_lock_irqsave(&pwq->whead->lock, flags);
+	entry = &pwq->wait.task_list;
+	prev = entry->prev;
+	if (prev->next != entry)
+		pr_err("epoll: list corruption: queue caller addr: 0x%lx, "
+			"function: %pS\n", pwq->poll_wait_addr,
+			(void *)pwq->poll_wait_addr);
+	spin_unlock_irqrestore(&pwq->whead->lock, flags);
+}
+
 static void ep_remove_wait_queue(struct eppoll_entry *pwq)
 {
 	wait_queue_head_t *whead;
@@ -520,8 +538,10 @@ static void ep_remove_wait_queue(struct eppoll_entry *pwq)
 	rcu_read_lock();
 	/* If it is cleared by POLLFREE, it should be rcu-safe */
 	whead = rcu_dereference(pwq->whead);
-	if (whead)
+	if (whead) {
+		check_pwq(pwq);
 		remove_wait_queue(whead, &pwq->wait);
+	}
 	rcu_read_unlock();
 }
 
@@ -1101,6 +1121,7 @@ static void ep_ptable_queue_proc(struct file *file, wait_queue_head_t *whead,
 		add_wait_queue(whead, &pwq->wait);
 		list_add_tail(&pwq->llink, &epi->pwqlist);
 		epi->nwait++;
+		pwq->poll_wait_addr = (unsigned long)__builtin_return_address(0);
 	} else {
 		/* We have to signal that an error occurred */
 		epi->nwait = -1;
