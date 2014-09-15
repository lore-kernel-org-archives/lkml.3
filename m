Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbaIOTar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:30:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54683 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117AbaIOT1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:27:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anton Altaparmakov <aia21@cam.ac.uk>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 3.16 122/158] __generic_file_write_iter(): fix handling of sync error after DIO
Date: Mon, 15 Sep 2014 12:26:01 -0700
Message-Id: <20140915192546.549926074@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 60bb45297f7551833346c5cebc6d483ea17ea5f2 upstream.

If DIO results in short write and sync write fails, we want to bugger off
whether the DIO part has written anything or not; the logics on the return
will take care of the right return value.

Reported-by: Anton Altaparmakov <aia21@cam.ac.uk>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2584,7 +2584,7 @@ ssize_t __generic_file_write_iter(struct
 		 * that this differs from normal direct-io semantics, which
 		 * will return -EFOO even if some bytes were written.
 		 */
-		if (unlikely(status < 0) && !written) {
+		if (unlikely(status < 0)) {
 			err = status;
 			goto out;
 		}


