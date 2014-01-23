Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbaAWTGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:06:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34964 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbaAWTGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:06:22 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Gao feng <gaofeng@cn.fujitsu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 3.12 07/27] vfs: Fix a regression in mounting proc
Date: Thu, 23 Jan 2014 11:06:44 -0800
Message-Id: <20140123190649.445014032@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140123190648.720195687@linuxfoundation.org>
References: <20140123190648.720195687@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit 41301ae78a99ead04ea42672a1ab72c6f44cc81d upstream.

Gao feng <gaofeng@cn.fujitsu.com> reported that commit
e51db73532955dc5eaba4235e62b74b460709d5b
userns: Better restrictions on when proc and sysfs can be mounted
caused a regression on mounting a new instance of proc in a mount
namespace created with user namespace privileges, when binfmt_misc
is mounted on /proc/sys/fs/binfmt_misc.

This is an unintended regression caused by the absolutely bogus empty
directory check in fs_fully_visible.  The check fs_fully_visible replaced
didn't even bother to attempt to verify proc was fully visible and
hiding proc files with any kind of mount is rare.  So for now fix
the userspace regression by allowing directory with nlink == 1
as /proc/sys/fs/binfmt_misc has.

I will have a better patch but it is not stable material, or
last minute kernel material.  So it will have to wait.

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Acked-by: Gao feng <gaofeng@cn.fujitsu.com>
Tested-by: Gao feng <gaofeng@cn.fujitsu.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/namespace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2888,7 +2888,7 @@ bool fs_fully_visible(struct file_system
 			struct inode *inode = child->mnt_mountpoint->d_inode;
 			if (!S_ISDIR(inode->i_mode))
 				goto next;
-			if (inode->i_nlink != 2)
+			if (inode->i_nlink > 2)
 				goto next;
 		}
 		visible = true;


