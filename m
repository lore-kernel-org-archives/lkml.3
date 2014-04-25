Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339AbaDYIUk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 04:20:40 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:48740 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbaDYIT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 04:19:57 -0400
Date: Fri, 25 Apr 2014 10:19:51 +0200
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
Message-ID: <20140425081951.GA24829@gmail.com>
References: <20140417081636.26341.87858.stgit@ltc230.yrl.intra.hitachi.co.jp>
 <20140417081856.26341.53535.stgit@ltc230.yrl.intra.hitachi.co.jp>
 <20140424085601.GA7768@gmail.com>
 <5358F458.1030300@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5358F458.1030300@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> (2014/04/24 17:56), Ingo Molnar wrote:
> >> diff --git a/include/linux/module.h b/include/linux/module.h
> >> index f520a76..2fdb673 100644
> >> --- a/include/linux/module.h
> >> +++ b/include/linux/module.h
> >> @@ -16,6 +16,7 @@
> >>  #include <linux/kobject.h>
> >>  #include <linux/moduleparam.h>
> >>  #include <linux/jump_label.h>
> >> +#include <linux/kprobes.h>
> > 
> > This include breaks the x86 build:
> > 
> >   CC      arch/x86/kernel/jump_label.o
> >   In file included from arch/x86/kernel/jump_label.c:14:0:
> >   /fast/mingo/tip/arch/x86/include/asm/kprobes.h:35:12: error: conflicting types for ‘kprobe_opcode_t' typedef u8 kprobe_opcode_t;
> >   [...]
> 
> Hmm, this error seems very odd... and I don't see

Needs 'make allnoconfig' or some similar .config combination.

> > But the #include kprobes.h is unnecessary to begin with, as no kprobe 
> > specific types are used.
> 
> OK, anyway I'll remove that.
> 
> > 
> >>  #include <linux/export.h>
> >>  
> >>  #include <linux/percpu.h>
> >> @@ -357,6 +358,10 @@ struct module {
> >>  	unsigned int num_ftrace_callsites;
> >>  	unsigned long *ftrace_callsites;
> >>  #endif
> >> +#ifdef CONFIG_KPROBES
> >> +	unsigned int num_kprobe_blacklist;
> >> +	unsigned long  *kprobe_blacklist;
> >> +#endif
> > 
> > There's a small coding style problem here.
> > 
> > More importantly, I think more should be done to make sure that module 
> > symbols are marked properly: since the module is going to register the 
> > kprobes handler, that would be a perfect place to emit a warning, 
> > right?
> > 
> > In fact, why don't kprobe handlers get added to the exclusion list 
> > explicitly, when the handler gets registered? With such an approach 
> > handlers are automatically nokprobe and don't need any annotation - 
> > which is a far more robust usage model.
> 
> Ah, I see. That is because there are some local functions called 
> only from the kprobe handlers. It is easy to blacklist the kprobe 
> handlers itself, but not for the functions which are only called 
> from them. :(
> 
> So, I can add a patch which automatically add handler functions to 
> blacklist. But that is another story. I think this patch is also 
> required.

Fair enough! I'd even argue to not do the auto-blacklisting I 
suggested, to make it really apparent to module authors that 
annotations are needed.

Thanks,

	Ingo
