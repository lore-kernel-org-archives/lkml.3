Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857Ab3GKWCH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:02:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43112 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756700Ab3GKWBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:01:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 18/19] cpufreq: Fix cpufreq regression after suspend/resume
Date: Thu, 11 Jul 2013 15:01:35 -0700
Message-Id: <20130711214832.686008000@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130711214830.611455274@linuxfoundation.org>
References: <20130711214830.611455274@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>

commit f51e1eb63d9c28cec188337ee656a13be6980cfd upstream.

Toralf Förster reported that the cpufreq ondemand governor behaves erratically
(doesn't scale well) after a suspend/resume cycle. The problem was that the
cpufreq subsystem's idea of the cpu frequencies differed from the actual
frequencies set in the hardware after a suspend/resume cycle. Toralf bisected
the problem to commit a66b2e5 (cpufreq: Preserve sysfs files across
suspend/resume).

Among other (harmless) things, that commit skipped the call to
cpufreq_update_policy() in the resume path. But cpufreq_update_policy() plays
an important role during resume, because it is responsible for checking if
the BIOS changed the cpu frequencies behind our back and resynchronize the
cpufreq subsystem's knowledge of the cpu frequencies, and update them
accordingly.

So, restore the call to cpufreq_update_policy() in the resume path to fix
the cpufreq regression.

Reported-and-tested-by: Toralf Förster <toralf.foerster@gmx.de>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/cpufreq_stats.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -349,6 +349,7 @@ static int __cpuinit cpufreq_stat_cpu_ca
 
 	switch (action) {
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		cpufreq_update_policy(cpu);
 		break;
 	case CPU_DOWN_PREPARE:


