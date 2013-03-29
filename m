Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab3C2HTS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 03:19:18 -0400
Received: from intranet.asianux.com ([58.214.24.6]:17535 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab3C2HTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 03:19:16 -0400
X-Spam-Score: -100.7
Message-ID: <51554055.90500@asianux.com>
Date: Fri, 29 Mar 2013 15:18:45 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: minyard@acm.org
CC: Greg KH <gregkh@linuxfoundation.org>,
        openipmi-developer@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/char/ipmi: memcpy, need additional 2 bytes to avoid
 memory overflow
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  when calling memcpy, read_data and write_data need additional 2 bytes.

  write_data:
    for checking:  "if (size > IPMI_MAX_MSG_LENGTH)" 
    for operating: "memcpy(bt->write_data + 3, data + 1, size - 1)"

  read_data:
    for checking:  "if (msg_len < 3 || msg_len > IPMI_MAX_MSG_LENGTH)"
    for operating: "memcpy(data + 2, bt->read_data + 4, msg_len - 2)"


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 drivers/char/ipmi/ipmi_bt_sm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

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
1.7.7.6
