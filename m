Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab3EMTjg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 15:39:36 -0400
Received: from kanga.kvack.org ([205.233.56.17]:57724 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229Ab3EMTjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 15:39:35 -0400
Date: Mon, 13 May 2013 15:39:34 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Corey Minyard <minyard@acm.org>
Cc: openipmi-developer@lists.sourceforge.net,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ipmi: ipmi_devintf: compat_ioctl method failes to take ipmi_mutex
Message-ID: <20130513193934.GA17394@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a 32 bit version of ipmitool is used on a 64 bit kernel, the
ipmi_devintf code fails to correctly acquire ipmi_mutex.  This results in
incomplete data being retrieved in some cases, or other possible failures.
Add a wrapper around compat_ipmi_ioctl() to take ipmi_mutex to fix this.
This is probably a candidate for -stable as well.

Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
---
 drivers/char/ipmi/ipmi_devintf.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

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
1.7.4.1


-- 
"Thought is the essence of where you are now."
