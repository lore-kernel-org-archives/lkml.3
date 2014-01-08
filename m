Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbaAHCGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 21:06:54 -0500
Received: from m59-178.qiye.163.com ([123.58.178.59]:46810 "EHLO
	m59-178.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749AbaAHCGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 21:06:43 -0500
Message-ID: <52CCB2A7.2000300@ubuntukylin.com>
Date: Wed, 08 Jan 2014 10:06:31 +0800
From: Li Wang <liwang@ubuntukylin.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>, Zefan Li <lizefan@huawei.com>,
        Matthew Wilcox <matthew@wil.cx>,
        Yunchuan Wen <yunchuanwen@ubuntukylin.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] Add shrink_pagecache_parent
References: <cover.1388409686.git.liwang@ubuntukylin.com>	<249cbd3edaa84dd58a0626780fb546ddf7c1dc11.1388409687.git.liwang@ubuntukylin.com> <20140102155534.9b0cd498209d835d0c93837e@linux-foundation.org>
In-Reply-To: <20140102155534.9b0cd498209d835d0c93837e@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-HM-Spam-Status: e1koWUFPN1dZCBgUCR5ZQUpIVU5IS0tLS01DTU1PTk5LQ1dZCQ4XHghZQV
	koKz0kKzooKCQyNSQzPjo*PilBS1VLQDYjJCI#KCQyNSQzPjo*PilBS1VLQCsvKSQiPigkMjUkMz
	46Pz4pQUtVS0A4NC41LykiJDg1QUtVS0ApPjwyNDUkOigyOkFLVUtAKyk0LTI1OD4kMTI6NTwoLk
	FLVUtAPyI1OjYyOCQyKyQiPigkMjUkMz46Pz4pQUlVS0ApPjo3JDIrJDI1JCk5NyQyNSQzPjo*Pi
	lBSklVS0A2LjcvMiQpOCsvJD8yPT0#KT41LyQyNSQzPjo*PilBSVVLQDIrJC80PzoiJDg1LyRLJE
	pLS0FLVUtAMiskTiQ2MjUuLz4kODUvJEskSktBS1VLQDIrJEokNjI1Li8#JDg1LyRLJEpLQUtVS0
	AyKyRKJDM0LikkODUvJEskSktLQUtVS0AyKyRISyQ2MjUuLz4kODUvJEskTktBS1VLQD01JDY6Ii
	RPSkIkMzcxJEokS0NLSEtPQUtVSEhAPSskKT4kPSwkMzcxJEtDS0hLTUFWTFVOQCguOSQ#QUpVTk
	5APTUkNjoiJE9KQiQzNzEkSSRLQ0tIS09BS1VLQD01JDkyL0wkMzcxJEtMSklLSUFIVUpOWQY+
X-HM-Sender-Digest: e1kSHx4VD1lBWUc6MQg6Cjo4LDo4EDorKjhIOj4qOkMwCjFVSlVKSENC
	Sk9NQ0tLT0NLVTMWGhIXVRcSDBoVHDsOGQ4VDw4QAhcSFVUYFBZFWVdZDB4ZWUEdGhcIHldZCAFZ
	QU5LT0I3V1kSC1lBWUpJSVVKQk9VSlVITlkG
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 01/03/2014 07:55 AM, Andrew Morton wrote:
> On Mon, 30 Dec 2013 21:45:17 +0800 Li Wang <liwang@ubuntukylin.com> wrote:
>
>> Analogous to shrink_dcache_parent except that it collects inodes.
>> It is not very appropriate to be put in dcache.c, but d_walk can only
>> be invoked from here.
>
> Please cc Dave Chinner on future revisions.  He be da man.
>
> The overall intent of the patchset seems reasonable and I agree that it
> can't be efficiently done from userspace with the current kernel API.
> We *could* do it from userspace by providing facilities for userspace to
> query the VFS caches: "is this pathname in the dentry cache" and "is
> this inode in the inode cache".
>
Even we have these available, i am afraid it will still introduce
non-negligible overhead due to frequent system calls for a directory
  walking operation, especially under massive small file situations.

>> --- a/fs/dcache.c
>> +++ b/fs/dcache.c
>> @@ -1318,6 +1318,42 @@ void shrink_dcache_parent(struct dentry *parent)
>>   }
>>   EXPORT_SYMBOL(shrink_dcache_parent);
>>
>> +static enum d_walk_ret gather_inode(void *data, struct dentry *dentry)
>> +{
>> +	struct list_head *list = data;
>> +	struct inode *inode = dentry->d_inode;
>> +
>> +	if ((inode == NULL) || ((!inode_owner_or_capable(inode)) &&
>> +				(!capable(CAP_SYS_ADMIN))))
>> +		goto out;
>> +	spin_lock(&inode->i_lock);
>> +	if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
>
> It's unclear what rationale lies behind this particular group of tests.
>
>> +		(inode->i_mapping->nrpages == 0) ||
>> +		(!list_empty(&inode->i_lru))) {
>
> arg, the "Inode locking rules" at the top of fs/inode.c needs a
> refresh, I suspect.  It is too vague.
>
> Formally, inode->i_lru is protected by
> i_sb->s_inode_lru->node[nid].lock, not by ->i_lock.  I guess you can
> just do a list_lru_add() and that will atomically add the inode to your
> local list_lru if ->i_lru wasn't being used for anything else.
>
> I *think* that your use of i_lock works OK, because code which fiddles
> with i_lru and s_inode_lru also takes i_lock.  However we need to
> decide which is the preferred and official lock.  ie: what is the
> design here??
>
> However...  most inodes will be on an LRU list, won't they?  Doesn't
> this reuse of i_lru mean that many inodes will fail to be processed?
> If so, we might need to add a new list_head to the inode, which will be
> problematic.
>
As far as I know, fix me if i am wrong, only when inode has zero
reference count, it will be put into superblock lru list. For most
situations, there is at least a dentry refers to it, so it will not
be on any lru list.

>
> Aside: inode_lru_isolate() fiddles directly with inode->i_lru without
> taking i_sb->s_inode_lru->node[nid].lock.  Why doesn't this make a
> concurrent s_inode_lru walker go oops??  Should we be using
> list_lru_del() in there?  (which should have been called
> list_lru_del_init(), sigh).
>
It seems inode_lru_isolate() only called by prune_icache_sb() as
a callback function. Before calling it, the caller has hold
the lock.
