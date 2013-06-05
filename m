Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933237Ab3FEViL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:38:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38113 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933184Ab3FEVgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:36:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wenchao Xia <xiawenc@linux.vnet.ibm.com>,
        Badari Pulavarty <pbadari@us.ibm.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Lingzhu Xiang <lxiang@redhat.com>
Subject: [ 118/127] target/file: Fix off-by-one READ_CAPACITY bug for !S_ISBLK export
Date: Wed,  5 Jun 2013 14:34:45 -0700
Message-Id: <20130605213231.391789216@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 21363ca873334391992f2f424856aa864345bb61 upstream.

This patch fixes a bug where FILEIO was incorrectly reporting the number
of logical blocks (+ 1) when using non struct block_device export mode.

It changes fd_get_blocks() to follow all other backend ->get_blocks() cases,
and reduces the calculated dev_size by one dev->dev_attrib.block_size
number of bytes, and also fixes initial fd_block_size assignment at
fd_configure_device() time introduced in commit 0fd97ccf4.

Reported-by: Wenchao Xia <xiawenc@linux.vnet.ibm.com>
Reported-by: Badari Pulavarty <pbadari@us.ibm.com>
Tested-by: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Lingzhu Xiang <lxiang@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_file.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -150,6 +150,7 @@ static int fd_configure_device(struct se
 	if (S_ISBLK(inode->i_mode)) {
 		unsigned long long dev_size;
 
+		fd_dev->fd_block_size = bdev_logical_block_size(inode->i_bdev);
 		/*
 		 * Determine the number of bytes from i_size_read() minus
 		 * one (1) logical sector from underlying struct block_device
@@ -168,11 +169,11 @@ static int fd_configure_device(struct se
 				" block_device\n");
 			goto fail;
 		}
-	}
 
-	fd_dev->fd_block_size = dev->dev_attrib.hw_block_size;
+		fd_dev->fd_block_size = FD_BLOCKSIZE;
+	}
 
-	dev->dev_attrib.hw_block_size = FD_BLOCKSIZE;
+	dev->dev_attrib.hw_block_size = fd_dev->fd_block_size;
 	dev->dev_attrib.hw_max_sectors = FD_MAX_SECTORS;
 	dev->dev_attrib.hw_queue_depth = FD_MAX_DEVICE_QUEUE_DEPTH;
 
@@ -583,11 +584,12 @@ static sector_t fd_get_blocks(struct se_
 	 * to handle underlying block_device resize operations.
 	 */
 	if (S_ISBLK(i->i_mode))
-		dev_size = (i_size_read(i) - fd_dev->fd_block_size);
+		dev_size = i_size_read(i);
 	else
 		dev_size = fd_dev->fd_dev_size;
 
-	return div_u64(dev_size, dev->dev_attrib.block_size);
+	return div_u64(dev_size - dev->dev_attrib.block_size,
+		       dev->dev_attrib.block_size);
 }
 
 static struct sbc_ops fd_sbc_ops = {


