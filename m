Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbaKLN1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 08:27:48 -0500
Received: from rrcs-76-79-27-186.west.biz.rr.com ([76.79.27.186]:13516 "EHLO
	rrcs-76-79-27-186.west.biz.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752337AbaKLN1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 08:27:47 -0500
Date: Wed, 12 Nov 2014 07:27:42 -0600
From: Jeff Epler <jepler@unpythonic.net>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: cmetcalf@tilera.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: tile: kernel: kgdb.c: Use memcpy() instead of
 pointer copy one by one
Message-ID: <20141112132741.GA53560@unpythonic.net>
References: <5454DD70.6060004@gmail.com>
 <5462C1D3.3010504@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5462C1D3.3010504@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems there's additional background required to understand the
diagnostic:

asm/ptrace.h has
    struct pt_regs {
        /* tp, sp, and lr must immediately follow regs[] for aliasing. */
        pt_reg_t regs[53];
        pt_reg_t tp;            /* aliases regs[TREG_TP] */
        pt_reg_t sp;            /* aliases regs[TREG_SP] */
        pt_reg_t lr;            /* aliases regs[TREG_LR] */
and the intended copy overwites all of regs[], plus tp, sp, and lr.

It's intended for thread_regs.regs[TREG_TP] to alias to thread_regs.tp,
though in C this is undefined behavior (it dereferences a pointer past
the end of the structure).
> >   arch/tile/kernel/kgdb.c:140:31: warning: iteration 53u invokes undefined behavior [-Waggressive-loop-optimizations]
> >      *(ptr++) = thread_regs->regs[reg];

If compilers are beginning to exploit the rule that indexing past the
end of an array is UB, then the way that these register aliases are
created may need to be revisited with careful attention to what the C
standard actually says; I'm just going by memory.  (I assume the
compiler could do things like replace an intended load from memory with
a constant load or even no load at all)

Jeff
