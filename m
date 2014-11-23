Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbaKWOYI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 09:24:08 -0500
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:40686 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751849AbaKWOYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 09:24:06 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: "Ira W. Snyder" <iws@ovro.caltech.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/3] carma-fpga-program.c: fix compile errors
Date: Sun, 23 Nov 2014 15:23:48 +0100
Message-Id: <1416752630-47360-2-git-send-email-hverkuil@xs4all.nl>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1416752630-47360-1-git-send-email-hverkuil@xs4all.nl>
References: <1416752630-47360-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/misc/carma/carma-fpga-program.c: In function 'fpga_program_dma':
drivers/misc/carma/carma-fpga-program.c:529:2: error: expected ';' before 'if'
  if (ret) {
  ^
drivers/misc/carma/carma-fpga-program.c: In function 'fpga_read':
drivers/misc/carma/carma-fpga-program.c:752:45: error: 'ppos' undeclared (first use in this function)
  return simple_read_from_buffer(buf, count, ppos,
                                             ^
drivers/misc/carma/carma-fpga-program.c:752:45: note: each undeclared identifier is reported only once for each function it appears in
drivers/misc/carma/carma-fpga-program.c: In function 'fpga_llseek':
drivers/misc/carma/carma-fpga-program.c:765:27: error: 'file' undeclared (first use in this function)
  return fixed_size_llseek(file, offset, origin, priv->fw_size);
                           ^
drivers/misc/carma/carma-fpga-program.c:759:9: warning: unused variable 'newpos' [-Wunused-variable]
  loff_t newpos;
         ^
drivers/misc/carma/carma-fpga-program.c: In function 'fpga_read':
drivers/misc/carma/carma-fpga-program.c:754:1: warning: control reaches end of non-void function [-Wreturn-type]
 }
 ^
drivers/misc/carma/carma-fpga-program.c: In function 'fpga_llseek':
drivers/misc/carma/carma-fpga-program.c:766:1: warning: control reaches end of non-void function [-Wreturn-type]
 }
 ^
scripts/Makefile.build:263: recipe for target 'drivers/misc/carma/carma-fpga-program.o' failed

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/misc/carma/carma-fpga-program.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/carma/carma-fpga-program.c b/drivers/misc/carma/carma-fpga-program.c
index 339b252..eb8942b 100644
--- a/drivers/misc/carma/carma-fpga-program.c
+++ b/drivers/misc/carma/carma-fpga-program.c
@@ -525,7 +525,7 @@ static noinline int fpga_program_dma(struct fpga_dev *priv)
 		goto out_dma_unmap;
 	}
 
-	ret = fsl_dma_external_start(chan, 1)
+	ret = fsl_dma_external_start(chan, 1);
 	if (ret) {
 		dev_err(priv->dev, "DMA external control setup failed\n");
 		goto out_dma_unmap;
@@ -749,20 +749,19 @@ static ssize_t fpga_read(struct file *filp, char __user *buf, size_t count,
 			 loff_t *f_pos)
 {
 	struct fpga_dev *priv = filp->private_data;
-	return simple_read_from_buffer(buf, count, ppos,
+	return simple_read_from_buffer(buf, count, f_pos,
 				       priv->vb.vaddr, priv->bytes);
 }
 
 static loff_t fpga_llseek(struct file *filp, loff_t offset, int origin)
 {
 	struct fpga_dev *priv = filp->private_data;
-	loff_t newpos;
 
 	/* only read-only opens are allowed to seek */
 	if ((filp->f_flags & O_ACCMODE) != O_RDONLY)
 		return -EINVAL;
 
-	return fixed_size_llseek(file, offset, origin, priv->fw_size);
+	return fixed_size_llseek(filp, offset, origin, priv->fw_size);
 }
 
 static const struct file_operations fpga_fops = {
-- 
2.1.3

