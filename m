Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210AbaBMV3K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 16:29:10 -0500
Received: from mail.windriver.com ([147.11.1.11]:38928 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbaBMV3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 16:29:08 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Michal Marek <mmarek@suse.cz>, David Howells <dhowells@redhat.com>
Subject: [PATCH] kbuild: unconditionally clobber include/linux/version.h on distclean
Date: Thu, 13 Feb 2014 16:28:58 -0500
Message-ID: <1392326938-14405-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of v3.7, the UAPI changes relocated headers around such that the
kernel version header lived in a new place.

If a person is bisecting and if you go back to pre-UAPI days,
you will create an include/linux/version.h  -- then if you checkout a
post-UAPI kernel, and even run "make distclean" it still won't delete
that old version file.  So you get a situation like this:

$ grep -R LINUX_VERSION_CODE include/
include/generated/uapi/linux/version.h:#define LINUX_VERSION_CODE 200192
include/linux/version.h:#define LINUX_VERSION_CODE 132646

The value in that second line is representative of a v2.6.38 version.
And it will be sourced/used, hence leading to strange behaviours, such
as drivers/staging content (which typically hasn't been purged of version
ifdefs) failing to build.

Since it is a subtle mode of failure, lets always clobber the old
file when doing a distclean.

Cc: Michal Marek <mmarek@suse.cz>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/Makefile b/Makefile
index fd6a01ed9ab9..1342363ca10d 100644
--- a/Makefile
+++ b/Makefile
@@ -1071,7 +1071,7 @@ MRPROPER_FILES += .config .config.old .version .old_version $(version_h) \
 		  Module.symvers tags TAGS cscope* GPATH GTAGS GRTAGS GSYMS \
 		  signing_key.priv signing_key.x509 x509.genkey		\
 		  extra_certificates signing_key.x509.keyid		\
-		  signing_key.x509.signer
+		  signing_key.x509.signer include/linux/version.h
 
 # clean - Delete most, but leave enough to build external modules
 #
-- 
1.8.5.2

