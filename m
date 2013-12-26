Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab3LZApU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 19:45:20 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:63627 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab3LZApT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 19:45:19 -0500
X-Nat-Received: from [202.181.97.72]:53193 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1388018702.6398
Message-Id: <201312260045.rBQ0j2TD059809@www262.sakura.ne.jp>
Subject: Re: [PATCH] drm/i915: Fix refcount leak and possible NULL pointer dereference.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: chris@chris-wilson.co.uk
Cc: ben@bwidawsk.net, daniel.vetter@ffwll.ch, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Thu, 26 Dec 2013 09:45:02 +0900
References: <201312242050.CGH78112.JQFOSVMLOFtHOF@I-love.SAKURA.ne.jp> <20131225215249.GA3832@nuc-i3427.alporthouse.com>
In-Reply-To: <20131225215249.GA3832@nuc-i3427.alporthouse.com>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 25122013 #7189795, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Chris Wilson wrote:
> > Since get_pid_task() grabs a reference on the task_struct, we have to drop the
> > refcount after reading that task\'s comm name. Also, directly reading like
> > get_pid_task()->comm can trigger an oops when get_pid_task() returned NULL.
> 
> The second issue is moot as file itself cannot exist if the task_struct
> is NULL, and the task_struct cannot be destroyed until we finish the
> function. The simpler fix would appear to be s/get_pid_task/pid_task/

I didn\'t catch. Please see below sample module.

pid_task() will return NULL if the target task has already died.
The target task could be killed (e.g. by the OOM killer) at any time, and
whether the target task\'s task_struct is not yet destroyed is irrelevant
for pid_task().

get_pid_task(file->pid, PIDTYPE_PID)->comm by chance didn\'t trigger
oops because offsetof(struct task_struct, comm) < PAGE_SIZE is true.

---------- sample start ----------
#include <linux/module.h>
#include <linux/delay.h>
#include <linux/kthread.h>

static int test_thread(void *unused)
{
        return 0;
}

static int __init test_init(void)
{
        struct task_struct *task = kthread_create(test_thread, NULL, \"test\");
        if (!IS_ERR(task)) {
                struct pid *pid;
                struct task_struct *t;
                get_task_struct(task);
                pid = get_pid(task->pids[PIDTYPE_PID].pid);
                rcu_read_lock();
                t = pid_task(pid, PIDTYPE_PID);
                rcu_read_unlock();
                printk(\"pid_task(%p)=%p\\n\", pid, t);
                wake_up_process(task);
                ssleep(1);
                rcu_read_lock();
                t = pid_task(pid, PIDTYPE_PID);
                rcu_read_unlock();
                printk(\"pid_task(%p)=%p\\n\", pid, t);
                put_task_struct(task);
                put_pid(pid);
        }
        return -EINVAL;
}

module_init(test_init);
MODULE_LICENSE(\"GPL\");
---------- sample end ----------

---------- output start ----------
pid_task(ffff8800474bff80)=ffff8800435b0e10
pid_task(ffff8800474bff80)=          (null)
---------- output end ----------
