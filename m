Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760404AbaJ1G5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 02:57:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45602 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245AbaJ1DrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:47:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Sterba <dsterba@suse.cz>, Chris Mason <clm@fb.com>
Subject: [PATCH 3.14 001/100] btrfs: wake up transaction thread from SYNC_FS ioctl
Date: Tue, 28 Oct 2014 11:34:46 +0800
Message-Id: <20141028033500.727822576@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033500.670583608@linuxfoundation.org>
References: <20141028033500.670583608@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.cz>

commit 2fad4e83e12591eb3bd213875b9edc2d18e93383 upstream.

The transaction thread may want to do more work, namely it pokes the
cleaner ktread that will start processing uncleaned subvols.

This can be triggered by user via the 'btrfs fi sync' command, otherwise
there was a delay up to 30 seconds before the cleaner started to clean
old snapshots.

Signed-off-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/ioctl.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4750,6 +4750,12 @@ long btrfs_ioctl(struct file *file, unsi
 		if (ret)
 			return ret;
 		ret = btrfs_sync_fs(file->f_dentry->d_sb, 1);
+		/*
+		 * The transaction thread may want to do more work,
+		 * namely it pokes the cleaner ktread that will start
+		 * processing uncleaned subvols.
+		 */
+		wake_up_process(root->fs_info->transaction_kthread);
 		return ret;
 	}
 	case BTRFS_IOC_START_SYNC:


