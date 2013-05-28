Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934529Ab3E1V0m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:26:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59870 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933713Ab3E1V0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:26:35 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benjamin LaHaise <bcrl@kvack.org>, Corey Minyard <cminyard@mvista.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 52/78] ipmi: ipmi_devintf: compat_ioctl method fails to take ipmi_mutex
Date: Tue, 28 May 2013 14:20:01 -0700
Message-Id: <1369776027-17859-53-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin LaHaise <bcrl@kvack.org>

commit 6368087e851e697679af059b4247aca33a69cef3 upstream.

When a 32 bit version of ipmitool is used on a 64 bit kernel, the
ipmi_devintf code fails to correctly acquire ipmi_mutex.  This results in
incomplete data being retrieved in some cases, or other possible failures.
Add a wrapper around compat_ipmi_ioctl() to take ipmi_mutex to fix this.

Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/char/ipmi/ipmi_devintf.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/char/ipmi/ipmi_devintf.c b/drivers/char/ipmi/ipmi_devintf.c
index 9eb360f..d5a5f02 100644
--- a/drivers/char/ipmi/ipmi_devintf.c
+++ b/drivers/char/ipmi/ipmi_devintf.c
@@ -837,13 +837,25 @@ static long compat_ipmi_ioctl(struct file *filep, unsigned int cmd,
 		return ipmi_ioctl(filep, cmd, arg);
 	}
 }
+
+static long unlocked_compat_ipmi_ioctl(struct file *filep, unsigned int cmd,
+				       unsigned long arg)
+{
+	int ret;
+
+	mutex_lock(&ipmi_mutex);
+	ret = compat_ipmi_ioctl(filep, cmd, arg);
+	mutex_unlock(&ipmi_mutex);
+
+	return ret;
+}
 #endif
 
 static const struct file_operations ipmi_fops = {
 	.owner		= THIS_MODULE,
 	.unlocked_ioctl	= ipmi_unlocked_ioctl,
 #ifdef CONFIG_COMPAT
-	.compat_ioctl   = compat_ipmi_ioctl,
+	.compat_ioctl   = unlocked_compat_ipmi_ioctl,
 #endif
 	.open		= ipmi_open,
 	.release	= ipmi_release,
-- 
1.8.1.2

