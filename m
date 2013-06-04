Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab3FDSct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 14:32:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28129 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab3FDScq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 14:32:46 -0400
X-Authority-Analysis: v=2.0 cv=BcJaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=8UkHzMSrflQA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=ITzkURZ2-D4A:10 a=_OJ1_znidk0119Dag-8A:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1370370763.9844.6.camel@gandalf.local.home>
Subject: Re: [PATCH v13 3/3] trace,x86: Add irq vector tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, tglx@linutronix.de, mingo@elte.hu, bp@alien8.de,
        linux-edac@vger.kernel.org, tony.luck@intel.com,
        dle-develop@lists.sourceforge.net, tomoki.sekiyama@hds.com
Date: Tue, 04 Jun 2013 14:32:43 -0400
In-Reply-To: <51AE2EDF.3000505@zytor.com>
References: <51ACEDBB.6040706@hds.com> <51ACEEB4.1010302@hds.com>
	 <1370303581.26799.109.camel@gandalf.local.home>
	 <51AE2EDF.3000505@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-04 at 11:15 -0700, H. Peter Anvin wrote:
> On 06/03/2013 04:53 PM, Steven Rostedt wrote:
> > 
> > This way we wont be opening up any easy root holes where if a process
> > finds a way to modify some arbitrary kernel memory, we can prevent it
> > from modifying the current_idt_descr_ptr and have a nice way to exploit
> > the IDT. Sure, one can argue that if they can modify arbitrary kernel
> > memory, we may already be lost, but lets not make it easier for them
> > than need be.
> > 
> 
> I don't like current_idt_descr_ptr if we can avoid it.  It is a direct
> proxy for reading and writing the original IDT, in other words, it
> really hasn't really addressed the issue.
> 
> What I'm thinking we really should have is a function that returns the
> IDT that we currently should be using, based on the current state.  If
> that state is, say, tracing on/off and NMI on/off, then that can be
> indicated by bits in a state vector.

The NMI on/off may be a bit trickier, as it is also a debug state as
well. When we go into a nested debug or NMI state we use the same IDT.

> 
> The point is that the IDT address itself should not be mutable state if
> it can be at all avoided.

Hmm, maybe we can do it. Have two counters, a debug_idt_ctr and a
trace_idt_ctr, then have a function that basically does this:

	if (this_cpu_read(debug_idt_ctr))
		load_idt(&nmi_idt_descr); /* probably should rename to debug_idt_descr) */
	else if (trace_idt_ctr)
		load_idt(&trace_idt_descr);
	else
		load_idt(&idt_descr);

Then all modifications of the idt would call this function.

-- Steve



