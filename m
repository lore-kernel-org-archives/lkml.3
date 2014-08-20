Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbaHTIMI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 04:12:08 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:43636 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbaHTIME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 04:12:04 -0400
Date: Wed, 20 Aug 2014 10:11:58 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, dave.hansen@linux.intel.com,
        peterz@infradead.org, mingo@redhat.com, ak@linux.intel.com,
        tim.c.chen@linux.intel.com, akpm@linux-foundation.org, cl@linux.com,
        penberg@kernel.org, linux-mm@kvack.org, kirill@shutemov.name,
        lauraa@codeaurora.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] [v2] TAINT_PERFORMANCE
Message-ID: <20140820081158.GA3991@gmail.com>
References: <20140820035751.08C980FB@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140820035751.08C980FB@viggo.jf.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Hansen <dave@sr71.net> wrote:

> 
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> Changes from v1:
>  * remove schedstats
>  * add DEBUG_PAGEALLOC and SLUB_DEBUG_ON
> 
> --
> 
> I have more than once myself been the victim of an accidentally-
> enabled kernel config option being mistaken for a true
> performance problem.
> 
> I'm sure I've also taken profiles or performance measurements
> and assumed they were real-world when really I was measuing the
> performance with an option that nobody turns on in production.

Most of these options already announce themselves in the 
syslog.

> A warning like this late in boot will help remind folks when
> these kinds of things are enabled.
> 
> As for the patch...
> 
> I originally wanted this for CONFIG_DEBUG_VM, but I think it also
> applies to things like lockdep and slab debugging.  See the patch
> for the list of offending config options.  I'm open to adding
> more, but this seemed like a good list to start.

> [    2.534574] CONFIG_LOCKDEP enabled
> [    2.536392] Do not use this kernel for performance measurement.

This is workload dependent: for many kernel workloads this is 
indeed true. For many user-space workloads it will add very 
little overhead.

> [    2.547189] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.16.0-10473-gc8d6637-dirty #800
> [    2.558075] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
> [    2.564483]  0000000080000000 ffff88009c70be78 ffffffff817ce318 0000000000000000
> [    2.582505]  ffffffff81dca5b6 ffff88009c70be88 ffffffff81dca5e2 ffff88009c70bef8
> [    2.588589]  ffffffff81000377 0000000000000000 0007000700000142 ffffffff81b78968
> [    2.592638] Call Trace:
> [    2.593762]  [<ffffffff817ce318>] dump_stack+0x4e/0x68

Generating a stack dump that tells us nothing isn't really 
useful.

>  	{ TAINT_SOFTLOCKUP,		'L', ' ' },
> +	{ TAINT_PERFORMANCE,		'Q', ' ' },

Also this looks like a slight abuse of the taint flag: we taint 
the kernel if there's a problem with it. But even for many 
types of performance measurements, a debug kernel is just fine. 
For other types of performance measurements, even a non-debug 
kernel option can have big impact.

A better option might be to declare known performance killers 
in /proc/config_debug or so, and maybe print them once at the 
end of the bootup, with a 'WARNING:' or 'INFO:' prefix. That 
way tooling (benchmarks, profilers, etc.) can print them, but 
it's also present in the syslog, just in case.

/proc/config_debug is different from /proc/config.gz IKCONFIG, 
because it would always be present when performance impacting 
options are enabled. So tools would only have to check the 
existence of this file, for the simplest test.

In any case I don't think it's a good idea to abuse existing 
facilities just to gain attention: you'll get the extra 
attention, but the abuse dillutes the utility of those only 
tangentially related facilities.

Thanks,

	Ingo
