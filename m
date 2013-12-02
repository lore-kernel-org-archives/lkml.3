Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab3LBNVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 08:21:05 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:58019 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab3LBNVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 08:21:01 -0500
From: Franck Bui-Huu <fbuihuu@gmail.com>
To: mmarek@suse.cz
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix detectition of kernel git repository in setlocalversion script
Date: Mon,  2 Dec 2013 14:21:37 +0100
Message-Id: <1385990497-11805-1-git-send-email-fbuihuu@gmail.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

setlocalversion script was testing the presence of .git directory in order to find out
if git is used as SCM to track the current kernel project. However in some cases, .git
is not a directory but can be a file: when the kernel is a git submodule part of a git
super project for example.

This patch just fixes this by using 'git rev-parse --show-cdup' to check that the
current directory is the kernel git topdir. This has the advantage to not test and rely
on git internal infrastructure directly.

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
---
 scripts/setlocalversion | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/setlocalversion b/scripts/setlocalversion
index 0b5ccf3..c16e65d 100755
--- a/scripts/setlocalversion
+++ b/scripts/setlocalversion
@@ -43,7 +43,8 @@ scm_version()
 	fi
 
 	# Check for git and a git repo.
-	if test -d .git && head=`git rev-parse --verify --short HEAD 2>/dev/null`; then
+	if topdir=$(git rev-parse --show-cdup 2>/dev/null) && test -z "$topdir" &&
+	   head=`git rev-parse --verify --short HEAD 2>/dev/null`; then
 
 		# If we are at a tagged commit (like "v2.6.30-rc6"), we ignore
 		# it, because this version is defined in the top level Makefile.
-- 
1.8.4.2

