Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933676Ab3CHEPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 23:15:39 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:35507 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932577Ab3CHEPi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 23:15:38 -0500
MIME-Version: 1.0
In-Reply-To: <1362710332.14386.38.camel@kjgkr>
References: <1362195678-20785-1-git-send-email-linkinjeon@gmail.com>
	<1362287099.14386.13.camel@kjgkr>
	<CAKYAXd8VzmxdrUq-vCbhDpLWirmUUxRjj_-5FUmNutBG5cojVA@mail.gmail.com>
	<1362710332.14386.38.camel@kjgkr>
Date: Fri, 8 Mar 2013 13:15:37 +0900
Message-ID: <CAKYAXd8Dokeg1Z5R+p9a+pt=Vk=4Rmm-yMdrao48QATt+JoQ+A@mail.gmail.com>
Subject: Re: [PATCH 4/5] f2fs: align f2fs maximum name length to linux based filesystem
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/8, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> 2013-03-04 (월), 15:25 +0900, Namjae Jeon:
>> 2013/3/3, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
>> > We should not change the on-disk layout.
>> > Instead, simply we can deal with it by changing original condition
>> > check
>> > like below.
>>
>> Even though the changes you suggested are ok. But there is one doubt.
>> By not changing the on-disk layout and just taking care of the limits
>> using the code is just causing confusion and looks a make-shift
>> arrangement.
>> Even though ‘256’ is the space reserved for the name ‘on-disk’ but by
>> changing the code – we are limiting it to use ‘255’.
>> If we chance the on-disk to make use of ‘255’ bytes it allows for
>> keeping all code intact and also like the code changes suggested, it
>> will still refer only the ‘255’ bytes.
>>
>> More so, changing the on-disk allows for ‘1byte’ which is still padded
>> at the same position to be used in future. Otherwise, this ‘extra’
>> byte will continue to exist without having that to be used for some
>> extra work.
>
> Agreed, but it still needs to change a couple of names.
> How about this?
Looks good to me.
Thanks!

