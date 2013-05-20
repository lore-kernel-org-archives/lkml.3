Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268Ab3ETMhu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 08:37:50 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:34571 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331Ab3ETMhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 08:37:48 -0400
Date: Mon, 20 May 2013 14:37:43 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Jens Axboe <jaxboe@fusionio.com>, Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Shaohua Li <shli@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Lost IPIs during CPU Hotplug
Message-ID: <20130520123743.GA4108@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052012-5024-0000-0000-00000618F4E6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just got a dump from a system running a 3.0.something kernel, however I
think the problem exists with current kernels as well.

Testcase was some I/O intense workload together with cpu hotplug stress.

When trying to bring a cpu online we got an endless loop on the cpu that
issued the cpu_up and called smp_call_function_single() within its cpu
hotplug notifier:

(cpu 1)
		generic_exec_single at 19230c
 #0 [7edd77b98] smp_call_function_single at 19261c
 #1 [7edd77c00] iucv_cpu_notify at 4e2896
 #2 [7edd77c50] notifier_call_chain at 4eaf7e
 #3 [7edd77ca8] __raw_notifier_call_chain at 17e342
 #4 [7edd77d00] _cpu_up at 4dfcde
 #5 [7edd77d60] cpu_up at 4dfde2
 #6 [7edd77d88] store_online at 4dde2e
 #7 [7edd77db8] sysfs_write_file at 2e7284
 #8 [7edd77e10] vfs_write at 260434
 #9 [7edd77e70] sys_write at 260608
#10 [7edd77eb8] sysc_noemu at 4e8d80

generic_exec_single() was told to send an IPI to cpu 3. Afterwards it busy
loops waiting for confirmation (wait == 1) which never happens:
[...]
	if (wait)
		csd_lock_wait(csd);
[...]

Looking at the dump cpu 3 actually never received the IPI and the reason
seems to be that generic_exec_single() only sends an IPI to the remote cpu
if its call_single_queue is empty. The dump however shows 108 (!) pending
IPIs, all of them "trigger_softirq" requests, for cpu 3.
Therefore no IPI was sent since the assumption is that some other cpu
already sent one or is about to send one.

It looks to me like the IPI(s) was lost when cpu 3 was brought down before:

When stop_machine_cpu_stop() executes its state machine to offline cpu 3
there could have been the case that when changing to the
STOPMACHINE_DISABLE_IRQ state cpu 3 disabled irqs before cpu 1.
So when cpu 1 still has IRQs enabled it could have received an interrupt
and its bottom halve would send an IPI to cpu 3 which will never see it
before it goes finally offline.
(Besides that there is no run time guarentee when an IPI will be seen by
 the receiving cpu anyway.)

So we end up with cpu 3 offline, but having a pending IPI and a non
empty call_single_queue for cpu 3 which will prevent sending further IPIs
if the cpu comes online again.

So it looks to me like yet another CPU_DYING cpu hotplug notifier is needed
for the generic smp code, which looks for pending IPIs on the to be brought
down cpu and executes them.

Does that make sense?

