Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab3GAWRh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 18:17:37 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:39896 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756Ab3GAWRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 18:17:36 -0400
MIME-Version: 1.0
X-Originating-IP: [212.159.75.221]
In-Reply-To: <alpine.DEB.2.02.1307012346320.4013@ionos.tec.linutronix.de>
References: <1372694659-30176-1-git-send-email-james.hogan@imgtec.com>
	<1372694659-30176-5-git-send-email-james.hogan@imgtec.com>
	<alpine.DEB.2.02.1307012346320.4013@ionos.tec.linutronix.de>
Date: Mon, 1 Jul 2013 23:17:34 +0100
X-Google-Sender-Auth: DoU8xYuRFUp2gBrPu2nTGk2XGhw
Message-ID: <CAAG0J9_fTNrKe7idPi3=O2kGRWBJmYSwMQuzGPiT2G+rXy4QuA@mail.gmail.com>
Subject: Re: [PATCH 4/5] metag: kick: prevent nested kick handlers
From: James Hogan <james.hogan@imgtec.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 July 2013 22:51, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Mon, 1 Jul 2013, James Hogan wrote:
>
>> The main kick trigger handler iterates a list of kick handlers and calls
>> each one. This is done with the kick_handlers_lock spin lock held, but
>> this causes a problem on SMP where IPIs are implemented with kicks. A
>> reschedule IPI calls scheduler_ipi() which uses irq_enter() and
>> irq_exit(). This results in the scheduler being invoked with
>> kick_handlers_lock held which can result in a nested kick trigger
>> attempting to acquire the lock, resulting in deadlock.
>>
>> irq_enter() and irq_exit() can nest, so call them from the main kick
>> interrupt handler so that softirqs are only handled after
>> kick_handlers_lock is released.
>
> This changelog is confusing. What I decode from the patch is, that you
> are adding a missing irq_enter/exit pair to the kick_handler, right ?

Yes. Previously the outermost pair of irq_enter/exit was inside the
spin lock critical section (inside scheduler_ipi). so soft-irqs
(apparently including the scheduler) would run from irq_exit with the
spinlock still held. Now it waits until the new outermost irq_exit(),
after the spin lock is released.

I should probably have increased the number of lines of diff context.
http://lxr.linux.no/#linux+v3.10/arch/metag/kernel/kick.c#L66

Cheers
James
