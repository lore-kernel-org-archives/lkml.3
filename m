Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030357AbaGPOtN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 10:49:13 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:40411 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965069AbaGPOtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 10:49:09 -0400
Date: Wed, 16 Jul 2014 09:49:06 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Pranith Kumar <bobby.prani@gmail.com>
cc: Randy Dunlap <rdunlap@infradead.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] doc: Add remote CPU access details to
 this_cpu_ops.txt
In-Reply-To: <1405481975-23034-1-git-send-email-bobby.prani@gmail.com>
Message-ID: <alpine.DEB.2.11.1407160944280.19597@gentwo.org>
References: <1405481975-23034-1-git-send-email-bobby.prani@gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2014, Pranith Kumar wrote:

> +The following this_cpu() operations with implied preemption protection
> +are defined. These operations can be used without worrying about
> +preemption.  Note that interrupts may still occur while an operation is

preemption and interrupts.

> +in progress and if the interrupt too modifies the variable, then RMW
> +actions may not be atomic.

These are guaranteed to be atomic vs interrupts too. The __this_cpu ops
do not have that guarantee.

>  Operations on a field of a per cpu structure
> @@ -178,10 +207,26 @@ replaced by code that disables interrupts, then does the operations
>  that are guaranteed to be atomic and then reenable interrupts. Doing
>  so is expensive. If there are other reasons why the scheduler cannot
>  change the processor we are executing on then there is no reason to
> -disable interrupts. For that purpose the __this_cpu operations are
> -provided. For example.
> +disable interrupts. For that purpose the following __this_cpu operations
> +are provided.

These operations have no guarantee against concurrent interrupts or
preemption. If a per cpu variable is not used in an interrupt context and
the scheduler cannot preempt then they are safe.

> +Remote access to per-CPU data
> +------------------------------
> +
> +Per cpu data structures are for the use of one cpu exclusively. If you
> +use the variables as intended, this_cpu_ops() are guaranteed to be
> +atomic as no other CPU has access to these data structures. But there are

atomic is a strong term here. Maybe put in ""?

> +special cases where you might need to access per cpu data structures
> +remotely. One such case is to perform maintenance tasks of idle CPUs
> +without having to wake them up using IPIs for power saving purposes.

It is usually safe to do read access and that is frequenly done to
summarize counters. Write access is problematic.

> +To access per-cpu data structure remotely, you need to convert the
> +per-cpu offset to a pointer using this_cpu_ptr().
> +
> +	DEFINE_PER_CPU(struct data, datap);
> +	struct data *p = this_cpu_ptr(&datap);
> +
> +p can now be passed to another CPU to be updated remotely.

That is not the way its usually done. You would use\

p = per_cpu(&datap, cpu);

This makes it explicit that we are getting ready to access a foreing
percpu area.

Passing of pointers calculated via this_cpu_ptr to other cpus is unusual
and should be avoided.


> +Such remote accesses to per CPU data are not guaranteed to be atomic
> +anymore. You will have to use atomic_t and rely on the standard atomic
> +operations for these remote accesses to be atomic.
> +
>  Christoph Lameter, April 3rd, 2013

Add your name here too?

