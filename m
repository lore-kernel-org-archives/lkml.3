Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab3HXLo4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 07:44:56 -0400
Received: from [94.18.233.162] ([94.18.233.162]:1744 "EHLO mail.secomea.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754337Ab3HXLoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 07:44:55 -0400
Message-ID: <52189CB1.9030806@secomea.dk>
Date: Sat, 24 Aug 2013 13:44:49 +0200
From: =?ISO-8859-1?Q?Svenning_S=F8rensen?= <sss@secomea.dk>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] IPC: bugfix for msgrcv with msgtyp < 0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to 'man msgrcv':
"If msgtyp is less than 0, the first message of the lowest type that is less
than or equal to the absolute value of msgtyp shall be received."

Bug: The kernel only returns a message if its type is 1; other messages with
type < abs(msgtype) will never get returned.

Fix: After having traversed the list to find the first message with the
lowest type, we need to actually return that message.

Signed-off-by: Svenning Soerensen <sss@secomea.dk>

diff --git a/ipc/msg.c b/ipc/msg.c
index bd60d7e..9f29d9e 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -839,7 +839,7 @@ static inline void free_copy(struct msg_msg *copy)
  
  static struct msg_msg *find_msg(struct msg_queue *msq, long *msgtyp, int mode)
  {
-	struct msg_msg *msg;
+	struct msg_msg *msg, *found = NULL;
  	long count = 0;
  
  	list_for_each_entry(msg, &msq->q_messages, m_list) {
@@ -848,6 +848,7 @@ static struct msg_msg *find_msg(struct msg_queue *msq, long *msgtyp, int mode)
  					       *msgtyp, mode)) {
  			if (mode == SEARCH_LESSEQUAL && msg->m_type != 1) {
  				*msgtyp = msg->m_type - 1;
+				found = msg;
  			} else if (mode == SEARCH_NUMBER) {
  				if (*msgtyp == count)
  					return msg;
@@ -857,7 +858,7 @@ static struct msg_msg *find_msg(struct msg_queue *msq, long *msgtyp, int mode)
  		}
  	}
  
-	return ERR_PTR(-EAGAIN);
+	return found ?: ERR_PTR(-EAGAIN);
  }
  
  long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp, int msgflg,

