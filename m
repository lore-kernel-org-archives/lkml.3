Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab3ARThH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 14:37:07 -0500
Received: from mail.skyhub.de ([78.46.96.112]:48904 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905Ab3ARThC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 14:37:02 -0500
Date: Fri, 18 Jan 2013 20:36:56 +0100
From: Borislav Petkov <bp@alien8.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Gopalakrishnan, Aravind" <Aravind.Gopalakrishnan@amd.com>,
        "rjw@sisk.pl" <rjw@sisk.pl>, Andre Przywara <andre@andrep.de>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andreas <linuxuser330250@gmx.net>
Subject: Re: [PATCH] drivers/cpufreq: Warn user when powernow-k8 tries to
 fall back to acpi-cpufreq and it is unavailable.
Message-ID: <20130118193656.GE4062@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	"Gopalakrishnan, Aravind" <Aravind.Gopalakrishnan@amd.com>,
	"rjw@sisk.pl" <rjw@sisk.pl>, Andre Przywara <andre@andrep.de>,
	"cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Andreas <linuxuser330250@gmx.net>
References: <1357780161-30581-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <20130111144940.GB21882@liondog.tnic>
 <20130111165054.GD10751@liondog.tnic>
 <4923C2DE085EEB4FAB1D375DD09D0BA6100CF170@sausexdag04.amd.com>
 <20130117115436.GA3853@pd.tnic>
 <20130118162347.GA31499@srcf.ucam.org>
 <20130118170755.GB4062@pd.tnic>
 <20130118190021.GD4062@pd.tnic>
 <20130118190659.GB16757@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130118190659.GB16757@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 07:06:59PM +0000, Matthew Garrett wrote:
> On Fri, Jan 18, 2013 at 08:00:21PM +0100, Borislav Petkov wrote:
> 
> > ##################################################################################
> > # x86 drivers.
> > # Link order matters. K8 is preferred to ACPI because of firmware bugs in early
> > # K8 systems.
> > ...
> > 
> > Great. :(
> 
> The only case I can see this hitting would be if the platform is using 
> system IO rather than fixed hardware functionality. Easiest thing to do 
> there would be something like this:
> 
> diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
> index 0d048f6..8b466d5 100644
> --- a/drivers/cpufreq/acpi-cpufreq.c
> +++ b/drivers/cpufreq/acpi-cpufreq.c
> @@ -762,6 +762,11 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
>  
>  	switch (perf->control_register.space_id) {
>  	case ACPI_ADR_SPACE_SYSTEM_IO:
> +		if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD) {
> +			pr_debug("Old AMD systems must use native drivers\n");
> +			result = -ENODEV;
> +			goto err_unreg;
> +		}
>  		pr_debug("SYSTEM IO addr space\n");
>  		data->cpu_feature = SYSTEM_IO_CAPABLE;
>  		break;

Ok, how much can we rely on ACPI to have this ACPI_ADR_SPACE_SYSTEM_IO
properly set on K8? Because the thing is, we want to use acpi-cpufreq on
F10h onwards and leave powernow-k8 to K8s.

So we're purely relying on ->control_register.space_id being
ACPI_ADR_SPACE_SYSTEM_IO on *all* K8s. And with the history BIOS has, I
don't trust it a single bit. Other than that, this could work...

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
