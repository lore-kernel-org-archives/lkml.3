Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935Ab3HHPqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 11:46:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757906Ab3HHPqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 11:46:50 -0400
Date: Thu, 8 Aug 2013 17:41:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Grazvydas Ignotas <notasas@gmail.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Denys Vlasenko <dvlasenk@redhat.com>
Subject: Re: [PATCH 0/1] (Was: Linux 3.11-rc4)
Message-ID: <20130808154107.GA28971@redhat.com>
References: <CA+55aFwTX47vLvZckozZub0rUEo-aCBe7weqe=4mfQGfrW7NUA@mail.gmail.com> <CAMP44s2bOniz4qx5y9h4ppHRUjiPVGL+igSwO5NUJd4zpObxFw@mail.gmail.com> <20130806154314.GA398@redhat.com> <CANOLnOMPhOH5uUBqWwV-YNSeA_YHxL_dDa0ftL4jcWRgGwkfiQ@mail.gmail.com> <CA+55aFxt1iqJXW=bsETugWVxj9LwZXkq0FT836YMJVsRP9juEQ@mail.gmail.com> <20130807192734.GA8395@redhat.com> <CA+55aFw7P7LYNFQzy6nrn9DDn5a0UdYYQNx_7sibShvZPLEcmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw7P7LYNFQzy6nrn9DDn5a0UdYYQNx_7sibShvZPLEcmg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07, Linus Torvalds wrote:
>
> Now, I do agree that the debug registers are *much* less likely to
> have those kinds of really subtle issues, so maybe relaxing some of
> the tests might be reasonable. I'd be a bit nervous about it, but if
> it's *only* the length/alignment, and Intel people can be convinced
> that it doesn't result in any nasty undefined behavior (as long as the
> address is in user space), maybe we could make that change just to
> make it easier for Wine.

Oh, I do not know. And again, this way a user can't notice the problem
if the arguments are wrong.

But personally I think it would be nice to cleanup the perf interface,
although probably it is too later.

On x86 execute breakpoints are only a single byte, which has to be
the first byte of the instruction. IOW the hardware requires len = 1
in dr7 or it doesn't work (iirc).

But for some reason perf requires bp_len = sizeof(long), not 1. And
note that it sets info->len = X86_BREAKPOINT_LEN_X. The comment says:

	x86 inst breakpoints need to have a specific undefined len

but despite its "special" name LEN_X is simply LEN_1, and other code
relies on this fact.

Now, ptrace correctly requires DR_LEN_1. So arch_bp_generic_fields()
translates this into "gen_len = sizeof(long)" for validation.

arch_build_bp_info() thinks that X86_BREAKPOINT_EXECUTE should have
->bp_len == sizeof(long), so we translate it back into LEN_1 internally.

This looks confusing, imho. And imho X86_BREAKPOINT_LEN_X should die.

> But the kernel address checking definitely needs to stay around for
> security reasons.

Sure. And btw it doesn't look right. I sent the patch below twice (iirc),
perhaps I should resend it again.

Oleg.


Date: Fri, 9 Nov 2012 19:29:43 +0100
Subject: [PATCH] arch_check_bp_in_kernelspace: fix the range check

arch_check_bp_in_kernelspace() tries to avoid the overflow and does 2
TASK_SIZE checks but it needs OR, not AND. Consider va = TASK_SIZE -1
and len = 2 case.

Note: TASK_SIZE doesn't look right at least on x86, I think it should
be replaced by TASK_SIZE_MAX.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- x/arch/arm64/kernel/hw_breakpoint.c
+++ x/arch/arm64/kernel/hw_breakpoint.c
@@ -293,7 +293,7 @@ int arch_check_bp_in_kernelspace(struct 
 	va = info->address;
 	len = get_hbp_len(info->ctrl.len);
 
-	return (va >= TASK_SIZE) && ((va + len - 1) >= TASK_SIZE);
+	return (va >= TASK_SIZE) || ((va + len - 1) >= TASK_SIZE);
 }
 
 /*
--- x/arch/arm/kernel/hw_breakpoint.c
+++ x/arch/arm/kernel/hw_breakpoint.c
@@ -464,7 +464,7 @@ int arch_check_bp_in_kernelspace(struct 
 	va = info->address;
 	len = get_hbp_len(info->ctrl.len);
 
-	return (va >= TASK_SIZE) && ((va + len - 1) >= TASK_SIZE);
+	return (va >= TASK_SIZE) || ((va + len - 1) >= TASK_SIZE);
 }
 
 /*
--- x/arch/sh/kernel/hw_breakpoint.c
+++ x/arch/sh/kernel/hw_breakpoint.c
@@ -132,7 +132,7 @@ int arch_check_bp_in_kernelspace(struct 
 	va = info->address;
 	len = get_hbp_len(info->len);
 
-	return (va >= TASK_SIZE) && ((va + len - 1) >= TASK_SIZE);
+	return (va >= TASK_SIZE) || ((va + len - 1) >= TASK_SIZE);
 }
 
 int arch_bp_generic_fields(int sh_len, int sh_type,
--- x/arch/x86/kernel/hw_breakpoint.c
+++ x/arch/x86/kernel/hw_breakpoint.c
@@ -200,7 +200,7 @@ int arch_check_bp_in_kernelspace(struct 
 	va = info->address;
 	len = get_hbp_len(info->len);
 
-	return (va >= TASK_SIZE) && ((va + len - 1) >= TASK_SIZE);
+	return (va >= TASK_SIZE) || ((va + len - 1) >= TASK_SIZE);
 }
 
 int arch_bp_generic_fields(int x86_len, int x86_type,


