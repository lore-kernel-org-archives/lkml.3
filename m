Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbaLaPfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 10:35:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60173 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbaLaPfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 10:35:30 -0500
From: Michal Marek <mmarek@suse.cz>
To: sedat.dilek@gmail.com
Cc: ben@decadent.org.uk, max@stro.at, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: [PATCH 1/2] kbuild: Fix removal of the debian/ directory
Date: Wed, 31 Dec 2014 16:35:18 +0100
Message-Id: <1420040119-32669-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <54A40743.8080401@suse.cz>
References: <54A40743.8080401@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

scripts/Makefile.clean treats absolute path specially, but
$(objtree)/debian is no longer an absolute path since 7e1c0477 (kbuild:
Use relative path for $(objtree). Work around this by checking if the
path starts with $(objtree)/.

Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
Fixes: 7e1c0477 (kbuild: Use relative path for $(objtree)
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/Makefile.clean | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/scripts/Makefile.clean b/scripts/Makefile.clean
index 1bca180..627f8cb 100644
--- a/scripts/Makefile.clean
+++ b/scripts/Makefile.clean
@@ -42,19 +42,19 @@ __clean-files	:= $(extra-y) $(extra-m) $(extra-)       \
 
 __clean-files   := $(filter-out $(no-clean-files), $(__clean-files))
 
-# as clean-files is given relative to the current directory, this adds
-# a $(obj) prefix, except for absolute paths
+# clean-files is given relative to the current directory, unless it
+# starts with $(objtree)/ (which means "./", so do not add "./" unless
+# you want to delete a file from the toplevel object directory).
 
 __clean-files   := $(wildcard                                               \
-                   $(addprefix $(obj)/, $(filter-out /%, $(__clean-files))) \
-		   $(filter /%, $(__clean-files)))
+		   $(addprefix $(obj)/, $(filter-out $(objtree)/%, $(__clean-files))) \
+		   $(filter $(objtree)/%, $(__clean-files)))
 
-# as clean-dirs is given relative to the current directory, this adds
-# a $(obj) prefix, except for absolute paths
+# same as clean-files
 
 __clean-dirs    := $(wildcard                                               \
-                   $(addprefix $(obj)/, $(filter-out /%, $(clean-dirs)))    \
-		   $(filter /%, $(clean-dirs)))
+		   $(addprefix $(obj)/, $(filter-out $(objtree)/%, $(clean-dirs)))    \
+		   $(filter $(objtree)/%, $(clean-dirs)))
 
 # ==========================================================================
 
-- 
2.1.2

