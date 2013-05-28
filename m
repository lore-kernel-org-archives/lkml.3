Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933495Ab3E1D4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:56:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52511 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758949Ab3E1DyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:23 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Corey Minyard" <cminyard@mvista.com>,
        "Benjamin LaHaise" <bcrl@kvack.org>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.638417539@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [42/94] ipmi: ipmi_devintf: compat_ioctl method fails to take
 ipmi_mutex
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/char/ipmi/ipmi_devintf.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/char/ipmi/ipmi_devintf.c
+++ b/drivers/char/ipmi/ipmi_devintf.c
@@ -838,13 +838,25 @@ static long compat_ipmi_ioctl(struct fil
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

