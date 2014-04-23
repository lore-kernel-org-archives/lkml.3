Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944AbaDWFUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 01:20:42 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:55188 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752303AbaDWFUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 01:20:40 -0400
X-Sasl-enc: nmWaK2UGi2srSSodWg51zR+5I7hDAY5DPmPitDaNlfG0 1398230438
Subject: [PATCH] autofs - fix lockref lookup
To: Andrew Morton <akpm@linux-foundation.org>
From: Ian Kent <raven@themaw.net>
Cc: autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 23 Apr 2014 13:20:36 +0800
Message-ID: <20140423052035.5999.69412.stgit@perseus.fritz.box>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

autofs needs to be able to see private data dentry flags for
its dentrys that are being created but not yet hashed and for
its dentys that have been rmdir()ed but not yet freed. It
needs to do this so it can block processes in these states
until a status has been returned to indicate the given
operation is complete.

It does this by keeping two lists, active and expring, of
dentrys in this state and uses ->d_release() to keep them
stable while it checks the reference count to determine
if they should be used.

But with the recent lockref changes dentrys being freed
sometimes don't transition to a reference count of 0 before
being freed so autofs can occassionally use a dentry that
is invalid which can lead to a panic.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/autofs4/root.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 2caf36a..cc87c1a 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -179,7 +179,7 @@ static struct dentry *autofs4_lookup_active(struct dentry *dentry)
 		spin_lock(&active->d_lock);
 
 		/* Already gone? */
-		if (!d_count(active))
+		if ((int) d_count(active) <= 0)
 			goto next;
 
 		qstr = &active->d_name;
@@ -230,7 +230,7 @@ static struct dentry *autofs4_lookup_expiring(struct dentry *dentry)
 
 		spin_lock(&expiring->d_lock);
 
-		/* Bad luck, we've already been dentry_iput */
+		/* We've already been dentry_iput or unlinked */
 		if (!expiring->d_inode)
 			goto next;
 

