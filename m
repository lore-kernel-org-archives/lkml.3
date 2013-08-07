Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343Ab3HGRUx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 13:20:53 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58987 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757261Ab3HGRUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 13:20:46 -0400
Date: Wed, 7 Aug 2013 19:20:44 +0200
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Jason Baron <jbaron@akamai.com>
Subject: Re: [PATCH 4/4] x86/jump-label: Show where and what was wrong on
 errors
Message-ID: <20130807172044.GC18272@pd.tnic>
References: <20130807164934.149920591@goodmis.org>
 <20130807165114.147890467@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130807165114.147890467@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 12:49:38PM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> When modifying text sections for jump labels, a paranoid check is
> performed. If the check fails, the system "bugs". But why it failed
> is not shown.
> 
> The BUG_ON()s in the jump label update code is replaced with bug_at(ip).
> This is a function that will show what pointer failed, and what was
> at the location of the failure that made jump label panic.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  arch/x86/kernel/jump_label.c |   21 ++++++++++++++++++---
>  1 file changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
> index 24cf2b2..912a528 100644
> --- a/arch/x86/kernel/jump_label.c
> +++ b/arch/x86/kernel/jump_label.c
> @@ -24,6 +24,18 @@ union jump_code_union {
>  	} __attribute__((packed));
>  };
>  
> +static void bug_at(unsigned char *ip, int line)
> +{
> +	/*
> +	 * The location is not an op that we were expecting.
> +	 * Something went wrong. Crash the box, as something could be
> +	 * corrupting the kernel.
> +	 */
> +	pr_warning("Unexpected op at %pS [%p] (%02x %02x %02x %02x %02x) %s:%d\n",
> +	       ip, ip, ip[0], ip[1], ip[2], ip[3], ip[4], __FILE__, line);
> +	BUG();

Why not simply

	panic("Unexpected...")

?

Besides, BUG can be disabled in CONFIG_EXPERT.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
