Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902AbaFSKNE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 06:13:04 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:61788 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbaFSKNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 06:13:01 -0400
Message-ID: <53A2B7A9.7080605@gmail.com>
Date: Thu, 19 Jun 2014 13:12:57 +0300
From: Boaz Harrosh <openosd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>, linux-kernel <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC: Sam Ravnborg <sam@ravnborg.org>
Subject: kbuild: support of new KBUILD_FULL_PATH
References: <53A1D3A1.70202@gmail.com>
In-Reply-To: <53A1D3A1.70202@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The commit:

	commit 9da0763bdd82572be243fcf5161734f11568960f
	Author: Michal Marek <mmarek@suse.cz>
	Date:   Fri Apr 25 23:25:18 2014 +0200

	kbuild: Use relative path when building in a subdir of the source tree

	When doing make O=<subdir>, use '..' to refer to the source tree. This
	allows for more readable compiler messages, and, more importantly, it
	sets the VPATH to '..', so filenames in WARN_ON() etc. will be shorter.

	Acked-by: Sam Ravnborg <sam@ravnborg.org>
	Signed-off-by: Michal Marek <mmarek@suse.cz>

Broke IDEs and other tools which analyze the make output.
Introduce a new KBUILD_FULL_PATH switch to Makefile that will revert
to the old output if KBUILD_FULL_PATH=1 is specified.
The default is KBUILD_FULL_PATH=0

Is there a document I need to edit for this new parameter?

Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
---
 Makefile | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 97b2861..778732a 100644
--- a/Makefile
+++ b/Makefile
@@ -149,11 +149,17 @@ else
 _all: modules
 endif
 
+# put KBUILD_FULL_PATH=1 if relative path to sources breaks your system
+ifneq ($(KBUILD_FULL_PATH), 1)
+	KBUILD_FULL_PATH=""
+endif
+
 ifeq ($(KBUILD_SRC),)
         # building in the source tree
         srctree := .
 else
-        ifeq ($(KBUILD_SRC)/,$(dir $(CURDIR)))
+        # if KBUILD_FULL_PATH is not empty then condition will fail
+        ifeq ($(KBUILD_FULL_PATH)$(KBUILD_SRC)/,$(dir $(CURDIR)))
                 # building in a subdirectory of the source tree
                 srctree := ..
         else
-- 
1.9.3


