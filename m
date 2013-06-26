Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab3FZCro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 22:47:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54111 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751445Ab3FZCp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 22:45:26 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jens Axboe" <axboe@kernel.dk>,
        "Vivek Goyal" <vgoyal@redhat.com>
Date: Wed, 26 Jun 2013 03:35:58 +0100
Message-ID: <lsq.1372214158.568207111@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [11/26] virtio-blk: Call revalidate_disk() upon online disk resize
In-Reply-To: <lsq.1372214158.425780530@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.48-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Vivek Goyal <vgoyal@redhat.com>

commit e9986f303dc0f285401de28cf96f42f4dd23a4a1 upstream.

If a virtio disk is open in guest and a disk resize operation is done,
(virsh blockresize), new size is not visible to tools like "fdisk -l".
This seems to be happening as we update only part->nr_sects and not
bdev->bd_inode size.

Call revalidate_disk() which should take care of it. I tested growing disk
size of already open disk and it works for me.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/block/virtio_blk.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -343,6 +343,7 @@ static void virtblk_config_changed_work(
 		  cap_str_10, cap_str_2);
 
 	set_capacity(vblk->disk, capacity);
+	revalidate_disk(vblk->disk);
 done:
 	mutex_unlock(&vblk->config_lock);
 }

