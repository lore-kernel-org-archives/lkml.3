Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbbAGQ7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 11:59:17 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:47007 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775AbbAGQ7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 11:59:16 -0500
Message-ID: <54AD65D4.9070101@oracle.com>
Date: Wed, 07 Jan 2015 11:59:00 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Imre Palik <imrep.amz@gmail.com>, xen-devel@lists.xenproject.org
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, "Palik, Imre" <imrep@amazon.de>,
        Anthony Liguori <aliguori@amazon.com>
Subject: Re: [PATCH RFC] xen-time: decreasing the rating of the xen clocksource
 below that of the tsc clocksource for dom0's
References: <1420647398-20207-1-git-send-email-imrep.amz@gmail.com>
In-Reply-To: <1420647398-20207-1-git-send-email-imrep.amz@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2015 11:16 AM, Imre Palik wrote:
> From: "Palik, Imre" <imrep@amazon.de>
>
> In Dom0's the use of the TSC clocksource (whenever it is stable enough to
> be used) instead of the Xen clocksource should not cause any issues, as
> Dom0 VMs never live-migrated.  The TSC clocksource is somewhat more
> efficient than the Xen paravirtualised clocksource, thus it should have
> higher rating.
>
> Cc: Anthony Liguori <aliguori@amazon.com>
> Signed-off-by: Imre Palik <imrep@amazon.de>
> ---
>   arch/x86/xen/time.c |    4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
> index f473d26..c768726 100644
> --- a/arch/x86/xen/time.c
> +++ b/arch/x86/xen/time.c
> @@ -487,6 +487,10 @@ static void __init xen_time_init(void)
>   	int cpu = smp_processor_id();
>   	struct timespec tp;
>   
> +	/* As Dom0 is never moved, no penalty on using TSC there */
> +	if (xen_initial_domain())
> +		xen_clocksource.rating = 275;


Should this only be limited to dom0? Can we do this for guests running 
with TSC_MODE_NEVER_EMULATE as well?

We also have disable_migrate flag for guests (but it doesn't appear to 
be accessible to a guest kernel).

-boris


> +
>   	clocksource_register_hz(&xen_clocksource, NSEC_PER_SEC);
>   
>   	if (HYPERVISOR_vcpu_op(VCPUOP_stop_periodic_timer, cpu, NULL) == 0) {

