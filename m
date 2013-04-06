Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932876Ab3DFVNi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 17:13:38 -0400
Received: from mail.ispras.ru ([83.149.199.45]:48838 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932713Ab3DFVNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 17:13:37 -0400
Message-ID: <51608FFD.2020706@ispras.ru>
Date: Sun, 07 Apr 2013 01:13:33 +0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Vyacheslav Dubeyko <slava@dubeyko.com>
CC: Al Viro <viro@zeniv.linux.org.uk>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org,
        Hin-Tak Leung <htl10@users.sourceforge.net>
Subject: Re: [PATCH] hfs: add error checking for hfs_find_init()
References: <1364593487-11034-1-git-send-email-khoroshilov@ispras.ru> <0D203BE4-D965-42FE-ADA7-831070860222@dubeyko.com>
In-Reply-To: <0D203BE4-D965-42FE-ADA7-831070860222@dubeyko.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vyacheslav,

On 03/30/2013 03:35 PM, Vyacheslav Dubeyko wrote:
>> Found by Linux Driver Verification project (linuxtesting.org).
>>
>> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
>> ---
>> fs/hfs/catalog.c |   12 +++++++++---
>> fs/hfs/dir.c     |    8 ++++++--
>> fs/hfs/extent.c  |   48 +++++++++++++++++++++++++++++++++---------------
>> fs/hfs/hfs_fs.h  |    2 +-
>> fs/hfs/inode.c   |   11 +++++++++--
>> fs/hfs/super.c   |    4 +++-
>> 6 files changed, 61 insertions(+), 24 deletions(-)
>>
>> diff --git a/fs/hfs/catalog.c b/fs/hfs/catalog.c
>> index 424b033..9569b39 100644
>> --- a/fs/hfs/catalog.c
>> +++ b/fs/hfs/catalog.c
>> @@ -92,7 +92,9 @@ int hfs_cat_create(u32 cnid, struct inode *dir, struct qstr *str, struct inode *
>> 		return -ENOSPC;
>>
>> 	sb = dir->i_sb;
>> -	hfs_find_init(HFS_SB(sb)->cat_tree, &fd);
>> +	err = hfs_find_init(HFS_SB(sb)->cat_tree, &fd);
>> +	if (err)
>> +		return err;
>>
>> 	hfs_cat_build_key(sb, fd.search_key, cnid, NULL);
>> 	entry_size = hfs_cat_build_thread(sb, &entry, S_ISDIR(inode->i_mode) ?
>> @@ -214,7 +216,9 @@ int hfs_cat_delete(u32 cnid, struct inode *dir, struct qstr *str)
>>
>> 	dprint(DBG_CAT_MOD, "delete_cat: %s,%u\n", str ? str->name : NULL, cnid);
>> 	sb = dir->i_sb;
>> -	hfs_find_init(HFS_SB(sb)->cat_tree, &fd);
>> +	res = hfs_find_init(HFS_SB(sb)->cat_tree, &fd);
>> +	if (res)
>> +		return res;
>>
>> 	hfs_cat_build_key(sb, fd.search_key, dir->i_ino, str);
>> 	res = hfs_brec_find(&fd);
>> @@ -281,7 +285,9 @@ int hfs_cat_move(u32 cnid, struct inode *src_dir, struct qstr *src_name,
>> 	dprint(DBG_CAT_MOD, "rename_cat: %u - %lu,%s - %lu,%s\n", cnid, src_dir->i_ino, src_name->name,
>> 		dst_dir->i_ino, dst_name->name);
>> 	sb = src_dir->i_sb;
>> -	hfs_find_init(HFS_SB(sb)->cat_tree, &src_fd);
>> +	err = hfs_find_init(HFS_SB(sb)->cat_tree, &src_fd);
>> +	if (err)
>> +		return err;
>> 	dst_fd = src_fd;
>>
>> 	/* find the old dir entry and read the data */
>> diff --git a/fs/hfs/dir.c b/fs/hfs/dir.c
>> index 5f7f1ab..e1c8048 100644
>> --- a/fs/hfs/dir.c
>> +++ b/fs/hfs/dir.c
>> @@ -25,7 +25,9 @@ static struct dentry *hfs_lookup(struct inode *dir, struct dentry *dentry,
>> 	struct inode *inode = NULL;
>> 	int res;
>>
>> -	hfs_find_init(HFS_SB(dir->i_sb)->cat_tree, &fd);
>> +	res = hfs_find_init(HFS_SB(dir->i_sb)->cat_tree, &fd);
>> +	if (res)
>> +		return ERR_PTR(res);
>> 	hfs_cat_build_key(dir->i_sb, fd.search_key, dir->i_ino, &dentry->d_name);
>> 	res = hfs_brec_read(&fd, &rec, sizeof(rec));
>> 	if (res) {
>> @@ -63,7 +65,9 @@ static int hfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
>> 	if (filp->f_pos >= inode->i_size)
>> 		return 0;
>>
>> -	hfs_find_init(HFS_SB(sb)->cat_tree, &fd);
>> +	err = hfs_find_init(HFS_SB(sb)->cat_tree, &fd);
>> +	if (err)
>> +		return err;
>> 	hfs_cat_build_key(sb, fd.search_key, inode->i_ino, NULL);
>> 	err = hfs_brec_find(&fd);
>> 	if (err)
>> diff --git a/fs/hfs/extent.c b/fs/hfs/extent.c
>> index a67955a..813447b 100644
>> --- a/fs/hfs/extent.c
>> +++ b/fs/hfs/extent.c
>> @@ -107,7 +107,7 @@ static u16 hfs_ext_lastblock(struct hfs_extent *ext)
>> 	return be16_to_cpu(ext->block) + be16_to_cpu(ext->count);
>> }
>>
>> -static void __hfs_ext_write_extent(struct inode *inode, struct hfs_find_data *fd)
>> +static int __hfs_ext_write_extent(struct inode *inode, struct hfs_find_data *fd)
>> {
>> 	int res;
>>
>> @@ -116,26 +116,31 @@ static void __hfs_ext_write_extent(struct inode *inode, struct hfs_find_data *fd
>> 	res = hfs_brec_find(fd);
>> 	if (HFS_I(inode)->flags & HFS_FLG_EXT_NEW) {
>> 		if (res != -ENOENT)
>> -			return;
>> +			return res;
>> 		hfs_brec_insert(fd, HFS_I(inode)->cached_extents, sizeof(hfs_extent_rec));
>> 		HFS_I(inode)->flags &= ~(HFS_FLG_EXT_DIRTY|HFS_FLG_EXT_NEW);
>> 	} else {
>> 		if (res)
>> -			return;
>> +			return res;
>> 		hfs_bnode_write(fd->bnode, HFS_I(inode)->cached_extents, fd->entryoffset, fd->entrylength);
>> 		HFS_I(inode)->flags &= ~HFS_FLG_EXT_DIRTY;
>> 	}
>> +	return 0;
>> }
> As I see, this fix makes sense and for hfsplus also. Please, make it and for hfsplus.
Sorry, I did not catch which fix do you mean. Could you please clarify it.

Thank you,
Alexey

