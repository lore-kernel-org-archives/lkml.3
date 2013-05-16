Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab3EPUGI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 16:06:08 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:14762 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777Ab3EPUFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 16:05:08 -0400
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 May 2013 16:05:08 EDT
From: Corey Minyard <cminyard@mvista.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
        Benjamin LaHaise <bcrl@kvack.org>, Corey Minyard <cminyard@mvista.com>,
        stable@vger.kernel.org
Subject: [PATCH 4/4] ipmi: ipmi_devintf: compat_ioctl method fails to take
 ipmi_mutex
Date: Thu, 16 May 2013 14:04:27 -0500
Message-id: <1368731067-31404-5-git-send-email-cminyard@mvista.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1368731067-31404-1-git-send-email-cminyard@mvista.com>
References: <1368731067-31404-1-git-send-email-cminyard@mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin LaHaise <bcrl@kvack.org>

When a 32 bit version of ipmitool is used on a 64 bit kernel, the
ipmi_devintf code fails to correctly acquire ipmi_mutex.  This results in
incomplete data being retrieved in some cases, or other possible failures.
Add a wrapper around compat_ipmi_ioctl() to take ipmi_mutex to fix this.

Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Cc: stable@vger.kernel.org
---
 drivers/char/ipmi/ipmi_devintf.c |   14 +++++++++++++-
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
1.7.9.5

