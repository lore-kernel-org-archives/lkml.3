Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab3LYNjv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 08:39:51 -0500
Received: from mail-vb0-f45.google.com ([209.85.212.45]:54342 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab3LYNjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 08:39:49 -0500
MIME-Version: 1.0
In-Reply-To: <20131225142340.92120e3c3d9a98858db79748@skynet.be>
References: <20131225142340.92120e3c3d9a98858db79748@skynet.be>
Date: Wed, 25 Dec 2013 14:39:48 +0100
Message-ID: <CAFLxGvx1m_HL7wPA1=LXpjJvwN7oMCKjxJk4AHO+cgQW0FPf+Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] reiserfs:Adding tmpfile support
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Jeff Mahoney <jeffm@suse.com>,
        Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 25, 2013 at 2:23 PM, Fabian Frederick <fabf@skynet.be> wrote:
> This patch is largely based on reiserfs_create function.
> -Removing dquot_initialize (cf ext2/tmpfile)
> -Removing add_entry code.
> -Adding d_tmpfile generic call.
>
> It was not extensively tested; other solutions would
> be to work with hidden entries or merge
> creation - tmpfile process.

Is it worth adding new features to a legacy file system like reiserfs?

> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  fs/reiserfs/namei.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 60 insertions(+)
>
> diff --git a/fs/reiserfs/namei.c b/fs/reiserfs/namei.c
> index dc5236f..125060b 100644
> --- a/fs/reiserfs/namei.c
> +++ b/fs/reiserfs/namei.c
> @@ -637,6 +637,65 @@ static int reiserfs_create(struct inode *dir, struct dentry *dentry, umode_t mod
>         return retval;
>  }
>
> +
> +/* tmpfile function based on reiserfs_create without filename entry
> +*/
> +
> +static int reiserfs_tmpfile(struct inode *dir, struct dentry *dentry,
> +       umode_t mode)
> +{
> +       int retval;
> +       struct inode *inode;
> +       int jbegin_count =
> +           JOURNAL_PER_BALANCE_CNT * 2 +
> +           2 * (REISERFS_QUOTA_INIT_BLOCKS(dir->i_sb) +
> +                REISERFS_QUOTA_TRANS_BLOCKS(dir->i_sb));
> +       struct reiserfs_transaction_handle th;
> +       struct reiserfs_security_handle security;
> +
> +       inode = new_inode(dir->i_sb);
> +       if (!inode)
> +               return -ENOMEM;
> +
> +       new_inode_init(inode, dir, mode);
> +
> +       jbegin_count += reiserfs_cache_default_acl(dir);
> +       retval = reiserfs_security_init(dir, inode, &dentry->d_name, &security);
> +       if (retval < 0) {
> +               drop_new_inode(inode);
> +               return retval;
> +       }
> +       jbegin_count += retval;
> +       reiserfs_write_lock(dir->i_sb);
> +
> +       retval = journal_begin(&th, dir->i_sb, jbegin_count);
> +       if (retval) {
> +               drop_new_inode(inode);
> +               goto out_failed;
> +       }
> +
> +       retval =
> +           reiserfs_new_inode(&th, dir, mode, NULL, 0 /*i_size */ , dentry,
> +                              inode, &security);
> +       if (retval)
> +               goto out_failed;
> +
> +       inode->i_op = &reiserfs_file_inode_operations;
> +       inode->i_fop = &reiserfs_file_operations;
> +       inode->i_mapping->a_ops = &reiserfs_address_space_operations;
> +
> +       reiserfs_update_inode_transaction(inode);
> +       reiserfs_update_inode_transaction(dir);
> +
> +       unlock_new_inode(inode);
> +       d_tmpfile(dentry, inode);
> +       retval = journal_end(&th, dir->i_sb, jbegin_count);
> +
> +      out_failed:
> +       reiserfs_write_unlock(dir->i_sb);
> +       return retval;
> +}
> +
>  static int reiserfs_mknod(struct inode *dir, struct dentry *dentry, umode_t mode,
>                           dev_t rdev)
>  {
> @@ -1522,6 +1581,7 @@ const struct inode_operations reiserfs_dir_inode_operations = {
>         .removexattr = reiserfs_removexattr,
>         .permission = reiserfs_permission,
>         .get_acl = reiserfs_get_acl,
> +       .tmpfile = reiserfs_tmpfile,
>  };
>
>  /*
> --
> 1.8.1.4
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks,
//richard
