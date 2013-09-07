Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751063Ab3IGQWA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 12:22:00 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:53472 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab3IGQV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 12:21:58 -0400
Message-ID: <522B5100.8050707@gmail.com>
Date: Sat, 07 Sep 2013 18:14:56 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [PATCH 08/19] pramfs: file operations for dirs
References: <522AE24C.6060903@gmail.com> <20130907150119.GB13318@ZenIV.linux.org.uk>
In-Reply-To: <20130907150119.GB13318@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 07/09/2013 17:01, Al Viro ha scritto:
> On Sat, Sep 07, 2013 at 10:22:36AM +0200, Marco Stornelli wrote:
>> +int pram_add_link(struct dentry *dentry, struct inode *inode)
>> +{
>> +	struct inode *dir = dentry->d_parent->d_inode;
>> +	struct pram_inode *pidir, *pi, *pitail = NULL;
>> +	u64 tail_ino, prev_ino;
>> +
>> +	const char *name = dentry->d_name.name;
>> +
>> +	int namelen = min_t(unsigned int, dentry->d_name.len, PRAM_NAME_LEN);
>
> Whatever the hell for?  Your ->lookup() rejects dentries with names longer
> than PRAM_NAME_LEN with an error, so they won't reach this function at all.
>

Ok. I'll remove it.

>> +int pram_remove_link(struct inode *inode)
>
> Umm...  That's called on rename (for old one) *and* inode eviction when link
> count goes to zero.  What's the point of keeping unlinked ones (unlink/rmdir/
> rename victims) on those lists?  Sure, you skip them on lookups, but why
> delay link removal until eviction?  You pay for that with extra locking,
> BTW - if not for that, you wouldn't need your i_link_mutex at all.
>

Good question. The only answer I've got now is for "historical" reason, 
I can't see at the moment why we can remove the link information in case 
of opened-but-unlinked, instead of delay the operation until evict.

>> +	pi = pram_get_inode(sb, inode->i_ino);
>> +
>> +	switch ((u32)file->f_pos) {
>> +	case 0:
>> +		ret = dir_emit_dot(file, ctx);
>> +		ctx->pos = 1;
>> +		return ret;
>
> Really?  So on the first call of ->iterate() you just generate one
> entry and don't even try to produce more?  And it looks like the
> rest is no nicer...
>

I'll try to improve the behavior here.

Marco
