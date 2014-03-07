Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbaCGWzE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 17:55:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbaCGWzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 17:55:01 -0500
Date: Fri, 7 Mar 2014 17:54:58 -0500
From: Don Zickus <dzickus@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org, vgoyal@redhat.com,
        ebiederm@xmission.com
Subject: Re: [PATCH] x86: Skip latched NMIs on early boot in kdump
Message-ID: <20140307225458.GZ25953@redhat.com>
References: <1394221143-29713-1-git-send-email-dzickus@redhat.com>
 <531A36F7.6020101@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <531A36F7.6020101@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 01:15:35PM -0800, H. Peter Anvin wrote:
> On 03/07/2014 11:39 AM, Don Zickus wrote:
> > A customer generated an external NMI using their iLO to test kdump worked.
> > Unfortunately, the machine hung.  Disabling the nmi_watchdog made things work.
> > 
> > I speculated the external NMI fired, caused the machine to panic (as expected)
> > and the perf NMI from the watchdog came in and was latched.  My guess was this
> > somehow caused the hang.
> > 
> 
> ... as any other unexpected exception would.
> 
> > 
> > I also do not fully understand why the latched NMI is not happening immediately
> > after the load idt call or why it comes after a page fault (the
> > early_make_pgtable).  Further adding to my confusion is why the early printk
> > magic didn't dump a stack as I believe I had that setup on my commandline.
> > But I figured I would just report what I have observed.
> > 
> 
> If the kdump is initiated from NMI context, I'm wondering if it might be
> possible that we haven't actually executed an IRET until this one
> happens, and the IRET re-enables NMI.

Ah makes sense then.

> 
> > My testing and debugging were based off a 3.10 kernel (RHEL-7) but has included
> > Seiji's tracepoint cleanups to arch/x86/kernel/head_64.S|head64.c.  Not much
> > has changed upstream here.  Also 3.14-rc4 still has the same hang.
> > 
> > Signed-off-by: Don Zickus <dzickus@redhat.com>
> 
> We really shouldn't be doing the fixup lookup for NMI, either.  Probably
> it makes more sense to just IRET on NMI until we have the real interrupt
> vectors set up, but it needs to be done a little earlier.
> 
> How does this patch work for you?

I tested it on 64 bit and it works good.  Thanks!

Cheers,
Don

> 
> 	-hpa
> 

> diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
> index 81ba276..d2a2159 100644
> --- a/arch/x86/kernel/head_32.S
> +++ b/arch/x86/kernel/head_32.S
> @@ -544,6 +544,10 @@ ENDPROC(early_idt_handlers)
>  	/* This is global to keep gas from relaxing the jumps */
>  ENTRY(early_idt_handler)
>  	cld
> +
> +	cmpl $X86_TRAP_NMI,(%esp)
> +	je is_nmi		# Ignore NMI
> +
>  	cmpl $2,%ss:early_recursion_flag
>  	je hlt_loop
>  	incl %ss:early_recursion_flag
> @@ -594,8 +598,9 @@ ex_entry:
>  	pop %edx
>  	pop %ecx
>  	pop %eax
> -	addl $8,%esp		/* drop vector number and error code */
>  	decl %ss:early_recursion_flag
> +is_nmi:
> +	addl $8,%esp		/* drop vector number and error code */
>  	iret
>  ENDPROC(early_idt_handler)
>  
> diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
> index e1aabdb..33f36c7 100644
> --- a/arch/x86/kernel/head_64.S
> +++ b/arch/x86/kernel/head_64.S
> @@ -343,6 +343,9 @@ early_idt_handlers:
>  ENTRY(early_idt_handler)
>  	cld
>  
> +	cmpl $X86_TRAP_NMI,(%rsp)
> +	je is_nmi		# Ignore NMI
> +
>  	cmpl $2,early_recursion_flag(%rip)
>  	jz  1f
>  	incl early_recursion_flag(%rip)
> @@ -405,8 +408,9 @@ ENTRY(early_idt_handler)
>  	popq %rdx
>  	popq %rcx
>  	popq %rax
> -	addq $16,%rsp		# drop vector number and error code
>  	decl early_recursion_flag(%rip)
> +is_nmi:
> +	addq $16,%rsp		# drop vector number and error code
>  	INTERRUPT_RETURN
>  ENDPROC(early_idt_handler)
>  

