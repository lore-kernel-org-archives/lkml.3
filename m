Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891Ab3F3Wgd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 18:36:33 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:55860 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394Ab3F3Wgc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 18:36:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
        Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: Fix cpufreq regression after suspend/resume
Date: Mon, 01 Jul 2013 00:46:03 +0200
Message-ID: <19337614.Mnu5DqParj@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51D07E7F.2030709@linux.vnet.ibm.com>
References: <51C08370.4050906@gmx.de> <51D06556.7080204@gmx.de> <51D07E7F.2030709@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 01, 2013 12:22:47 AM Srivatsa S. Bhat wrote:
> On 06/30/2013 10:35 PM, Toralf Förster wrote:
> > On 06/30/2013 06:33 PM, Srivatsa S. Bhat wrote:
> >> Toralf, can you please
> >> try out the below patch and see if it improves anything? (Don't revert anything,
> >> just apply the below diff on a problematic kernel and see if it solves your
> >> issue).
> > 
> > applied on top of a66b2e5 - issue went away (either fixed or hidden now)
> > 
> 
> Cool! So here is the proper patch, with changelog added.
> 
> Regards,
> Srivatsa S. Bhat
> 
> 
> -----------------------------------------------------------------------------
> 
> From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Subject: [PATCH] cpufreq: Fix cpufreq regression after suspend/resume
> 
> Toralf Förster reported that the cpufreq ondemand governor behaves erratically
> (doesn't scale well) after a suspend/resume cycle. The problem was that the
> cpufreq subsystem's idea of the cpu frequencies differed from the actual
> frequencies set in the hardware after a suspend/resume cycle. Toralf bisected
> the problem to commit a66b2e5 (cpufreq: Preserve sysfs files across
> suspend/resume).
> 
> Among other (harmless) things, that commit skipped the call to
> cpufreq_update_policy() in the resume path. But cpufreq_update_policy() plays
> an important role during resume, because it is responsible for checking if
> the BIOS changed the cpu frequencies behind our back and resynchronize the
> cpufreq subsystem's knowledge of the cpu frequencies, and update them
> accordingly.
> 
> So, restore the call to cpufreq_update_policy() in the resume path to fix
> the cpufreq regression.
> 
> Reported-by: Toralf Förster <toralf.foerster@gmx.de>
> Tested-by: Toralf Förster <toralf.foerster@gmx.de>
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Thanks Srivatsa, I'll queue it up as 3.11 (and 3.10-stable) material.

Thanks,
Rafael


> ---
> 
>  drivers/cpufreq/cpufreq_stats.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
> index fb65dec..591b6fb 100644
> --- a/drivers/cpufreq/cpufreq_stats.c
> +++ b/drivers/cpufreq/cpufreq_stats.c
> @@ -349,6 +349,7 @@ static int __cpuinit cpufreq_stat_cpu_callback(struct notifier_block *nfb,
>  
>  	switch (action) {
>  	case CPU_ONLINE:
> +	case CPU_ONLINE_FROZEN:
>  		cpufreq_update_policy(cpu);
>  		break;
>  	case CPU_DOWN_PREPARE:
> 
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
