Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168Ab3DGJcI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 05:32:08 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:53755 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760566Ab3DGJcF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 05:32:05 -0400
Subject: Re: [PATCH] hfs: add error checking for hfs_find_init()
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Vyacheslav Dubeyko <slava@dubeyko.com>
In-Reply-To: <51608FFD.2020706@ispras.ru>
Date: Sun, 7 Apr 2013 13:31:59 +0400
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org,
        Hin-Tak Leung <htl10@users.sourceforge.net>
Content-Transfer-Encoding: 8BIT
Message-Id: <0199BA74-9971-4928-A133-DB1FC562DC43@dubeyko.com>
References: <1364593487-11034-1-git-send-email-khoroshilov@ispras.ru> <0D203BE4-D965-42FE-ADA7-831070860222@dubeyko.com> <51608FFD.2020706@ispras.ru>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
X-Mailer: Apple Mail (2.1085)
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 46.39.244.28 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexey,

On Apr 7, 2013, at 1:13 AM, Alexey Khoroshilov wrote:

> Hi Vyacheslav,
> 
> On 03/30/2013 03:35 PM, Vyacheslav Dubeyko wrote:
>>> Found by Linux Driver Verification project (linuxtesting.org).
>>> 
>>> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
>>> ---
>>> fs/hfs/catalog.c |   12 +++++++++---
>>> fs/hfs/dir.c     |    8 ++++++--
>>> fs/hfs/extent.c  |   48 +++++++++++++++++++++++++++++++++---------------
>>> fs/hfs/hfs_fs.h  |    2 +-
>>> fs/hfs/inode.c   |   11 +++++++++--
>>> fs/hfs/super.c   |    4 +++-
>>> 6 files changed, 61 insertions(+), 24 deletions(-)
>>> 
>>> diff --git a/fs/hfs/catalog.c b/fs/hfs/catalog.c
>>> index 424b033..9569b39 100644
>>> --- a/fs/hfs/catalog.c
>>> +++ b/fs/hfs/catalog.c
>>> @@ -92,7 +92,9 @@ int hfs_cat_create(u32 cnid, struct inode *dir, struct qstr *str, struct inode *
>>> 		return -ENOSPC;
>>> 
>>> 	sb = dir->i_sb;
>>> -	hfs_find_init(HFS_SB(sb)->cat_tree, &fd);
>>> +	err = hfs_find_init(HFS_SB(sb)->cat_tree, &fd);
>>> +	if (err)
>>> +		return err;
>>> 
>>> 	hfs_cat_build_key(sb, fd.search_key, cnid, NULL);
>>> 	entry_size = hfs_cat_build_thread(sb, &entry, S_ISDIR(inode->i_mode) ?
>>> @@ -214,7 +216,9 @@ int hfs_cat_delete(u32 cnid, struct inode *dir, struct qstr *str)
>>> 
>>> 	dprint(DBG_CAT_MOD, "delete_cat: %s,%u\n", str ? str->name : NULL, cnid);
>>> 	sb = dir->i_sb;
>>> -	hfs_find_init(HFS_SB(sb)->cat_tree, &fd);
>>> +	res = hfs_find_init(HFS_SB(sb)->cat_tree, &fd);
>>> +	if (res)
>>> +		return res;
>>> 
>>> 	hfs_cat_build_key(sb, fd.search_key, dir->i_ino, str);
>>> 	res = hfs_brec_find(&fd);
>>> @@ -281,7 +285,9 @@ int hfs_cat_move(u32 cnid, struct inode *src_dir, struct qstr *src_name,
>>> 	dprint(DBG_CAT_MOD, "rename_cat: %u - %lu,%s - %lu,%s\n", cnid, src_dir->i_ino, src_name->name,
>>> 		dst_dir->i_ino, dst_name->name);
>>> 	sb = src_dir->i_sb;
>>> -	hfs_find_init(HFS_SB(sb)->cat_tree, &src_fd);
>>> +	err = hfs_find_init(HFS_SB(sb)->cat_tree, &src_fd);
>>> +	if (err)
>>> +		return err;
>>> 	dst_fd = src_fd;
>>> 
>>> 	/* find the old dir entry and read the data */
>>> diff --git a/fs/hfs/dir.c b/fs/hfs/dir.c
>>> index 5f7f1ab..e1c8048 100644
>>> --- a/fs/hfs/dir.c
>>> +++ b/fs/hfs/dir.c
>>> @@ -25,7 +25,9 @@ static struct dentry *hfs_lookup(struct inode *dir, struct dentry *dentry,
>>> 	struct inode *inode = NULL;
>>> 	int res;
>>> 
>>> -	hfs_find_init(HFS_SB(dir->i_sb)->cat_tree, &fd);
>>> +	res = hfs_find_init(HFS_SB(dir->i_sb)->cat_tree, &fd);
>>> +	if (res)
>>> +		return ERR_PTR(res);
>>> 	hfs_cat_build_key(dir->i_sb, fd.search_key, dir->i_ino, &dentry->d_name);
>>> 	res = hfs_brec_read(&fd, &rec, sizeof(rec));
>>> 	if (res) {
>>> @@ -63,7 +65,9 @@ static int hfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
>>> 	if (filp->f_pos >= inode->i_size)
>>> 		return 0;
>>> 
>>> -	hfs_find_init(HFS_SB(sb)->cat_tree, &fd);
>>> +	err = hfs_find_init(HFS_SB(sb)->cat_tree, &fd);
>>> +	if (err)
>>> +		return err;
>>> 	hfs_cat_build_key(sb, fd.search_key, inode->i_ino, NULL);
>>> 	err = hfs_brec_find(&fd);
>>> 	if (err)
>>> diff --git a/fs/hfs/extent.c b/fs/hfs/extent.c
>>> index a67955a..813447b 100644
>>> --- a/fs/hfs/extent.c
>>> +++ b/fs/hfs/extent.c
>>> @@ -107,7 +107,7 @@ static u16 hfs_ext_lastblock(struct hfs_extent *ext)
>>> 	return be16_to_cpu(ext->block) + be16_to_cpu(ext->count);
>>> }
>>> 
>>> -static void __hfs_ext_write_extent(struct inode *inode, struct hfs_find_data *fd)
>>> +static int __hfs_ext_write_extent(struct inode *inode, struct hfs_find_data *fd)
>>> {
>>> 	int res;
>>> 
>>> @@ -116,26 +116,31 @@ static void __hfs_ext_write_extent(struct inode *inode, struct hfs_find_data *fd
>>> 	res = hfs_brec_find(fd);
>>> 	if (HFS_I(inode)->flags & HFS_FLG_EXT_NEW) {
>>> 		if (res != -ENOENT)
>>> -			return;
>>> +			return res;
>>> 		hfs_brec_insert(fd, HFS_I(inode)->cached_extents, sizeof(hfs_extent_rec));
>>> 		HFS_I(inode)->flags &= ~(HFS_FLG_EXT_DIRTY|HFS_FLG_EXT_NEW);
>>> 	} else {
>>> 		if (res)
>>> -			return;
>>> +			return res;
>>> 		hfs_bnode_write(fd->bnode, HFS_I(inode)->cached_extents, fd->entryoffset, fd->entrylength);
>>> 		HFS_I(inode)->flags &= ~HFS_FLG_EXT_DIRTY;
>>> 	}
>>> +	return 0;
>>> }
>> As I see, this fix makes sense and for hfsplus also. Please, make it and for hfsplus.
> Sorry, I did not catch which fix do you mean. Could you please clarify it.
> 

I meant:
(1) correction the issue with returning error in __hfsplus_ext_write_extent() method (http://lxr.free-electrons.com/source/fs/hfsplus/extents.c#L86);
(2) adding error processing in hfsplus_ext_write_extent_locked() method (http://lxr.free-electrons.com/source/fs/hfsplus/extents.c#L132);
(3) adding error processing in __hfsplus_ext_cache_extent() method (http://lxr.free-electrons.com/source/fs/hfsplus/extents.c#L179).

Moreover, as I remember, Hin-Tak asks about adding dprint messages.

Thanks,
Vyacheslav Dubeyko.

> Thank you,
> Alexey
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

