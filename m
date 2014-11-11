Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbaKKIS7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 03:18:59 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:62155 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbaKKIQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 03:16:06 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v3 10/21] backports: avoid git tree reinitialization
Date: Tue, 11 Nov 2014 00:15:01 -0800
Message-Id: <1415693712-23743-11-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415693712-23743-1-git-send-email-mcgrof@do-not-panic.com>
References: <1415693712-23743-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

When using backports against for packaging with --gitdebug you either
have to use --clean or assume the directory is empty already. In either
case you start fresh. With integration this will be a bit different, you
could end up with a project directory where the git tree was present but
only the target directory was empty.

Calling git init on an already existing git directory will reinitialize
your git tree, that can reset some config stuff, let's avoid that.

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 gentree.py | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/gentree.py b/gentree.py
index 04e8f5e..68efce9 100755
--- a/gentree.py
+++ b/gentree.py
@@ -288,7 +288,10 @@ def git_debug_init(args):
     """
     if not args.gitdebug:
         return
-    git.init(tree=args.bpid.project_dir)
+    # Git supports re-initialization, although not well documented it can
+    # reset config stuff, lets avoid that if the tree already exists.
+    if not os.path.exists(os.path.join(args.bpid.project_dir, '.git')):
+        git.init(tree=args.bpid.project_dir)
     git.commit_all("Copied backport", tree=args.bpid.project_dir)
 
 
-- 
2.1.1

