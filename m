Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965602AbaKLBtE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:49:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60860 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965560AbaKLBsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:48:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Streetman <ddstreet@ieee.org>,
        Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 3.14 197/203] powerpc: use device_online/offline() instead of cpu_up/down()
Date: Wed, 12 Nov 2014 10:17:47 +0900
Message-Id: <20141112011551.733243142@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/pseries/dlpar.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/platforms/pseries/dlpar.c
+++ b/arch/powerpc/platforms/pseries/dlpar.c
@@ -380,7 +380,7 @@ static int dlpar_online_cpu(struct devic
 			BUG_ON(get_cpu_current_state(cpu)
 					!= CPU_STATE_OFFLINE);
 			cpu_maps_update_done();
-			rc = cpu_up(cpu);
+			rc = device_online(get_cpu_device(cpu));
 			if (rc)
 				goto out;
 			cpu_maps_update_begin();
@@ -463,7 +463,7 @@ static int dlpar_offline_cpu(struct devi
 			if (get_cpu_current_state(cpu) == CPU_STATE_ONLINE) {
 				set_preferred_offline_state(cpu, CPU_STATE_OFFLINE);
 				cpu_maps_update_done();
-				rc = cpu_down(cpu);
+				rc = device_offline(get_cpu_device(cpu));
 				if (rc)
 					goto out;
 				cpu_maps_update_begin();


