Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341Ab3APBgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 20:36:41 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17729 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757184Ab3APBgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 20:36:39 -0500
X-Authority-Analysis: v=2.0 cv=UsXhxpMB c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=2tMXkHrMfAEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ABkKjlAME6MA:10 a=87OZ7pP8U5-F9HxkCYUA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1358300198.4068.41.camel@gandalf.local.home>
Subject: Re: [RFC][PATCH v7 2/2]trace,x86: code-sharing between non-trace
 and trace irq handlers
From: Steven Rostedt <rostedt@goodmis.org>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin (hpa@zytor.com)" <hpa@zytor.com>,
        "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "Borislav Petkov (bp@alien8.de)" <bp@alien8.de>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>
Date: Tue, 15 Jan 2013 20:36:38 -0500
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D414A3D296@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A3D296@USINDEM103.corp.hds.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-10 at 17:33 +0000, Seiji Aguchi wrote:
> diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
> index 624ef3f..580aa93 100644
> --- a/include/linux/hardirq.h
> +++ b/include/linux/hardirq.h
> @@ -6,6 +6,7 @@
>  #include <linux/ftrace_irq.h>
>  #include <linux/vtime.h>
>  #include <asm/hardirq.h>
> +#include <asm/idle.h>
>  
>  /*
>   * We put the hardirq and softirq counter into the preemption
> @@ -198,4 +199,28 @@ extern void irq_exit(void);
>  		ftrace_nmi_exit();				\
>  	} while (0)
>  
> +static inline void entering_irq(void)
> +{
> +	irq_enter();
> +	exit_idle();
> +}
> +
> +static inline void entering_ack_irq(void)
> +{
> +	ack_APIC_irq();
> +	entering_irq();
> +}
> +
> +static inline void exiting_irq(void)
> +{
> +	irq_exit();
> +}
> +
> +static inline void exiting_ack_irq(void)
> +{
> +        irq_exit();
> +	/* Ack only at the end to avoid potential reentry */
> +        ack_APIC_irq();
> +}

Shouldn't these be in a x86 specific header? Not a generic header like
hardirq.h. I don't think other archs will be doing an ack_APIC_irq(), as
it's only defined in x86. Why not add these to
arch/x86/include/asm/apic.h ?

-- Steve

> +
>  #endif /* LINUX_HARDIRQ_H */
> -- 1.7.1


