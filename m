Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429Ab3BPAPJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 19:15:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39127 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080Ab3BPAPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 19:15:06 -0500
Message-ID: <511ECF2B.8090202@zytor.com>
Date: Fri, 15 Feb 2013 16:13:31 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Seiji Aguchi <seiji.aguchi@hds.com>
CC: Steven Rostedt <rostedt@goodmis.org>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "Borislav Petkov (bp@alien8.de)" <bp@alien8.de>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>
Subject: Re: [PATCH v9 3/3] trace,x86: code-sharing between non-trace and
 trace irq handlers
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A64C5B@USINDEM103.corp.hds.com>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D414A64C5B@USINDEM103.corp.hds.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2013 02:50 PM, Seiji Aguchi wrote:
> [Issue]
> 
> Currently, irq vector handlers for tracing are just
> copied non-trace handlers by simply inserting tracepoints.
> 
> It is difficult to manage the codes.
> 
> [Solution]
> 
> This patch shares common codes between non-trace and trace handlers
> as follows to make them manageable and readable.
> 
> Non-trace irq handler:
> smp_irq_handler()
> {
> 	entering_irq(); /* pre-processing of this handler */
> 	__smp_irq_handler(); /*
>                           * common logic between non-trace and trace handlers
>                           * in a vector.
>                           */
> 	exiting_irq(); /* post-processing of this handler */
> 
> }
> 
> Trace irq_handler:
> smp_trace_irq_handler()
> {
> 	entering_irq(); /* pre-processing of this handler */
> 	trace_irq_entry(); /* tracepoint for irq entry */
> 	__smp_irq_handler(); /*
>                           * common logic between non-trace and trace handlers
>                           * in a vector.
>                           */
> 	trace_irq_exit(); /* tracepoint for irq exit */
> 	exiting_irq(); /* post-processing of this handler */
> 
> }
> 

How important is it that the tracepoint is *inside* the enter/exit
handling?  If not, it would be simpler to just do:

smp_trace_irq_handler()
{
	trace_irq_entry();
	smp_irq_handler();
	trace_irq_exit();
}

... which seems a bit cleaner.  If this isn't possible, then this patch
is fine, but please add to the patch description why the simple wrapper
isn't doable.

	-hpa


