Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab3AKQvA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 11:51:00 -0500
Received: from mail.skyhub.de ([78.46.96.112]:42212 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753704Ab3AKQu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 11:50:58 -0500
Date: Fri, 11 Jan 2013 17:50:54 +0100
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        Andre Przywara <andre@andrep.de>, rjw@sisk.pl, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andreas <linuxuser330250@gmx.net>
Subject: Re: [PATCH] drivers/cpufreq: Warn user when powernow-k8 tries to
 fall back to acpi-cpufreq and it is unavailable.
Message-ID: <20130111165054.GD10751@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
	Andre Przywara <andre@andrep.de>, rjw@sisk.pl,
	cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Andreas <linuxuser330250@gmx.net>
References: <1357780161-30581-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <20130111144940.GB21882@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130111144940.GB21882@liondog.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding bugreporter from BZ to CC.

On Fri, Jan 11, 2013 at 03:49:40PM +0100, Borislav Petkov wrote:
> + Andre.
> 
> On Wed, Jan 09, 2013 at 07:09:21PM -0600, Aravind Gopalakrishnan wrote:
> > This patch is in reference to bug#:51741. (https://bugzilla.kernel.org/show_bug.cgi?id=51741)
> > powernow-k8 falls back to acpi-cpufreq if CPU is not supported. However, it states that acpi-cpufreq
> > has taken over even if acpi-cpufreq is not compiled in. This patch rewords the warning message to
> > clarify that the CPU is unsupported and prints a warning message when there is no acpi-cpufreq
> > present.
> > 
> > Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
> > ---
> >  drivers/cpufreq/powernow-k8.c |   10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
> > index 056faf6..6fa58b4 100644
> > --- a/drivers/cpufreq/powernow-k8.c
> > +++ b/drivers/cpufreq/powernow-k8.c
> > @@ -1256,7 +1256,15 @@ static int __cpuinit powernowk8_init(void)
> >  	int rv;
> >  
> >  	if (static_cpu_has(X86_FEATURE_HW_PSTATE)) {
> > -		pr_warn(PFX "this CPU is not supported anymore, using acpi-cpufreq instead.\n");
> > +		pr_warn(PFX
> > +			"this CPU is not supported anymore, use acpi-cpufreq instead"
> > +			"Look for message from acpi-cpufreq to ensure it is loaded."
> > +			".\n");
> > +#ifndef CONFIG_X86_ACPI_CPUFREQ
> > +	pr_warn(PFX "acpi-cpufreq is disabled."
> > +		"Enable it in the config options to get frequency scaling.\n");
> > +	return -ENODEV;
> > +#endif
> >  		request_module("acpi-cpufreq");
> >  		return -ENODEV;
> 
> Ok, the suggestion in that BZ is valid and something needs to be done
> for that case but I don't think that simply warning the user about it is
> enough.
> 
> First of all, CONFIG_X86_POWERNOW_K8 should depend on
> CONFIG_X86_ACPI_CPUFREQ since powernow-k8.ko requests that module.
> 
> Then, having that dependency out of the way, we can almost safely
> request_module("acpi-cpufreq"). However, we can also check the return
> value of that function to make sure loading went fine.
> 
> And finally, we should check that acpi-cpufreq actually registered
> properly and wasn't unloaded later for some other reason which wasn't
> signalled through request_module retval.
> 
> Andre, I'm not sure about the details of that last one but the first
> two are easy. Any ideas, since you've been looking at acpi-cpufreq code
> lately?

Ok,

this turned out to be not that hard, here's what I came up with. I
haven't checked the case where acpi-cpufreq and powernow-k8 are built in
and what happens then.

This still doesn't deal with pathological situations when acpi-cpufreq
f*cks up loading later and errors out. For that, we probably need to
export some cpufreq internals like cpufreq_driver and look at its ->name
member and decide whether it is properly set. I'm not sure that is
really warranted though...

In the meantime, here's a first stab at it, which should cover the major
holes.

--
From: Borislav Petkov <bp@suse.de>
Date: Fri, 11 Jan 2013 17:36:58 +0100
Subject: [PATCH] powernow-k8: Robustify loading of acpi-cpufreq

Andreas says in https://bugzilla.kernel.org/show_bug.cgi?id=51741 that
with his Gentoo config, acpi-cpufreq wasn't enabled and powernow-k8
couldn't handoff properly to acpi-cpufreq leading to running without
P-state support (i.e., cores are constantly in P0).

To alleaviate that, we need to make powernow-k8 depend on acpi-cpufreq
so that acpi-cpufreq is always present as a module and is thus loadable.
Also, request_module waits until acpi-cpufreq is loaded so we check its
retval whether the loading succeeded or not. If not, we warn the user so
that she can take precaution and fix the situation.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 drivers/cpufreq/Kconfig.x86   | 2 +-
 drivers/cpufreq/powernow-k8.c | 8 ++++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/Kconfig.x86 b/drivers/cpufreq/Kconfig.x86
index 934854ae5eb4..7227cd734042 100644
--- a/drivers/cpufreq/Kconfig.x86
+++ b/drivers/cpufreq/Kconfig.x86
@@ -106,7 +106,7 @@ config X86_POWERNOW_K7_ACPI
 config X86_POWERNOW_K8
 	tristate "AMD Opteron/Athlon64 PowerNow!"
 	select CPU_FREQ_TABLE
-	depends on ACPI && ACPI_PROCESSOR
+	depends on ACPI && ACPI_PROCESSOR && X86_ACPI_CPUFREQ
 	help
 	  This adds the CPUFreq driver for K8/early Opteron/Athlon64 processors.
 	  Support for K10 and newer processors is now in acpi-cpufreq.
diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index 056faf6af1a9..1adbe86d0d3b 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -1256,8 +1256,12 @@ static int __cpuinit powernowk8_init(void)
 	int rv;
 
 	if (static_cpu_has(X86_FEATURE_HW_PSTATE)) {
-		pr_warn(PFX "this CPU is not supported anymore, using acpi-cpufreq instead.\n");
-		request_module("acpi-cpufreq");
+		pr_warn(PFX "This CPU is now supported by acpi-cpufreq, loading it.\n");
+
+		if (request_module("acpi-cpufreq"))
+			pr_warn(PFX "Error loading acpi-cpufreq, make sure you "
+				"have it enabled, else you won't have any "
+				"Pstates support on this CPU!\n");
 		return -ENODEV;
 	}
 
-- 
1.8.1.rc3

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
