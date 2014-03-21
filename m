Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966435AbaCUA1C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:27:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37229 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966007AbaCUAJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:09:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Oleg Drokin:" <green@linuxhacker.ru>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 3.10 76/85] Fix mountpoint reference leakage in linkat
Date: Thu, 20 Mar 2014 17:10:19 -0700
Message-Id: <20140321000609.596835128@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000558.606667505@linuxfoundation.org>
References: <20140321000558.606667505@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
 fs/namei.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3655,6 +3655,7 @@ retry:
 out_dput:
 	done_path_create(&new_path, new_dentry);
 	if (retry_estale(error, how)) {
+		path_put(&old_path);
 		how |= LOOKUP_REVAL;
 		goto retry;
 	}


