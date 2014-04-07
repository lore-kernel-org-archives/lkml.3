Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbaDGBmI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 21:42:08 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:34095 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753111AbaDGBmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 21:42:05 -0400
X-Sasl-enc: nxtWJX/xV/LV/O+tQtr34EvxjEanZ9CUmT1y6W2q4HXA 1396834923
Subject: [PATCH] autofs4: check dev ioctl size before allocating
To: Andrew Morton <akpm@linux-foundation.org>
From: Ian Kent <raven@themaw.net>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 07 Apr 2014 09:42:00 +0800
Message-ID: <20140407014200.5099.51469.stgit@perseus.fritz.box>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sasha Levin <sasha.levin@oracle.com>

There wasn't any check of the size passed from userspace before
trying to allocate the memory required.

This meant that userspace might request more space than allowed,
triggering an OOM.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/autofs4/dev-ioctl.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
index 3182c0e..232e03d 100644
--- a/fs/autofs4/dev-ioctl.c
+++ b/fs/autofs4/dev-ioctl.c
@@ -103,6 +103,9 @@ static struct autofs_dev_ioctl *copy_dev_ioctl(struct autofs_dev_ioctl __user *i
 	if (tmp.size < sizeof(tmp))
 		return ERR_PTR(-EINVAL);
 
+	if (tmp.size > (PATH_MAX + sizeof(tmp)))
+		return ERR_PTR(-ENAMETOOLONG);
+
 	return memdup_user(in, tmp.size);
 }
 

