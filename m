Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbaDALe6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:34:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42653 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802AbaDALSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:18:33 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Oleg Drokin:" <green@linuxhacker.ru>, Al Viro <viro@zeniv.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 113/144] Fix mountpoint reference leakage in linkat
Date: Tue,  1 Apr 2014 12:15:17 +0100
Message-Id: <1396350948-29910-114-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Drokin <green@linuxhacker.ru>

commit d22e6338db7f613dd4f6095c190682fcc519e4b7 upstream.

Recent changes to retry on ESTALE in linkat
(commit 442e31ca5a49e398351b2954b51f578353fdf210)
introduced a mountpoint reference leak and a small memory
leak in case a filesystem link operation returns ESTALE
which is pretty normal for distributed filesystems like
lustre, nfs and so on.
Free old_path in such a case.

[AV: there was another missing path_put() nearby - on the previous
goto retry]

Signed-off-by: Oleg Drokin: <green@linuxhacker.ru>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
[ luis: backported to 3.11:
  - dropped AV changes as they are not applicable to 3.11 kernel ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/namei.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/namei.c b/fs/namei.c
index df9946e..b8f1f7f 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3708,6 +3708,7 @@ retry:
 out_dput:
 	done_path_create(&new_path, new_dentry);
 	if (retry_estale(error, how)) {
+		path_put(&old_path);
 		how |= LOOKUP_REVAL;
 		goto retry;
 	}
-- 
1.9.1

