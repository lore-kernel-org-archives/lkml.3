Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527AbbAGCQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:16:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46943 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757496AbbAGCQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:16:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        P J P <ppandit@redhat.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH 3.17 01/73] isofs: Fix infinite looping over CE entries
Date: Tue,  6 Jan 2015 18:15:22 -0800
Message-Id: <20150107021557.575867053@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107021557.521276020@linuxfoundation.org>
References: <20150107021557.521276020@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit f54e18f1b831c92f6512d2eedb224cd63d607d3d upstream.

Rock Ridge extensions define so called Continuation Entries (CE) which
define where is further space with Rock Ridge data. Corrupted isofs
image can contain arbitrarily long chain of these, including a one
containing loop and thus causing kernel to end in an infinite loop when
traversing these entries.

Limit the traversal to 32 entries which should be more than enough space
to store all the Rock Ridge data.

Reported-by: P J P <ppandit@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/isofs/rock.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/isofs/rock.c
+++ b/fs/isofs/rock.c
@@ -30,6 +30,7 @@ struct rock_state {
 	int cont_size;
 	int cont_extent;
 	int cont_offset;
+	int cont_loops;
 	struct inode *inode;
 };
 
@@ -73,6 +74,9 @@ static void init_rock_state(struct rock_
 	rs->inode = inode;
 }
 
+/* Maximum number of Rock Ridge continuation entries */
+#define RR_MAX_CE_ENTRIES 32
+
 /*
  * Returns 0 if the caller should continue scanning, 1 if the scan must end
  * and -ve on error.
@@ -105,6 +109,8 @@ static int rock_continue(struct rock_sta
 			goto out;
 		}
 		ret = -EIO;
+		if (++rs->cont_loops >= RR_MAX_CE_ENTRIES)
+			goto out;
 		bh = sb_bread(rs->inode->i_sb, rs->cont_extent);
 		if (bh) {
 			memcpy(rs->buffer, bh->b_data + rs->cont_offset,


