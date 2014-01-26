Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbaAZQfT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 11:35:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167AbaAZQfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 11:35:18 -0500
Date: Sun, 26 Jan 2014 17:35:36 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dcache: error out if the name buffer is too short
Message-ID: <20140126163536.GA21320@redhat.com>
References: <1390572299-3074-1-git-send-email-dvlasenk@redhat.com> <20140124161922.GA14195@redhat.com> <20140126153737.GA8184@redhat.com> <20140126155141.GA12249@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140126155141.GA12249@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26, Oleg Nesterov wrote:
>
> Al, Denys, unless I am totally confused the "restart" logic is very broken.
> We can't simply restart because the main loop changes dentry?

Plus prepend_name() can't actually return -ENAMETOOLONG,
"int error" inside the loop is wrong.

I believe the minimal fix is something like below. I'll try to test
this change (currently I can't) later and resend. And I still think
it can be cleanuped a bit, but this is minor.

Oleg.


--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -3103,7 +3103,7 @@ char *simple_dname(struct dentry *dentry, char *buffer, int buflen)
 	/* these dentries are never renamed, so d_lock is not needed */
 	if (prepend(&end, &buflen, " (deleted)", 11) ||
 	    prepend(&end, &buflen, dentry->d_name.name, dentry->d_name.len) ||
-	    prepend(&end, &buflen, "/", 1))  
+	    prepend(&end, &buflen, "/", 1))
 		end = ERR_PTR(-ENAMETOOLONG);
 	return end;
 }
@@ -3113,32 +3113,34 @@ char *simple_dname(struct dentry *dentry, char *buffer, int buflen)
  */
 static char *__dentry_path(struct dentry *dentry, char *buf, int buflen)
 {
+	struct dentry *de;
 	char *end, *retval;
 	int len, seq = 0;
 	int error = 0;
 
+	if (buflen < 2)
+		goto Elong;
+
 	rcu_read_lock();
 restart:
 	end = buf + buflen;
 	len = buflen;
 	prepend(&end, &len, "\0", 1);
-	if (buflen < 1)
-		goto Elong;
 	/* Get '/' right */
 	retval = end-1;
 	*retval = '/';
+	de = dentry;
 	read_seqbegin_or_lock(&rename_lock, &seq);
-	while (!IS_ROOT(dentry)) {
-		struct dentry *parent = dentry->d_parent;
-		int error;
+	while (!IS_ROOT(de)) {
+		struct dentry *parent = de->d_parent;
 
 		prefetch(parent);
-		error = prepend_name(&end, &len, &dentry->d_name);
+		error = prepend_name(&end, &len, &de->d_name);
 		if (error)
 			break;
 
 		retval = end;
-		dentry = parent;
+		de = parent;
 	}
 	if (!(seq & 1))
 		rcu_read_unlock();

