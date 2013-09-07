Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751248Ab3IGQYo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 12:24:44 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:50689 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab3IGQYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 12:24:43 -0400
Message-ID: <522B51A5.4040003@gmail.com>
Date: Sat, 07 Sep 2013 18:17:41 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/19] pramfs: inode operations for dirs
References: <522AE28E.3010709@gmail.com> <20130907150857.GC13318@ZenIV.linux.org.uk>
In-Reply-To: <20130907150857.GC13318@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 07/09/2013 17:08, Al Viro ha scritto:
> On Sat, Sep 07, 2013 at 10:23:42AM +0200, Marco Stornelli wrote:
>
>> +static int pram_rmdir(struct inode *dir, struct dentry *dentry)
>> +{
>> +	struct inode *inode = dentry->d_inode;
>> +	struct pram_inode *pi;
>> +	int err = -ENOTEMPTY;
>> +
>> +	if (!inode)
>> +		return -ENOENT;
>> +
>> +	pi = pram_get_inode(dir->i_sb, inode->i_ino);
>> +
>> +	/* directory to delete is empty? */
>> +	if (pi->i_type.dir.tail == 0) {
>> +		inode->i_ctime = dir->i_ctime;
>> +		inode->i_size = 0;
>> +		clear_nlink(inode);
>> +		pram_write_inode(inode, NULL);
>> +		pram_dec_count(dir);
>> +		err = 0;
>> +	} else {
>> +		pram_dbg("dir not empty\n");
>> +	}
>> +
>> +	return err;
>> +}
>
> ... and here you are paying for delayed removal of entries:
> 	mkdir foo
> 	touch foo/bar
> 	rm -rf foo <foo/bar
> will fail, since opened-and-unlinked file in effect keeps the directory
> where it used to be "not empty" from your rmdir (and rename) POV.
>

Yep. Same problem as before. I think I can move the remove link into 
pram_dec_count and I have to modify the evict path, it should be easy to 
manage.

Thanks for your comments Al!!!!

Marco
