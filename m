Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617AbaJOO67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 10:58:59 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:51469 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbaJOO65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 10:58:57 -0400
From: Andy Lutomirski <luto@amacapital.net>
X-Google-Original-From: Andy Lutomirski <luto@mit.edu>
Message-ID: <543E8BAD.7000207@mit.edu>
Date: Wed, 15 Oct 2014 07:58:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Seth Forshee <seth.forshee@canonical.com>,
        Miklos Szeredi <miklos@szeredi.hu>
CC: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge H. Hallyn" <serge.hallyn@ubuntu.com>
Subject: Re: [PATCH v4 5/5] fuse: Allow user namespace mounts
References: <1413296756-25071-1-git-send-email-seth.forshee@canonical.com> <1413296756-25071-6-git-send-email-seth.forshee@canonical.com>
In-Reply-To: <1413296756-25071-6-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2014 07:25 AM, Seth Forshee wrote:
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Serge H. Hallyn <serge.hallyn@ubuntu.com>
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>  fs/fuse/inode.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index 5e00a6a76049..6522926b14e4 100644
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
> @@ -1212,7 +1212,7 @@ static void fuse_kill_sb_anon(struct super_block *sb)
>  static struct file_system_type fuse_fs_type = {
>  	.owner		= THIS_MODULE,
>  	.name		= "fuse",
> -	.fs_flags	= FS_HAS_SUBTYPE,
> +	.fs_flags	= FS_HAS_SUBTYPE | FS_USERNS_MOUNT,
>  	.mount		= fuse_mount,
>  	.kill_sb	= fuse_kill_sb_anon,
>  };
> @@ -1244,7 +1244,7 @@ static struct file_system_type fuseblk_fs_type = {
>  	.name		= "fuseblk",
>  	.mount		= fuse_mount_blk,
>  	.kill_sb	= fuse_kill_sb_blk,
> -	.fs_flags	= FS_REQUIRES_DEV | FS_HAS_SUBTYPE,
> +	.fs_flags	= FS_REQUIRES_DEV | FS_HAS_SUBTYPE | FS_USERNS_MOUNT,

I think it's decision time -- if these patches are applied, then FUSE
will be the first filesystem for which userns nodev behavior matters for
security, so applying this patch will enshrine an API decision.

I would very much prefer to make this patch depend on this:

http://lkml.kernel.org/g/2686c32f00b14148379e8cfee9c028c794d4aa1a.1407974494.git.luto@amacapital.net

That change will require that anyone who tries to mount one of these
things explicitly requests MS_NODEV instead of keeping the current
behavior of implicitly setting MS_NODEV and possibly confusing user code
that tries to remount.

If you like my patch, feel free to fold it in to your series, or Eric
can apply it directly (pretty please).

For background, with your patches as is, if you mount a FUSE fs and then
remount it with identical flags, the remount is likely to fail.

--Andy

>  };
>  MODULE_ALIAS_FS("fuseblk");
>  
> 

