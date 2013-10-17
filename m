Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761394Ab3JQA3L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 20:29:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:39390 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761224Ab3JQA3J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 20:29:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,510,1378882800"; 
   d="scan'208";a="308826315"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Wang, Xiaoming" <xiaoming.wang@intel.com>,
        "Li, Zhuangzhi" <zhuangzhi.li@intel.com>
Subject: RE: [PATCH] x86: Remove WARN_ON(in_nmi()) from vmalloc_fault
Thread-Topic: [PATCH] x86: Remove WARN_ON(in_nmi()) from vmalloc_fault
Thread-Index: AQHOym0me0lm8e7+s06wEnAbpy7yvZn2wdGAgAFIqgA=
Date: Thu, 17 Oct 2013 00:29:04 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01B64F02@SHSMSX101.ccr.corp.intel.com>
References: <20131015163906.342d8ffa@gandalf.local.home>
 <20131016061118.GA21109@gmail.com>
 <20131016084219.53deac7a@gandalf.local.home>
 <20131016125111.GB2611@gmail.com>
In-Reply-To: <20131016125111.GB2611@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Ingo Molnar [mailto:mingo.kernel.org@gmail.com] On Behalf Of Ingo
> Molnar
> Sent: Wednesday, October 16, 2013 8:51 PM
> To: Steven Rostedt
> Cc: LKML; Thomas Gleixner; H. Peter Anvin; Frederic Weisbecker; Andrew
> Morton; paulmck@linux.vnet.ibm.com; Peter Zijlstra; x86@kernel.org; Wang,
> Xiaoming; Li, Zhuangzhi; Liu, Chuansheng
> Subject: Re: [PATCH] x86: Remove WARN_ON(in_nmi()) from vmalloc_fault
> 
> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Wed, 16 Oct 2013 08:11:18 +0200
> > Ingo Molnar <mingo@kernel.org> wrote:
> >
> > >
> > > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > >
> > > > Since the NMI iretq nesting has been fixed, there's no reason that
> > > > an NMI handler can not take a page fault for vmalloc'd code. No locks
> > > > are taken in that code path, and the software now handles nested NMIs
> > > > when the fault re-enables NMIs on iretq.
> > > >
> > > > Not only that, if the vmalloc_fault() WARN_ON_ONCE() is hit, and that
> > > > warn on triggers a vmalloc fault for some reason, then we can go into
> > > > an infinite loop (the WARN_ON_ONCE() does the WARN() before updating
> > > > the variable to make it happen "once").
> > > >
> > > > Reported-by: "Liu, Chuansheng" <chuansheng.liu@intel.com>
> > > > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > >
> > > Would be nice to see the warning quoted that triggered this.
> >
> > Sure, want me to add this to the change log?
> 
> Yeah, that would be helpful - but only the stack trace portion I suspect,
> to make it clear what caused the fault.
> 
> The one posted in the thread shows:
> 
> [   17.148755]  [<c2825b08>] do_page_fault+0x8/0x10
> [   17.153926]  [<c2823066>] error_code+0x5a/0x60
> [   17.158905]  [<c2825b00>] ? __do_page_fault+0x4a0/0x4a0
> [   17.164760]  [<c208d1a9>] ? module_address_lookup+0x29/0xb0
> [   17.170999]  [<c208dddb>] kallsyms_lookup+0x9b/0xb0
> [   17.186804]  [<c208def4>] sprint_symbol+0x14/0x20
> [   17.192063]  [<c208df1e>] __print_symbol+0x1e/0x40
> [   17.197430]  [<c25e00d7>] ? ashmem_shrink+0x77/0xf0
> [   17.202895]  [<c25e13e0>] ? logger_aio_write+0x230/0x230
> [   17.208845]  [<c205bdf5>] ? up+0x25/0x40
> [   17.213242]  [<c2039cb7>] ? console_unlock+0x337/0x440
> [   17.218998]  [<c2818236>] ? printk+0x38/0x3a
> [   17.223782]  [<c20006d0>] __show_regs+0x70/0x190
> [   17.228954]  [<c200353a>] show_regs+0x3a/0x1b0
> [   17.233931]  [<c2818236>] ? printk+0x38/0x3a
> [   17.238717]  [<c2824182>]
> arch_trigger_all_cpu_backtrace_handler+0x62/0x80
> [   17.246413]  [<c2823919>] nmi_handle.isra.0+0x39/0x60
> [   17.252071]  [<c2823a29>] do_nmi+0xe9/0x3f0
> 
> So kallsyms_lookup() faulted, while the NMI watchdog triggered a
> show_regs()? How is that possible?
Not NMI watchdog triggered show_regs(), when we call arch_trigger_all_cpu_backtrace(),
the NMI handler arch_trigger_all_cpu_backtrace_handler() will call show_regs().

> 
> Thanks,
> 
> 	Ingo
