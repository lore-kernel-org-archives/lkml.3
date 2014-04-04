Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbaDDGnx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:43:53 -0400
Received: from smtp2-g21.free.fr ([212.27.42.2]:52056 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104AbaDDGnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:43:46 -0400
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
To: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        stable@vger.kernel.org
Cc: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] topology: Fix compilation warning when not in SMP
Date: Fri,  4 Apr 2014 08:43:18 +0200
Message-Id: <1396593798-29173-1-git-send-email-vincent.stehle@laposte.net>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The topology_##name() macro does not use its argument when CONFIG_SMP is not
set, as it ultimately calls the cpu_data() macro.

So we avoid maintaining a possibly unused `cpu' variable, to avoid the
following compilation warning:

  drivers/base/topology.c: In function ‘show_physical_package_id’:
  drivers/base/topology.c:103:118: warning: unused variable ‘cpu’ [-Wunused-variable]
   define_id_show_func(physical_package_id);

  drivers/base/topology.c: In function ‘show_core_id’:
  drivers/base/topology.c:106:106: warning: unused variable ‘cpu’ [-Wunused-variable]
   define_id_show_func(core_id);

This can be seen with e.g. x86 defconfig and CONFIG_SMP not set.

Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org> # 3.10.x
Cc: <stable@vger.kernel.org> # 3.13.x
Cc: <stable@vger.kernel.org> # 3.14.x
---
 drivers/base/topology.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/base/topology.c b/drivers/base/topology.c
index ad9d177..c928576 100644
--- a/drivers/base/topology.c
+++ b/drivers/base/topology.c
@@ -39,8 +39,7 @@
 static ssize_t show_##name(struct device *dev,			\
 		struct device_attribute *attr, char *buf)	\
 {								\
-	unsigned int cpu = dev->id;				\
-	return sprintf(buf, "%d\n", topology_##name(cpu));	\
+	return sprintf(buf, "%d\n", topology_##name(dev->id));	\
 }
 
 #if defined(topology_thread_cpumask) || defined(topology_core_cpumask) || \
-- 
1.9.1

