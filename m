Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962Ab3AOW3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:29:14 -0500
Received: from mail.kernel.org ([198.145.19.201]:41619 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757941Ab3AOW3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:29:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [ 065/221] jffs2: hold erase_completion_lock on exit
Date: Tue, 15 Jan 2013 10:49:52 -0800
Message-Id: <20130115185002.745407482@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

commit 2cbba75a56ea78e6876b4e2547a882f10b3fe72b upstream.

Users of jffs2_do_reserve_space() expect they still held
erase_completion_lock after call to it. But there is a path
where jffs2_do_reserve_space() leaves erase_completion_lock unlocked.
The patch fixes it.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/jffs2/nodemgmt.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/jffs2/nodemgmt.c
+++ b/fs/jffs2/nodemgmt.c
@@ -417,14 +417,16 @@ static int jffs2_do_reserve_space(struct
 			spin_unlock(&c->erase_completion_lock);
 
 			ret = jffs2_prealloc_raw_node_refs(c, jeb, 1);
-			if (ret)
-				return ret;
+
 			/* Just lock it again and continue. Nothing much can change because
 			   we hold c->alloc_sem anyway. In fact, it's not entirely clear why
 			   we hold c->erase_completion_lock in the majority of this function...
 			   but that's a question for another (more caffeine-rich) day. */
 			spin_lock(&c->erase_completion_lock);
 
+			if (ret)
+				return ret;
+
 			waste = jeb->free_size;
 			jffs2_link_node_ref(c, jeb,
 					    (jeb->offset + c->sector_size - waste) | REF_OBSOLETE,


