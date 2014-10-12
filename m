Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbaJLAND (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 20:13:03 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34252 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbaJLANB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 20:13:01 -0400
Date: Sun, 12 Oct 2014 01:12:59 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Biggers <ebiggers3@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: fs/namei.c: Misuse of sequence counts?
Message-ID: <20141012001259.GM7996@ZenIV.linux.org.uk>
References: <20141011225808.GA20777@zzz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141011225808.GA20777@zzz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11, 2014 at 05:58:08PM -0500, Eric Biggers wrote:

> In path_init(), said commit added a call to read_seqcount_retry() after loading
> the inode.  I see two problems with this:
> 
>   - The read_seqcount_retry() isn't needed just to load the inode pointer, so
>     the change doesn't seem to accomplish anything.

Huh?  What's to guarantee that dentry hasn't become negative since the
moment we'd fetched the seqcount?  _That_ is the problem we are dealing
with here - link_path_walk() relies on nd->inode being non-NULL.

>   - If the -ECHILD code path actually runs, the reference to the 'struct file'
>     can be leaked.

Umm...  That, OTOH, might be true, _if_ we could hit it on the path where
nd->path comes from file (and descriptor table had been shared).  Which
could happen, if we could get d_drop() done to that sucker for some
reason - other codepaths bumping the seqcount are impossible for pinned
dentry (including that of an opened file).

Which can, indeed, happen on something like NFS.  OK, so all callers of
path_init() should go to the same place where they go on link_path_walk()
failure, like this.  And that's probably what we want in backports; however,
longer term we would be better off with a combined path_init + link_path_walk -
all callers do exactly the same thing there...  OK, that can be in a followup...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/fs/namei.c b/fs/namei.c
index d20d579..0f64aa4 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1950,7 +1950,7 @@ static int path_lookupat(int dfd, const char *name,
 	err = path_init(dfd, name, flags | LOOKUP_PARENT, nd, &base);
 
 	if (unlikely(err))
-		return err;
+		goto out;
 
 	current->total_link_count = 0;
 	err = link_path_walk(name, nd);
@@ -1982,6 +1982,7 @@ static int path_lookupat(int dfd, const char *name,
 		}
 	}
 
+out:
 	if (base)
 		fput(base);
 
@@ -2301,7 +2302,7 @@ path_mountpoint(int dfd, const char *name, struct path *path, unsigned int flags
 
 	err = path_init(dfd, name, flags | LOOKUP_PARENT, &nd, &base);
 	if (unlikely(err))
-		return err;
+		goto out;
 
 	current->total_link_count = 0;
 	err = link_path_walk(name, &nd);
