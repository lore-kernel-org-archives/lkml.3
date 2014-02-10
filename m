Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909AbaBJTI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:08:27 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:41966 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbaBJTIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:08:24 -0500
Date: Tue, 11 Feb 2014 00:37:37 +0530
From: Gautham R Shenoy <ego@linux.vnet.ibm.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: paulus@samba.org, oleg@redhat.com, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org,
        mingo@kernel.org, paulmck@linux.vnet.ibm.com, tj@kernel.org,
        walken@google.com, ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, Robert Richter <rric@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: Re: [PATCH 26/51] x86, oprofile, nmi: Fix CPU hotplug callback
 registration
Message-ID: <20140210190737.GD3416@in.ibm.com>
Reply-To: ego@linux.vnet.ibm.com
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
 <20140205220921.19080.94715.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140205220921.19080.94715.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021019-0928-0000-0000-0000062E3D95
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Feb 06, 2014 at 03:39:22AM +0530, Srivatsa S. Bhat wrote:
> Fix the oprofile code in x86 by using this latter form of callback
> registration. But retain the calls to get/put_online_cpus(), since they
> also protect the variables 'nmi_enabled' and 'ctr_running'.

get/put_online_cpus() protect us against cpu_hotplug_begin/end(). The
latter is always nested inside cpu_maps_update_begin/end(), which we
are already using here. 

So what additional protection are we getting by retaining
get/put_online_cpus() ?

> By nesting
> get/put_online_cpus() *inside* cpu_maps_update_begin/done(), we avoid
> the ABBA deadlock possibility mentioned above.
> 
> Cc: Robert Richter <rric@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
> 
>  arch/x86/oprofile/nmi_int.c |   15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
> index 6890d84..85e5f6e 100644
> --- a/arch/x86/oprofile/nmi_int.c
> +++ b/arch/x86/oprofile/nmi_int.c
> @@ -494,14 +494,19 @@ static int nmi_setup(void)
>  	if (err)
>  		goto fail;
> 
> +	cpu_maps_update_begin();
> +
> +	/* Use get/put_online_cpus() to protect 'nmi_enabled' */
>  	get_online_cpus();
> -	register_cpu_notifier(&oprofile_cpu_nb);
>  	nmi_enabled = 1;
>  	/* make nmi_enabled visible to the nmi handler: */
>  	smp_mb();
>  	on_each_cpu(nmi_cpu_setup, NULL, 1);
> +	__register_cpu_notifier(&oprofile_cpu_nb);
>  	put_online_cpus();
> 
> +	cpu_maps_update_done();
> +
>  	return 0;
>  fail:
>  	free_msrs();
> @@ -512,12 +517,18 @@ static void nmi_shutdown(void)
>  {
>  	struct op_msrs *msrs;
> 
> +	cpu_maps_update_begin();
> +
> +	/* Use get/put_online_cpus() to protect 'nmi_enabled' & 'ctr_running' */
>  	get_online_cpus();
> -	unregister_cpu_notifier(&oprofile_cpu_nb);
>  	on_each_cpu(nmi_cpu_shutdown, NULL, 1);
>  	nmi_enabled = 0;
>  	ctr_running = 0;
> +	__unregister_cpu_notifier(&oprofile_cpu_nb);
>  	put_online_cpus();
> +
> +	cpu_maps_update_done();
> +
>  	/* make variables visible to the nmi handler: */
>  	smp_mb();
>  	unregister_nmi_handler(NMI_LOCAL, "oprofile");
> 

