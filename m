Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbaHLJbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 05:31:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbaHLJbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 05:31:39 -0400
Message-ID: <53E9DEDB.1080608@redhat.com>
Date: Tue, 12 Aug 2014 11:31:07 +0200
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Jan Beulich <JBeulich@suse.com>
CC: Andy Lutomirski <luto@amacapital.net>, Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Denys Vlasenko <vda.linux@googlemail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Oleg Nesterov <oleg@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] x86: entry_64.S: always allocate complete "struct
 pt_regs"
References: <1406904498-21647-1-git-send-email-dvlasenk@redhat.com> <1406904498-21647-4-git-send-email-dvlasenk@redhat.com> <20140801231929.GB26491@localhost.localdomain> <CAK1hOcNXdBwd4KZi1V2dLMtRdusvNLPZwTKwYvnpvz3PRnsM+Q@mail.gmail.com> <20140811004559.GA2656@lerouge> <53E89DA3020000780002B00B@mail.emea.novell.com> <53E8C476.8000800@redhat.com> <53E8EC9F020000780002B383@mail.emea.novell.com> <53E8D905.7030809@zytor.com> <53E8F87B020000780002B41D@mail.emea.novell.com> <53E8DD8D.3060500@zytor.com>
In-Reply-To: <53E8DD8D.3060500@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2014 05:13 PM, H. Peter Anvin wrote:
> On 08/11/2014 08:08 AM, Jan Beulich wrote:
>>> No, in *human language*.  What does the DW_CFA_def_cfa_expression
>>> actually aim to accomplish?  If you don't know the innards of the DWARF
>>> spec, the whole thing might as well be Hungarian.
>>
>> Just like the other DW_CFA_def_cfa_* ones it sets the current
>> frame address (CFA), just not via one of the pre-canned shortcuts,
>> but via an expression (in the case here de-referencing the stack
>> pointer to read the top of stack, and then adding the necessary
>> offset). So it indeed is similar enough to other .cfi_* annotations we
>> use without further comments.
>>
> 
> Actually, what you had inside the parenteses there is actually a
> half-decent comment.  I'm going to pretend the rest of this wasn't posted.

Jan, Pater, does this look correct _and_ human-understandable?

--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -652,10 +652,14 @@ END(interrupt)
        cmovzq PER_CPU_VAR(irq_stack_ptr),%rsp
        CFI_DEF_CFA_REGISTER    rsi
        pushq %rsi
+       /*
+        * For debugger:
+        * "CFA (Current Frame Address) is the value on stack + offset"
+        */
        CFI_ESCAPE      0x0f /* DW_CFA_def_cfa_expression */, 6, \
-                       0x77 /* DW_OP_breg7 */, 0, \
+                       0x77 /* DW_OP_breg7 (rsp) */, 0, \
                        0x06 /* DW_OP_deref */, \
-                       0x08 /* DW_OP_const1u */, SS+8-RBP, \
+                       0x08 /* DW_OP_const1u */, SIZEOF_PTREGS-RBP, \
                        0x22 /* DW_OP_plus */
        /* We entered an interrupt context - irqs are off: */
        TRACE_IRQS_OFF

