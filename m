Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbaKKHpG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 02:45:06 -0500
Received: from ns.omicron.at ([212.183.10.25]:35619 "EHLO ns.omicron.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbaKKHpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 02:45:05 -0500
X-Greylist: delayed 1119 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Nov 2014 02:45:03 EST
From: Christian Riesch <christian.riesch@omicron.at>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC: =?UTF-8?q?M=C3=A5ns=20Rullg=C3=A5rd?= <mans@mansr.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Christian Riesch <christian.riesch@omicron.at>,
        <stable@vger.kernel.org>
Subject: [PATCH v2] n_tty: Fix read_buf race condition, increment read_head after pushing data
Date: Tue, 11 Nov 2014 08:24:17 +0100
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <a2e126c9-3001-4255-91c9-6311b54988c5@EXC02-ATKLA.omicron.at>
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

This is version 2 of the patch in [1].

Changes for v2:
- Rewrote commit message. Since I did not know better, I blamed the compiler
  in v1, but actually the code was wrong. See the discussion in [1].
- Removed memory barriers. For non-SMP machines they are not required,
  for SMP machines more brainwork and discussions are needed.

Best regards,
Christian

[1] https://lkml.org/lkml/2014/11/6/216


 drivers/tty/n_tty.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 2e900a9..b09f326 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -321,7 +321,9 @@ static void n_tty_check_unthrottle(struct tty_struct *tty)
 
 static inline void put_tty_queue(unsigned char c, struct n_tty_data *ldata)
 {
-	*read_buf_addr(ldata, ldata->read_head++) = c;
+	*read_buf_addr(ldata, ldata->read_head) = c;
+	/* increment read_head _after_ placing the character in the buffer */
+	ldata->read_head++;
 }
 
 /**
-- 
1.7.9.5

