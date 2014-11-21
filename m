Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758742AbaKURLs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 12:11:48 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:36990 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755353AbaKURLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 12:11:47 -0500
Date: Fri, 21 Nov 2014 12:11:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tejun Heo <tj@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141121121136.18df4ecb@gandalf.local.home>
In-Reply-To: <20141121170151.GC30603@home.goodmis.org>
References: <alpine.DEB.2.11.1411200002330.3909@nanos>
	<20141119235033.GE11386@lerouge>
	<20141120122339.GA14877@htj.dyndns.org>
	<alpine.DEB.2.11.1411202204030.3950@nanos>
	<20141120221122.GA25393@htj.dyndns.org>
	<alpine.DEB.2.11.1411202315230.3950@nanos>
	<20141120230514.GB25393@htj.dyndns.org>
	<alpine.DEB.2.11.1411210109460.6439@nanos>
	<20141121141332.GA8808@lerouge>
	<20141121162506.GA15461@htj.dyndns.org>
	<20141121170151.GC30603@home.goodmis.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2014 12:01:51 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:
 
> Looking at kernel/trace/trace_functions.c: function_trace_call() which is
> registered with RECURSION_SAFE, I see that the recursion check is done
> before the per_cpu_ptr() call to the dynamically allocated per_cpu data.
> 
> It looks OK, but...
> 
> Oh! but if we trace the page fault handler, and we fault here too
> we just nuked the cr2 register. Not good.

Ah! Looking at the code, I see that do_page_fault (called from
assembly) is marked notrace. And the first thing it does is:

	unsigned long address = read_cr2();

And uses that. Thus if the function tracer were to fault on
exception_enter() or __do_page_fautt(), the address wont be
clobbered.

-- Steve
