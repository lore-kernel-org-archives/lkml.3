Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbaL3Sq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 13:46:28 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:33413 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbaL3Sq1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 13:46:27 -0500
From: Paul Moore <paul@paul-moore.com>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux Kernel <linux-kernel@vger.kernel.org>, linux-audit@redhat.com
Subject: Re: v3.19-rc2: crashes during boot (syslog-ng, rpcbind ...)
Date: Tue, 30 Dec 2014 13:46:24 -0500
Message-ID: <4559278.bMkG2euyQm@sifl>
User-Agent: KMail/4.14.3 (Linux/3.16.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <5490032.bFDrnJqxyv@sifl>
References: <54A17C49.5080102@gmx.de> <54A1B724.8070106@gmx.de> <5490032.bFDrnJqxyv@sifl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 30, 2014 09:11:32 AM Paul Moore wrote:
> On Monday, December 29, 2014 09:18:44 PM Toralf Förster wrote:
> > On 12/29/2014 08:41 PM, Paul Moore wrote:
> > > To help verify that I'm heading down the right path, could you share
> > > your audit configuration as well?  If that's not possible, can you at
> > > least confirm that you using a few audit directory watches?
> > 
> > Well, it is just a victim system for trinity - but I did not configured
> > auditd in a special manner - so it is just the plain default configuration
> > of Gentoo:
>
> Okay, thanks for the information; the file related syscall watches are
> likely what triggered the problem code.  Until I've got the fix sorted out,
> removing the syscall watches or just disabling auditd from starting at boot
> should workaround the problem.

I still want to go over the below patch a bit more to check a few things, but 
it solves the problem for me and I believe it should solve the problem you are 
seeing as well.  Can you give it a try and let me know what happens?

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 287b3d3..d834770 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -72,6 +72,8 @@
 #include <linux/fs_struct.h>
 #include <linux/compat.h>
 #include <linux/ctype.h>
+#include <linux/string.h>
+#include <uapi/linux/limits.h>
 
 #include "audit.h"
 
@@ -1862,7 +1864,7 @@ void __audit_inode(struct filename *name, const struct 
dentry *dentry,
 
 	list_for_each_entry_reverse(n, &context->names_list, list) {
 		/* does the name pointer match? */
-		if (!n->name || n->name->name != name->name)
+		if (!n->name || strcmp(n->name->name, name->name))
 			continue;
 
 		/* match the correct record type */
@@ -1881,14 +1883,39 @@ out_alloc:
 	n = audit_alloc_name(context, AUDIT_TYPE_UNKNOWN);
 	if (!n)
 		return;
-	if (name)
-		/* since name is not NULL we know there is already a matching
-		 * name record, see audit_getname(), so there must be a type
-		 * mismatch; reuse the string path since the original name
-		 * record will keep the string valid until we free it in
-		 * audit_free_names() */
-		n->name = name;
+	/* unfortunately, while we may have a path name to record with the
+	 * inode, we can't always rely on the string lasting until the end of
+	 * the syscall so we need to create our own copy, it may fail due to
+	 * memory allocation issues, but we do our best */
+	if (name) {
+		/* we can't use getname_kernel() due to size limits */
+		struct filename *new = __getname();
 
+		if (unlikely(!new))
+			goto out;
+
+		memset(new, 0, sizeof(*new));
+		if ((strlen(name->name) + 1) <= (PATH_MAX - sizeof(*new))) {
+			char *new_name = (char *)(new) + sizeof(*new);
+			new->name = new_name;
+			new->separate = false;
+		} else {
+			/* this looks odd, but is due to final_putname() */
+			struct filename *new2;
+			new2 = kzalloc(sizeof(*new2), GFP_KERNEL);
+			if (unlikely(!new2)) {
+				__putname(new);
+				goto out;
+			}
+			new2->name = (char *)new;
+			new = new2;
+			new->separate = true;
+		}
+		strcpy((char *)new->name, name->name);
+		new->aname = n;
+		n->name = new;
+		n->name_put = true;
+	}
 out:
 	if (parent) {
 		n->name_len = n->name ? parent_len(n->name->name) : AUDIT_NAME_FULL;

-- 
paul moore
www.paul-moore.com

