Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbaG2T2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 15:28:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693AbaG2T2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 15:28:14 -0400
Date: Tue, 29 Jul 2014 21:25:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org,
        Alexei Starovoitov <ast@plumgrid.com>, hpa@zytor.com,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v4 3/5] x86: Split syscall_trace_enter into two phases
Message-ID: <20140729192555.GB6308@redhat.com>
References: <cover.1406604806.git.luto@amacapital.net> <714cf438762d342673b3b131d5c90bc69ca921a9.1406604806.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <714cf438762d342673b3b131d5c90bc69ca921a9.1406604806.git.luto@amacapital.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28, Andy Lutomirski wrote:
>
> +long syscall_trace_enter_phase2(struct pt_regs *regs, u32 arch,
> +				unsigned long phase1_result)
> +{
> +	long ret = 0;
> +	u32 work = ACCESS_ONCE(current_thread_info()->flags) &
> +		_TIF_WORK_SYSCALL_ENTRY;
> +
> +	BUG_ON(regs != task_pt_regs(current));
>  
>  	/*
>  	 * If we stepped into a sysenter/syscall insn, it trapped in
> @@ -1463,17 +1569,20 @@ long syscall_trace_enter(struct pt_regs *regs)
>  	 * do_debug() and we need to set it again to restore the user
>  	 * state.  If we entered on the slow path, TF was already set.
>  	 */
> -	if (test_thread_flag(TIF_SINGLESTEP))
> +	if (work & _TIF_SINGLESTEP)
>  		regs->flags |= X86_EFLAGS_TF;

This is minor, I won't argue, but this can be moved into phase1(), afaics.

Oleg.

