Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbaKROMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:12:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57040 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755155AbaKROKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:32 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dan Streetman <ddstreet@ieee.org>,
        Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 198/206] powerpc: use device_online/offline() instead of cpu_up/down()
Date: Tue, 18 Nov 2014 15:09:13 +0100
Message-Id: <8f9363f79d0b7cfb70f2dcec99719f6a53359d97.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Streetman <ddstreet@ieee.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/powerpc/platforms/pseries/dlpar.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/dlpar.c b/arch/powerpc/platforms/pseries/dlpar.c
index 7cfdaae1721a..679df556f4ab 100644
--- a/arch/powerpc/platforms/pseries/dlpar.c
+++ b/arch/powerpc/platforms/pseries/dlpar.c
@@ -380,7 +380,7 @@ static int dlpar_online_cpu(struct device_node *dn)
 			BUG_ON(get_cpu_current_state(cpu)
 					!= CPU_STATE_OFFLINE);
 			cpu_maps_update_done();
-			rc = cpu_up(cpu);
+			rc = device_online(get_cpu_device(cpu));
 			if (rc)
 				goto out;
 			cpu_maps_update_begin();
@@ -471,7 +471,7 @@ static int dlpar_offline_cpu(struct device_node *dn)
 			if (get_cpu_current_state(cpu) == CPU_STATE_ONLINE) {
 				set_preferred_offline_state(cpu, CPU_STATE_OFFLINE);
 				cpu_maps_update_done();
-				rc = cpu_down(cpu);
+				rc = device_offline(get_cpu_device(cpu));
 				if (rc)
 					goto out;
 				cpu_maps_update_begin();
-- 
2.1.3

