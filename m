Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760708Ab3EDPwQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 11:52:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46029 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760464Ab3EDPwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 11:52:15 -0400
Date: Sat, 4 May 2013 16:52:14 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Michael Leun <lkml20130126@newton.leun.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [REGRESSION] bisected: 3.8 -> 3.9 cannot umount after using fuse
Message-ID: <20130504155214.GD25399@ZenIV.linux.org.uk>
References: <20130504124519.032ac684@xenia.leun.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130504124519.032ac684@xenia.leun.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 04, 2013 at 12:45:19PM +0200, Michael Leun wrote:

> After reverting 57eccb830f1cc93d4b506ba306d8dfa685e0c88f from 3.9 that
> umount above works (not busy).

Sigh...  Check if the following fix works for your testcase:
diff --git a/fs/namespace.c b/fs/namespace.c
index b4f96a5..b68eef2d 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2284,12 +2284,11 @@ long do_mount(const char *dev_name, const char *dir_name,
 
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
