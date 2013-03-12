Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964911Ab3CLWrO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:47:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60742 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964861Ab3CLWop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:44:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 17/21] vfs: fix pipe counter breakage
Date: Tue, 12 Mar 2013 15:44:19 -0700
Message-Id: <20130312223247.097458622@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223245.109098379@linuxfoundation.org>
References: <20130312223245.109098379@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@ZenIV.linux.org.uk>

commit a930d8790552658140d7d0d2e316af4f0d76a512 upstream.

If you open a pipe for neither read nor write, the pipe code will not
add any usage counters to the pipe, causing the 'struct pipe_inode_info"
to be potentially released early.

That doesn't normally matter, since you cannot actually use the pipe,
but the pipe release code - particularly fasync handling - still expects
the actual pipe infrastructure to all be there.  And rather than adding
NULL pointer checks, let's just disallow this case, the same way we
already do for the named pipe ("fifo") case.

This is ancient going back to pre-2.4 days, and until trinity, nobody
naver noticed.

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/pipe.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -859,6 +859,9 @@ pipe_rdwr_open(struct inode *inode, stru
 {
 	int ret = -ENOENT;
 
+	if (!(filp->f_mode & (FMODE_READ|FMODE_WRITE)))
+		return -EINVAL;
+
 	mutex_lock(&inode->i_mutex);
 
 	if (inode->i_pipe) {


