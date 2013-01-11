Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab3AKOto (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 09:49:44 -0500
Received: from mail.skyhub.de ([78.46.96.112]:40264 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341Ab3AKOtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 09:49:42 -0500
Date: Fri, 11 Jan 2013 15:49:40 +0100
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        Andre Przywara <andre@andrep.de>
Cc: rjw@sisk.pl, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/cpufreq: Warn user when powernow-k8 tries to
 fall back to acpi-cpufreq and it is unavailable.
Message-ID: <20130111144940.GB21882@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
	Andre Przywara <andre@andrep.de>, rjw@sisk.pl,
	cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1357780161-30581-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1357780161-30581-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Andre.

On Wed, Jan 09, 2013 at 07:09:21PM -0600, Aravind Gopalakrishnan wrote:
> This patch is in reference to bug#:51741. (https://bugzilla.kernel.org/show_bug.cgi?id=51741)
> powernow-k8 falls back to acpi-cpufreq if CPU is not supported. However, it states that acpi-cpufreq
> has taken over even if acpi-cpufreq is not compiled in. This patch rewords the warning message to
> clarify that the CPU is unsupported and prints a warning message when there is no acpi-cpufreq
> present.
> 
> Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
> ---
>  drivers/cpufreq/powernow-k8.c |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
> index 056faf6..6fa58b4 100644
> --- a/drivers/cpufreq/powernow-k8.c
> +++ b/drivers/cpufreq/powernow-k8.c
> @@ -1256,7 +1256,15 @@ static int __cpuinit powernowk8_init(void)
>  	int rv;
>  
>  	if (static_cpu_has(X86_FEATURE_HW_PSTATE)) {
> -		pr_warn(PFX "this CPU is not supported anymore, using acpi-cpufreq instead.\n");
> +		pr_warn(PFX
> +			"this CPU is not supported anymore, use acpi-cpufreq instead"
> +			"Look for message from acpi-cpufreq to ensure it is loaded."
> +			".\n");
> +#ifndef CONFIG_X86_ACPI_CPUFREQ
> +	pr_warn(PFX "acpi-cpufreq is disabled."
> +		"Enable it in the config options to get frequency scaling.\n");
> +	return -ENODEV;
> +#endif
>  		request_module("acpi-cpufreq");
>  		return -ENODEV;

Ok, the suggestion in that BZ is valid and something needs to be done
for that case but I don't think that simply warning the user about it is
enough.

First of all, CONFIG_X86_POWERNOW_K8 should depend on
CONFIG_X86_ACPI_CPUFREQ since powernow-k8.ko requests that module.

Then, having that dependency out of the way, we can almost safely
request_module("acpi-cpufreq"). However, we can also check the return
value of that function to make sure loading went fine.

And finally, we should check that acpi-cpufreq actually registered
properly and wasn't unloaded later for some other reason which wasn't
signalled through request_module retval.

Andre, I'm not sure about the details of that last one but the first
two are easy. Any ideas, since you've been looking at acpi-cpufreq code
lately?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
