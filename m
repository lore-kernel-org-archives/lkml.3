Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab3ETKyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:54:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56454 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756632Ab3ETKyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:54:12 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chen Gang <gang.chen@asianux.com>, Corey Minyard <cminyard@mvista.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 109/115] drivers/char/ipmi: memcpy, need additional 2 bytes to avoid memory overflow
Date: Mon, 20 May 2013 11:51:49 +0100
Message-Id: <1369047116-9378-110-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Gang <gang.chen@asianux.com>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/char/ipmi/ipmi_bt_sm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_bt_sm.c b/drivers/char/ipmi/ipmi_bt_sm.c
index cdd4c09f..a22a7a5 100644
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
1.8.1.2

