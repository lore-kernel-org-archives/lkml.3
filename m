Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727AbaDXVw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 17:52:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39716 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445AbaDXVqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:46:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Josef Bacik <jbacik@fb.com>
Subject: [PATCH 3.10 10/23] Btrfs: skip submitting barrier for missing device
Date: Thu, 24 Apr 2014 14:48:40 -0700
Message-Id: <20140424214827.213305119@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140424214825.933835556@linuxfoundation.org>
References: <20140424214825.933835556@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

commit f88ba6a2a44ee98e8d59654463dc157bb6d13c43 upstream.

I got an error on v3.13:
 BTRFS error (device sdf1) in write_all_supers:3378: errno=-5 IO failure (errors while submitting device barriers.)

how to reproduce:
  > mkfs.btrfs -f -d raid1 /dev/sdf1 /dev/sdf2
  > wipefs -a /dev/sdf2
  > mount -o degraded /dev/sdf1 /mnt
  > btrfs balance start -f -sconvert=single -mconvert=single -dconvert=single /mnt

The reason of the error is that barrier_all_devices() failed to submit
barrier to the missing device.  However it is clear that we cannot do
anything on missing device, and also it is not necessary to care chunks
on the missing device.

This patch stops sending/waiting barrier if device is missing.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Signed-off-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/disk-io.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3161,6 +3161,8 @@ static int barrier_all_devices(struct bt
 	/* send down all the barriers */
 	head = &info->fs_devices->devices;
 	list_for_each_entry_rcu(dev, head, dev_list) {
+		if (dev->missing)
+			continue;
 		if (!dev->bdev) {
 			errors_send++;
 			continue;
@@ -3175,6 +3177,8 @@ static int barrier_all_devices(struct bt
 
 	/* wait for all the barriers */
 	list_for_each_entry_rcu(dev, head, dev_list) {
+		if (dev->missing)
+			continue;
 		if (!dev->bdev) {
 			errors_wait++;
 			continue;


