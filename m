Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185AbaFEASf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:18:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40202 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbaFDXWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ian Kent <raven@themaw.net>, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3.14 137/228] autofs: fix lockref lookup
Date: Wed,  4 Jun 2014 16:22:46 -0700
Message-Id: <20140604232352.418627555@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Kent <raven@themaw.net>

commit 6b6751f7feba68d8f5c72b72cc69a1c5a625529c upstream.

autofs needs to be able to see private data dentry flags for its dentrys
that are being created but not yet hashed and for its dentrys that have
been rmdir()ed but not yet freed.  It needs to do this so it can block
processes in these states until a status has been returned to indicate
the given operation is complete.

It does this by keeping two lists, active and expring, of dentrys in
this state and uses ->d_release() to keep them stable while it checks
the reference count to determine if they should be used.

But with the recent lockref changes dentrys being freed sometimes don't
transition to a reference count of 0 before being freed so autofs can
occassionally use a dentry that is invalid which can lead to a panic.

Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/autofs4/root.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -179,7 +179,7 @@ static struct dentry *autofs4_lookup_act
 		spin_lock(&active->d_lock);
 
 		/* Already gone? */
-		if (!d_count(active))
+		if ((int) d_count(active) <= 0)
 			goto next;
 
 		qstr = &active->d_name;
@@ -230,7 +230,7 @@ static struct dentry *autofs4_lookup_exp
 
 		spin_lock(&expiring->d_lock);
 
-		/* Bad luck, we've already been dentry_iput */
+		/* We've already been dentry_iput or unlinked */
 		if (!expiring->d_inode)
 			goto next;
 


