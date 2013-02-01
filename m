Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab3BACeF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 21:34:05 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15995 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab3BACeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 21:34:04 -0500
X-Authority-Analysis: v=2.0 cv=C91rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=_-1zCJSF_OMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=vw99MyFtH44A:10 a=uOn9NBOg4aT8VhwKWLMA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1359686040.5642.9.camel@gandalf.local.home>
Subject: Re: [RFC][PATCH v8 2/3] trace,x86: add x86 irq vector tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin (hpa@zytor.com)" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "Borislav Petkov (bp@alien8.de)" <bp@alien8.de>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>
Date: Thu, 31 Jan 2013 21:34:00 -0500
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D414A508CE@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A508CE@USINDEM103.corp.hds.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-21 at 22:14 +0000, Seiji Aguchi wrote:

> +void trace_irq_vector_regfunc(void)
> +{
> +	if (!trace_irq_vector_refcount) {
> +		smp_call_function(switch_to_trace_idt, NULL, 0);
> +		local_irq_disable();
> +		switch_to_trace_idt(NULL);
> +		local_irq_enable();
> +	}
> +	trace_irq_vector_refcount++;
> +}
> +
> +void trace_irq_vector_unregfunc(void)
> +{
> +	trace_irq_vector_refcount--;
> +	if (!trace_irq_vector_refcount) {
> +		smp_call_function(restore_original_idt, NULL, 0);
> +		local_irq_disable();
> +		restore_original_idt(NULL);
> +		local_irq_enable();
> +	}
> +}
> +

What protection do these functions have? I mean, the reg functions of a
TRACE_EVENT() can be initiated by perf and ftrace at he same time, as
well as LTTng (if someone adds it). The tracepoint itself may have
protection, but all the tracepoints you created use the same reg
functions, and they are not protected from each other.

You need to add a mutex around these, like:

static DEFINE_MUTEX(irq_reg_mutex);

void trace_irq_vector_regfunc(void)
{
	mutex_lock(&irq_reg_mutex);
	if (!trace_irq_vector_refcount) {
		smp_call_function(switch_to_trace_idt, NULL, 0);
		local_irq_disable();
		switch_to_trace_idt(NULL);
		local_irq_enable();
	}
	trace_irq_vector_refcount++;
	mutex_unlock(&irq_reg_mutex);
}

and the same for the trace_irq_vector_unregfunc().

-- Steve


