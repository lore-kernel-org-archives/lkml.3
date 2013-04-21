Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab3DUAH0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 20:07:26 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:43171 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756025Ab3DUAHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 20:07:24 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: linux-mm@kvack.org,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        mgorman@suse.de, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 2/3] buffer: add BH_Prio and BH_Meta flags
Date: Sat, 20 Apr 2013 20:07:07 -0400
Message-Id: <1366502828-7793-2-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.12.rc0.22.gcdd159b
In-Reply-To: <1366502828-7793-1-git-send-email-tytso@mit.edu>
References: <20130421000522.GA5054@thunk.org>
 <1366502828-7793-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add buffer_head flags so that buffer cache writebacks can be marked
with the the appropriate request flags, so that metadata blocks can be
marked appropriately in blktrace.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/buffer.c                 | 5 +++++
 include/linux/buffer_head.h | 4 ++++
 2 files changed, 9 insertions(+)

diff --git a/fs/buffer.c b/fs/buffer.c
index b4dcb34..a15575c 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2988,6 +2988,11 @@ int submit_bh(int rw, struct buffer_head * bh)
 	/* Take care of bh's that straddle the end of the device */
 	guard_bh_eod(rw, bio, bh);
 
+	if (buffer_meta(bh))
+		rw |= REQ_META;
+	if (buffer_prio(bh))
+		rw |= REQ_PRIO;
+
 	bio_get(bio);
 	submit_bio(rw, bio);
 
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 5afc4f9..33c0f81 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -34,6 +34,8 @@ enum bh_state_bits {
 	BH_Write_EIO,	/* I/O error on write */
 	BH_Unwritten,	/* Buffer is allocated on disk but not written */
 	BH_Quiet,	/* Buffer Error Prinks to be quiet */
+	BH_Meta,	/* Buffer contains metadata */
+	BH_Prio,	/* Buffer should be submitted with REQ_PRIO */
 
 	BH_PrivateStart,/* not a state bit, but the first bit available
 			 * for private allocation by other entities
@@ -124,6 +126,8 @@ BUFFER_FNS(Delay, delay)
 BUFFER_FNS(Boundary, boundary)
 BUFFER_FNS(Write_EIO, write_io_error)
 BUFFER_FNS(Unwritten, unwritten)
+BUFFER_FNS(Meta, meta)
+BUFFER_FNS(Prio, prio)
 
 #define bh_offset(bh)		((unsigned long)(bh)->b_data & ~PAGE_MASK)
 
-- 
1.7.12.rc0.22.gcdd159b

