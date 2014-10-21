Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbaJUFlo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 01:41:44 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34702 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbaJUFlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 01:41:42 -0400
Date: Tue, 21 Oct 2014 07:41:18 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Erik Bosman <ebn310@few.vu.nl>
Subject: Re: [RFC 3/5] x86: Add a comment clarifying LDT context switching
Message-ID: <20141021054118.GA4420@pd.tnic>
References: <cover.1413323611.git.luto@amacapital.net>
 <93ffc13d9e829f3ded9776fec62385bccb7439e1.1413323612.git.luto@amacapital.net>
 <20141016154914.GD30314@nazgul.tnic>
 <CALCETrVmS+ZNj+iXNTy5zC8araMH=x=jUBNDMUNPDJwu0huMMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrVmS+ZNj+iXNTy5zC8araMH=x=jUBNDMUNPDJwu0huMMQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 09:21:42AM -0700, Andy Lutomirski wrote:
> I think it's the same as in the other case in switch_mm. leave_mm does
> cpumask_clear_cpu(cpu, mm_cpumask(active_mm)), and, once that has
> happened, modify_ldt won't send an IPI to this CPU. So, if leave_mm
> runs, and then another CPU calls modify_ldt on the mm that is in lazy
> mode here, it won't update our LDT register, so the LDT register and
> prev->context.ldt might not match.

Ok, let me see if I can follow with an example:

We call leave_mm() on, say, cpu 3 and mm_cpumask(active_mm) has cpu 3 and
4 set. Then, on cpu 4 we call modify_ldt on that same mm and there in
alloc_ldt() we have this:

                if (!cpumask_equal(mm_cpumask(current->mm),
                                   cpumask_of(smp_processor_id())))
                        smp_call_function(flush_ldt, current->mm, 1);

and since we've cleared cpu 3 from the cpumask, we don't flush_ldt()
on it and there you have the difference.

Am I close?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
