Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab3ATK0K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 05:26:10 -0500
Received: from mail.skyhub.de ([78.46.96.112]:41416 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672Ab3ATKYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 05:24:39 -0500
From: Borislav Petkov <bp@alien8.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: =?UTF-8?q?Andr=C3=A9=20Przywara?= <andre@andrep.de>,
        Leonid Isaev <lisaev@umail.iu.edu>, Tom Gundersen <teg@jklm.no>,
        cpufreq@vger.kernel.org, linux-acpi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Borislav Petkov <bp@suse.de>
Subject: [PATCH 2/6] acpi-cpufreq: Do not load on K8
Date: Sun, 20 Jan 2013 11:24:26 +0100
Message-Id: <1358677470-17394-3-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.rc3
In-Reply-To: <1358677470-17394-1-git-send-email-bp@alien8.de>
References: <1358677470-17394-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Garrett <mjg59@srcf.ucam.org>

de3ed81d746d ("[CPUFREQ] Change link order of x86 cpufreq modules")
changed cpufreq drivers link order so that powernow-k8 gets loaded first
due to earlier K8s having BIOS bugs.

However, now that acpi-cpufreq supports both AMD and Intel CPUs with HW
P-states, we want to load it first, so that cases where acpi-cpufreq and
powernow-k8 are both built-in and powernow-k8 initializing first, can be
addressed.

So, make sure that even if acpi-cpufreq gets loaded first, it errors out
on K8s and powernow-k8 can be loaded then successfully.

Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>
Link: http://lkml.kernel.org/r/20130118162347.GA31499@srcf.ucam.org
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 drivers/cpufreq/acpi-cpufreq.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 0d048f6a2b23..31b06bbab54c 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -762,6 +762,12 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
 
 	switch (perf->control_register.space_id) {
 	case ACPI_ADR_SPACE_SYSTEM_IO:
+		if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
+		    boot_cpu_data.x86 == 0xf) {
+			pr_debug("AMD K8 systems must use native drivers.\n");
+			result = -ENODEV;
+			goto err_unreg;
+		}
 		pr_debug("SYSTEM IO addr space\n");
 		data->cpu_feature = SYSTEM_IO_CAPABLE;
 		break;
-- 
1.8.1.rc3

