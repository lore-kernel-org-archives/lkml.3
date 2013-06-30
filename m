Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab3F3BQS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 21:16:18 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:57419 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab3F3BQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 21:16:16 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
References: <1372536729.850656@landley.net>
Date: Sat, 29 Jun 2013 18:15:40 -0700
In-Reply-To: <1372536729.850656@landley.net> (Rob Landley's message of "Sat,
	29 Jun 2013 13:12:14 -0700 (PDT)")
Message-ID: <87y59swg8z.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+zxUciEgJl6ax4laeDH3yPgsXXrU5Mi30=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Rob Landley <rob@landley.net>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 1/5] initmpfs: replace MS_NOUSER in initramfs
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley <rob@landley.net> writes:

> From: Rob Landley <rob@landley.net>
>
> Mounting MS_NOUSER prevents --bind mounts from rootfs. Prevent new rootfs
> mounts with a different mechanism that doesn't affect bind mounts.

I don't see patches 4 and 5 so I don't know if you have covered this
elsewhere but a very important part of the reason for MS_NOUSER is to
prevent unmounting of rootfs.

The entire vfs breaks if you are allowed to unmount rootfs, and it
appears this patch is allowing that.

Eric

> Signed-off-by: Rob Landley <rob@landley.net>
> ---
>
>  fs/ramfs/inode.c |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
> index c24f1e1..14b9c35 100644
> --- a/fs/ramfs/inode.c
> +++ b/fs/ramfs/inode.c
> @@ -247,7 +247,14 @@ struct dentry *ramfs_mount(struct file_system_type *fs_type,
>  static struct dentry *rootfs_mount(struct file_system_type *fs_type,
>  	int flags, const char *dev_name, void *data)
>  {
> -	return mount_nodev(fs_type, flags|MS_NOUSER, data, ramfs_fill_super);
> +	static int once;
> +
> +	if (once)
> +		return ERR_PTR(-ENODEV);
> +	else
> +		once++;
> +
> +	return mount_nodev(fs_type, flags, data, ramfs_fill_super);
>  }
>  
>  static void ramfs_kill_sb(struct super_block *sb)
