Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbaCEJBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 04:01:20 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:39160 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbaCEJBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 04:01:19 -0500
Date: Wed, 5 Mar 2014 10:01:13 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: tglx@linutronix.de, dvhart@linux.intel.com, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: futex funkiness -- massive lockups
Message-ID: <20140305090113.GE2705@gmail.com>
References: <1393983784.2512.40.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393983784.2512.40.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Davidlohr Bueso <davidlohr@hp.com> wrote:

> Hi,
> 
> A large amount of lockups are seen on a 480 core system doing some sort
> of database-like workload. All except one are soft lockups. This is a
> SLES11 system with most of the recent futex changes backported,
> including commits 63b1a816, b0c29f79, 99b60ce6, a52b89eb, 0d00c7b2,
> 5cdec2d8 and f12d5bfc.
> 
> The following are some traces I put together in chronological order from
> the report I received. While the traces aren't perfect, I believe it
> exemplifies the issue pretty well. There are a lot more, but just of the
> same.
> 
> [212046.044098] Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 22
> [212046.044098] Pid: 312554, comm: XXX Tainted: GF     D W  N  3.0.101-0.15-default #1
> [212046.044098] Call Trace:
> [212046.044098]  [<ffffffff81004935>] dump_trace+0x75/0x310
> [212046.044098]  [<ffffffff8145e0b3>] dump_stack+0x69/0x6f
> [212046.044098]  [<ffffffff8145e14c>] panic+0x93/0x201
> [212046.044098]  [<ffffffff810c65e4>] watchdog_overflow_callback+0xb4/0xc0
> [212046.044098]  [<ffffffff810f2d9a>] __perf_event_overflow+0xaa/0x230
> [212046.044098]  [<ffffffff81018210>] intel_pmu_handle_irq+0x1a0/0x330
> [212046.044098]  [<ffffffff81462ae1>] perf_event_nmi_handler+0x31/0xa0
> [212046.044098]  [<ffffffff81464c37>] notifier_call_chain+0x37/0x70
> [212046.044098]  [<ffffffff81464c7d>] __atomic_notifier_call_chain+0xd/0x20
> [212046.044098]  [<ffffffff81464ccd>] notify_die+0x2d/0x40
> [212046.044098]  [<ffffffff81462127>] default_do_nmi+0x37/0x200
> [212046.044098]  [<ffffffff81462358>] do_nmi+0x68/0x80
> [212046.044098]  [<ffffffff814618ad>] restart_nmi+0x1a/0x1e

Is this end of the traceback, i.e. does the first anomalous lockup 
show that the NMI interrupted user-space mode? If yes then that's 
highly unusual.

The 'GF D W' taint also suggests that there was something going on 
before this triggered: 'W' suggests that something warned before, 'D' 
suggests something died anomalously before and 'F' suggests a forced 
or unsigned module.

So even the earliest traces look like after effects.

Thanks,

	Ingo
