Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307AbaH1N42 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 09:56:28 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:39114 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbaH1N41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 09:56:27 -0400
From: rtg.canonical@gmail.com
X-Google-Original-From: tim.gardner@canonical.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH v2] fs: namespace: suppress 'may be used uninitialized' warnings
Date: Thu, 28 Aug 2014 07:55:49 -0600
Message-Id: <1409234149-3485-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140827210112.GE18016@ZenIV.linux.org.uk>
References: <20140827210112.GE18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Gardner <tim.gardner@canonical.com>

The gcc version 4.9.1 compiler complains even though it isn't possible for
these variables to not get initialized before they are used.

fs/namespace.c: In function ‘SyS_mount’:
fs/namespace.c:2720:8: warning: ‘kernel_dev’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  ret = do_mount(kernel_dev, kernel_dir->name, kernel_type, flags,
        ^
fs/namespace.c:2699:8: note: ‘kernel_dev’ was declared here
  char *kernel_dev;
        ^
fs/namespace.c:2720:8: warning: ‘kernel_type’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  ret = do_mount(kernel_dev, kernel_dir->name, kernel_type, flags,
        ^
fs/namespace.c:2697:8: note: ‘kernel_type’ was declared here
  char *kernel_type;
        ^
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---

V1 - use of the uninitialized_var() macro rejected.
V2 - assign automatic variables an initial value.

 fs/namespace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index a01c773..365a06d 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2665,9 +2665,9 @@ SYSCALL_DEFINE5(mount, char __user *, dev_name, char __user *, dir_name,
 		char __user *, type, unsigned long, flags, void __user *, data)
 {
 	int ret;
-	char *kernel_type;
+	char *kernel_type = NULL;
 	struct filename *kernel_dir;
-	char *kernel_dev;
+	char *kernel_dev = NULL;
 	unsigned long data_page;
 
 	ret = copy_mount_string(type, &kernel_type);
-- 
2.1.0

