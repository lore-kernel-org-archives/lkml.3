Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbaKJKuJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 05:50:09 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:46201 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbaKJKuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 05:50:05 -0500
Message-ID: <54609804.9070006@linux.vnet.ibm.com>
Date: Mon, 10 Nov 2014 16:18:36 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: mpe@ellerman.id.au, mikey@neuling.org, joel.stanley@au1.ibm.com,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>
CC: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        rjw@rjwysocki.net
Subject: Re: [PATCH] cpuidle/powernv: Fix return value of idle index in fastsleep
References: <20141027132618.9085.97044.stgit@preeti.in.ibm.com>
In-Reply-To: <20141027132618.9085.97044.stgit@preeti.in.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14111010-0005-0000-0000-0000063DD662
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben, Mikey,

Can you please take a look at this patch?  I feel the commit dcb1869 was
just a plug-in solution. Shouldn't we take a look at this again?

Ideally we should not need this check. With the cpuidle redesign on
PowerNV going in, we can enable fastsleep at bootup itself and without
checks on any debug parameters such as powersave_nap .We will then only
need to check for powersave_nap == 0 and return only if that is the
case. This check is still required since the user can disable all deep
idle states by setting powersave_nap to 0.

Regards
Preeti U Murthy

On 10/27/2014 06:56 PM, Preeti U Murthy wrote:
> Commit dcb18694 : Fix ipi on Palmeto added a workaround to disable
> going into fastsleep on Palmeto boards which was reported to fail
> to boot when fastsleep was enabled. However it missed returning
> an idle index. Fix this.
> 
> There is probably no harm in returning the index of fastsleep
> although the cpu did not enter this state. The governor will notice
> the difference in the residency time in the idle state and the
> target residency of the idle state and prevent cpus from entering
> fastsleep from that point on. Hence the usage and time statistics
> logged for fastsleep will not be out of sync with reality except
> for the first entry.
> 
> Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
> ---
> Do we still need this workaround? Or can we get rid of the check
> on powersave_nap altogether?
> ---
> 
>  drivers/cpuidle/cpuidle-powernv.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/cpuidle/cpuidle-powernv.c b/drivers/cpuidle/cpuidle-powernv.c
> index fa79392..c18da24 100644
> --- a/drivers/cpuidle/cpuidle-powernv.c
> +++ b/drivers/cpuidle/cpuidle-powernv.c
> @@ -70,7 +70,7 @@ static int fastsleep_loop(struct cpuidle_device *dev,
>  	unsigned long new_lpcr;
>  
>  	if (powersave_nap < 2)
> -		return;
> +		return index;
>  	if (unlikely(system_state < SYSTEM_RUNNING))
>  		return index;
>  
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
> 

