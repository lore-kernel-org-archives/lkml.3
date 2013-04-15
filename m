Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934702Ab3DOCsY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 22:48:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36482 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933374Ab3DOCns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 22:43:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steven Whitehouse <swhiteho@redhat.com>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [ 12/27] GFS2: Fix unlock of fcntl locks during withdrawn state
Date: Sun, 14 Apr 2013 19:43:11 -0700
Message-Id: <20130415024232.275402430@linuxfoundation.org>
X-Mailer: git-send-email 1.8.2.1.368.g99c2266
In-Reply-To: <20130415024231.351969241@linuxfoundation.org>
References: <20130415024231.351969241@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Whitehouse <swhiteho@redhat.com>

commit c2952d202f710d326ac36a8ea6bd216b20615ec8 upstream.

When withdraw occurs, we need to continue to allow unlocks of fcntl
locks to occur, however these will only be local, since the node has
withdrawn from the cluster. This prevents triggering a VFS level
bug trap due to locks remaining when a file is closed.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/gfs2/file.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -924,8 +924,11 @@ static int gfs2_lock(struct file *file,
 		cmd = F_SETLK;
 		fl->fl_type = F_UNLCK;
 	}
-	if (unlikely(test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
+	if (unlikely(test_bit(SDF_SHUTDOWN, &sdp->sd_flags))) {
+		if (fl->fl_type == F_UNLCK)
+			posix_lock_file_wait(file, fl);
 		return -EIO;
+	}
 	if (IS_GETLK(cmd))
 		return dlm_posix_get(ls->ls_dlm, ip->i_no_addr, file, fl);
 	else if (fl->fl_type == F_UNLCK)


