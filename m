Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbaKYBeH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 20:34:07 -0500
Received: from mail-qg0-f44.google.com ([209.85.192.44]:39899 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaKYBeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 20:34:05 -0500
MIME-Version: 1.0
In-Reply-To: <20141125004221.803122027@goodmis.org>
References: <20141125004221.803122027@goodmis.org>
Date: Mon, 24 Nov 2014 17:34:04 -0800
X-Google-Sender-Auth: lSEaPsYZRpalmBpms3hxKp85zrg
Message-ID: <CA+55aFxUTUbdxpjVMW8X9c=o8sui7OB_MYPfcbJuDyfUWtNrNg@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/7] ftrace/x86: Clean up of mcount.S code
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 4:42 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Let me know if these changes have mcount.S give you less heebie-jeebies.

So I haven't looked at the individual patches, I just looked at the
rolled-up final patch in this email.

And yes, from that final patch, I certainly like this much more. At
least it now creates the frame in the obvious place, and the comments
explain the layout.

However, explain this (in the ftrace_caller_setup macro):

 #ifdef CC_USING_FENTRY
-       movq SS+16(%rsp), %rsi
+       movq MCOUNT_REG_SIZE+8+\added(%rsp), %rsi
 #else
-       movq 8(%rbp), %rsi
+       /* Need to grab the original %rbp */
+       movq RBP(%rsp), %rsi
+       /* Now parent address is 8 above original %rbp */
+       movq 8(%rsi), %rsi
 #endif

Why isn't that "follow rbp" approach now *always* the right thing to
do, regardless of fentry-vs-not? And in particular, couldn't you have
made '%rsi' already contain that old rbp address in save_mcount_regs,
the same way %rdi contains the RIP value?

(Yes, you can only do that after you've saved the old %rsi, but that's
easy enough to do by just delaying the second

    mov %rsp,%rbp

until after the save area, and replacing it with

    mov %rbp,%rsi
    lea MCOUNT_REG_SIZE - MCOUNT_FRAME_SIZE(%rsp),%rbp

after the saving of the frame. And now you have that RBP(%rsp) in %rsi
already, so regardless of whether you have CC_USING_FENTRY or not, the
above code becomes just

    /* Now parent address is 8 above original %rbp */
    movq 8(%rsi), %rsi

No?

Ok, so I didn't write it all out, and maybe I made some mistake while
writing this email. but it *looks* like your ftrace_caller_setup macro
is just unnecessarily complicated, and again, it's because you have
two different macros and they aren't taking advantage of each other
very well.

Hmm?

                 Linus
