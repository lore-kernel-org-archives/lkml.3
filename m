Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbaDXJMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:12:36 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:60585 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755036AbaDXI4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:56:15 -0400
Date: Thu, 24 Apr 2014 10:56:01 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, fche@redhat.com,
        mingo@redhat.com, Rob Landley <rob@landley.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>, systemtap@sourceware.org
Subject: Re: [PATCH -tip v9 20/26] kprobes: Support blacklist functions in
 module
Message-ID: <20140424085601.GA7768@gmail.com>
References: <20140417081636.26341.87858.stgit@ltc230.yrl.intra.hitachi.co.jp>
 <20140417081856.26341.53535.stgit@ltc230.yrl.intra.hitachi.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140417081856.26341.53535.stgit@ltc230.yrl.intra.hitachi.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> To blacklist the functions in a module (e.g. user-defined
> kprobe handler and the functions invoked from it), expand
> blacklist support for modules.
> With this change, users can use NOKPROBE_SYMBOL() macro in
> their own modules.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Rob Landley <rob@landley.net>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  Documentation/kprobes.txt |    8 ++++++
>  include/linux/module.h    |    5 ++++
>  kernel/kprobes.c          |   63 ++++++++++++++++++++++++++++++++++++++-------
>  kernel/module.c           |    6 ++++
>  4 files changed, 72 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/kprobes.txt b/Documentation/kprobes.txt
> index 4bbeca8..2845956 100644
> --- a/Documentation/kprobes.txt
> +++ b/Documentation/kprobes.txt
> @@ -512,6 +512,14 @@ int enable_jprobe(struct jprobe *jp);
>  Enables *probe which has been disabled by disable_*probe(). You must specify
>  the probe which has been registered.
>  
> +4.9 NOKPROBE_SYMBOL()
> +
> +#include <linux/kprobes.h>
> +NOKPROBE_SYMBOL(FUNCTION);
> +
> +Protects given FUNCTION from other kprobes. This is useful for handler
> +functions and functions called from the handlers.
> +
>  5. Kprobes Features and Limitations
>  
>  Kprobes allows multiple probes at the same address.  Currently,
> diff --git a/include/linux/module.h b/include/linux/module.h
> index f520a76..2fdb673 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -16,6 +16,7 @@
>  #include <linux/kobject.h>
>  #include <linux/moduleparam.h>
>  #include <linux/jump_label.h>
> +#include <linux/kprobes.h>

This include breaks the x86 build:

  CC      arch/x86/kernel/jump_label.o
  In file included from arch/x86/kernel/jump_label.c:14:0:
  /fast/mingo/tip/arch/x86/include/asm/kprobes.h:35:12: error: conflicting types for ‘kprobe_opcode_t' typedef u8 kprobe_opcode_t;
  [...]

But the #include kprobes.h is unnecessary to begin with, as no kprobe 
specific types are used.

>  #include <linux/export.h>
>  
>  #include <linux/percpu.h>
> @@ -357,6 +358,10 @@ struct module {
>  	unsigned int num_ftrace_callsites;
>  	unsigned long *ftrace_callsites;
>  #endif
> +#ifdef CONFIG_KPROBES
> +	unsigned int num_kprobe_blacklist;
> +	unsigned long  *kprobe_blacklist;
> +#endif

There's a small coding style problem here.

More importantly, I think more should be done to make sure that module 
symbols are marked properly: since the module is going to register the 
kprobes handler, that would be a perfect place to emit a warning, 
right?

In fact, why don't kprobe handlers get added to the exclusion list 
explicitly, when the handler gets registered? With such an approach 
handlers are automatically nokprobe and don't need any annotation - 
which is a far more robust usage model.

So I'm skipping this patch and the next one that makes use of it.

Thanks,

	Ingo
