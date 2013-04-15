Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139Ab3DOCrg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 22:47:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36491 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933541Ab3DOCnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 22:43:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 11/27] ipc: set msg back to -EAGAIN if copy wasnt performed
Date: Sun, 14 Apr 2013 19:43:10 -0700
Message-Id: <20130415024232.197618863@linuxfoundation.org>
X-Mailer: git-send-email 1.8.2.1.368.g99c2266
In-Reply-To: <20130415024231.351969241@linuxfoundation.org>
References: <20130415024231.351969241@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Kinsbursky <skinsbursky@parallels.com>

commit 2dc958fa2fe6987e7ab106bd97029a09a82fcd8d upstream.

Make sure that msg pointer is set back to error value in case of
MSG_COPY flag is set and desired message to copy wasn't found.  This
garantees that msg is either a error pointer or a copy address.

Otherwise the last message in queue will be freed without unlinking from
the queue (which leads to memory corruption) and the dummy allocated
copy won't be released.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 ipc/msg.c |    1 +
 1 file changed, 1 insertion(+)

--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -872,6 +872,7 @@ long do_msgrcv(int msqid, void __user *b
 							goto out_unlock;
 						break;
 					}
+					msg = ERR_PTR(-EAGAIN);
 				} else
 					break;
 				msg_counter++;


