Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbaKZVci (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 16:32:38 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:59637 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaKZVcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 16:32:36 -0500
Date: Wed, 26 Nov 2014 13:32:34 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
cc: Lukasz Pawelczyk <havner@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        Sameer Nanda <snanda@chromium.org>,
        Guillaume Morin <guillaume@morinfr.org>, Li Zefan <lizefan@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel/exit.c: make sure current's nsproxy != NULL while
 checking caps
In-Reply-To: <1417011661-19230-1-git-send-email-l.pawelczyk@samsung.com>
Message-ID: <alpine.DEB.2.10.1411261326170.32216@chino.kir.corp.google.com>
References: <1417011661-19230-1-git-send-email-l.pawelczyk@samsung.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2014, Lukasz Pawelczyk wrote:

> There is a rare case where current's nsproxy might be NULL but we are
> required to check for credentials and capabilities. It sometimes happens
> during an exit() syscall while destroying user's session (logging out).
> 
> My understanding is that while we have to use task_nsproxy() to get
> task's nsproxy and check whether it's NULL, for the 'current' we don't
> have to and it's expected not to be NULL. There is a code in the kernel
> currently that does current->nsproxy->user_ns without any checks.
> 
> There seem to be no crash currently because of this, but with other LSM
> modules or in future there might be. This is the backtrace:
> 
> 0  smk_tskacc (task=0xffff88003b0b92e0, obj_known=0x2 <irq_stack_union+2>, mode=2, a=0xffff88003be53dd8) at security/smack/smack_access.c:261
> 1  0xffffffff8130e2aa in smk_curacc (obj_known=<optimized out>, mode=<optimized out>, a=<optimized out>) at security/smack/smack_access.c:318
> 2  0xffffffff8130a50d in smack_task_kill (p=0xffff88003b0b92e0, info=<optimized out>, sig=<optimized out>, secid=<optimized out>) at security/smack/smack_lsm.c:2071
> 3  0xffffffff812ea4f6 in security_task_kill (p=<optimized out>, info=<optimized out>, sig=<optimized out>, secid=<optimized out>) at security/security.c:952
> 4  0xffffffff8109ac80 in check_kill_permission (sig=15, info=0x0 <irq_stack_union>, t=0xffff88003b0b8000) at kernel/signal.c:796
> 5  0xffffffff8109d3ab in group_send_sig_info (sig=15, info=0x0 <irq_stack_union>, p=0xffff88003b0b8000) at kernel/signal.c:1296
> 6  0xffffffff8108e527 in forget_original_parent (father=<optimized out>) at kernel/exit.c:575
> 7  exit_notify (group_dead=<optimized out>, tsk=<optimized out>) at kernel/exit.c:606
> 8  do_exit (code=<optimized out>) at kernel/exit.c:775
> 9  0xffffffff8108ec0f in do_group_exit (exit_code=0) at kernel/exit.c:891
> 10 0xffffffff8108ec84 in SYSC_exit_group (error_code=<optimized out>) at kernel/exit.c:902
> 11 SyS_exit_group (error_code=<optimized out>) at kernel/exit.c:900
> 
> LSM task_kill() hook is triggered and current->nsproxy within is NULL.
> 
> This happens during an exit() syscall because exit_task_namespaces() is
> called before the exit_notify(). This patch changes their order.
> 

This is a classic case of a patch being proposed for a problem that only 
occurs on kernels that include other patches that are not upstream.  The 
order that things are deconstructed in the exit path is complex and 
carefully choreographed, changing it comes at significant risk.  That risk 
would be justified if a patch were being proposed for upstream that fixes 
an upstream problem.  It becomes too much of a maintenance nightmare to 
try to address problems and keep issues from arising for non-upstream 
patches.  Thus, I don't think this is something that we want.
