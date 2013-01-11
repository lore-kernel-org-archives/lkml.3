Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab3AKRk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 12:40:27 -0500
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:22780
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753719Ab3AKRkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 12:40:07 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -7
X-BigFish: VPS-7(zz98dI9371I15bfK542I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bh8275dhz2dh668h839h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h1155h)
X-WSS-ID: 0MGH2EL-02-57D-02
X-M-MSG: 
From: "Gopalakrishnan, Aravind" <Aravind.Gopalakrishnan@amd.com>
To: Borislav Petkov <bp@alien8.de>, Andre Przywara <andre@andrep.de>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Andreas <linuxuser330250@gmx.net>
Subject: RE: [PATCH] drivers/cpufreq: Warn user when powernow-k8 tries to
 fall back to acpi-cpufreq and it is unavailable.
Thread-Topic: [PATCH] drivers/cpufreq: Warn user when powernow-k8 tries to
 fall back to acpi-cpufreq and it is unavailable.
Thread-Index: AQHN7s8exX7w9Ky4iEWIRc9vlXABaphEnLsAgAAh3wD//55uMA==
Date: Fri, 11 Jan 2013 17:39:56 +0000
Message-ID: <4923C2DE085EEB4FAB1D375DD09D0BA6100CF130@sausexdag04.amd.com>
References: <1357780161-30581-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <20130111144940.GB21882@liondog.tnic> <20130111165054.GD10751@liondog.tnic>
In-Reply-To: <20130111165054.GD10751@liondog.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.236.49.67]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0BHeVlC021803

So, I had tried out the case when acpi-cpufreq was compiled into the kernel and looked at the return values from request_module(); it returns a positive value (255) both when acpi-cpufreq was compiled-in and when not compiled-in.  (Please do let me know if I am missing something here...)
(This was the case Andreas had mentioned in the bug report too)

It was due to this that I had decided to just check the CONFIG option and print out a warning to the user.

-----Original Message-----
From: Borislav Petkov [mailto:bp@alien8.de] 
Sent: Friday, January 11, 2013 10:51 AM
To: Gopalakrishnan, Aravind; Andre Przywara; rjw@sisk.pl; cpufreq@vger.kernel.org; linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org
Cc: Andreas
Subject: Re: [PATCH] drivers/cpufreq: Warn user when powernow-k8 tries to fall back to acpi-cpufreq and it is unavailable.

Adding bugreporter from BZ to CC.

On Fri, Jan 11, 2013 at 03:49:40PM +0100, Borislav Petkov wrote:
> + Andre.
> 
> On Wed, Jan 09, 2013 at 07:09:21PM -0600, Aravind Gopalakrishnan wrote:
> > This patch is in reference to bug#:51741. 
> > (https://bugzilla.kernel.org/show_bug.cgi?id=51741)
> > powernow-k8 falls back to acpi-cpufreq if CPU is not supported. 
> > However, it states that acpi-cpufreq has taken over even if 
> > acpi-cpufreq is not compiled in. This patch rewords the warning 
> > message to clarify that the CPU is unsupported and prints a warning message when there is no acpi-cpufreq present.
> > 
> > Signed-off-by: Aravind Gopalakrishnan 
> > <Aravind.Gopalakrishnan@amd.com>
> > ---
> >  drivers/cpufreq/powernow-k8.c |   10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/cpufreq/powernow-k8.c 
> > b/drivers/cpufreq/powernow-k8.c index 056faf6..6fa58b4 100644
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
> for that case but I don't think that simply warning the user about it 
> is enough.
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
> two are easy. Any ideas, since you've been looking at acpi-cpufreq 
> code lately?

Ok,

this turned out to be not that hard, here's what I came up with. I haven't checked the case where acpi-cpufreq and powernow-k8 are built in and what happens then.

This still doesn't deal with pathological situations when acpi-cpufreq f*cks up loading later and errors out. For that, we probably need to export some cpufreq internals like cpufreq_driver and look at its ->name member and decide whether it is properly set. I'm not sure that is really warranted though...

In the meantime, here's a first stab at it, which should cover the major holes.

--
From: Borislav Petkov <bp@suse.de>
Date: Fri, 11 Jan 2013 17:36:58 +0100
Subject: [PATCH] powernow-k8: Robustify loading of acpi-cpufreq

Andreas says in https://bugzilla.kernel.org/show_bug.cgi?id=51741 that with his Gentoo config, acpi-cpufreq wasn't enabled and powernow-k8 couldn't handoff properly to acpi-cpufreq leading to running without P-state support (i.e., cores are constantly in P0).

To alleaviate that, we need to make powernow-k8 depend on acpi-cpufreq so that acpi-cpufreq is always present as a module and is thus loadable.
Also, request_module waits until acpi-cpufreq is loaded so we check its retval whether the loading succeeded or not. If not, we warn the user so that she can take precaution and fix the situation.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 drivers/cpufreq/Kconfig.x86   | 2 +-
 drivers/cpufreq/powernow-k8.c | 8 ++++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/Kconfig.x86 b/drivers/cpufreq/Kconfig.x86 index 934854ae5eb4..7227cd734042 100644
--- a/drivers/cpufreq/Kconfig.x86
+++ b/drivers/cpufreq/Kconfig.x86
@@ -106,7 +106,7 @@ config X86_POWERNOW_K7_ACPI  config X86_POWERNOW_K8
 	tristate "AMD Opteron/Athlon64 PowerNow!"
 	select CPU_FREQ_TABLE
-	depends on ACPI && ACPI_PROCESSOR
+	depends on ACPI && ACPI_PROCESSOR && X86_ACPI_CPUFREQ
 	help
 	  This adds the CPUFreq driver for K8/early Opteron/Athlon64 processors.
 	  Support for K10 and newer processors is now in acpi-cpufreq.
diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c index 056faf6af1a9..1adbe86d0d3b 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -1256,8 +1256,12 @@ static int __cpuinit powernowk8_init(void)
 	int rv;
 
 	if (static_cpu_has(X86_FEATURE_HW_PSTATE)) {
-		pr_warn(PFX "this CPU is not supported anymore, using acpi-cpufreq instead.\n");
-		request_module("acpi-cpufreq");
+		pr_warn(PFX "This CPU is now supported by acpi-cpufreq, loading 
+it.\n");
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

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
