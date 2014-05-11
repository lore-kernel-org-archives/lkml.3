Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934309AbaEKTcL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:32:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48508 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932860AbaEKT0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:26:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Matthew Daley <mattd@bugfuzz.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.4 03/22] floppy: dont write kernel-only members to FDRAWCMD ioctl output
Date: Sun, 11 May 2014 21:21:11 +0200
Message-Id: <20140511192104.201296691@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511192103.733723493@linuxfoundation.org>
References: <20140511192103.733723493@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Daley <mattd@bugfuzz.com>

commit 2145e15e0557a01b9195d1c7199a1b92cb9be81f upstream.

Do not leak kernel-only floppy_raw_cmd structure members to userspace.
This includes the linked-list pointer and the pointer to the allocated
DMA space.

Signed-off-by: Matthew Daley <mattd@bugfuzz.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/floppy.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3058,7 +3058,10 @@ static int raw_cmd_copyout(int cmd, void
 	int ret;
 
 	while (ptr) {
-		ret = copy_to_user(param, ptr, sizeof(*ptr));
+		struct floppy_raw_cmd cmd = *ptr;
+		cmd.next = NULL;
+		cmd.kernel_data = NULL;
+		ret = copy_to_user(param, &cmd, sizeof(cmd));
 		if (ret)
 			return -EFAULT;
 		param += sizeof(struct floppy_raw_cmd);


