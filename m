Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422639Ab3DKU5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:57:31 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:50895 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab3DKU51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:57:27 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Serge Hallyn <serge.hallyn@canonical.com>
References: <20130411202503.783159048@goodmis.org>
	<20130411202604.352966800@goodmis.org>
Date: Thu, 11 Apr 2013 13:57:19 -0700
In-Reply-To: <20130411202604.352966800@goodmis.org> (Steven Rostedt's message
	of "Thu, 11 Apr 2013 16:26:53 -0400")
Message-ID: <87vc7su6og.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19xC6aNhxpwQnjWNUW0ql1Kc6kAor2EhZY=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Steven Rostedt <rostedt@goodmis.org>
X-Spam-Relay-Country: 
Subject: Re: [ 110/171 ] vfs: Add a mount flag to lock read only bind mounts
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> 3.6.11.2 stable review patch.
> If anyone has any objections, please let me know.

Mounting only with privilege in the user namespace (where we use
MNT_LOCK_READONLY) only dates back to 3.8 so this is not needed in 3.6.

Not that it should do any harm, but there doesn't seem to be much point
in backporting this one.

Eric

> ------------------
>
> From: "Eric W. Biederman" <ebiederm@xmission.com>
>
> [ Upstream commit 90563b198e4c6674c63672fae1923da467215f45 ]
>
> When a read-only bind mount is copied from mount namespace in a higher
> privileged user namespace to a mount namespace in a lesser privileged
> user namespace, it should not be possible to remove the the read-only
> restriction.
>
> Add a MNT_LOCK_READONLY mount flag to indicate that a mount must
> remain read-only.
>
> CC: stable@vger.kernel.org
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  fs/namespace.c        |    3 +++
>  include/linux/mount.h |    2 ++
>  2 files changed, 5 insertions(+)
>
> diff --git a/fs/namespace.c b/fs/namespace.c
> index c48b0d3..48c7edb 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -1702,6 +1702,9 @@ static int change_mount_flags(struct vfsmount *mnt, int ms_flags)
>  	if (readonly_request == __mnt_is_readonly(mnt))
>  		return 0;
>  
> +	if (mnt->mnt_flags & MNT_LOCK_READONLY)
> +		return -EPERM;
> +
>  	if (readonly_request)
>  		error = mnt_make_readonly(real_mount(mnt));
>  	else
> diff --git a/include/linux/mount.h b/include/linux/mount.h
> index d7029f4..73005f9 100644
> --- a/include/linux/mount.h
> +++ b/include/linux/mount.h
> @@ -47,6 +47,8 @@ struct mnt_namespace;
>  
>  #define MNT_INTERNAL	0x4000
>  
> +#define MNT_LOCK_READONLY	0x400000
> +
>  struct vfsmount {
>  	struct dentry *mnt_root;	/* root of the mounted tree */
>  	struct super_block *mnt_sb;	/* pointer to superblock */
