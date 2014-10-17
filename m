Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbaJQRJE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 13:09:04 -0400
Received: from mout.gmx.net ([212.227.17.22]:57376 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032AbaJQRJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 13:09:00 -0400
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>,
        John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH v2 1/1] fallocate: create FAN_MODIFY and IN_MODIFY events
Date: Fri, 17 Oct 2014 19:08:21 +0200
Message-Id: <1413565701-3249-1-git-send-email-xypron.glpk@gmx.de>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <20141014154349.ca831a4d1e5c1747779552ec@linux-foundation.org>
References: <20141014154349.ca831a4d1e5c1747779552ec@linux-foundation.org>
X-Provags-ID: V03:K0:E5Hbxof/6C/blw/p5U+rzl0LYlgpXCFdjQ/KXVWwc6PBY7Jfj5e
 Lpu1vjvu31al/vKwiiJt8NgoBILAEjAShafyvaTIs0aU6LnNryZHg51SQRdps/6At8169Os
 iOmTTcmQZGHWcK4O1Ydwto7nF0ZYg9QWQLYq4m9gvEFMoCOLHGySUsm9T1nlQhup9StFz1+
 5KPAIEoirAQY7xJaOQctg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

:: Andrew Morton wrote:
::
:: Jan wondered why we generate events for FALLOC_FL_KEEP_SIZE, so other
:: people will wonder the same thing.  We should tell them.  Via code
:: comments and/or changelogging.
:: 
:: Any question which a reviewer asks should be viewed as a defect in the
:: patch. The patch isn't finished until people can read it without
:: having questions.

Please, find below a new version of the patch with an updated message and
additional comment lines in the code.



The fanotify and the inotify API can be used to monitor changes of the file
system. System call fallocate() modifies files. Hence it should trigger the
corresponding fanotify (FAN_MODIFY) and inotify (IN_MODIFY) events.
The most interesting case is FALLOC_FL_COLLAPSE_RANGE because this value
allows to create arbitrary file content from random data.

This patch adds the missing call to fsnotify_modify().

The FAN_MODIFY and IN_MODIFY event will be created when fallocate() succeeds.
It will even be created if the file length remains unchanged, e.g. when
calling fanotify with flag FALLOC_FL_KEEP_SIZE.

This logic was primarily chosen to keep the coding simple.

It resembles the logic of the write() system call.

When we call write() we always create a FAN_MODIFY event, even in the
case of overwriting with identical data.

Events FAN_MODIFY and IN_MODIFY do not provide any guarantee that data was
actually changed.

Furthermore even if if the filesize remains unchanged, fallocate() may influence
whether a subsequent write() will succeed and hence the fallocate() call
may be considered a modification.

The fallocate(2) man page teaches:
After a successful call, subsequent writes into the range specified by
offset and len are guaranteed not to fail because of lack of disk space.

So calling fallocate(fd, FALLOC_FL_KEEP_SIZE, offset, len) may result in
different outcomes of a subsequent write depending on the values of
offset and len.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 fs/open.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/open.c b/fs/open.c
index d6fd3ac..550d464 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -295,6 +295,17 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 
 	sb_start_write(inode->i_sb);
 	ret = file->f_op->fallocate(file, mode, offset, len);
+
+	/*
+	 * Create inotify and fanotify events.
+	 *
+	 * To keep the logic simple always create events if fallocate succeeds.
+	 * This implies that events are even created if the file size remains
+	 * unchanged, e.g. when using flag FALLOC_FL_KEEP_SIZE.
+	 */
+	if (ret == 0)
+		fsnotify_modify(file);
+
 	sb_end_write(inode->i_sb);
 	return ret;
 }
-- 
2.1.1

