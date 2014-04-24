Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbaDXJDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:03:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47161 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203AbaDXI4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:56:34 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 177/182] topology: Fix compilation warning when not in SMP
Date: Thu, 24 Apr 2014 09:51:42 +0100
Message-Id: <1398329507-5911-178-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>

commit 53974e06603977f348ed978d75c426b0532daa67 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/base/topology.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/base/topology.c b/drivers/base/topology.c
index 2f5919e..7d0066b 100644
--- a/drivers/base/topology.c
+++ b/drivers/base/topology.c
@@ -40,8 +40,7 @@
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

