Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861AbaFSBQH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 21:16:07 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:57400 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756091AbaFSBQE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 21:16:04 -0400
Date: Wed, 18 Jun 2014 21:15:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: kbuild test robot <fengguang.wu@intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>, kbuild-all@01.org,
        LKML <linux-kernel@vger.kernel.org>,
        Michael Halcrow <mhalcrow@us.ibm.com>,
        Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org
Subject: Re: [trace:ftrace/core 1/3] include/trace/syscall.h:39:6: error:
 'TIF_SYSCALL_TRACEPOINT' undeclared
Message-ID: <20140618211559.76bdea15@gandalf.local.home>
In-Reply-To: <53a1e7ba.ZIiv6DbOB78b9RzY%fengguang.wu@intel.com>
References: <53a1e7ba.ZIiv6DbOB78b9RzY%fengguang.wu@intel.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2014 03:25:46 +0800
kbuild test robot <fengguang.wu@intel.com> wrote:

> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git ftrace/core
> head:   72fa1a896d8ef355e81270667803ceb16a3dd13f
> commit: 32def52ce8faec72c353b6304ca98176687e18f1 [1/3] tracing: Fix syscall_*regfunc() vs copy_process() race
> config: make ARCH=xtensa allyesconfig
> 
> All error/warnings:
> 
>    In file included from include/linux/syscalls.h:80:0,
>                     from fs/ecryptfs/keystore.c:29:
>    include/trace/syscall.h: In function 'syscall_tracepoint_update':
> >> include/trace/syscall.h:39:6: error: 'TIF_SYSCALL_TRACEPOINT' undeclared (first use in this function)
>    include/trace/syscall.h:39:6: note: each undeclared identifier is reported only once for each function it appears in
> 
> vim +/TIF_SYSCALL_TRACEPOINT +39 include/trace/syscall.h
> 
>     33		struct ftrace_event_call *exit_event;
>     34	};
>     35	
>     36	#ifdef CONFIG_TRACEPOINTS
>     37	static inline void syscall_tracepoint_update(struct task_struct *p)
>     38	{
>   > 39		if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
>     40			set_tsk_thread_flag(p, TIF_SYSCALL_TRACEPOINT);
>     41		else
>     42			clear_tsk_thread_flag(p, TIF_SYSCALL_TRACEPOINT);
> 
> ---
> 0-DAY kernel build testing backend              Open Source Technology Center
> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation

My allyesconfig build passed with flying colors. Although we should
probably still add the include of thread_info.h into trace/syscalls.h,
there's no reason that ecryptfs/keystore.c includes linux/syscalls.h.

I suggest adding the patch below.

-- Steve

>From 58029546c4acf896b9ce01a820e0093e37bb98be Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Date: Wed, 18 Jun 2014 21:12:38 -0400
Subject: [PATCH] ecryptfs: Remove unnecessary include of syscall.h in
 keystore.c

There's no reason to include syscalls.h in keystore.c. Remove it.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/ecryptfs/keystore.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index 4725a07f003c..831c5f8529be 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -26,7 +26,6 @@
  */
 
 #include <linux/string.h>
-#include <linux/syscalls.h>
 #include <linux/pagemap.h>
 #include <linux/key.h>
 #include <linux/random.h>
-- 
2.0.0.rc2

