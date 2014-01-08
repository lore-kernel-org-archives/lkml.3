Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbaAHEa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 23:30:56 -0500
Received: from mail-qe0-f51.google.com ([209.85.128.51]:45138 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994AbaAHEas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 23:30:48 -0500
MIME-Version: 1.0
In-Reply-To: <CACVXFVMbofkaoHDzSPE2BpEcKwhHni-dj4yugqzbn4a8TSPVdg@mail.gmail.com>
References: <1389090568-29079-1-git-send-email-tom.leiming@gmail.com>
	<20140107142742.9c075b52ad81e60d19bff3d3@linux-foundation.org>
	<CACVXFVMVBbSqLfCwX9Q2EvAH6K4u1Y_nbtcxEixH8-g-4j6oPA@mail.gmail.com>
	<20140107173645.64d6838e.akpm@linux-foundation.org>
	<CACVXFVMbofkaoHDzSPE2BpEcKwhHni-dj4yugqzbn4a8TSPVdg@mail.gmail.com>
Date: Wed, 8 Jan 2014 12:30:47 +0800
Message-ID: <CACVXFVPN1VSP6khBhEgRR7Cdpmh2CQDQ4u9e-YHiS=7w1YE6Fw@mail.gmail.com>
Subject: Re: [PATCH] lib/percpu_counter.c: disable local irq when updating
 percpu couter
From: Ming Lei <tom.leiming@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Shaohua Li <shli@fusionio.com>, Jens Axboe <axboe@kernel.dk>,
        Fan Du <fan.du@windriver.com>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 8, 2014 at 11:29 AM, Ming Lei <tom.leiming@gmail.com> wrote:
> Hi Andrew,
>
> On Wed, Jan 8, 2014 at 9:36 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
>>> I am wondering if the above patch is more efficient, because:
>>>
>>> - raw_local_irq_save()/raw_local_irq_restore() should be cheaper
>>> than preempt_enable() in theory
>>
>> Don't think so - local_irq_disable() requires quite some internal
>> synchronization in the CPU and is expensive.  preempt_disable() is just
>
> Yes, it might be a little expensive on some CPUs, but should be
> arch-dependent(CPU inside things are involved)
>
>> an add+barrier, minus the add if the kernel is non-preemptable.
>
> IMO, generally, from software view, local_irq_save() only save the
> CPU's interrupt mask to the local variable 'flag', and sets irq mask
> to register, considered local variable can be thought to be in cache,
> so I think it might be cheaper than preempt_enable() because
> preempt counter may not be in cache.
>
> Also this_cpu_add() won't work in batch path(slow path), we still
> need to avoid interrupt coming between reading the percpu counter
> and resetting it, otherwise counts might be lost too, :-)

Sorry, I miss the __this_cpu_sub() in slow path, so it is correct, and
even preempt_enable() and preempt_disable() can be removed.


Thanks,
-- 
Ming Lei
