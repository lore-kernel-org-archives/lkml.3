Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222Ab3EHVFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 17:05:40 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48160 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755820Ab3EHVFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 17:05:38 -0400
Message-ID: <1368047134.8623.5.camel@dabdike>
Subject: Re: [PATCH] parisc: avoid WARNING: at kernel/cpu/idle.c:96
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org, John David Anglin <dave.anglin@bell.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 08 May 2013 14:05:34 -0700
In-Reply-To: <20130508204242.GA16254@p100.box>
References: <20130508204242.GA16254@p100.box>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-08 at 22:42 +0200, Helge Deller wrote:
> We need to enable local irqs to avoid this runtime warning.
> 
> Signed-off-by: Helge Deller <deller@gmx.de>
> 
> diff --git a/arch/parisc/kernel/process.c b/arch/parisc/kernel/process.c
> index 55f92b6..2840d43 100644
> --- a/arch/parisc/kernel/process.c
> +++ b/arch/parisc/kernel/process.c
> @@ -286,3 +286,8 @@ void *dereference_function_descriptor(void *ptr)
>  	return ptr;
>  }
>  #endif
> +
> +void arch_cpu_idle(void)
> +{
> +	local_irq_enable();

This is definitely wrong.  we'd need at least a cpu_relax() in there.
Without that the cpu will bounce around in the idle loop.  I'd advise
that we simply keep the default cpu_idle_poll().

However, this looks like a kernel bug to me in cpu_idle_loop()?  not
something we should be working around in the arch code.

Thomas, what's going on here?  It looks like you can never avoid the
WARN_ON_ONCE if you don't provide any arch specific idle functions.  If
you wish to allow this case then the correct patch (keeping the WARN_ON)
would appear to be this one.

James

----
diff --git a/kernel/cpu/idle.c b/kernel/cpu/idle.c
index 8b86c0c..829e41f 100644
--- a/kernel/cpu/idle.c
+++ b/kernel/cpu/idle.c
@@ -56,6 +56,7 @@ void __weak arch_cpu_idle_dead(void) { }
 void __weak arch_cpu_idle(void)
 {
 	cpu_idle_force_poll = 1;
+	local_irq_enable();
 }
 
 /*


