Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab3IYAQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:16:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38980 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954Ab3IYAQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:16:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pavel Shilovsky <pshilovsky@samba.org>,
        Steve French <smfrench@gmail.com>
Subject: [ 026/110] CIFS: Fix a memory leak when a lease break comes
Date: Tue, 24 Sep 2013 17:14:24 -0700
Message-Id: <20130925001326.235057399@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001323.387158698@linuxfoundation.org>
References: <20130925001323.387158698@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Shilovsky <pshilovsky@samba.org>

commit 1a05096de82f3cd672c76389f63964952678506f upstream.

This happens when we receive a lease break from a server, then
find an appropriate lease key in opened files and schedule the
oplock_break slow work. lw pointer isn't freed in this case.

Signed-off-by: Pavel Shilovsky <pshilovsky@samba.org>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb2misc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -469,6 +469,7 @@ smb2_is_valid_lease_break(char *buffer,
 
 				queue_work(cifsiod_wq, &cfile->oplock_break);
 
+				kfree(lw);
 				spin_unlock(&cifs_file_list_lock);
 				spin_unlock(&cifs_tcp_ses_lock);
 				return true;


