Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750981AbaKMFAH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 00:00:07 -0500
Received: from ns.omicron.at ([212.183.10.25]:36611 "EHLO ns.omicron.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701AbaKMFAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 00:00:05 -0500
X-Greylist: delayed 321 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Nov 2014 00:00:04 EST
From: Christian Riesch <christian.riesch@omicron.at>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC: =?UTF-8?q?M=C3=A5ns=20Rullg=C3=A5rd?= <mans@mansr.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Christian Riesch <christian.riesch@omicron.at>,
        <stable@vger.kernel.org>
Subject: [PATCH v3] n_tty: Fix read_buf race condition, increment read_head after pushing data
Date: Thu, 13 Nov 2014 05:53:26 +0100
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <507f543b-60d6-4a3d-a509-c8f27b9082bb@EXC01-ATKLA.omicron.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: <stable@vger.kernel.org>
---

Changes for v3:
- Removed unnecessary comment.

Changes for v2:
- Rewrote commit message. Since I did not know better, I blamed the compiler
  in v1, but actually the code was wrong. See the discussion in [1].
- Removed memory barriers. For non-SMP machines they are not required,
  for SMP machines more brainwork and discussions are needed.

 drivers/tty/n_tty.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 2e900a9..47ca0f3 100644
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
1.7.9.5

