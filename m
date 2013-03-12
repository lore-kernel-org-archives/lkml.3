Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933703Ab3CLWiW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:38:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60411 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108Ab3CLWdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:33:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 086/100] vfs: fix pipe counter breakage
Date: Tue, 12 Mar 2013 15:32:11 -0700
Message-Id: <20130312223132.194447593@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -863,6 +863,9 @@ pipe_rdwr_open(struct inode *inode, stru
 {
 	int ret = -ENOENT;
 
+	if (!(filp->f_mode & (FMODE_READ|FMODE_WRITE)))
+		return -EINVAL;
+
 	mutex_lock(&inode->i_mutex);
 
 	if (inode->i_pipe) {


