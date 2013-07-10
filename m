Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab3GJVrB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 17:47:01 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:60733 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754189Ab3GJVrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 17:47:00 -0400
Message-ID: <1373492818.14604.75.camel@joe-AO722>
Subject: Re: [RFC] [PATCH 1/2 v2] x86: introduce int3-based instruction
 patching
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Borislav Petkov <bpetkov@suse.de>, linux-kernel@vger.kernel.org
Date: Wed, 10 Jul 2013 14:46:58 -0700
In-Reply-To: <alpine.LNX.2.00.1307102328540.25858@pobox.suse.cz>
References: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz>
	 <alpine.LNX.2.00.1307102218200.25858@pobox.suse.cz>
	 <alpine.LNX.2.00.1307102328540.25858@pobox.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-10 at 23:31 +0200, Jiri Kosina wrote:
> Introduce a method for run-time instrucntion patching on a live SMP kernel 
> based on int3 breakpoint, completely avoiding the need for stop_machine().

Yet more trivia:

instruction typo

> The way this is achieved:
> 
>         - add a int3 trap to the address that will be patched
>         - sync cores
>         - update all but the first byte of the patched range
>         - sync cores
>         - replalace the first byte (int3) by the first byte of

replace typo

> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
[]
> +static int int3_notify(struct notifier_block *self, unsigned long val, void *data)
> +{
> +       struct die_args *args = data;
> +       struct pt_regs *regs = args->regs;
> +
> +       /* bp_patching_in_progress */
> +       smp_rmb();
> +
> +       if (likely(!bp_patching_in_progress))
> +               return NOTIFY_DONE;
> +
> +       /* we are not interested in non-int3 faults and ring > 0 faults */
> +       if (val != DIE_INT3 || !regs || user_mode_vm(regs)
> +                           || (unsigned long) bp_int3_addr != regs->ip)
> +               return NOTIFY_DONE;
> +
> +       /* set up the specified breakpoint handler */
> +       args->regs->ip = (unsigned long) bp_int3_handler;

Probably better to use regs->ip as that's what's used
in the test above.

I'd also change the test to order the regs->ip first

	if (val != DIE_INT3 || !regs || user_mode_vm(regs) ||
	    regs->ip != (unsigned long) bp_int3_addr)
		return NOTIFY_DONE;

	regs->ip = (unsigned long) bp_int3_handler;

> +/*
> + * text_poke_bp() -- update instructions on live kernel on SMP
> + * @addr:      address to patch
> + * @opcode:    opcode of new instruction
> + * @len:       length to copy
> + * @handler:   address to jump to when the temporary breakpoint is hit
> + *

kernel-doc?

> +
> + * Modify multi-byte instruction by using int3 breakpoint on SMP.
> + * In contrary to text_poke_smp(), we completely avoid stop_machine() here,
> + * and achieve the synchronization using int3 breakpoint.
> + *
> + * The way it is done:
> + *     - add a int3 trap to the address that will be patched
> + *     - sync cores
> + *     - update all but the first byte of the patched range
> + *     - sync cores
> + *     - replalace the first byte (int3) by the first byte of

same typo

> +       /*
> +        * corresponding read barrier in int3 notifier for
> +        * making sure the in_progress flags is correctly ordered wrt.
> +        * patching */

Some might care about the comment style.
	/*
	 * foo
	 */



