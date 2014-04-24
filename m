Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbaDXL0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 07:26:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50095 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759AbaDXL0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 07:26:11 -0400
Date: Thu, 24 Apr 2014 13:26:07 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        akpm@linux-foundation.org, tglx@linutronix.de, oleg@redhat.com,
        fengguang.wu@intel.com, bp@suse.de, paul.gortmaker@windriver.com
cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/kprobes] kprobes, x86: Allow kprobes on text_poke/
 hw_breakpoint
In-Reply-To: <tip-9c54b6164eeb292a0eac86c6913bd8daaff35e62@git.kernel.org>
Message-ID: <alpine.LNX.2.00.1404241325420.3265@pobox.suse.cz>
References: <20140417081807.26341.73219.stgit@ltc230.yrl.intra.hitachi.co.jp> <tip-9c54b6164eeb292a0eac86c6913bd8daaff35e62@git.kernel.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2014, tip-bot for Masami Hiramatsu wrote:

> Commit-ID:  9c54b6164eeb292a0eac86c6913bd8daaff35e62
> Gitweb:     http://git.kernel.org/tip/9c54b6164eeb292a0eac86c6913bd8daaff35e62
> Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> AuthorDate: Thu, 17 Apr 2014 17:18:07 +0900
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Thu, 24 Apr 2014 10:03:02 +0200
> 
> kprobes, x86: Allow kprobes on text_poke/hw_breakpoint
> 
> Allow kprobes on text_poke/hw_breakpoint because
> those are not related to the critical int3-debug
> recursive path of kprobes at this moment.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Fengguang Wu <fengguang.wu@intel.com>
> Cc: Jiri Kosina <jkosina@suse.cz>

Reviewed-by: Jiri Kosina <jkosina@suse.cz>

> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> Link: http://lkml.kernel.org/r/20140417081807.26341.73219.stgit@ltc230.yrl.intra.hitachi.co.jp
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
>  arch/x86/kernel/alternative.c   | 3 +--
>  arch/x86/kernel/hw_breakpoint.c | 5 ++---
>  2 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> index df94598..703130f 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -5,7 +5,6 @@
>  #include <linux/mutex.h>
>  #include <linux/list.h>
>  #include <linux/stringify.h>
> -#include <linux/kprobes.h>
>  #include <linux/mm.h>
>  #include <linux/vmalloc.h>
>  #include <linux/memory.h>
> @@ -551,7 +550,7 @@ void *__init_or_module text_poke_early(void *addr, const void *opcode,
>   *
>   * Note: Must be called under text_mutex.
>   */
> -void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
> +void *text_poke(void *addr, const void *opcode, size_t len)
>  {
>  	unsigned long flags;
>  	char *vaddr;
> diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
> index a67b47c..5f9cf20 100644
> --- a/arch/x86/kernel/hw_breakpoint.c
> +++ b/arch/x86/kernel/hw_breakpoint.c
> @@ -32,7 +32,6 @@
>  #include <linux/irqflags.h>
>  #include <linux/notifier.h>
>  #include <linux/kallsyms.h>
> -#include <linux/kprobes.h>
>  #include <linux/percpu.h>
>  #include <linux/kdebug.h>
>  #include <linux/kernel.h>
> @@ -424,7 +423,7 @@ EXPORT_SYMBOL_GPL(hw_breakpoint_restore);
>   * NOTIFY_STOP returned for all other cases
>   *
>   */
> -static int __kprobes hw_breakpoint_handler(struct die_args *args)
> +static int hw_breakpoint_handler(struct die_args *args)
>  {
>  	int i, cpu, rc = NOTIFY_STOP;
>  	struct perf_event *bp;
> @@ -511,7 +510,7 @@ static int __kprobes hw_breakpoint_handler(struct die_args *args)
>  /*
>   * Handle debug exception notifications.
>   */
> -int __kprobes hw_breakpoint_exceptions_notify(
> +int hw_breakpoint_exceptions_notify(
>  		struct notifier_block *unused, unsigned long val, void *data)
>  {
>  	if (val != DIE_DEBUG)
> 

-- 
Jiri Kosina
SUSE Labs
