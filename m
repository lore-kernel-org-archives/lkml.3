Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbaBYM63 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 07:58:29 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:63686 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbaBYM62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 07:58:28 -0500
X-Nat-Received: from [202.181.97.72]:55765 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1393332841.26586
To: laijs@cn.fujitsu.com
Cc: akpm@linux-foundation.org, joe@perches.com, keescook@chromium.org,
        geert@linux-m68k.org, jkosina@suse.cz, viro@zeniv.linux.org.uk,
        davem@davemloft.net, linux-kernel@vger.kernel.org, mingo@elte.hu,
        peterz@infradead.org, rostedt@goodmis.org, tglx@linutronix.de
Subject: Re: [PATCH] Change task_struct->comm to use RCU.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20140207180647.5944fe3d.akpm@linux-foundation.org>
	<201402092327.JAD12489.QOLSFVMHJtFOOF@I-love.SAKURA.ne.jp>
	<201402102243.IEJ52676.JOFVMOQFOFSLtH@I-love.SAKURA.ne.jp>
	<201402172027.BFH81210.FJtOQOMLHFSVOF@I-love.SAKURA.ne.jp>
	<530BF6B4.3040206@cn.fujitsu.com>
In-Reply-To: <530BF6B4.3040206@cn.fujitsu.com>
Message-Id: <201402252154.HAE13049.QFFSMVOFOOtLJH@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 25 Feb 2014 21:54:01 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 25022014 #7301207, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai Jiangshan wrote:
> CC scheduler people.
> 
> I can't figure out what we get with this patch.
> 
OK. Welcome to this thread. I'll explain you what is going on.

Current problem:

  printk("%s\n", task->comm) is racy because "%s" format specifier assumes that
  the corresponding argument does not change between strnlen() and the for loop
  at string() in lib/vsnprintf.c . If task->comm was "Hello Linux" until
  strnlen() and becomes "Penguin" before the for loop, "%s" will emit
  "Penguin\0nux" (note the unexpected '\0' byte and the garbage bytes).

  Likewise, audit_log_untrustedstring(ab, current->comm) is racy.
  If task->comm was "Hello Linux" until audit_string_contains_control() in
  audit_log_n_untrustedstring() returns false, and becomes "Penguin" before
  memcpy() in audit_log_n_string() is called, memcpy() will emit "Penguin\0nux"
  into the audit log, which results in loss of information (e.g. SELinux
  context) due to the unexpected '\0' byte.

Proposed solution:

  To fix abovementioned problem, I proposed commcpy() and "%pT" format
  specifier which does

    char tmp[16];
    memcpy(tmp, task->comm, 16);
    tmp[15] = '\0';
    sprintf(buf, "%s", tmp);

  instead of

    sprintf(buf, "%s", task->comm);

  .

Remaining problem:

  Although the proposed solution will prevent the caller from emitting the
  unexpected '\0' byte and the garbage bytes, memcpy(tmp, task->comm, 16) in
  the proposed solution is not atomic. That is, "%pT" does not emit the '\0'
  byte like "Penguin\0nux" but "%pT" still might emit "Penguininux".

  To fix this problem, I proposed protecting memcpy(tmp, task->comm, 16) part
  using RCU. This patch is a design for how the update side of task->comm will
  look like if we use RCU approach.

  Of course, this approach depends on that nobody prefers the speed of reading
  task->comm over the atomicity of reading task->comm . If somebody strongly
  objects on the cost of calling rcu_read_lock()/rcu_read_unlock() for the
  atomicity, I'm fine without this patch.
