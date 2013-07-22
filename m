Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414Ab3GVG4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 02:56:16 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:48057 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756314Ab3GVG4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 02:56:08 -0400
Date: Mon, 22 Jul 2013 09:53:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: Eric Paris <eparis@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] fsnotify: potential use after free
Message-ID: <20130722065327.GA14617@longonot.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My static checker complains that if we drop the last reference then it
would be a use after free.  I don't know if it's possible, but really
the atomic_dec(&group->num_marks); should be done while we are holding a
reference to "group".

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/notify/mark.c b/fs/notify/mark.c
index 923fe4a..27e357e 100644
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -262,9 +262,9 @@ int fsnotify_add_mark_locked(struct fsnotify_mark *mark,
 err:
 	mark->flags &= ~FSNOTIFY_MARK_FLAG_ALIVE;
 	list_del_init(&mark->g_list);
+	atomic_dec(&group->num_marks);
 	fsnotify_put_group(group);
 	mark->group = NULL;
-	atomic_dec(&group->num_marks);
 
 	spin_unlock(&mark->lock);
 
