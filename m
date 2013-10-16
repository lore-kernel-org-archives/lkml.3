Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760251Ab3JPIni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 04:43:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48731 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760029Ab3JPInf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 04:43:35 -0400
Date: Wed, 16 Oct 2013 10:43:22 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 4/6] Use raw_cpu_write for initialization of per cpu
 refcount.
Message-ID: <20131016084322.GR10651@twins.programming.kicks-ass.net>
References: <20131015174722.615394057@linux.com>
 <20131015174746.793436648@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131015174746.793436648@linux.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 12:47:26PM -0500, Christoph Lameter wrote:
> The initialization of a structure is not subject to synchronization.
> The use of __this_cpu would trigger a false positive with the
> additional preemption checks for __this_cpu ops.
> 
> So simply disable the check through the use of raw_cpu ops.
> 
> Trace:
> 
> [    0.668066] __this_cpu_write operation in preemptible [00000000] code: modprobe/286
> [    0.668108] caller is __this_cpu_preempt_check+0x38/0x60
> [    0.668111] CPU: 3 PID: 286 Comm: modprobe Tainted: GF            3.12.0-rc4+ #187
> [    0.668112] Hardware name: FUJITSU CELSIUS W530 Power/D3227-A1, BIOS V4.6.5.4 R1.10.0 for D3227-A1x 09/16/2013
> [    0.668113]  0000000000000003 ffff8807edda1d18 ffffffff816d5a57 ffff8807edda1fd8
> [    0.668117]  ffff8807edda1d48 ffffffff8137359c ffff8807edda1ef8 ffffffffa0002178
> [    0.668121]  ffffc90000067730 ffff8807edda1e48 ffff8807edda1d88 ffffffff813735f8
> [    0.668124] Call Trace:
> [    0.668129]  [<ffffffff816d5a57>] dump_stack+0x4e/0x82
> [    0.668132]  [<ffffffff8137359c>] check_preemption_disabled+0xec/0x110
> [    0.668135]  [<ffffffff813735f8>] __this_cpu_preempt_check+0x38/0x60
> [    0.668139]  [<ffffffff810c24fd>] load_module+0xcfd/0x2650
> [    0.668143]  [<ffffffff816dd922>] ? page_fault+0x22/0x30
> [    0.668146]  [<ffffffff810c3ef6>] SyS_init_module+0xa6/0xd0
> [    0.668150]  [<ffffffff816e4fd3>] tracesys+0xe1/0xe6
> 
> 
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> Index: linux/kernel/module.c
> ===================================================================
> --- linux.orig/kernel/module.c	2013-09-05 13:43:30.557687773 -0500
> +++ linux/kernel/module.c	2013-10-07 12:33:43.732059759 -0500
> @@ -643,7 +643,7 @@ static int module_unload_init(struct mod
>  	INIT_LIST_HEAD(&mod->target_list);
>  
>  	/* Hold reference count during initialization. */
> -	__this_cpu_write(mod->refptr->incs, 1);
> +	raw_cpu_write(mod->refptr->incs, 1);

Just add: Safe to use raw because we're the only user. So we all
instantly know.

>  	/* Backwards compatibility macros put refcount during init. */
>  	mod->waiter = current;
>  
> 
