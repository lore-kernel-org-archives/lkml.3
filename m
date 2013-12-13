Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab3LMQzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 11:55:55 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:53221 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab3LMQzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 11:55:53 -0500
MIME-Version: 1.0
Date: Sat, 14 Dec 2013 00:55:53 +0800
Message-ID: <CAAdffVGw9Fz1AzAWs5y2943R3JsTvaCvQN1kipCdpeK+Guv_JQ@mail.gmail.com>
Subject: [PATCH] scsi: integer overflow in megadev_ioctl()
From: Yu Chen <chyyuu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: megaraidlinux@lsi.com, xiaoqixue_1 <xiaoqixue_1@163.com>,
        =?GB2312?B?t7bOxMG8?= <fanwlexca@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a potential integer overflow in megadev_ioctl() if
userspace passes in a large u32 variable uioc.adapno. The
int variable adapno would < 0, leading to a error array access
for hdb_soft_state[adapno].

Reported-by: Wenliang Fan <fanwlexca@gmail.com>
Suggested-by: Qixue Xiao <xiaoqixue_1@163.com>
Signed-off-by: Yu Chen <chyyuu@gmail.com>
---
 drivers/scsi/megaraid.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 816db12..41bbc21 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -3113,7 +3113,8 @@ megadev_ioctl(struct file *filep, unsigned int
cmd, unsigned long arg)
  /*
  * Which adapter
  */
- if( (adapno = GETADAP(uioc.adapno)) >= hba_count )
+                adapno = GETADAP(uioc.adapno);
+ if( adapno >= hba_count || adapno < 0 )
  return (-ENODEV);

  adapter = hba_soft_state[adapno];
-- 
1.8.3.2
