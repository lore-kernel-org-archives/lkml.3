Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab3FEJMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 05:12:13 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:26218 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab3FEJMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 05:12:10 -0400
USER-AGENT: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514
 Thunderbird/17.0.6
MIME-Version: 1.0
Message-ID: <51AF0153.2050704@oracle.com>
Date: Wed, 5 Jun 2013 02:13:55 -0700 (PDT)
From: vaughan <vaughan.cao@oracle.com>
To: Xitao Cao <xitao.cao@gmail.com>
Cc: vaughan.cao@oracle.com, linux-kernel@vger.kernel.org
Subject: [PATCH] [SCSI] sg: atomize check and set sdp->exclude
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check and set sdp->exclude should be atomic when set in sg_open().

Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
---
  drivers/scsi/sg.c | 17 ++++++++++++++++-
  1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 25b5455..0ede08f 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -245,6 +245,21 @@ static int set_exclude(Sg_device *sdp, char val)
      return val;
  }

+/* Check if we can set exclude and then set, return 1 if success */
+static int try_set_exclude(Sg_device *sdp)
+{
+    unsigned long flags;
+
+    spin_lock_irqsave(&sg_open_exclusive_lock, flags);
+    if (sdp->exclude) {
+        spin_unlock_irqrestore(&sg_open_exclusive_lock, flags);
+        return 0;
+    }
+    sdp->exclude = 1;
+    spin_unlock_irqrestore(&sg_open_exclusive_lock, flags);
+    return 1;
+}
+
  static int sfds_list_empty(Sg_device *sdp)
  {
      unsigned long flags;
@@ -303,7 +318,7 @@ sg_open(struct inode *inode, struct file *filp)
              goto error_out;
          }
          res = wait_event_interruptible(sdp->o_excl_wait,
-                       ((!sfds_list_empty(sdp) || get_exclude(sdp)) ? 0 
: set_exclude(sdp, 1)));
+            ((!sfds_list_empty(sdp) || get_exclude(sdp)) ? 0 : 
try_set_exclude(sdp)));
          if (res) {
              retval = res;    /* -ERESTARTSYS because signal hit process */
              goto error_out;
-- 
1.7.11.7

