Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759314Ab3JOOTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 10:19:53 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:63378 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759273Ab3JOOTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 10:19:52 -0400
Date: Tue, 15 Oct 2013 10:19:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "Ingo Molnar (mingo@kernel.org)" <mingo@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>,
        "Wang, Xiaoming" <xiaoming.wang@intel.com>,
        "Li, Zhuangzhi" <zhuangzhi.li@intel.com>
Subject: Re: Panic and page fault in loop during handling NMI backtrace
 handler
Message-ID: <20131015101947.6a6433e5@gandalf.local.home>
In-Reply-To: <20131015125409.GB29884@localhost.localdomain>
References: <27240C0AC20F114CBF8149A2696CBE4A01B60835@SHSMSX101.ccr.corp.intel.com>
	<20131015121849.GA29884@localhost.localdomain>
	<20131015123717.GJ10651@twins.programming.kicks-ass.net>
	<20131015125409.GB29884@localhost.localdomain>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Oct 2013 14:54:11 +0200
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Tue, Oct 15, 2013 at 02:37:17PM +0200, Peter Zijlstra wrote:
> > On Tue, Oct 15, 2013 at 02:18:53PM +0200, Frederic Weisbecker wrote:
> > > On Tue, Oct 15, 2013 at 02:01:04AM +0000, Liu, Chuansheng wrote:
> > > > We meet one issue that during trigger all CPU backtrace, but during in the NMI handler arch_trigger_all_cpu_backtrace_handler,
> > > > It hit the PAGE fault, then PAGE fault is in loop, at last the thread stack overflow, and system panic.
> > > > 
> > > > Anyone can give some help? Thanks.
> > > 
> > > Looks like we re-enter the fault several times. On x86-32, NMIs can
> > > fault if they dereference vmalloc'ed area. I wonder if the module thing
> > > we lookup in the NMI is stored on some vmalloc'ed area.
> > 
> > IIRC modules are indeed allocated using vmalloc. See module_alloc()
> > using vmalloc_exec()
> 
> Right. At least the module text. Now I'm not sure the module_address_lookup()
> dereference that. But there many other objects allocated in module.c that use
> alloc_percpu(), which in turn can use vmalloc.
> 
> IIRC Steve made the NMIs safely faultable. So may be we can remove the WARN_ON in
> do_page_fault(). It may not be a good idea to allow fault in NMIs though. Steve?

NMIs should be safe to fault after my patches went in. My main concern
was with x86-64 as the NMI vector uses IST which resets the stack, but
x86-32 keeps using the same stack if we are in ring0 (switches if we
are in ring3 just like any other interrupt).

What's the original panic? I don't see the original post?

-- Steve
