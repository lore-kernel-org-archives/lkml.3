Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084Ab3IEUmJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 16:42:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52048 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756911Ab3IEU2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 16:28:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Svenning Soerensen <sss@secomea.dk>,
        Peter Hurley <peter@hurleysoftware.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 12/36] IPC: bugfix for msgrcv with msgtyp < 0
Date: Thu,  5 Sep 2013 13:27:41 -0700
Message-Id: <20130905202703.721147829@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130905202702.289738686@linuxfoundation.org>
References: <20130905202702.289738686@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Svenning Soerensen <sss@secomea.dk>

commit 368ae537e056acd3f751fa276f48423f06803922 upstream.

According to 'man msgrcv': "If msgtyp is less than 0, the first message of
the lowest type that is less than or equal to the absolute value of msgtyp
shall be received."

Bug: The kernel only returns a message if its type is 1; other messages
with type < abs(msgtype) will never get returned.

Fix: After having traversed the list to find the first message with the
lowest type, we need to actually return that message.

This regression was introduced by commit daaf74cf0867 ("ipc: refactor
msg list search into separate function")

Signed-off-by: Svenning Soerensen <sss@secomea.dk>
Reviewed-by: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 ipc/msg.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -795,7 +795,7 @@ static inline void free_copy(struct msg_
 
 static struct msg_msg *find_msg(struct msg_queue *msq, long *msgtyp, int mode)
 {
-	struct msg_msg *msg;
+	struct msg_msg *msg, *found = NULL;
 	long count = 0;
 
 	list_for_each_entry(msg, &msq->q_messages, m_list) {
@@ -804,6 +804,7 @@ static struct msg_msg *find_msg(struct m
 					       *msgtyp, mode)) {
 			if (mode == SEARCH_LESSEQUAL && msg->m_type != 1) {
 				*msgtyp = msg->m_type - 1;
+				found = msg;
 			} else if (mode == SEARCH_NUMBER) {
 				if (*msgtyp == count)
 					return msg;
@@ -813,7 +814,7 @@ static struct msg_msg *find_msg(struct m
 		}
 	}
 
-	return ERR_PTR(-EAGAIN);
+	return found ?: ERR_PTR(-EAGAIN);
 }
 
 


