Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965643AbaCUAFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:05:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36842 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760417AbaCUAE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:04:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Oleg Drokin:" <green@linuxhacker.ru>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 3.13 145/149] Fix mountpoint reference leakage in linkat
Date: Thu, 20 Mar 2014 17:05:08 -0700
Message-Id: <20140321000441.983465676@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/namei.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3945,10 +3945,13 @@ out_dput:
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


