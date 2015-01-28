Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023AbbA2JCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:02:12 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44762 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752723AbbA2JCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:02:07 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Christian Riesch <christian.riesch@omicron.at>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 038/176] n_tty: Fix read_buf race condition, increment read_head after pushing data
Date: Wed, 28 Jan 2015 15:27:48 +0100
Message-Id: <fcd05986ca4be59515477a117324651386aa2142.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Riesch <christian.riesch@omicron.at>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 8bfbe2de769afda051c56aba5450391670e769fc upstream.

Commit 19e2ad6a09f0c06dbca19c98e5f4584269d913dd ("n_tty: Remove overflow
tests from receive_buf() path") moved the increment of read_head into
the arguments list of read_buf_addr(). Function calls represent a
sequence point in C. Therefore read_head is incremented before the
character c is placed in the buffer. Since the circular read buffer is
a lock-less design since commit 6d76bd2618535c581f1673047b8341fd291abc67
("n_tty: Make N_TTY ldisc receive path lockless"), this creates a race
condition that leads to communication errors.

This patch modifies the code to increment read_head _after_ the data
is placed in the buffer and thus fixes the race for non-SMP machines.
To fix the problem for SMP machines, memory barriers must be added in
a separate patch.

Signed-off-by: Christian Riesch <christian.riesch@omicron.at>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/n_tty.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 1197767b3019..d711dbb6d9fb 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -319,7 +319,8 @@ static void n_tty_check_unthrottle(struct tty_struct *tty)
 
 static inline void put_tty_queue(unsigned char c, struct n_tty_data *ldata)
 {
-	*read_buf_addr(ldata, ldata->read_head++) = c;
+	*read_buf_addr(ldata, ldata->read_head) = c;
+	ldata->read_head++;
 }
 
 /**
-- 
2.2.2

