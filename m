Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbaJOO7I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 10:59:08 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:35736 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbaJOO7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 10:59:03 -0400
Message-ID: <543E8BB3.6040701@amacapital.net>
Date: Wed, 15 Oct 2014 07:58:59 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Seth Forshee <seth.forshee@canonical.com>,
        Miklos Szeredi <miklos@szeredi.hu>
CC: fuse-devel@lists.sourceforge.net,
        "Serge H. Hallyn" <serge.hallyn@ubuntu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v4 3/5] fuse: Restrict allow_other to uids already controlled
 by the user
References: <1413296756-25071-1-git-send-email-seth.forshee@canonical.com> <1413296756-25071-4-git-send-email-seth.forshee@canonical.com>
In-Reply-To: <1413296756-25071-4-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2014 07:25 AM, Seth Forshee wrote:
> Unprivileged users are normally restricted from mounting with the
> allow_other option by system policy, but this could be bypassed
> for a mount done with user namespace root permissions. In such
> cases allow_other should not allow users outside the user
> namespace to access the mount as doing so would give the
> unprivileged user the ability to manipulate processes it would
> otherwise be unable to manipulate.

What threat is this intended to protect against?  I think that, if this
is needed, tasks outside the userns or its descendents should be
blocked, even if the user ids match.  That is, I think you should check
the namespace, not the uid and gid.

--Andy

> 
> Cc: Eric W. Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
> Cc: Serge H. Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> ---
>  fs/fuse/dir.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> index 123db1e06c78..e3123bfbc711 100644
> --- a/fs/fuse/dir.c
> +++ b/fs/fuse/dir.c
> @@ -1089,12 +1089,20 @@ int fuse_reverse_inval_entry(struct super_block *sb, u64 parent_nodeid,
>   */
>  int fuse_allow_current_process(struct fuse_conn *fc)
>  {
> -	const struct cred *cred;
> +	const struct cred *cred = current_cred();
>  
> -	if (fc->flags & FUSE_ALLOW_OTHER)
> -		return 1;
> +	if (fc->flags & FUSE_ALLOW_OTHER) {
> +		if (kuid_has_mapping(fc->user_ns, cred->euid) &&
> +		    kuid_has_mapping(fc->user_ns, cred->suid) &&
> +		    kuid_has_mapping(fc->user_ns, cred->uid) &&
> +		    kgid_has_mapping(fc->user_ns, cred->egid) &&
> +		    kgid_has_mapping(fc->user_ns, cred->sgid) &&
> +		    kgid_has_mapping(fc->user_ns, cred->gid))
> +			return 1;
> +
> +		return 0;
> +	}
>  
> -	cred = current_cred();
>  	if (uid_eq(cred->euid, fc->user_id) &&
>  	    uid_eq(cred->suid, fc->user_id) &&
>  	    uid_eq(cred->uid,  fc->user_id) &&
> 

