Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933069AbaAaWec (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 17:34:32 -0500
Received: from linuxhacker.ru ([217.76.32.60]:46361 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932385AbaAaWea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 17:34:30 -0500
From: Oleg Drokin <green@linuxhacker.ru>
To: linux-kernel@vger.kernel.org, jlayton@redhat.com, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Cc: Oleg Drokin <green@linuxhacker.ru>
Subject: [PATCH v2] vfs: Fix mountpoint reference leakage in linkat
Date: Fri, 31 Jan 2014 17:34:11 -0500
Message-Id: <1391207651-6152-1-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <20140131223013.GP10323@ZenIV.linux.org.uk>
References: <20140131223013.GP10323@ZenIV.linux.org.uk>
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
Also fix a similar leak in case of broken delegation.

Signed-off-by: Oleg Drokin: <green@linuxhacker.ru>
---
 fs/namei.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/namei.c b/fs/namei.c
index bcb838e..31ec503 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3927,10 +3927,13 @@ out_dput:
 	done_path_create(&new_path, new_dentry);
 	if (delegated_inode) {
 		error = break_deleg_wait(&delegated_inode);
-		if (!error)
+		if (!error) {
+			path_put(&old_path);
 			goto retry;
+		}
 	}
 	if (retry_estale(error, how)) {
+		path_put(&old_path);
 		how |= LOOKUP_REVAL;
 		goto retry;
 	}
-- 
1.8.5.3

