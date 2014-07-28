Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704AbaG1TAf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 15:00:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbaG1TA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 15:00:29 -0400
Date: Mon, 28 Jul 2014 20:58:03 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org,
        Alexei Starovoitov <ast@plumgrid.com>, hpa@zytor.com
Subject: TIF_NOHZ can escape nonhz mask? (Was: [PATCH v3 6/8] x86: Split
	syscall_trace_enter into two phases)
Message-ID: <20140728185803.GA24663@redhat.com>
References: <cover.1405992946.git.luto@amacapital.net> <3f649f5658a163645e3ce15156176c325283762e.1405992946.git.luto@amacapital.net> <20140728173723.GA20993@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140728173723.GA20993@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Off-topic, but...

On 07/28, Oleg Nesterov wrote:
>
> But we should always call user_exit() unconditionally?

Frederic, don't we need the patch below? In fact clear_() can be moved
under "if ()" too. and probably copy_process() should clear this flag...

Or. __context_tracking_task_switch() can simply do

	 if (context_tracking_cpu_is_enabled())
	 	set_tsk_thread_flag(next, TIF_NOHZ);
	 else
	 	clear_tsk_thread_flag(next, TIF_NOHZ);

and then we can forget about copy_process(). Or I am totally confused?


I am also wondering if we can extend user_return_notifier to handle
enter/exit and kill TIF_NOHZ.

Oleg.

--- x/kernel/context_tracking.c
+++ x/kernel/context_tracking.c
@@ -202,7 +202,8 @@ void __context_tracking_task_switch(stru
 				    struct task_struct *next)
 {
 	clear_tsk_thread_flag(prev, TIF_NOHZ);
-	set_tsk_thread_flag(next, TIF_NOHZ);
+	if (context_tracking_cpu_is_enabled())
+		set_tsk_thread_flag(next, TIF_NOHZ);
 }
 
 #ifdef CONFIG_CONTEXT_TRACKING_FORCE

