Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab3LBTcX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:32:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39705 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025Ab3LBTTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:19:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3.12 193/212] media: av7110_hw: Dont use dynamic static allocation
Date: Mon,  2 Dec 2013 11:16:24 -0800
Message-Id: <20131202191310.480809115@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/pci/ttpci/av7110_hw.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

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
@@ -488,11 +496,18 @@ static int av7110_send_fw_cmd(struct av7
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
 


