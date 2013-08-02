Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759555Ab3HBKJs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:09:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37188 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759444Ab3HBKJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:09:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Miao Xie <miaox@cn.fujitsu.com>,
        Stefan Behrens <sbehrens@giantdisaster.de>,
        Josef Bacik <jbacik@fusionio.com>
Subject: [ 38/99] Btrfs: fix wrong write offset when replacing a device
Date: Fri,  2 Aug 2013 18:07:51 +0800
Message-Id: <20130802100231.389623825@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Behrens <sbehrens@giantdisaster.de>

commit 115930cb2d444a684975cf2325759cb48ebf80cc upstream.

Miao Xie reported the following issue:

The filesystem was corrupted after we did a device replace.

Steps to reproduce:
 # mkfs.btrfs -f -m single -d raid10 <device0>..<device3>
 # mount <device0> <mnt>
 # btrfs replace start -rfB 1 <device4> <mnt>
 # umount <mnt>
 # btrfsck <device4>

The reason for the issue is that we changed the write offset by mistake,
introduced by commit 625f1c8dc.

We read the data from the source device at first, and then write the
data into the corresponding place of the new device. In order to
implement the "-r" option, the source location is remapped using
btrfs_map_block(). The read takes place on the mapped location, and
the write needs to take place on the unmapped location. Currently
the write is using the mapped location, and this commit changes it
back by undoing the change to the write address that the aforementioned
commit added by mistake.

Reported-by: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/scrub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2501,7 +2501,7 @@ again:
 			ret = scrub_extent(sctx, extent_logical, extent_len,
 					   extent_physical, extent_dev, flags,
 					   generation, extent_mirror_num,
-					   extent_physical);
+					   extent_logical - logical + physical);
 			if (ret)
 				goto out;
 


