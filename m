Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab3AUMWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:22:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57018 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab3AUMW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:22:28 -0500
Message-ID: <50FD32FA.7010306@canonical.com>
Date: Mon, 21 Jan 2013 12:22:18 +0000
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andre Przywara <andre@andrep.de>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg@redhat.com>
Subject: Re: kernel 3.7+ cpufreq regression on AMD system running as dom0
References: <50F42B3E.7090602@canonical.com> <20130114163445.GA4867@liondog.tnic> <20130115175305.GA12449@phenom.dumpdata.com> <20130115181839.GC8101@liondog.tnic> <20130118190015.GC11351@phenom.dumpdata.com> <20130118200331.GF4062@pd.tnic>
In-Reply-To: <20130118200331.GF4062@pd.tnic>
Content-Type: multipart/mixed;
 boundary="------------010500090408050606080507"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010500090408050606080507
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01/18/2013 08:03 PM, Borislav Petkov wrote:
> On Fri, Jan 18, 2013 at 02:00:15PM -0500, Konrad Rzeszutek Wilk wrote:
>> I did not explain myself well. The fix is OK - it just that the
>> hypervisor causes the quirk to not work correctly. Hmm, I wonder if
>> there BIOSes that do the same thing (cause the MSR to return 0). Per
>> you estimation of BIOS quality, it seems that this could happen.
>
> Yeah, I don't think there's a limit to the amount of SNAFU a BIOS can
> cause :-).
>

So for having the "check for sensible BIOS" in mainline I refreshed the patch 
(fixed the bit test, and actually tested it this time) and also added some 
hopefully sensible explanation to it (attached below).

Should I send it to acpi lists or would that have to go via an Andre?

-Stefan

 From 6e2fc8291c91339123a37162382d8b08b50867ba Mon Sep 17 00:00:00 2001
From: Stefan Bader <stefan.bader@canonical.com>
Date: Mon, 14 Jan 2013 16:17:00 +0100
Subject: [PATCH] ACPI: Check MSR valid bit before using P-state frequencies

To fix incorrect P-state frequencies which can happen on
some AMD systems f594065faf4f9067c2283a34619fc0714e79a98d
   "ACPI: Add fixups for AMD P-state figures"
introduced a quirk to obtain the correct values by reading
from AMD specific MSRs.

This did cause a regression when running a kernel using that
quirk under Xen which does (currently) not pass on the contents
of the HW but 0. And this seems to cause a failure to initialize
the ondemand governour (hard to say for sure as all P-states
appear to run at the same frequency).

While this should also be fixed in the hypervisor (to allow
a guest to read that MSR), this patch is intended to work
around the issue in the meantime. In discussion it turned out
that indeed real HW/BIOSes may choose to not set the valid bit
and thus mark the P-state as invalid. So this could be considered
a fix for broken BIOSes that also works around the issue on Xen.

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Cc: stable@vger.kernel.org # v3.7..
---
  drivers/acpi/processor_perflib.c | 3 +++
  1 file changed, 3 insertions(+)

diff --git a/drivers/acpi/processor_perflib.c b/drivers/acpi/processor_perflib.c
index 836bfe0..41f4bdac 100644
--- a/drivers/acpi/processor_perflib.c
+++ b/drivers/acpi/processor_perflib.c
@@ -340,6 +340,9 @@ static void amd_fixup_frequency(struct acpi_processor_px 
*px, int i)
  	if ((boot_cpu_data.x86 == 0x10 && boot_cpu_data.x86_model < 10)
  	    || boot_cpu_data.x86 == 0x11) {
  		rdmsr(MSR_AMD_PSTATE_DEF_BASE + index, lo, hi);
+		/* Bit 63 indicates whether contents are valid */
+		if (!(hi & 0x80000000))
+			return;
  		fid = lo & 0x3f;
  		did = (lo >> 6) & 7;
  		if (boot_cpu_data.x86 == 0x10)
-- 
1.8.0



--------------010500090408050606080507
Content-Type: text/x-diff;
 name="0001-ACPI-Check-MSR-valid-bit-before-using-P-state-freque.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-ACPI-Check-MSR-valid-bit-before-using-P-state-freque.pa";
 filename*1="tch"

>From 6e2fc8291c91339123a37162382d8b08b50867ba Mon Sep 17 00:00:00 2001
From: Stefan Bader <stefan.bader@canonical.com>
Date: Mon, 14 Jan 2013 16:17:00 +0100
Subject: [PATCH] ACPI: Check MSR valid bit before using P-state frequencies

To fix incorrect P-state frequencies which can happen on
some AMD systems f594065faf4f9067c2283a34619fc0714e79a98d
  "ACPI: Add fixups for AMD P-state figures"
introduced a quirk to obtain the correct values by reading
from AMD specific MSRs.

This did cause a regression when running a kernel using that
quirk under Xen which does (currently) not pass on the contents
of the HW but 0. And this seems to cause a failure to initialize
the ondemand governour (hard to say for sure as all P-states
appear to run at the same frequency).

While this should also be fixed in the hypervisor (to allow
a guest to read that MSR), this patch is intended to work
around the issue in the meantime. In discussion it turned out
that indeed real HW/BIOSes may choose to not set the valid bit
and thus mark the P-state as invalid. So this could be considered
a fix for broken BIOSes that also works around the issue on Xen.

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Cc: stable@vger.kernel.org # v3.7..
---
 drivers/acpi/processor_perflib.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/acpi/processor_perflib.c b/drivers/acpi/processor_perflib.c
index 836bfe0..41f4bdac 100644
--- a/drivers/acpi/processor_perflib.c
+++ b/drivers/acpi/processor_perflib.c
@@ -340,6 +340,9 @@ static void amd_fixup_frequency(struct acpi_processor_px *px, int i)
 	if ((boot_cpu_data.x86 == 0x10 && boot_cpu_data.x86_model < 10)
 	    || boot_cpu_data.x86 == 0x11) {
 		rdmsr(MSR_AMD_PSTATE_DEF_BASE + index, lo, hi);
+		/* Bit 63 indicates whether contents are valid */
+		if (!(hi & 0x80000000))
+			return;
 		fid = lo & 0x3f;
 		did = (lo >> 6) & 7;
 		if (boot_cpu_data.x86 == 0x10)
-- 
1.8.0


--------------010500090408050606080507--
