Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab3ARTAx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 14:00:53 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:16759 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab3ARTAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 14:00:51 -0500
Date: Fri, 18 Jan 2013 14:00:15 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Borislav Petkov <bp@alien8.de>, Stefan Bader <stefan.bader@canonical.com>,
        Andre Przywara <andre@andrep.de>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg@redhat.com>
Subject: Re: kernel 3.7+ cpufreq regression on AMD system running as dom0
Message-ID: <20130118190015.GC11351@phenom.dumpdata.com>
References: <50F42B3E.7090602@canonical.com>
 <20130114163445.GA4867@liondog.tnic>
 <20130115175305.GA12449@phenom.dumpdata.com>
 <20130115181839.GC8101@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130115181839.GC8101@liondog.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 07:18:39PM +0100, Borislav Petkov wrote:
> On Tue, Jan 15, 2013 at 12:53:05PM -0500, Konrad Rzeszutek Wilk wrote:
> > > I don't think that's the right change - this is fixing baremetal so that
> > > it works on xen. And besides, this code was in powernow-k8 before so I'm
> > > wondering why did it work then.
> > 
> > Powernow-k8 only populated the cpufreq policy information. This library
> > (processor_perflib) is the generic library used for ACPI P-states parsing.
> > This specific function (acpi_processor_get_performance_states) is just
> > used to fetch and parse the P-states.
> > 
> > Xen-acpi-processor (which we use to upload the P and C-states to the
> > hypervisor) ends up calling this library to parse the P-states
> > and this unfortunate quirk clamps the P-states based on the MSRS.
> 
> Huh? This is a fix for _PSS frequency values which are rounded and thus
> imprecise. The _PSS objects are the unfortunate ones, as most of the
> other crap BIOS produces.

I did not explain myself well. The fix is OK - it just that the hypervisor
causes the quirk to not work correctly. Hmm, I wonder if there BIOSes
that do the same thing (cause the MSR to return 0). Per you estimation
of BIOS quality, it seems that this could happen.

> 
> > It is odd that this CPU specific quirk got added in this generic
> > library. Is there no ACPI quirk system similar to how DMI quirks are
> > handled?
> 
> Even if there were, do you know all the boards and BIOS revisions which
> have those rounded values? The fix addresses the hardware which has
> those 50MHz multiples and simply ignores the _PSS data but reads out the
> P-states directly from the hardware.

Oh, I was not thinking DMI per-say. I was thinking something similar to
DMI-quirk API. But for the ACPI subsystem, so it would be:

	if (ARM)
		... these quirks neccessary
	if (AMD)
		.. these quirks

and then the ACPI code can make the calls to this ACPI-quirk API to
figure out whether it needs to modulate values. But this is all
hand-waving at this point.
> 
> > Anyhow, I think this patch makes sense - it makes sure that the MSR
> > value is sane.
> 
> I agree to a certain degree. Testing the Valid bit is something we
> should do for P-state MSRs - and for all MSRs containing a Valid bit,
> for that matter - and the original code didn't do it.

OK.
> 
> However, you need to push down the *correct* frequencies *after* the
> quirk to the hypervisor (I'm looking at push_pxx_to_hypervisor()) so
> that it is aware of the exact P-state frequencies this CPU supports and
> not some rounded values.

Yes!  It could be done in the hypervisor (it does the MSRs and figures out
that the P-states need tweaking).

> 
> AFAICT for the xen part, of course. But the baseline stands: you need to
> tell the thing that switches P-states the exact P-state frequencies of
> the CPU. :-).

Right, that information is gathered from the MSRs. I think the Xen would
need to do this since it can do the MSRs correctly and modify the P-states.

So something like this in the hypervisor maybe (not even tested):

diff --git a/xen/arch/x86/acpi/cpufreq/powernow.c b/xen/arch/x86/acpi/cpufreq/powernow.c
index a9b7792..54e7808 100644
--- a/xen/arch/x86/acpi/cpufreq/powernow.c
+++ b/xen/arch/x86/acpi/cpufreq/powernow.c
@@ -146,7 +146,40 @@ static int powernow_cpufreq_target(struct cpufreq_policy *policy,
 
     return 0;
 }
+#define MSR_AMD_PSTATE_DEF_BASE     0xc0010064
+static void amd_fixup_frequency(struct xen_processor_px *px, int i)
+{
+	u32 hi, lo, fid, did;
+	int index = px->control & 0x00000007;
+
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
+		return;
+
+	if ((boot_cpu_data.x86 == 0x10 && boot_cpu_data.x86_model < 10)
+	    || boot_cpu_data.x86 == 0x11) {
+		rdmsr(MSR_AMD_PSTATE_DEF_BASE + index, lo, hi);
+        /* Bit 63 indicates whether contents are valid */
+        if (!(hi & 0x80000000))
+            return;
+
+		fid = lo & 0x3f;
+		did = (lo >> 6) & 7;
+		if (boot_cpu_data.x86 == 0x10)
+			px->core_frequency = (100 * (fid + 0x10)) >> did;
+		else
+			px->core_frequency = (100 * (fid + 8)) >> did;
+	}
+}
+
+static void amd_fixup_freq(struct processor_performance *perf)
+{
 
+    int i;
+
+    for (i = 0; i < perf->state_count; i++)
+        amd_fixup_frequency(perf->states, i);
+
+}
 static int powernow_cpufreq_verify(struct cpufreq_policy *policy)
 {
     struct acpi_cpufreq_data *data;
@@ -158,6 +191,8 @@ static int powernow_cpufreq_verify(struct cpufreq_policy *policy)
 
     perf = &processor_pminfo[policy->cpu]->perf;
 
+    amd_fixup_freq(perf);
+
     cpufreq_verify_within_limits(policy, 0, 
         perf->states[perf->platform_limit].core_frequency * 1000);
 
