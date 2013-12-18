Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab3LRJ7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 04:59:25 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:53558 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab3LRJ7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 04:59:21 -0500
Date: Wed, 18 Dec 2013 10:59:05 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Russell King <linux@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>, Paul Mundt <lethal@linux-sh.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Hogan <james.hogan@imgtec.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Shawn Guo <shawn.guo@linaro.org>, x86@kernel.org,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mips@linux-mips.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH v3 2/2] provide -fstack-protector-strong build option
Message-ID: <20131218095905.GB19319@gmail.com>
References: <1387320194-24185-1-git-send-email-keescook@chromium.org>
 <1387320194-24185-3-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387320194-24185-3-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kees Cook <keescook@chromium.org> wrote:

> This changes the stack protector config option into a choice of "None",
> "Regular", and "Strong". For "Strong", the kernel is built with
> -fstack-protector-strong (gcc 4.9 and later). This options increases
> the coverage of the stack protector without the heavy performance hit
> of -fstack-protector-all.
> 
> For reference, the stack protector options available in gcc are:
> 
> -fstack-protector-all:
> Adds the stack-canary saving prefix and stack-canary checking suffix to
> _all_ function entry and exit. Results in substantial use of stack space
> for saving the canary for deep stack users (e.g. historically xfs), and
> measurable (though shockingly still low) performance hit due to all the
> saving/checking. Really not suitable for sane systems, and was entirely
> removed as an option from the kernel many years ago.
> 
> -fstack-protector:
> Adds the canary save/check to functions that define an 8
> (--param=ssp-buffer-size=N, N=8 by default) or more byte local char
> array. Traditionally, stack overflows happened with string-based
> manipulations, so this was a way to find those functions. Very few
> total functions actually get the canary; no measurable performance or
> size overhead.
> 
> -fstack-protector-strong
> Adds the canary for a wider set of functions, since it's not just those
> with strings that have ultimately been vulnerable to stack-busting. With
> this superset, more functions end up with a canary, but it still
> remains small compared to all functions with no measurable change in
> performance. Based on the original design document, a function gets the
> canary when it contains any of:
> - local variable's address used as part of the RHS of an assignment or
>   function argument
> - local variable is an array (or union containing an array), regardless
>   of array type or length
> - uses register local variables
> https://docs.google.com/a/google.com/document/d/1xXBH6rRZue4f296vGt9YQcuLVQHeE516stHwt8M9xyU
> 
> Comparison of "size" output when built with gcc-4.9 in three configurations:
> - defconfig
> - defconfig + CONFIG_CC_STACKPROTECTOR (+0.33%)
> - defconfig + CONFIG_CC_STACKPROTECTOR_STRONG via this patch (+2.24%)
> 
> text      data     bss      dec       hex     filename
> 11430641  1457584  1191936  14080161  d6d8a1  vmlinux
> 11468490  1457584  1191936  14118010  d76c7a  vmlinux.stackprotector
> 11692790  1457584  1191936  14342310  dad8a6  vmlinux.stackprotector-strong

Beyond the kernel size calculation, could you please also provide an 
estimation about the _number_ of functions affected, out of N kernel 
functions, so that the user has a rough picture about the scope and 
distribution of these variants?

I.e. something like:

                                                 # of canary checks
 ..................................................................................
 - defconfig                                     0 functions out of 100k functions
 - defconfig + STACKPROTECTOR                   1k functions out of 100k functions  
 - defconfig + STACKPROTECTOR_STRONG           20k functions out of 100k functions
	
Thanks,

	Ingo
