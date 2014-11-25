Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbaKYLXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:23:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58670 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbaKYKmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:42:10 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Streetman <ddstreet@ieee.org>,
        Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 132/254] powerpc: use device_online/offline() instead of cpu_up/down()
Date: Tue, 25 Nov 2014 10:38:02 +0000
Message-Id: <1416912004-5928-133-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Streetman <ddstreet@ieee.org>

commit 10ccaf178b2b961d8bca252d647ed7ed8aae2a20 upstream.

In powerpc pseries platform dlpar operations, use device_online() and
device_offline() instead of cpu_up() and cpu_down().

Calling cpu_up/down() directly does not update the cpu device offline
field, which is used to online/offline a cpu from sysfs. Calling
device_online/offline() instead keeps the sysfs cpu online value
correct. The hotplug lock, which is required to be held when calling
device_online/offline(), is already held when dlpar_online/offline_cpu()
are called, since they are called only from cpu_probe|release_store().

This patch fixes errors on phyp (PowerVM) systems that have cpu(s)
added/removed using dlpar operations; without this patch, the
/sys/devices/system/cpu/cpuN/online nodes do not correctly show the
online state of added/removed cpus.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Fixes: 0902a9044fa5 ("Driver core: Use generic offline/online for CPU offline/online")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/platforms/pseries/dlpar.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/dlpar.c b/arch/powerpc/platforms/pseries/dlpar.c
index 2d0b4d68a40a..c89787d43dd1 100644
--- a/arch/powerpc/platforms/pseries/dlpar.c
+++ b/arch/powerpc/platforms/pseries/dlpar.c
@@ -379,7 +379,7 @@ static int dlpar_online_cpu(struct device_node *dn)
 			BUG_ON(get_cpu_current_state(cpu)
 					!= CPU_STATE_OFFLINE);
 			cpu_maps_update_done();
-			rc = cpu_up(cpu);
+			rc = device_online(get_cpu_device(cpu));
 			if (rc)
 				goto out;
 			cpu_maps_update_begin();
@@ -462,7 +462,7 @@ static int dlpar_offline_cpu(struct device_node *dn)
 			if (get_cpu_current_state(cpu) == CPU_STATE_ONLINE) {
 				set_preferred_offline_state(cpu, CPU_STATE_OFFLINE);
 				cpu_maps_update_done();
-				rc = cpu_down(cpu);
+				rc = device_offline(get_cpu_device(cpu));
 				if (rc)
 					goto out;
 				cpu_maps_update_begin();
-- 
2.1.0

