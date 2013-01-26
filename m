Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab3AZV11 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 16:27:27 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:38806 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257Ab3AZV1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 16:27:25 -0500
Date: Sat, 26 Jan 2013 21:29:18 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH review 5/6] userns: Allow the userns root to mount
 ramfs.
Message-ID: <20130126212918.GG11274@mail.hallyn.com>
References: <87ehh8it9s.fsf@xmission.com>
 <87ip6khe7w.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ip6khe7w.fsf@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> 
> There is no backing store to ramfs and file creation
> rules are the same as for any other filesystem so
> it is semantically safe to allow unprivileged users
> to mount it.
> 
> The memory control group successfully limits how much
> memory ramfs can consume on any system that cares about
> a user namespace root using ramfs to exhaust memory
> the memory control group can be deployed.

But that does mean that to avoid this new type of attack, when handed a
new kernel (i.e. by one's distro) one has to explicitly (know about and)
configure those limits.  The "your distro should do this for you"
argument doesn't seem right.  And I'd really prefer there not be
barriers to user namespaces being compiled in when there don't have to
be.

What was your thought on the suggestion to only allow FS_USERNS_MOUNT
mounts by users confined in a non-init memory cgroup?

Alternatively, what about a simple sysctl knob to turn on
FS_USERNS_MOUNTs?  Then if I've got no untrusted users I can just turn
that on without the system second-guessing me for not having extra
configuration...

> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  fs/ramfs/inode.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
> index eab8c09..c24f1e1 100644
> --- a/fs/ramfs/inode.c
> +++ b/fs/ramfs/inode.c
> @@ -260,6 +260,7 @@ static struct file_system_type ramfs_fs_type = {
>  	.name		= "ramfs",
>  	.mount		= ramfs_mount,
>  	.kill_sb	= ramfs_kill_sb,
> +	.fs_flags	= FS_USERNS_MOUNT,
>  };
>  static struct file_system_type rootfs_fs_type = {
>  	.name		= "rootfs",
> -- 
> 1.7.5.4
