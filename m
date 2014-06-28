Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbaF1SPN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:15:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54185 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913AbaF1Rvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:51:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 3.15 045/139] ext4: fix ZERO_RANGE test failure in data journalling
Date: Sat, 28 Jun 2014 10:46:46 -0700
Message-Id: <20140628174607.492893301@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <namjae.jeon@samsung.com>

commit e1ee60fd89670da61b0a4bda59f8ffb2b8abea63 upstream.

xfstests generic/091 is failing when mounting ext4 with data=journal.
I think that this regression is same problem that occurred prior to collapse
range issue. So ZERO RANGE also need to call ext4_force_commit as
collapse range.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/extents.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4744,6 +4744,13 @@ static long ext4_zero_range(struct file
 	if (!S_ISREG(inode->i_mode))
 		return -EINVAL;
 
+	/* Call ext4_force_commit to flush all data in case of data=journal. */
+	if (ext4_should_journal_data(inode)) {
+		ret = ext4_force_commit(inode->i_sb);
+		if (ret)
+			return ret;
+	}
+
 	/*
 	 * Write out all dirty pages to avoid race conditions
 	 * Then release them.


