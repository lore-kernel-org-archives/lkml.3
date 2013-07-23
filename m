Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934529Ab3GWW41 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:56:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41494 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934128Ab3GWW1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 015/103] powerpc/numa: Do not update sysfs cpu registration from invalid context
Date: Tue, 23 Jul 2013 15:25:26 -0700
Message-Id: <20130723220420.290001879@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Fontenot <nfont@linux.vnet.ibm.com>

commit dd023217e17e72b46fb4d49c7734c426938c3dba upstream.

The topology update code that updates the cpu node registration in sysfs
should not be called while in stop_machine(). The register/unregister
calls take a lock and may sleep.

This patch moves these calls outside of the call to stop_machine().

Signed-off-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/mm/numa.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -1433,11 +1433,9 @@ static int update_cpu_topology(void *dat
 		if (cpu != update->cpu)
 			continue;
 
-		unregister_cpu_under_node(update->cpu, update->old_nid);
 		unmap_cpu_from_node(update->cpu);
 		map_cpu_to_node(update->cpu, update->new_nid);
 		vdso_getcpu_init();
-		register_cpu_under_node(update->cpu, update->new_nid);
 	}
 
 	return 0;
@@ -1485,6 +1483,9 @@ int arch_update_cpu_topology(void)
 	stop_machine(update_cpu_topology, &updates[0], &updated_cpus);
 
 	for (ud = &updates[0]; ud; ud = ud->next) {
+		unregister_cpu_under_node(ud->cpu, ud->old_nid);
+		register_cpu_under_node(ud->cpu, ud->new_nid);
+
 		dev = get_cpu_device(ud->cpu);
 		if (dev)
 			kobject_uevent(&dev->kobj, KOBJ_CHANGE);


