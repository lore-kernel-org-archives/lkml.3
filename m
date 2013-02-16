Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812Ab3BPBZI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 20:25:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3644 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab3BPBZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 20:25:05 -0500
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=psnlgLDug10A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=PU5ldj0W8K0A:10 a=6DF5gkPlXpPtHeY18fQA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1360977902.23152.119.camel@gandalf.local.home>
Subject: Re: [PATCH v9 3/3] trace,x86: code-sharing between non-trace and
 trace irq handlers
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "Borislav Petkov (bp@alien8.de)" <bp@alien8.de>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Date: Fri, 15 Feb 2013 20:25:02 -0500
In-Reply-To: <511ECF2B.8090202@zytor.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A64C5B@USINDEM103.corp.hds.com>
	 <511ECF2B.8090202@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-15 at 16:13 -0800, H. Peter Anvin wrote:

> How important is it that the tracepoint is *inside* the enter/exit
> handling?  If not, it would be simpler to just do:
> 
> smp_trace_irq_handler()
> {
> 	trace_irq_entry();
> 	smp_irq_handler();
> 	trace_irq_exit();
> }
> 
> ... which seems a bit cleaner.  If this isn't possible, then this patch
> is fine, but please add to the patch description why the simple wrapper
> isn't doable.

The problem is with irq_enter/exit() being called. They must be called
before trace_irq_enter/exit(), because of the rcu_irq_enter() must be
called before any tracepoints are used, as tracepoints use rcu to
synchronize.

Now perhaps we could do this and have trace_irq_entry().

Not only that, the tracepoint callbacks expect irq_enter() to already be
called.

Hmm, if irq_enter() can nest, which I think it can, perhaps we can call
irq_enter() first. I'm not sure if that will screw up the second
irq_entry() inside smp_irq_handler().

smp_trace_irq_hander()
{
	irq_entry();
	trace_irq_entry();
	smp_irq_handler();
	trace_irq_exit();
	irq_exit();
}

-- Steve


