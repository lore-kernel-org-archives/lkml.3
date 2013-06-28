Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab3F1OJp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 10:09:45 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33282 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755005Ab3F1OJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 10:09:42 -0400
Date: Fri, 28 Jun 2013 16:09:38 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86: Use asm-goto to implement mutex fast path on x86-64
Message-ID: <20130628140938.GA24819@pd.tnic>
References: <1372416851-56830-1-git-send-email-wedsonaf@gmail.com>
 <20130628111948.GA31065@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130628111948.GA31065@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 01:19:48PM +0200, Ingo Molnar wrote:
> 
> * Wedson Almeida Filho <wedsonaf@gmail.com> wrote:
> 
> > The new implementation allows the compiler to better optimize the code; the
> > original implementation is still used when the kernel is compiled with older
> > versions of gcc that don't support asm-goto.
> > 
> > Compiling with gcc 4.7.3, the original mutex_lock() is 60 bytes with the fast
> > path taking 16 instructions; the new mutex_lock() is 42 bytes, with the fast
> > path taking 12 instructions.
> > 
> > The original mutex_unlock() is 24 bytes with the fast path taking 7
> > instructions; the new mutex_unlock() is 25 bytes (because the compiler used
> > a 2-byte ret) with the fast path taking 4 instructions.
> > 
> > The two versions of the functions are included below for reference.

Btw, do we have any perf data showing any improvements from this patch?

[ … ]

> One detail:
> 
> > +#if defined(CC_HAVE_ASM_GOTO)
> > +#if defined(CC_HAVE_ASM_GOTO)
> 
> Please change these to #ifdef.

Cool - so we have a scripts/gcc-goto.sh which checks for support
for asm goto.

Our testing for asm goto otherwise is a bit more, hmm, hands-on in
arch/x86/include/asm/cpufeature.h:

#if __GNUC__ > 4 || __GNUC_MINOR__ >= 5

Maybe I should change that to the more explicit CC_HAVE_ASM_GOTO then.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
