Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758909Ab3EIWnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:43:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46297 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758404Ab3EIWeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:34:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Sandeen <sandeen@redhat.com>, "Theodore Tso" <tytso@mit.edu>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Lingzhu Xiang <lxiang@redhat.com>
Subject: [ 09/26] ext4: add check for inodes_count overflow in new resize ioctl
Date: Thu,  9 May 2013 15:34:23 -0700
Message-Id: <20130509223423.413283929@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509223422.368544659@linuxfoundation.org>
References: <20130509223422.368544659@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 3f8a6411fbada1fa482276591e037f3b1adcf55b upstream.

Addresses-Red-Hat-Bugzilla: #913245

Reported-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Lingzhu Xiang <lxiang@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/resize.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1630,6 +1630,10 @@ int ext4_resize_fs(struct super_block *s
 		return 0;
 
 	ext4_get_group_no_and_offset(sb, n_blocks_count - 1, &n_group, &offset);
+	if (n_group > (0xFFFFFFFFUL / EXT4_INODES_PER_GROUP(sb))) {
+		ext4_warning(sb, "resize would cause inodes_count overflow");
+		return -EINVAL;
+	}
 	ext4_get_group_no_and_offset(sb, o_blocks_count - 1, &o_group, &offset);
 
 	n_desc_blocks = (n_group + EXT4_DESC_PER_BLOCK(sb)) /


