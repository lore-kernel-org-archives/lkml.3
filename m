Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbaJMDJ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 23:09:27 -0400
Received: from omr2.cc.vt.edu ([198.82.141.100]:50032 "EHLO omr2.cc.vt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826AbaJMDJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 23:09:25 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH[ fix duplicate console-efi entries in pstore
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Sun, 12 Oct 2014 23:09:08 -0400
Message-ID: <15420.1413169748@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pstore filesystem still creates duplicate filename/inode pairs for
some pstore types.  Add the id to the filename to prevent that.

Before patch:

[/sys/fs/pstore] ls -li
total 0
1250 -r--r--r--. 1 root root 67 Sep 29 17:09 console-efi
1250 -r--r--r--. 1 root root 67 Sep 29 17:09 console-efi
1250 -r--r--r--. 1 root root 67 Sep 29 17:09 console-efi
1250 -r--r--r--. 1 root root 67 Sep 29 17:09 console-efi
1250 -r--r--r--. 1 root root 67 Sep 29 17:09 console-efi
1250 -r--r--r--. 1 root root 67 Sep 29 17:09 console-efi
1250 -r--r--r--. 1 root root 67 Sep 29 17:09 console-efi
1250 -r--r--r--. 1 root root 67 Sep 29 17:09 console-efi
1250 -r--r--r--. 1 root root 67 Sep 29 17:09 console-efi


After:

[/sys/fs/pstore] ls -li
total 0
1232 -r--r--r--. 1 root root 148 Sep 29 17:09 console-efi-141202499100000
1231 -r--r--r--. 1 root root  67 Sep 29 17:09 console-efi-141202499200000
1230 -r--r--r--. 1 root root 148 Sep 29 17:44 console-efi-141202705400000
1229 -r--r--r--. 1 root root  67 Sep 29 17:44 console-efi-141202705500000
1228 -r--r--r--. 1 root root  67 Sep 29 20:42 console-efi-141203772600000
1227 -r--r--r--. 1 root root 148 Sep 29 23:42 console-efi-141204854900000
1226 -r--r--r--. 1 root root  67 Sep 29 23:42 console-efi-141204855000000
1225 -r--r--r--. 1 root root 148 Sep 29 23:59 console-efi-141204954200000
1224 -r--r--r--. 1 root root  67 Sep 29 23:59 console-efi-141204954400000

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

--- linux-next/fs/pstore/inode.c.orig	2014-10-03 23:58:00.440386528 -0400
+++ linux-next/fs/pstore/inode.c	2014-10-09 17:50:50.613829841 -0400
@@ -320,10 +320,10 @@ int pstore_mkfile(enum pstore_type_id ty
 						compressed ? ".enc.z" : "");
 		break;
 	case PSTORE_TYPE_CONSOLE:
-		sprintf(name, "console-%s", psname);
+		sprintf(name, "console-%s-%lld", psname, id);
 		break;
 	case PSTORE_TYPE_FTRACE:
-		sprintf(name, "ftrace-%s", psname);
+		sprintf(name, "ftrace-%s-%lld", psname, id);
 		break;
 	case PSTORE_TYPE_MCE:
 		sprintf(name, "mce-%s-%lld", psname, id);

