Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434AbaBEUXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:23:54 -0500
Received: from mail.windriver.com ([147.11.1.11]:55434 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190AbaBEUH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:07:28 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Eric Sandeen <sandeen@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 166/213] jbd2: clear BH_Delay & BH_Unwritten in journal_unmap_buffer
Date: Wed, 5 Feb 2014 15:02:01 -0500
Message-ID: <1391630568-49251-167-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 15291164b22a357cb211b618adfef4fa82fc0de3 upstream.

journal_unmap_buffer()'s zap_buffer: code clears a lot of buffer head
state ala discard_buffer(), but does not touch _Delay or _Unwritten as
discard_buffer() does.

This can be problematic in some areas of the ext4 code which assume
that if they have found a buffer marked unwritten or delay, then it's
a live one.  Perhaps those spots should check whether it is mapped
as well, but if jbd2 is going to tear down a buffer, let's really
tear it down completely.

Without this I get some fsx failures on sub-page-block filesystems
up until v3.2, at which point 4e96b2dbbf1d7e81f22047a50f862555a6cb87cb
and 189e868fa8fdca702eb9db9d8afc46b5cb9144c9 make the failures go
away, because buried within that large change is some more flag
clearing.  I still think it's worth doing in jbd2, since
->invalidatepage leads here directly, and it's the right place
to clear away these flags.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/jbd2/transaction.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index bfc70f57900f..ed89123a240f 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1836,6 +1836,8 @@ zap_buffer_unlocked:
 	clear_buffer_mapped(bh);
 	clear_buffer_req(bh);
 	clear_buffer_new(bh);
+	clear_buffer_delay(bh);
+	clear_buffer_unwritten(bh);
 	bh->b_bdev = NULL;
 	return may_free;
 }
-- 
1.8.5.2

