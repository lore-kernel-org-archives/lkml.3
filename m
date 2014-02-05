Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933174AbaBEUlE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:41:04 -0500
Received: from mail.windriver.com ([147.11.1.11]:55109 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927AbaBEUGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:06:30 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Chen Gang <gang.chen@asianux.com>, Corey Minyard <cminyard@mvista.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 120/213] drivers/char/ipmi: memcpy, need additional 2 bytes to avoid memory overflow
Date: Wed, 5 Feb 2014 15:01:15 -0500
Message-ID: <1391630568-49251-121-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chen Gang <gang.chen@asianux.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit a5f2b3d6a738e7d4180012fe7b541172f8c8dcea upstream.

When calling memcpy, read_data and write_data need additional 2 bytes.

  write_data:
    for checking:  "if (size > IPMI_MAX_MSG_LENGTH)"
    for operating: "memcpy(bt->write_data + 3, data + 1, size - 1)"

  read_data:
    for checking:  "if (msg_len < 3 || msg_len > IPMI_MAX_MSG_LENGTH)"
    for operating: "memcpy(data + 2, bt->read_data + 4, msg_len - 2)"

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/char/ipmi/ipmi_bt_sm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_bt_sm.c b/drivers/char/ipmi/ipmi_bt_sm.c
index 7b98c067190a..a65a574eac6b 100644
--- a/drivers/char/ipmi/ipmi_bt_sm.c
+++ b/drivers/char/ipmi/ipmi_bt_sm.c
@@ -95,9 +95,9 @@ struct si_sm_data {
 	enum bt_states	state;
 	unsigned char	seq;		/* BT sequence number */
 	struct si_sm_io	*io;
-	unsigned char	write_data[IPMI_MAX_MSG_LENGTH];
+	unsigned char	write_data[IPMI_MAX_MSG_LENGTH + 2]; /* +2 for memcpy */
 	int		write_count;
-	unsigned char	read_data[IPMI_MAX_MSG_LENGTH];
+	unsigned char	read_data[IPMI_MAX_MSG_LENGTH + 2]; /* +2 for memcpy */
 	int		read_count;
 	int		truncated;
 	long		timeout;	/* microseconds countdown */
-- 
1.8.5.2

