Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933577Ab3BNIhy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 03:37:54 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:46665 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab3BNIhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 03:37:53 -0500
Date: Thu, 14 Feb 2013 00:37:49 -0800
From: Joel Becker <jlbec@evilplan.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-fsdevel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        Mark Fasheh <mfasheh@suse.com>
Subject: Re: [PATCH review 25/85] ocfs2: Compare kuids and kgids using uid_eq
 and gid_eq
Message-ID: <20130214083748.GF18408@localhost>
Mail-Followup-To: "Eric W. Biederman" <ebiederm@xmission.com>,
	linux-fsdevel@vger.kernel.org,
	Linux Containers <containers@lists.linux-foundation.org>,
	linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
	Mark Fasheh <mfasheh@suse.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
 <1360777934-5663-25-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360777934-5663-25-git-send-email-ebiederm@xmission.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 09:51:14AM -0800, Eric W. Biederman wrote:
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  fs/ocfs2/file.c         |    8 ++++----
>  fs/ocfs2/refcounttree.c |    2 +-
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 8ee9332..0a2924a 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1175,14 +1175,14 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
>  		}
>  	}
>  
> -	if ((attr->ia_valid & ATTR_UID && attr->ia_uid != inode->i_uid) ||
> -	    (attr->ia_valid & ATTR_GID && attr->ia_gid != inode->i_gid)) {
> +	if ((attr->ia_valid & ATTR_UID && !uid_eq(attr->ia_uid, inode->i_uid)) ||
> +	    (attr->ia_valid & ATTR_GID && !gid_eq(attr->ia_gid, inode->i_gid))) {

Will the code work if built just before this patch?  IOW, does the
original comparison (attr->ia_gid != inode->i_gid) work when the system
is in the init_user_namespace?  If not, then the previous patches are
not leaving a functional filesystem.

Joel

>  		/*
>  		 * Gather pointers to quota structures so that allocation /
>  		 * freeing of quota structures happens here and not inside
>  		 * dquot_transfer() where we have problems with lock ordering
>  		 */
> -		if (attr->ia_valid & ATTR_UID && attr->ia_uid != inode->i_uid
> +		if (attr->ia_valid & ATTR_UID && !uid_eq(attr->ia_uid, inode->i_uid)
>  		    && OCFS2_HAS_RO_COMPAT_FEATURE(sb,
>  		    OCFS2_FEATURE_RO_COMPAT_USRQUOTA)) {
>  			transfer_to[USRQUOTA] = dqget(sb, make_kqid_uid(attr->ia_uid));
> @@ -1191,7 +1191,7 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
>  				goto bail_unlock;
>  			}
>  		}
> -		if (attr->ia_valid & ATTR_GID && attr->ia_gid != inode->i_gid
> +		if (attr->ia_valid & ATTR_GID && !gid_eq(attr->ia_gid, inode->i_gid)
>  		    && OCFS2_HAS_RO_COMPAT_FEATURE(sb,
>  		    OCFS2_FEATURE_RO_COMPAT_GRPQUOTA)) {
>  			transfer_to[GRPQUOTA] = dqget(sb, make_kqid_gid(attr->ia_gid));
> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
> index 30a0550..934a4ac 100644
> --- a/fs/ocfs2/refcounttree.c
> +++ b/fs/ocfs2/refcounttree.c
> @@ -4407,7 +4407,7 @@ static int ocfs2_vfs_reflink(struct dentry *old_dentry, struct inode *dir,
>  	 * rights to do so.
>  	 */
>  	if (preserve) {
> -		if ((current_fsuid() != inode->i_uid) && !capable(CAP_CHOWN))
> +		if (!uid_eq(current_fsuid(), inode->i_uid) && !capable(CAP_CHOWN))
>  			return -EPERM;
>  		if (!in_group_p(inode->i_gid) && !capable(CAP_CHOWN))
>  			return -EPERM;
> -- 
> 1.7.5.4
> 

-- 

"Where are my angels?
 Where's my golden one?
 And where is my hope
 Now that my heroes are gone?"

			http://www.jlbec.org/
			jlbec@evilplan.org
