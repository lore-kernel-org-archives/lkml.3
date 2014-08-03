Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbaHCMDw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 08:03:52 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:41123 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbaHCMDu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 08:03:50 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: Soft lockups during reading /proc/PID/smaps
From: Aleksei Besogonov <alex.besogonov@gmail.com>
In-Reply-To: <20140802181958.GA28283@redhat.com>
Date: Sun, 3 Aug 2014 05:03:45 -0700
Cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <264016DC-6B8B-4732-8977-44AA2CF47E1A@gmail.com>
References: <loom.20140731T091947-310@post.gmane.org> <alpine.DEB.2.02.1407310041500.20816@chino.kir.corp.google.com> <117A54C0-F3AC-4DD0-B2F6-886C5D4419E3@gmail.com> <20140802181958.GA28283@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02 Aug 2014, at 11:19, Oleg Nesterov <oleg@redhat.com> wrote:
> On 07/31, Aleksei Besogonov wrote:
>> 
>> On 31 Jul 2014, at 00:43, David Rientjes <rientjes@google.com> wrote:
>> 
>>> The while_each_thread() in vm_is_stack() looks suspicious since the task
>>> isn't current and rcu won't protect the iteration, and we also don't hold
>>> sighand lock or a readlock on tasklist_lock.
>>> I think Oleg will know how to proceed, cc'd.
>> I’m attaching a minimal test case that can reproduce the issue. Works in 100% cases on any system I’ve tried.
> Thanks. I think David is right and we need the simple patch below.
> This reminds me I should kill while_each_thread :/
> Any chance you can test it? If not, I will do this later and send
> the patch if it helps.
Thanks, it works on the rc7 kernel.

I can make a backported version for earlier kernels if nobody else is interested.

> 
> Oleg.
> 
> --- x/mm/util.c
> +++ x/mm/util.c
> @@ -277,17 +277,14 @@ pid_t vm_is_stack(struct task_struct *ta
> 
> 	if (in_group) {
> 		struct task_struct *t;
> -		rcu_read_lock();
> -		if (!pid_alive(task))
> -			goto done;
> 
> -		t = task;
> -		do {
> +		rcu_read_lock();
> +		for_each_thread(task, t) {
> 			if (vm_is_stack_for_task(t, vma)) {
> 				ret = t->pid;
> 				goto done;
> 			}
> -		} while_each_thread(task, t);
> +		}
> done:
> 		rcu_read_unlock();
> 	}
> 

