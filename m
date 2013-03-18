Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab3CRElK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:41:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33615 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752064Ab3CREax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:30:53 -0400
Message-Id: <20130318042148.523896927@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:22:28 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 44/82] vfs: fix pipe counter breakage
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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


