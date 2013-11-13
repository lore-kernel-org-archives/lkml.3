Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759416Ab3KMOuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 09:50:52 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:2745 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546Ab3KMOuu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 09:50:50 -0500
From: "Long, Wai Man" <waiman.long@hp.com>
To: Al Viro <viro@ZenIV.linux.org.uk>,
        Michael Marineau <michael.marineau@coreos.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: 3.12 Regression: dcache: Translating dentry into pathname
 without taking rename_lock 232d2d60
Thread-Topic: 3.12 Regression: dcache: Translating dentry into pathname
 without taking rename_lock 232d2d60
Thread-Index: AQHO4GRH39VMpnh6F0u1NblcUo+FtZojGhaAgAAkHAA=
Date: Wed, 13 Nov 2013 14:49:46 +0000
Message-ID: <401F72D6D1DFE3499766D25AA4EED18A35432DEF@G5W2743.americas.hpqcorp.net>
References: <CAGr1u3vZU_Pxwu1nSab0PExNPQsE0xiSpcoMbUQ7MeGbJzBAjA@mail.gmail.com>
 <20131113123947.GB13318@ZenIV.linux.org.uk>
In-Reply-To: <20131113123947.GB13318@ZenIV.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [15.193.49.22]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al,

Thank a lot for quickly locating the bug. 

-Longman

-----Original Message-----
From: Al Viro [mailto:viro@ftp.linux.org.uk] On Behalf Of Al Viro
Sent: Wednesday, November 13, 2013 7:40 AM
To: Michael Marineau
Cc: Long, Wai Man; linux-kernel@vger.kernel.org
Subject: Re: 3.12 Regression: dcache: Translating dentry into pathname without taking rename_lock 232d2d60

On Wed, Nov 13, 2013 at 03:34:13AM -0800, Michael Marineau wrote:
> Greetings,
> 
> Commit 232d2d60aa5469bb097f55728f65146bd49c1d25 causes intermittent 
> errors in /proc/*/fd/* where readlink returns "/" instead of the 
> correct path. This can be reproduced by the script below which copies 
> the kernel source directory structure while obsessively looking up 
> directory fds in proc from another process. Reverting
> 232d2d60aa5469bb097f55728f65146bd49c1d25 after two related commits 
> 48f5ec21d9c67e881ff35343988e290ef5cf933f
> 1812997720ab90d029548778c55d7315555e1fef fixes the issue.

Looking into it...  It seems that we are getting to the end of
prepend_path() with non-negative error and bptr == *buffer.
What the...

OK, I see what's going on.  We never reinitialize dentry, vfsmount and mnt if we decide to restart.  See if the following helps:

diff --git a/fs/dcache.c b/fs/dcache.c
index ae6ebb8..89f9671 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2881,9 +2881,9 @@ static int prepend_path(const struct path *path,
 			const struct path *root,
 			char **buffer, int *buflen)
 {
-	struct dentry *dentry = path->dentry;
-	struct vfsmount *vfsmnt = path->mnt;
-	struct mount *mnt = real_mount(vfsmnt);
+	struct dentry *dentry;
+	struct vfsmount *vfsmnt;
+	struct mount *mnt;
 	int error = 0;
 	unsigned seq = 0;
 	char *bptr;
@@ -2893,6 +2893,9 @@ static int prepend_path(const struct path *path,
 restart:
 	bptr = *buffer;
 	blen = *buflen;
+	dentry = path->dentry;
+	vfsmnt = path->mnt;
+	mnt = real_mount(vfsmnt);
 	read_seqbegin_or_lock(&rename_lock, &seq);
 	while (dentry != root->dentry || vfsmnt != root->mnt) {
 		struct dentry * parent;
