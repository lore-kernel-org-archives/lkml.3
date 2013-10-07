Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab3JGADP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 20:03:15 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:42015 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009Ab3JGADM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 20:03:12 -0400
MIME-Version: 1.0
In-Reply-To: <5251B524.3000101@gmail.com>
References: <5251B524.3000101@gmail.com>
Date: Sun, 6 Oct 2013 19:03:11 -0500
Message-ID: <CAH2r5mvyCduRWcC=wgDFXZfUH-ojSKWY25mwQQ6k5zyy7E1TqA@mail.gmail.com>
Subject: Re: cifs: Fix inability to write files >2GB to SMB2/3 shares (THIS
 TIME I GOT IT RIGHT, PROMISE!)
From: Steve French <smfrench@gmail.com>
To: Jan Klos <honza.klos@gmail.com>
Cc: Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <trivial@kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good.

Will plan to merge into cifs-2..6.git soon.

Probably should also go to stable kernels

On Sun, Oct 6, 2013 at 2:08 PM, Jan Klos <honza.klos@gmail.com> wrote:
> When connecting to SMB2/3 shares, maximum file size is set to non-LFS maximum in superblock. This is due to cap_large_files bit being different for SMB1 and SMB2/3 (where it is just an internal flag that is not negotiated and the SMB1 one corresponds to multichannel capability, so maybe LFS works correctly if server sends 0x08 flag) while capabilities are checked always for the SMB1 bit in cifs_read_super().
>
> The patch fixes this by checking for the correct bit according to the protocol version.
>
> Sorry for the TWO reposts, Gmail messed up the first mail, Thunderbird added spaces to the patch part in the second. I am really sorry! I think I fixed a quite significant bug, so have mercy on me...
>
>
> Signed-off-by: Jan Klos <honza.klos@gmail.com>
>
> ---
>
> diff -uprN a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> --- a/fs/cifs/cifsfs.c  2013-10-05 16:18:07.000000000 +0200
> +++ b/fs/cifs/cifsfs.c  2013-10-06 16:18:13.488378000 +0200
> @@ -120,14 +120,16 @@ cifs_read_super(struct super_block *sb)
>  {
>         struct inode *inode;
>         struct cifs_sb_info *cifs_sb;
> +       struct cifs_tcon *tcon;
>         int rc = 0;
>
>         cifs_sb = CIFS_SB(sb);
> +       tcon = cifs_sb_master_tcon(cifs_sb);
>
>         if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIXACL)
>                 sb->s_flags |= MS_POSIXACL;
>
> -       if (cifs_sb_master_tcon(cifs_sb)->ses->capabilities & CAP_LARGE_FILES)
> +       if (tcon->ses->capabilities & tcon->ses->server->vals->cap_large_files)
>                 sb->s_maxbytes = MAX_LFS_FILESIZE;
>         else
>                 sb->s_maxbytes = MAX_NON_LFS;
> @@ -147,7 +149,7 @@ cifs_read_super(struct super_block *sb)
>                 goto out_no_root;
>         }
>
> -       if (cifs_sb_master_tcon(cifs_sb)->nocase)
> +       if (tcon->nocase)
>                 sb->s_d_op = &cifs_ci_dentry_ops;
>         else
>                 sb->s_d_op = &cifs_dentry_ops;



-- 
Thanks,

Steve
