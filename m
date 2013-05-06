Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198Ab3EFUrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 16:47:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59394 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758147Ab3EFUrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 16:47:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [ 107/115] do_mount(): fix a leak introduced in 3.9 ("mount: consolidate permission checks")
Date: Mon,  6 May 2013 13:45:43 -0700
Message-Id: <20130506203106.550214339@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506203055.537199268@linuxfoundation.org>
References: <20130506203055.537199268@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 0d5cadb87e0fa764db7fa0b78d8a6f173cb475a1 upstream.

Bisected-by: Michael Leun <lkml20130126@newton.leun.net>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/namespace.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2238,12 +2238,11 @@ long do_mount(const char *dev_name, cons
 
 	retval = security_sb_mount(dev_name, &path,
 				   type_page, flags, data_page);
+	if (!retval && !may_mount())
+		retval = -EPERM;
 	if (retval)
 		goto dput_out;
 
-	if (!may_mount())
-		return -EPERM;
-
 	/* Default to relatime unless overriden */
 	if (!(flags & MS_NOATIME))
 		mnt_flags |= MNT_RELATIME;