>
> From 2ce7f345559d967bc1c79959885dff9f0a713e32 Mon Sep 17 00:00:00 2001
> From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> Date: Sun, 3 Mar 2013 13:58:05 +0900
> Subject: [PATCH] f2fs: align f2fs maximum name length to linux based
> filesystem
> Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
> linux-f2fs-devel@lists.sourceforge.net
>
> The maximum filename length supported in linux is 255 characters.
> So let's follow that.
>
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> ---
>  fs/f2fs/dir.c           |  3 +++
>  fs/f2fs/namei.c         |  2 +-
>  fs/f2fs/super.c         |  2 +-
>  include/linux/f2fs_fs.h | 17 +++++++++--------
>  4 files changed, 14 insertions(+), 10 deletions(-)
>
> diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
> index a1f3844..2851ae6 100644
> --- a/fs/f2fs/dir.c
> +++ b/fs/f2fs/dir.c
> @@ -189,6 +189,9 @@ struct f2fs_dir_entry *f2fs_find_entry(struct inode
> *dir,
>  	unsigned int max_depth;
>  	unsigned int level;
>
> +	if (namelen > F2FS_NAME_LEN)
> +		return NULL;
> +
>  	if (npages == 0)
>  		return NULL;
>
> diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
> index 1a49b88..d4a171b 100644
> --- a/fs/f2fs/namei.c
> +++ b/fs/f2fs/namei.c
> @@ -197,7 +197,7 @@ static struct dentry *f2fs_lookup(struct inode *dir,
> struct dentry *dentry,
>  	struct f2fs_dir_entry *de;
>  	struct page *page;
>
> -	if (dentry->d_name.len > F2FS_MAX_NAME_LEN)
> +	if (dentry->d_name.len > F2FS_NAME_LEN)
>  		return ERR_PTR(-ENAMETOOLONG);
>
>  	de = f2fs_find_entry(dir, &dentry->d_name, &page);
> diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
> index 8c11764..1c7f595 100644
> --- a/fs/f2fs/super.c
> +++ b/fs/f2fs/super.c
> @@ -180,7 +180,7 @@ static int f2fs_statfs(struct dentry *dentry, struct
> kstatfs *buf)
>  	buf->f_files = sbi->total_node_count;
>  	buf->f_ffree = sbi->total_node_count - valid_inode_count(sbi);
>
> -	buf->f_namelen = F2FS_MAX_NAME_LEN;
> +	buf->f_namelen = F2FS_NAME_LEN;
>  	buf->f_fsid.val[0] = (u32)id;
>  	buf->f_fsid.val[1] = (u32)(id >> 32);
>
> diff --git a/include/linux/f2fs_fs.h b/include/linux/f2fs_fs.h
> index f9a12f6..df6fab8 100644
> --- a/include/linux/f2fs_fs.h
> +++ b/include/linux/f2fs_fs.h
> @@ -139,7 +139,7 @@ struct f2fs_extent {
>  	__le32 len;		/* lengh of the extent */
>  } __packed;
>
> -#define F2FS_MAX_NAME_LEN	256
> +#define F2FS_NAME_LEN		255
>  #define ADDRS_PER_INODE         923	/* Address Pointers in an Inode */
>  #define ADDRS_PER_BLOCK         1018	/* Address Pointers in a Direct
> Block */
>  #define NIDS_PER_BLOCK          1018	/* Node IDs in an Indirect Block
> */
> @@ -165,7 +165,8 @@ struct f2fs_inode {
>  	__le32 i_flags;			/* file attributes */
>  	__le32 i_pino;			/* parent inode number */
>  	__le32 i_namelen;		/* file name length */
> -	__u8 i_name[F2FS_MAX_NAME_LEN];	/* file name for SPOR */
> +	__u8 i_name[F2FS_NAME_LEN];	/* file name for SPOR */
> +	__u8 i_reserved2;		/* for backward compatibility */
>
>  	struct f2fs_extent i_ext;	/* caching a largest extent */
>
> @@ -362,10 +363,10 @@ struct f2fs_summary_block {
>  typedef __le32	f2fs_hash_t;
>
>  /* One directory entry slot covers 8bytes-long file name */
> -#define F2FS_NAME_LEN		8
> -#define F2FS_NAME_LEN_BITS	3
> +#define F2FS_SLOT_LEN		8
> +#define F2FS_SLOT_LEN_BITS	3
>
> -#define GET_DENTRY_SLOTS(x)	((x + F2FS_NAME_LEN - 1) >>
> F2FS_NAME_LEN_BITS)
> +#define GET_DENTRY_SLOTS(x)	((x + F2FS_SLOT_LEN - 1) >>
> F2FS_SLOT_LEN_BITS)
>
>  /* the number of dentry in a block */
>  #define NR_DENTRY_IN_BLOCK	214
> @@ -377,10 +378,10 @@ typedef __le32	f2fs_hash_t;
>  #define SIZE_OF_DENTRY_BITMAP	((NR_DENTRY_IN_BLOCK + BITS_PER_BYTE -
> 1) / \
>  					BITS_PER_BYTE)
>  #define SIZE_OF_RESERVED	(PAGE_SIZE - ((SIZE_OF_DIR_ENTRY + \
> -				F2FS_NAME_LEN) * \
> +				F2FS_SLOT_LEN) * \
>  				NR_DENTRY_IN_BLOCK + SIZE_OF_DENTRY_BITMAP))
>
> -/* One directory entry slot representing F2FS_NAME_LEN-sized file name
> */
> +/* One directory entry slot representing F2FS_SLOT_LEN-sized file name
> */
>  struct f2fs_dir_entry {
>  	__le32 hash_code;	/* hash code of file name */
>  	__le32 ino;		/* inode number */
> @@ -394,7 +395,7 @@ struct f2fs_dentry_block {
>  	__u8 dentry_bitmap[SIZE_OF_DENTRY_BITMAP];
>  	__u8 reserved[SIZE_OF_RESERVED];
>  	struct f2fs_dir_entry dentry[NR_DENTRY_IN_BLOCK];
> -	__u8 filename[NR_DENTRY_IN_BLOCK][F2FS_NAME_LEN];
> +	__u8 filename[NR_DENTRY_IN_BLOCK][F2FS_SLOT_LEN];
>  } __packed;
>
>  /* file types used in inode_info->flags */
> --
> 1.8.1.3.566.gaa39828
>
>
>
>
> --
> Jaegeuk Kim
> Samsung
>
