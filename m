Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893AbaAaVci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 16:32:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932271AbaAaVcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 16:32:35 -0500
Date: Fri, 31 Jan 2014 16:32:31 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Oleg Drokin <green@linuxhacker.ru>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Fix mountpoint reference leakage in linkat
Message-ID: <20140131163231.2585a08d@tlielax.poochiereds.net>
In-Reply-To: <A3886415-1FA1-4090-8F64-F5B4D4DDD786@linuxhacker.ru>
References: <1391200918-29185-1-git-send-email-green@linuxhacker.ru>
	<20140131210334.GO10323@ZenIV.linux.org.uk>
	<A3886415-1FA1-4090-8F64-F5B4D4DDD786@linuxhacker.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jan 2014 16:13:19 -0500
Oleg Drokin <green@linuxhacker.ru> wrote:

> 
> On Jan 31, 2014, at 4:03 PM, Al Viro wrote:
> >> diff --git a/fs/namei.c b/fs/namei.c
> >> index bcb838e..e620937 100644
> >> --- a/fs/namei.c
> >> +++ b/fs/namei.c
> >> @@ -3931,6 +3931,7 @@ out_dput:
> >> 			goto retry;
> >> 	}
> >> 	if (retry_estale(error, how)) {
> >> +		path_put(&old_path);
> >> 		how |= LOOKUP_REVAL;
> >> 		goto retry;
> >> 	}
> > Umm...  That obviously can't be right - we have another goto retry
> > in the same situation (see in your diff context).  I agree that
> > we have a leak there, but you've fixed only a half of it.
> 
> Hm, you are right, I did not notice this other one somehow.
> 
> So, not to take any guesses, should I convert the other goto retry into
> retry_deleg similar in style to what happens in rename and unlink, only
> make retry)deleg label before call to the security_path_link?
> After the call to the security_path_link?
> Or would you prefer to just free old_path in both cases?
> 
> Bye,
>     Oleg

Maybe something like this (untested) instead?

--------------------------8<---------------------------

[PATCH] vfs: fix linkat old_path reference leak

Cc: <stable@vger.kernel.org> # v3.8+
Reported-by: Oleg Drokin <green@linuxhacker.ru>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 46dbd31..e70dd81 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3927,8 +3927,10 @@ retry:
 	new_dentry = user_path_create(newdfd, newname, &new_path,
 					(how & LOOKUP_REVAL));
 	error = PTR_ERR(new_dentry);
-	if (IS_ERR(new_dentry))
+	if (IS_ERR(new_dentry)) {
+		path_put(&old_path);
 		goto out;
+	}
 
 	error = -EXDEV;
 	if (old_path.mnt != new_path.mnt)
@@ -3942,6 +3944,7 @@ retry:
 	error = vfs_link(old_path.dentry, new_path.dentry->d_inode, new_dentry, &delegated_inode);
 out_dput:
 	done_path_create(&new_path, new_dentry);
+	path_put(&old_path);
 	if (delegated_inode) {
 		error = break_deleg_wait(&delegated_inode);
 		if (!error)
@@ -3952,8 +3955,6 @@ out_dput:
 		goto retry;
 	}
 out:
-	path_put(&old_path);
-
 	return error;
 }
 
-- 
1.8.5.3




