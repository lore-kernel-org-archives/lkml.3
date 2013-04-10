Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937317Ab3DJKve (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 06:51:34 -0400
Received: from www.linutronix.de ([62.245.132.108]:57123 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936553Ab3DJKvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 06:51:33 -0400
Date: Wed, 10 Apr 2013 12:51:15 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Hansen <dave@sr71.net>
cc: Borislav Petkov <bp@alien8.de>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        dhillf@gmail.com, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] kthread: Prevent unpark race which puts threads on the
 wrong cpu
In-Reply-To: <alpine.LFD.2.02.1304101024010.21884@ionos>
Message-ID: <alpine.LFD.2.02.1304101250320.21884@ionos>
References: <515F457E.5050505@sr71.net> <515FCAC6.8090806@linux.vnet.ibm.com> <alpine.LFD.2.02.1304061019000.21884@ionos> <alpine.LFD.2.02.1304071119100.21884@ionos> <20130407095025.GA31307@pd.tnic> <alpine.LFD.2.02.1304081122040.21884@ionos>
 <20130408115553.GA4395@pd.tnic> <alpine.LFD.2.02.1304081415570.21884@ionos> <alpine.LFD.2.02.1304091635430.21884@ionos> <516439DF.3050901@sr71.net> <alpine.LFD.2.02.1304092036431.21884@ionos> <alpine.LFD.2.02.1304092126150.21884@ionos> <51647C30.3050109@sr71.net>
 <alpine.LFD.2.02.1304101024010.21884@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Apr 2013, Thomas Gleixner wrote:
> On Tue, 9 Apr 2013, Dave Hansen wrote:
> 
> > On 04/09/2013 12:30 PM, Thomas Gleixner wrote:
> > > On Tue, 9 Apr 2013, Thomas Gleixner wrote:
> > > Thought more about it and found, that the stupid binding only works
> > > when the task is really descheduled. So there is a small window left,
> > > which could lead to this. Revised patch below.
> > > 
> > > Anyway a trace for that issue would be appreciated nevertheless.
> > 
> > Here you go:
> > 
> > 	http://sr71.net/~dave/linux/bigbox.1365539189.txt.gz
> 
> Hmm. Unfortunately migration/146 is not in the trace.
>  
> Can you please apply the patch below? That avoids the oops, but might
> hang an online operation. Though the machine should stay up and you
> should be able to retrieve the trace.
> 
> Thanks,
> 
> 	tglx
> ---
> Index: linux-2.6/kernel/smpboot.c
> ===================================================================
> --- linux-2.6.orig/kernel/smpboot.c
> +++ linux-2.6/kernel/smpboot.c
> @@ -131,7 +131,10 @@ static int smpboot_thread_fn(void *data)
>  			continue;
>  		}
>  
> -		BUG_ON(td->cpu != smp_processor_id());
> +		if (td->cpu != smp_processor_id()) {
> +			tracing_off();
> +			schedule();

Bah, that wants a continue. Revised patch below.

> +		}
>  
>  		/* Check for state change setup */
>  		switch (td->status) {
 
Index: linux-2.6/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/kernel/smpboot.c
+++ linux-2.6/kernel/smpboot.c
@@ -131,7 +131,11 @@ static int smpboot_thread_fn(void *data)
 			continue;
 		}
 
-		BUG_ON(td->cpu != smp_processor_id());
+		if (td->cpu != smp_processor_id()) {
+			tracing_off();
+			schedule();
+			continue;
+		}
 
 		/* Check for state change setup */
 		switch (td->status) {
