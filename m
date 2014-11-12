Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbaKLBXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:23:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58666 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852AbaKLBXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:23:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Valdis Kletnieks <valdis.kletnieks@vt.edu>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH 3.17 082/319] pstore: Fix duplicate {console,ftrace}-efi entries
Date: Wed, 12 Nov 2014 10:13:40 +0900
Message-Id: <20141112011006.183508076@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>

commit d4bf205da618bbd0b038e404d646f14e76915718 upstream.

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
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/pstore/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
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


