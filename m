Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376AbaJCIUa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 04:20:30 -0400
Received: from mout.gmx.net ([212.227.17.20]:51678 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbaJCIU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 04:20:27 -0400
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Eric Paris <eparis@parisplace.org>,
        John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH 1/1] fallocate: create FAN_MODIFY and IN_MODIFY events
Date: Fri,  3 Oct 2014 10:19:30 +0200
Message-Id: <1412324370-959-1-git-send-email-xypron.glpk@gmx.de>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1412287587-5392-1-git-send-email-xypron.glpk@gmx.de>
References: <1412287587-5392-1-git-send-email-xypron.glpk@gmx.de>
X-Provags-ID: V03:K0:EjTTydGRqCD3MKC7a5LFIrBJSLiZk+SLynPpJn8GClt9K/orp9a
 sRE8R/k58kt2vYHe966pT9iwT3qyVki4nkvNoDUltzmX7lYSoPnaXX4Mjo/S2aUTURnAeAj
 yuyfclrwANrYDPq1tKj83lLcEp2Fxe3wKikUdBBXuIBfCROCHPs3qJGcgZUxZ+1ZesynwE1
 fxYwE1xMZnhiEUo/45l9A==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fanotify and the inotify API can used to monitor changes of the file
system.

System call fallocate modifies files. Hence it should trigger the corresponding
fanotify (FAN_MODIFY) and inotify (IN_MODIFY) events.

This patch adds the missing call to fsnotify_modify.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 fs/open.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/open.c b/fs/open.c
index d6fd3ac..03aa8e5 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -295,6 +295,11 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 
 	sb_start_write(inode->i_sb);
 	ret = file->f_op->fallocate(file, mode, offset, len);
+
+	/* Create inotify and fanotify events. */
+	if (ret == 0)
+		fsnotify_modify(file);
+
 	sb_end_write(inode->i_sb);
 	return ret;
 }
-- 
2.1.0

