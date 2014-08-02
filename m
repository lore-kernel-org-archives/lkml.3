Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbaHBSVs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 14:21:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754808AbaHBSVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 14:21:47 -0400
Date: Sat, 2 Aug 2014 20:19:58 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Aleksei Besogonov <alex.besogonov@gmail.com>
Cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org
Subject: Re: Soft lockups during reading /proc/PID/smaps
Message-ID: <20140802181958.GA28283@redhat.com>
References: <loom.20140731T091947-310@post.gmane.org> <alpine.DEB.2.02.1407310041500.20816@chino.kir.corp.google.com> <117A54C0-F3AC-4DD0-B2F6-886C5D4419E3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <117A54C0-F3AC-4DD0-B2F6-886C5D4419E3@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31, Aleksei Besogonov wrote:
>
> On 31 Jul 2014, at 00:43, David Rientjes <rientjes@google.com> wrote:
>
> > The while_each_thread() in vm_is_stack() looks suspicious since the task
> > isn't current and rcu won't protect the iteration, and we also don't hold
> > sighand lock or a readlock on tasklist_lock.
> > I think Oleg will know how to proceed, cc'd.
> I’m attaching a minimal test case that can reproduce the issue. Works in 100% cases on any system I’ve tried.

Thanks. I think David is right and we need the simple patch below.
This reminds me I should kill while_each_thread :/

Any chance you can test it? If not, I will do this later and send
the patch if it helps.

Oleg.

--- x/mm/util.c
+++ x/mm/util.c
@@ -277,17 +277,14 @@ pid_t vm_is_stack(struct task_struct *ta
 
 	if (in_group) {
 		struct task_struct *t;
-		rcu_read_lock();
-		if (!pid_alive(task))
-			goto done;
 
-		t = task;
-		do {
+		rcu_read_lock();
+		for_each_thread(task, t) {
 			if (vm_is_stack_for_task(t, vma)) {
 				ret = t->pid;
 				goto done;
 			}
-		} while_each_thread(task, t);
+		}
 done:
 		rcu_read_unlock();
 	}

