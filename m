Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932888AbaAaUmh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 15:42:37 -0500
Received: from linuxhacker.ru ([217.76.32.60]:45809 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932491AbaAaUmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 15:42:36 -0500
From: Oleg Drokin <green@linuxhacker.ru>
To: linux-kernel@vger.kernel.org, jlayton@redhat.com, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Cc: Oleg Drokin <green@linuxhacker.ru>
Subject: [PATCH] Fix mountpoint reference leakage in linkat
Date: Fri, 31 Jan 2014 15:41:58 -0500
Message-Id: <1391200918-29185-1-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent changes to retry on ESTALE in linkat
(commit 442e31ca5a49e398351b2954b51f578353fdf210)
introduced a mountpoint reference leak and a small memory
leak in case a filesystem link operation returns ESTALE
which is pretty normal for distributed filesystems like
lustre, nfs and so on.
Free old_path in such a case.

Signed-off-by: Oleg Drokin: <green@linuxhacker.ru>
---
 fs/namei.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/namei.c b/fs/namei.c
index bcb838e..e620937 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3931,6 +3931,7 @@ out_dput:
 			goto retry;
 	}
 	if (retry_estale(error, how)) {
+		path_put(&old_path);
 		how |= LOOKUP_REVAL;
 		goto retry;
 	}
-- 
1.8.5.3

