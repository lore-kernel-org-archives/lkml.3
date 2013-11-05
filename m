Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab3KEHFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 02:05:42 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:54560 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab3KEHFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 02:05:40 -0500
Date: Tue, 5 Nov 2013 08:05:37 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH -tip v2 3/3] [BUGFIX] kprobes: Prohibit probing on
 func_ptr_is_kernel_text
Message-ID: <20131105070537.GA2007@gmail.com>
References: <20131101112530.14657.87835.stgit@kbuild-fedora.novalocal>
 <20131101112537.14657.88496.stgit@kbuild-fedora.novalocal>
 <20131104210053.76c37210@gandalf.local.home>
 <20131105060901.GA29936@gmail.com>
 <5278973A.1010705@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5278973A.1010705@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> (2013/11/05 15:09), Ingo Molnar wrote:
> > 
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> >> On Fri, 01 Nov 2013 11:25:37 +0000
> >> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> >>
> >>> Prohibit probing on func_ptr_is_kernel_text().
> >>> Since the func_ptr_is_kernel_text() is called from
> >>> notifier_call_chain() which is called from int3 handler,
> >>> probing it may cause double int3 fault and kernel will
> >>> reboot.
> >>>
> >>> This happenes when the kernel built with CONFIG_DEBUG_NOTIFIERS=y.
> >>>
> >>> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> >>> Cc: Andrew Morton <akpm@linux-foundation.org>
> >>> Cc: "Uwe Kleine-König" <u.kleine-koenig@pengutronix.de>
> >>> Cc: Borislav Petkov <bp@suse.de>
> >>> Cc: Ingo Molnar <mingo@kernel.org>
> >>> ---
> >>>  kernel/extable.c |    2 +-
> >>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>>
> >>> diff --git a/kernel/extable.c b/kernel/extable.c
> >>> index 832cb28..022fb25 100644
> >>> --- a/kernel/extable.c
> >>> +++ b/kernel/extable.c
> >>> @@ -129,7 +129,7 @@ int kernel_text_address(unsigned long addr)
> >>>   * pointer is part of the kernel text, we need to do some
> >>>   * special dereferencing first.
> >>>   */
> >>> -int func_ptr_is_kernel_text(void *ptr)
> >>> +int nokprobe func_ptr_is_kernel_text(void *ptr)
> >>>  {
> >>>  	unsigned long addr;
> >>>  	addr = (unsigned long) dereference_function_descriptor(ptr);
> >>>
> >>
> >> One thing I worry about the "nokprobe" annotation, is that it moves the 
> >> location of the function out of local. This function no exists in the 
> >> section with its users. Same with the debug functions in the other 
> >> patch.
> > 
> > Well, it's a bit like noinline, that changes the position of the function 
> > as well. So it's not true that 'noxyz' attributes don't affect function 
> > placement - they often don't, but some do.
> > 
> > The more important aspect is that 'noprobe' makes it really, really 
> > apparent what the tag is about, at first sight.
> > 
> > _How_ the 'non probing' is achived is an implementational detail when 
> > kprobes are enabled: right now it puts a function into a separate section, 
> > but we could just a much build a list of function names and check against 
> > it at probe insertion time.
> 
> Actually, kprobes already has it -- kprobes_blacklist. Currently the 
> list is manually maintained in kprobes.c separated from the function 
> definition. [...]

Yes, I meant a list that is built automatically from the 'noprobe' 
annotations.

> [...] I hope to build the list when the kernel build time if possible... 
> Would you have any idea to classify some annotated(but no side-effect) 
> functions?

The macro magic I can think of would need to change the syntax of the 
function definition - for example that is how the SYSCALL_DEFINE*() macros 
work.

It would be nice if there was a GCC extension that marked a function 
noinline and allowed the emitting of the function's address (and size) 
into a special section - but I'm not aware of any such compiler feature 
today.

Thanks,

	Ingo
