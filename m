Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab3KNXuh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 18:50:37 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:53846 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab3KNXu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 18:50:29 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: containers@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org,
        serge@hallyn.com, linux-kernel@vger.kernel.org
References: <1384327663-12032-1-git-send-email-gaofeng@cn.fujitsu.com>
Date: Thu, 14 Nov 2013 15:50:19 -0800
In-Reply-To: <1384327663-12032-1-git-send-email-gaofeng@cn.fujitsu.com> (Gao
	feng's message of "Wed, 13 Nov 2013 15:27:43 +0800")
Message-ID: <874n7e4k78.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/4hbL8+j6OkwN4f2V3IMFAjufNpDrmUuQ=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1326]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Gao feng <gaofeng@cn.fujitsu.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] userns: allow privileged user to operate locked mount
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gao feng <gaofeng@cn.fujitsu.com> writes:

> Privileged user should have rights to mount/umount/move
> these even locked mount.

Hmm. This is pretty much a can't happen case, as the only exist in mount
namespaces where the global root isn't the root.  How are you getting
into this situation?  Using setns() ?

Why would we even care?

As implemented this patch does not handle nested user namespaces and
that really worries me at a semantic level.

We don't want to design cases where we can create containers in
containers.

Eric


> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
> ---
>  fs/namespace.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/fs/namespace.c b/fs/namespace.c
> index da5c494..7097fc7 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -1297,6 +1297,11 @@ static inline bool may_mount(void)
>  	return ns_capable(current->nsproxy->mnt_ns->user_ns, CAP_SYS_ADMIN);
>  }
>  
> +static inline bool may_mount_lock(struct mount *mnt)
> +{
> +	return !(mnt->mnt.mnt_flags & MNT_LOCKED) || capable(CAP_SYS_ADMIN);
> +}
> +
>  /*
>   * Now umount can handle mount points as well as block devices.
>   * This is important for filesystems which use unnamed block devices.
> @@ -1330,7 +1335,7 @@ SYSCALL_DEFINE2(umount, char __user *, name, int, flags)
>  		goto dput_and_out;
>  	if (!check_mnt(mnt))
>  		goto dput_and_out;
> -	if (mnt->mnt.mnt_flags & MNT_LOCKED)
> +	if (!may_mount_lock(mnt))
>  		goto dput_and_out;
>  
>  	retval = do_umount(mnt, flags);
> @@ -1768,7 +1773,8 @@ static int do_loopback(struct path *path, const char *old_name,
>  	if (!check_mnt(parent) || !check_mnt(old))
>  		goto out2;
>  
> -	if (!recurse && has_locked_children(old, old_path.dentry))
> +	if (!recurse && has_locked_children(old, old_path.dentry) &&
> +	    !capable(CAP_SYS_ADMIN))
>  		goto out2;
>  
>  	if (recurse)
> @@ -1895,7 +1901,7 @@ static int do_move_mount(struct path *path, const char *old_name)
>  	if (!check_mnt(p) || !check_mnt(old))
>  		goto out1;
>  
> -	if (old->mnt.mnt_flags & MNT_LOCKED)
> +	if (!may_mount_lock(old))
>  		goto out1;
>  
>  	err = -EINVAL;
> @@ -2679,7 +2685,7 @@ SYSCALL_DEFINE2(pivot_root, const char __user *, new_root,
>  		goto out4;
>  	if (!check_mnt(root_mnt) || !check_mnt(new_mnt))
>  		goto out4;
> -	if (new_mnt->mnt.mnt_flags & MNT_LOCKED)
> +	if (!may_mount_lock(new_mnt))
>  		goto out4;
>  	error = -ENOENT;
>  	if (d_unlinked(new.dentry))
