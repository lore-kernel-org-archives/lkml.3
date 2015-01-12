Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbbALSW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:22:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57578 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581AbbALSGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:06:10 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christian Riesch <christian.riesch@omicron.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 059/216] n_tty: Fix read_buf race condition, increment read_head after pushing data
Date: Mon, 12 Jan 2015 18:02:56 +0000
Message-Id: <1421085933-32536-60-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Riesch <christian.riesch@omicron.at>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/tty/n_tty.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index f44f1ba762c3..d31b4a8c02ab 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -321,7 +321,8 @@ static void n_tty_check_unthrottle(struct tty_struct *tty)
 
 static inline void put_tty_queue(unsigned char c, struct n_tty_data *ldata)
 {
-	*read_buf_addr(ldata, ldata->read_head++) = c;
+	*read_buf_addr(ldata, ldata->read_head) = c;
+	ldata->read_head++;
 }
 
 /**
-- 
2.1.4

