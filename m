Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167AbaD1Bbc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:31:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42935 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752637AbaD1B3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>,
        "Josef Bacik" <jbacik@fb.com>
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.937284052@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 40/94] Btrfs: skip submitting barrier for missing device
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/disk-io.c | 4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2731,6 +2731,8 @@ static int barrier_all_devices(struct bt
 	/* send down all the barriers */
 	head = &info->fs_devices->devices;
 	list_for_each_entry_rcu(dev, head, dev_list) {
+		if (dev->missing)
+			continue;
 		if (!dev->bdev) {
 			errors++;
 			continue;
@@ -2745,6 +2747,8 @@ static int barrier_all_devices(struct bt
 
 	/* wait for all the barriers */
 	list_for_each_entry_rcu(dev, head, dev_list) {
+		if (dev->missing)
+			continue;
 		if (!dev->bdev) {
 			errors++;
 			continue;

