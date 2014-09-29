Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbaI2S6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 14:58:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:53583 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbaI2S6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 14:58:44 -0400
Date: Mon, 29 Sep 2014 20:59:11 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andy Lutomirski <luto@amacapital.net>
cc: Anish Bhatt <anish@chelsio.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, mingo@redhat.com, hpa@zytor.com, sebastian@fds-team.de
Subject: Re: [PATCH] x86 : Ensure X86_FLAGS_NT is cleared on syscall entry
In-Reply-To: <54299979.6080705@amacapital.net>
Message-ID: <alpine.DEB.2.02.1409292038590.22082@ionos.tec.linutronix.de>
References: <1411674171-24442-1-git-send-email-anish@chelsio.com> <54299979.6080705@amacapital.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-646430505-1412017152=:22082"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-646430505-1412017152=:22082
Content-Type: TEXT/PLAIN; charset=windows-1252
Content-Transfer-Encoding: 8BIT

On Mon, 29 Sep 2014, Andy Lutomirski wrote:
> On 09/25/2014 12:42 PM, Anish Bhatt wrote:
> > The MSR_SYSCALL_MASK, which is responsible for clearing specific EFLAGS on
> >  syscall entry, should also clear the nested task (NT) flag to be safe from
> >  userspace injection. Without this fix the application segmentation
> >  faults on syscall return because of the changed meaning of the IRET
> >  instruction.
> > 
> > Further details can be seen here https://bugs.winehq.org/show_bug.cgi?id=33275
> > 
> > Signed-off-by: Anish Bhatt <anish@chelsio.com>
> > Signed-off-by: Sebastian Lackner <sebastian@fds-team.de>
> > ---
> >  arch/x86/kernel/cpu/common.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> > index e4ab2b4..3126558 100644
> > --- a/arch/x86/kernel/cpu/common.c
> > +++ b/arch/x86/kernel/cpu/common.c
> > @@ -1184,7 +1184,7 @@ void syscall_init(void)
> >  	/* Flags to clear on syscall */
> >  	wrmsrl(MSR_SYSCALL_MASK,
> >  	       X86_EFLAGS_TF|X86_EFLAGS_DF|X86_EFLAGS_IF|
> > -	       X86_EFLAGS_IOPL|X86_EFLAGS_AC);
> > +	       X86_EFLAGS_IOPL|X86_EFLAGS_AC|X86_EFLAGS_NT);
> 
> Something's weird here, and at the very least the changelog is
> insufficiently informative.
> 
> The Intel SDM says:
> 
> If the NT flag is set and the processor is in IA-32e mode, the IRET
> instruction causes a general protection exception.
> 
> Presumably interrupt delivery clears NT.  I haven't spotted where that's
> documented yet. 

Nope, that's unrelated.

See Volume 3, chapter 7.4 "Task linking":

"The previous task link field of the TSS (sometimes called the
 “backlink”) and the NT flag in the EFLAGS register are used to return
 execution to the previous task. EFLAGS.NT = 1 indicates that the
 currently executing task is nested within the execution of another
 task.

 When a CALL instruction, an interrupt, or an exception causes a task
 switch: the processor copies the segment selector for the current TSS
 to the previous task link field of the TSS for the new task; it then
 sets EFLAGS.NT = 1.  If software uses an IRET instruction to suspend
 the new task, the processor checks for EFLAGS.NT = 1; it then uses the
 value in the previous task link field to return to the previous
 task. See Figures 7-8."

Now, Linux does not care about that. Thread management is done purely
in software. So nothing uses and nothing can use the TSS backlink and
NT mode.

In IA-32e mode a IRET seing EFLAGS.NT=1 will cause #GP. In non IA-32e
mode it would simply explode by returning to TSS.back_link, which is
reliably NULL.

So there is nothing to see here other than the stupid user space task
fiddling with the NT flag being killed rightfully.

Thanks,

	tglx






--8323329-646430505-1412017152=:22082--
