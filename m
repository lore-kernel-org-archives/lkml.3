Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283Ab3BGEOA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 23:14:00 -0500
Received: from ozlabs.org ([203.10.76.45]:49634 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846Ab3BGENz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 23:13:55 -0500
Date: Thu, 7 Feb 2013 15:13:55 +1100
From: Anton Blanchard <anton@samba.org>
To: eparis@redhat.com, viro@zeniv.linux.org.uk, benh@kernel.crashing.org,
        paulus@samba.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/4] audit: Syscall rules are not applied to existing
 processes on non-x86
Message-ID: <20130207151355.33f0970a@kryten>
In-Reply-To: <20130109104617.74e995a5@kryten>
References: <20130109104617.74e995a5@kryten>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Just following up on this. I've had a few people complaining about
audit being broken on ppc64 and it would be nice to fix.

Anton
--

On Wed, 9 Jan 2013 10:46:17 +1100
Anton Blanchard <anton@samba.org> wrote:

> 
> Commit b05d8447e782 (audit: inline audit_syscall_entry to reduce
> burden on archs) changed audit_syscall_entry to check for a dummy
> context before calling __audit_syscall_entry. Unfortunately the dummy
> context state is maintained in __audit_syscall_entry so once set it
> never gets cleared, even if the audit rules change.
> 
> As a result, if there are no auditing rules when a process starts
> then it will never be subject to any rules added later. x86 doesn't
> see this because it has an assembly fast path that calls directly into
> __audit_syscall_entry.
> 
> I noticed this issue when working on audit performance optimisations.
> I wrote a set of simple test cases available at:
> 
> http://ozlabs.org/~anton/junkcode/audit_tests.tar.gz
> 
> 02_new_rule.py fails without the patch and passes with it. The
> test case clears all rules, starts a process, adds a rule then
> verifies the process produces a syscall audit record.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>
> Cc: <stable@kernel.org> # 3.3+
> ---
> 
> Index: b/include/linux/audit.h
> ===================================================================
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -119,7 +119,7 @@ static inline void audit_syscall_entry(i
>  				       unsigned long a1, unsigned
> long a2, unsigned long a3)
>  {
> -	if (unlikely(!audit_dummy_context()))
> +	if (unlikely(current->audit_context))
>  		__audit_syscall_entry(arch, major, a0, a1, a2, a3);
>  }
>  static inline void audit_syscall_exit(void *pt_regs)

