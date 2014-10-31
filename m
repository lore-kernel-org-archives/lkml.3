Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939AbaJaTly (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 15:41:54 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:63770 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758145AbaJaTlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 15:41:52 -0400
From: Dan Streetman <ddstreet@ieee.org>
To: Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Cc: Dan Streetman <ddstreet@ieee.org>, Paul Mackerras <paulus@samba.org>,
        Thomas Falcon <tlfalcon@linux.vnet.ibm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Walter <dwalter@google.com>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Neil Zhang <zhangwm@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] powerpc: use device_online/offline() instead of cpu_up/down()
Date: Fri, 31 Oct 2014 15:41:34 -0400
Message-Id: <1414784494-12573-1-git-send-email-ddstreet@ieee.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <CALZtONCwrBb+HPY7j7x4R-xmyhajFNCwaS3sns50RMDxHxyiEQ@mail.gmail.com>
References: <CALZtONCwrBb+HPY7j7x4R-xmyhajFNCwaS3sns50RMDxHxyiEQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In powerpc pseries platform dlpar operations, Use device_online() and
device_offline() instead of cpu_up() and cpu_down().

Calling cpu_up/down directly does not update the cpu device offline
field, which is used to online/offline a cpu from sysfs.  Calling
device_online/offline instead keeps the sysfs cpu online value correct.
The hotplug lock, which is required to be held when calling
device_online/offline, is already held when dlpar_online/offline_cpu
are called, since they are called only from cpu_probe|release_store.

This patch fixes errors on PowerVM systems that have cpu(s) added/removed
using dlpar operations; without this patch, the
/sys/devices/system/cpu/cpuN/online nodes do not correctly show the
online state of added/removed cpus.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>
---

Previous discussion for this:
https://lkml.org/lkml/2014/10/29/839

 arch/powerpc/platforms/pseries/dlpar.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/dlpar.c b/arch/powerpc/platforms/pseries/dlpar.c
index 6ad83bd..c22bb1b 100644
--- a/arch/powerpc/platforms/pseries/dlpar.c
+++ b/arch/powerpc/platforms/pseries/dlpar.c
@@ -382,7 +382,7 @@ static int dlpar_online_cpu(struct device_node *dn)
 			BUG_ON(get_cpu_current_state(cpu)
 					!= CPU_STATE_OFFLINE);
 			cpu_maps_update_done();
-			rc = cpu_up(cpu);
+			rc = device_online(get_cpu_device(cpu));
 			if (rc)
 				goto out;
 			cpu_maps_update_begin();
@@ -467,7 +467,7 @@ static int dlpar_offline_cpu(struct device_node *dn)
 			if (get_cpu_current_state(cpu) == CPU_STATE_ONLINE) {
 				set_preferred_offline_state(cpu, CPU_STATE_OFFLINE);
 				cpu_maps_update_done();
-				rc = cpu_down(cpu);
+				rc = device_offline(get_cpu_device(cpu));
 				if (rc)
 					goto out;
 				cpu_maps_update_begin();
-- 
1.8.3.1

