Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbaCXOUd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 10:20:33 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:34147 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753215AbaCXOUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 10:20:32 -0400
Date: Mon, 24 Mar 2014 10:20:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH RT] drop migrate_disabled section in _cpu_down
Message-ID: <20140324102029.48350386@gandalf.local.home>
In-Reply-To: <20140324122025.GB18300@opentech.at>
References: <20140324122025.GB18300@opentech.at>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Mar 2014 13:20:25 +0100
Nicholas Mc Guire <der.herr@hofr.at> wrote:

> HI !
> 
> 
> Minor cleanup: drop unnecessary migrate_disable in _cpu_down
> 
> in kernel/cpu.c:_cpu_down
>     ...
>     cpumask_andnot(cpumask, cpu_online_mask, cpumask_of(cpu));
>     set_cpus_allowed_ptr(current, cpumask);
>     ...
>     migrate_disable();
>     mycpu = smp_processor_id();
>     if (mycpu == cpu) {
>             printk(KERN_ERR "Yuck! Still on unplug CPU\n!");
>             migrate_enable();
>             err = -EBUSY;
>             goto restore_cpus;
>     }
>     migrate_enable();
> 
> If we got migrated off "cpu" then we can not get migrate
> back as the cpus_allowed was updated. so if smp_processor_id(); returns
> anything != cpu we are fine even if migrated off to a third cpu between
> the mycpu = smp_processor_id() and the if (mycpu == cpu). No need for
> migration protection here.
> 
> Further the migrate disable is effectively only needed for the condition
> check in the if statement - so I think it could be replaced by:
> 
>     if (cpu==smp_processor_id()) {
>             pr_err("Yuck! Still on unplug CPU\n!");
>             err = -EBUSY;
>             goto restore_cpus;
>     }
> 
> even in the case that the cpus_allowed had not been updated.
> 
> Patch is against 3.12.13-rt21

This is checking for an anomaly, and it's in a very slow path. I feel
more comfortable with keeping the code as is, than to change it for a
micro optimization.

-- Steve


> 
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
