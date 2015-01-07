Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746AbbAGQbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 11:31:17 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:58676 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602AbbAGQbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 11:31:16 -0500
X-IronPort-AV: E=Sophos;i="5.07,715,1413244800"; 
   d="scan'208";a="212637123"
Message-ID: <1420648234.18631.117.camel@citrix.com>
Subject: Re: [Xen-devel] [PATCH RFC] xen-time: decreasing the rating of the
 xen clocksource below that of the tsc clocksource for dom0's
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Imre Palik <imrep.amz@gmail.com>
CC: <xen-devel@lists.xenproject.org>, "Palik, Imre" <imrep@amazon.de>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, David Vrabel <david.vrabel@citrix.com>,
        "Anthony Liguori" <aliguori@amazon.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 7 Jan 2015 16:30:34 +0000
In-Reply-To: <1420647398-20207-1-git-send-email-imrep.amz@gmail.com>
References: <1420647398-20207-1-git-send-email-imrep.amz@gmail.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-07 at 17:16 +0100, Imre Palik wrote:
> From: "Palik, Imre" <imrep@amazon.de>
> 
> In Dom0's the use of the TSC clocksource (whenever it is stable enough to
> be used) instead of the Xen clocksource should not cause any issues, as
> Dom0 VMs never live-migrated.

Is this still true given that dom0's vcpus are migrated amongst pcpus on
the host? The tsc are not synchronised on some generations of hardware
so the result there would be the TSC appearing to do very odd things
under dom0's feet. Does Linux cope with that or does it not matter for
some other reason?

> 
> Cc: Anthony Liguori <aliguori@amazon.com>
> Signed-off-by: Imre Palik <imrep@amazon.de>
> ---
>  arch/x86/xen/time.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
> index f473d26..c768726 100644
> --- a/arch/x86/xen/time.c
> +++ b/arch/x86/xen/time.c
> @@ -487,6 +487,10 @@ static void __init xen_time_init(void)
>  	int cpu = smp_processor_id();
>  	struct timespec tp;
>  
> +	/* As Dom0 is never moved, no penalty on using TSC there */
> +	if (xen_initial_domain())
> +		xen_clocksource.rating = 275;
> +
>  	clocksource_register_hz(&xen_clocksource, NSEC_PER_SEC);
>  
>  	if (HYPERVISOR_vcpu_op(VCPUOP_stop_periodic_timer, cpu, NULL) == 0) {


