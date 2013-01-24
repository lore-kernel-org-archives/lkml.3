Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945980Ab3AXV3v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:29:51 -0500
Received: from mail.kernel.org ([198.145.19.201]:40426 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756916Ab3AXVOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:14:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Stefan Bader <stefan.bader@canonical.com>,
        Borislav Petkov <bp@suse.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 42/46] ACPI: Check MSR valid bit before using P-state frequencies
Date: Thu, 24 Jan 2013 13:13:20 -0800
Message-Id: <20130124211150.928057093@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130124211135.862755794@linuxfoundation.org>
References: <20130124211135.862755794@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Bader <stefan.bader@canonical.com>

commit 9855d8ce41a7801548a05d844db2f46c3e810166 upstream.

To fix incorrect P-state frequencies which can happen on
some AMD systems f594065faf4f9067c2283a34619fc0714e79a98d
   "ACPI: Add fixups for AMD P-state figures"
introduced a quirk to obtain the correct values by reading
from AMD specific MSRs.

This did cause a regression when running a kernel using that
quirk under Xen which does (currently) not pass through MSR
reads to the HW. Instead the guest gets a 0 in return.
And this seems to cause a failure to initialize the ondemand
governour (hard to say for sure as all P-states appear to run
at the same frequency).

While this should also be fixed in the hypervisor (to allow
a guest to read that MSR), this patch is intended to work
around the issue in the meantime. In discussion it turned out
that indeed real HW/BIOSes may choose to not set the valid bit
and thus mark the P-state as invalid. So this could be considered
a fix for broken BIOSes that also works around the issue on Xen.

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Acked-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/processor_perflib.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/acpi/processor_perflib.c
+++ b/drivers/acpi/processor_perflib.c
@@ -340,6 +340,13 @@ static void amd_fixup_frequency(struct a
 	if ((boot_cpu_data.x86 == 0x10 && boot_cpu_data.x86_model < 10)
 	    || boot_cpu_data.x86 == 0x11) {
 		rdmsr(MSR_AMD_PSTATE_DEF_BASE + index, lo, hi);
+		/*
+		 * MSR C001_0064+:
+		 * Bit 63: PstateEn. Read-write. If set, the P-state is valid.
+		 */
+		if (!(hi & BIT(31)))
+			return;
+
 		fid = lo & 0x3f;
 		did = (lo >> 6) & 7;
 		if (boot_cpu_data.x86 == 0x10)


