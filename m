Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162723Ab3LFNer (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:34:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44360 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758270Ab3LFNDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:03:17 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 169/272] [media] av7110_hw: Don't use dynamic static allocation
Date: Fri,  6 Dec 2013 12:57:38 +0000
Message-Id: <1386334761-25517-170-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

commit 5bf30b3bc4ff80ef71a733a1f459cca4fa507892 upstream.

Dynamic static allocation is evil, as Kernel stack is too low, and
compilation complains about it on some archs:
	drivers/media/pci/ttpci/av7110_hw.c:510:1: warning: 'av7110_fw_cmd' uses dynamic stack allocation [enabled by default]
Instead, let's enforce a limit for the buffer.
In the specific case of this driver, the maximum fw command size
is 6 + 2, as checked using:
	$ git grep -A1 av7110_fw_cmd drivers/media/pci/ttpci/
So, use 8 for the buffer size.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/pci/ttpci/av7110_hw.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/ttpci/av7110_hw.c b/drivers/media/pci/ttpci/av7110_hw.c
index f1cbfe5..6299d5d 100644
--- a/drivers/media/pci/ttpci/av7110_hw.c
+++ b/drivers/media/pci/ttpci/av7110_hw.c
@@ -22,7 +22,7 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
  *
- * the project's page is at http://www.linuxtv.org/ 
+ * the project's page is at http://www.linuxtv.org/
  */
 
 /* for debugging ARM communication: */
@@ -40,6 +40,14 @@
 
 #define _NOHANDSHAKE
 
+/*
+ * Max transfer size done by av7110_fw_cmd()
+ *
+ * The maximum size passed to this function is 6 bytes. The buffer also
+ * uses two additional ones for type and size. So, 8 bytes is enough.
+ */
+#define MAX_XFER_SIZE  8
+
 /****************************************************************************
  * DEBI functions
  ****************************************************************************/
@@ -488,11 +496,18 @@ static int av7110_send_fw_cmd(struct av7110 *av7110, u16* buf, int length)
 int av7110_fw_cmd(struct av7110 *av7110, int type, int com, int num, ...)
 {
 	va_list args;
-	u16 buf[num + 2];
+	u16 buf[MAX_XFER_SIZE];
 	int i, ret;
 
 //	dprintk(4, "%p\n", av7110);
 
+	if (2 + num > sizeof(buf)) {
+		printk(KERN_WARNING
+		       "%s: %s len=%d is too big!\n",
+		       KBUILD_MODNAME, __func__, num);
+		return -EINVAL;
+	}
+
 	buf[0] = ((type << 8) | com);
 	buf[1] = num;
 
-- 
1.8.3.2

