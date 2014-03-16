Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105AbaCPBkh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 21:40:37 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:49819 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505AbaCPBke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 21:40:34 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: raven@themaw.net
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] autofs4: check dev ioctl size before allocating
Date: Sat, 15 Mar 2014 21:40:21 -0400
Message-Id: <1394934021-16965-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.3.2
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There wasn't any check of the size passed from userspace before
trying to allocate the memory required.

This meant that userspace might request more space than allowed,
triggering an OOM.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 fs/autofs4/dev-ioctl.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
index 3182c0e..86fa7af 100644
--- a/fs/autofs4/dev-ioctl.c
+++ b/fs/autofs4/dev-ioctl.c
@@ -103,6 +103,9 @@ static struct autofs_dev_ioctl *copy_dev_ioctl(struct autofs_dev_ioctl __user *i
 	if (tmp.size < sizeof(tmp))
 		return ERR_PTR(-EINVAL);
 
+	if (tmp.size > (PATH_MAX + sizeof(tmp)))
+		return ERR_PTR(-E2BIG);
+
 	return memdup_user(in, tmp.size);
 }
 
-- 
1.7.2.5

