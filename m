Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341AbaJ1IGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 04:06:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44286 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585AbaJ1DgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:36:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andreas Schneider <asn@cryptomilk.org>,
        Filipe Manana <fdmanana@suse.com>, Chris Mason <clm@fb.com>
Subject: [PATCH 3.17 004/146] Btrfs: add missing compression property remove in btrfs_ioctl_setflags
Date: Tue, 28 Oct 2014 11:32:26 +0800
Message-Id: <20141028033343.631036397@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit 78a017a2c92df9b571db0a55a016280f9019c65e upstream.

The behaviour of a 'chattr -c' consists of getting the current flags,
clearing the FS_COMPR_FL bit and then sending the result to the set
flags ioctl - this means the bit FS_NOCOMP_FL isn't set in the flags
passed to the ioctl. This results in the compression property not being
cleared from the inode - it was cleared only if the bit FS_NOCOMP_FL
was set in the received flags.

Reproducer:

    $ mkfs.btrfs -f /dev/sdd
    $ mount /dev/sdd /mnt && cd /mnt
    $ mkdir a
    $ chattr +c a
    $ touch a/file
    $ lsattr a/file
    --------c------- a/file
    $ chattr -c a
    $ touch a/file2
    $ lsattr a/file2
    --------c------- a/file2
    $ lsattr -d a
    ---------------- a

Reported-by: Andreas Schneider <asn@cryptomilk.org>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/ioctl.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -332,6 +332,9 @@ static int btrfs_ioctl_setflags(struct f
 			goto out_drop;
 
 	} else {
+		ret = btrfs_set_prop(inode, "btrfs.compression", NULL, 0, 0);
+		if (ret && ret != -ENODATA)
+			goto out_drop;
 		ip->flags &= ~(BTRFS_INODE_COMPRESS | BTRFS_INODE_NOCOMPRESS);
 	}
 


