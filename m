Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbaBGVQy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 16:16:54 -0500
Received: from fieldses.org ([174.143.236.118]:56841 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463AbaBGVQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 16:16:52 -0500
Date: Fri, 7 Feb 2014 16:16:44 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, dhowells@redhat.com,
        zab@redhat.com, jack@suse.cz, luto@amacapital.net, mszeredi@suse.cz
Subject: Re: [PATCH 07/13] vfs: lock_two_nondirectories: allow directory args
Message-ID: <20140207211644.GB8801@fieldses.org>
References: <1391791751-2533-1-git-send-email-miklos@szeredi.hu>
 <1391791751-2533-8-git-send-email-miklos@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391791751-2533-8-git-send-email-miklos@szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 05:49:05PM +0100, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> lock_two_nondirectories warned if either of its args was a directory.
> Instead just ignore the directory args.  This is needed for locking in
> cross rename.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
>  fs/inode.c | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index 4bcdad3c9361..763010771cf4 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -944,18 +944,21 @@ EXPORT_SYMBOL(unlock_new_inode);
>  
>  /**
>   * lock_two_nondirectories - take two i_mutexes on non-directory objects
> + *
> + * If either or both arguments are directories, then ignore those.
> + * Therefore zero, one or two objects may be locked by this function.
> + *
>   * @inode1: first inode to lock
>   * @inode2: second inode to lock
>   */
>  void lock_two_nondirectories(struct inode *inode1, struct inode *inode2)
>  {
> -	WARN_ON_ONCE(S_ISDIR(inode1->i_mode));
> -	if (inode1 == inode2 || !inode2) {
> +	if (S_ISDIR(inode1->i_mode)) {
> +		if (inode2 && !S_ISDIR(inode2->i_mode))
> +			mutex_lock(&inode2->i_mutex);
> +	} else if (inode1 == inode2 || !inode2 || S_ISDIR(inode2->i_mode)) {
>  		mutex_lock(&inode1->i_mutex);
> -		return;
> -	}
> -	WARN_ON_ONCE(S_ISDIR(inode2->i_mode));
> -	if (inode1 < inode2) {
> +	} else if (inode1 < inode2) {
>  		mutex_lock(&inode1->i_mutex);
>  		mutex_lock_nested(&inode2->i_mutex, I_MUTEX_NONDIR2);
>  	} else {

Nit: I find the conditionals here a little complicated.

Would something like this be clearer? (Untested):

	if (inode1 > inode2)
		swap(inode1, inode2);

	if (inode1 && !S_ISDIR(inode1->i_mode))
		mutex_lock(&inode1->i_mutex);

	if (inode2 && !S_ISDIR(inode2->i_mode) && inode2 != inode1)
		mutex_lock_nested(&inode2->i_mutex, I_MUTEX_NONDIR2);

--b.

diff --git a/fs/inode.c b/fs/inode.c
index 4bcdad3..94e41c8 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -944,24 +944,23 @@ EXPORT_SYMBOL(unlock_new_inode);
 
 /**
  * lock_two_nondirectories - take two i_mutexes on non-directory objects
+ *
+ * Lock any non-NULL argument that is not a directory.
+ * Zero, one or two objects may be locked by this function.
+ *
  * @inode1: first inode to lock
  * @inode2: second inode to lock
  */
 void lock_two_nondirectories(struct inode *inode1, struct inode *inode2)
 {
-	WARN_ON_ONCE(S_ISDIR(inode1->i_mode));
-	if (inode1 == inode2 || !inode2) {
-		mutex_lock(&inode1->i_mutex);
-		return;
-	}
-	WARN_ON_ONCE(S_ISDIR(inode2->i_mode));
-	if (inode1 < inode2) {
+	if (inode1 > inode2)
+		swap(inode1, inode2);
+
+	if (inode1 && !S_ISDIR(inode1->i_mode))
 		mutex_lock(&inode1->i_mutex);
+
+	if (inode2 && !S_ISDIR(inode2->i_mode) && inode2 != inode1)
 		mutex_lock_nested(&inode2->i_mutex, I_MUTEX_NONDIR2);
-	} else {
-		mutex_lock(&inode2->i_mutex);
-		mutex_lock_nested(&inode1->i_mutex, I_MUTEX_NONDIR2);
-	}
 }
 EXPORT_SYMBOL(lock_two_nondirectories);
 
@@ -972,8 +971,9 @@ EXPORT_SYMBOL(lock_two_nondirectories);
  */
 void unlock_two_nondirectories(struct inode *inode1, struct inode *inode2)
 {
-	mutex_unlock(&inode1->i_mutex);
-	if (inode2 && inode2 != inode1)
+	if (inode1 && !S_ISDIR(inode1->i_mode))
+		mutex_unlock(&inode1->i_mutex);
+	if (inode2 && !S_ISDIR(inode2->i_mode) && inode2 != inode1)
 		mutex_unlock(&inode2->i_mutex);
 }
 EXPORT_SYMBOL(unlock_two_nondirectories);
