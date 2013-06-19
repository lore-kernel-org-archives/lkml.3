Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935218Ab3FSU4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 16:56:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25845 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934971Ab3FSU4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 16:56:33 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=aw0pCclbxz8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=ITzkURZ2-D4A:10 a=mGD6Kg4gOt5RiIQ29Q0A:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371675390.18733.70.camel@gandalf.local.home>
Subject: Re: [PATCH v16 4/4] trace,x86: Add irq vector tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
        mingo@elte.hu, bp@alien8.de, linux-edac@vger.kernel.org,
        tony.luck@intel.com, tomoki.sekiyama@hds.com,
        dle-develop@lists.sourceforge.net
Date: Wed, 19 Jun 2013 16:56:30 -0400
In-Reply-To: <51C0AE77.3030907@hds.com>
References: <51C0ADA6.8040801@hds.com> <51C0AE77.3030907@hds.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function tracer self test would crash hard after applying this
patch. I found the bug:



On Tue, 2013-06-18 at 15:01 -0400, Seiji Aguchi wrote:
>  /*
>   * the load_current_idt() is called with interrupt disabled by
> local_irq_save()
>   * to avoid races. That way the IDT will always be set back to the
> expected
> @@ -442,6 +508,8 @@ static inline void load_current_idt(void)
>         local_irq_save(flags);
>         if (is_debug_idt_enabled())
>                 load_debug_idt();
> +       if (is_trace_idt_enabled())
> +               load_trace_idt();

This should be:

	else if (is_trace_idt_enabled())

Otherwise, you just totally negated the previous if.

-- Steve

>         else
>                 load_idt((const struct desc_ptr *)&idt_descr);
>         local_irq_restore(flags); 

