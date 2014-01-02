Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745AbaABMoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 07:44:23 -0500
Received: from m59-178.qiye.163.com ([123.58.178.59]:46378 "EHLO
	m59-178.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbaABMoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 07:44:21 -0500
Message-ID: <52C55F12.4050406@ubuntukylin.com>
Date: Thu, 02 Jan 2014 20:44:02 +0800
From: Li Wang <liwang@ubuntukylin.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Dave Hansen <dave.hansen@intel.com>, Andreas Dilger <adilger@dilger.ca>
CC: Alexander Viro <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>, Zefan Li <lizefan@huawei.com>,
        Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 0/3] Fadvise: Directory level page cache cleaning support
References: <cover.1388409686.git.liwang@ubuntukylin.com> <52C1C6F7.8010809@intel.com> <FFE7C704-791E-4B73-9251-EFB9135AB254@dilger.ca> <52C1E6B1.4010402@intel.com>
In-Reply-To: <52C1E6B1.4010402@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-HM-Spam-Status: e1koWUFPN1dZCBgUCR5ZQUpIVU5OQkJCQk9NTkJPSUhDSFdZCQ4XHghZQV
	koKz0kKzooKCQyNSQzPjo*PilBS1VLQDYjJCI#KCQyNSQzPjo*PilBS1VLQCsvKSQiPigkMjUkMz
	46Pz4pQUtVS0A4NC41LykiJDg1QUtVS0ApPjwyNDUkOigyOkFLVUtAKyk0LTI1OD4kMy41OjVBS1
	VLQD8iNTo2MjgkMiskNTQkMjUkMz46Pz4pQUtVS0ApPjo3JDIrJDI1JCk5NyQyNSQzPjo*PilBSk
	lVS0A2LjcvMiQpOCsvJD8yPT0#KT41LyQyNSQzPjo*PilBSVVLQDIrJC80PzoiJDg1LyRLJEpLS0
	FLVUtAMiskTiQ2MjUuLz4kODUvJEskSktBS1VLQDIrJEokNjI1Li8#JDg1LyRLJEpLQUtVS0AyKy
	RKJDM0LikkODUvJEskSktLQUtVS0AyKyRISyQ2MjUuLz4kODUvJEskTktBS1VLQD01JDY6IiRPSk
	IkMzcxJEokS0NLSEtPQUtVSEhAPSskKT4kPSwkMzcxJEtDS0hLTUFWTFVOQCguOSQ#QUpVTk5APT
	UkKC45JD41LDQpPygkMzcxJEpLS0lLSkFLVUlDQD01JDkyL0wkMzcxJEtMSklLSUFIVUpOQD01JD
	0pPj4kMzcxJEtMS05LT0FKVUxOWQY+
X-HM-Sender-Digest: e1kSHx4VD1lBWUc6MQg6Cjo4LDo4EDorKjhIOj4qOkMwCjFVSlVKSEND
	TU1NTU5MSk9DVTMWGhIXVRcSDBoVHDsOGQ4VDw4QAhcSFVUYFBZFWVdZDB4ZWUEdGhcIHldZCAFZ
	QUhDSEk3V1kSC1lBWU1KVUpDTFVOT1VCWQY+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do we really need clean dcache/icache at the current stage?
That will introduce more code work, so far, iput() will put
those unreferenced inodes into superblock lru list. To free
the inodes inside a specific directory, it seems we do not
have a handy API to use, and need
modify iput() to recognize our situation, and collect those
inodes into our list rather than superblock lru list. Maybe
we stay at current stage now, since it is simple and could
gain the major benefits, leave the dcache/icache cleaning
to do in the future?

On 2013/12/31 5:33, Dave Hansen wrote:
> On 12/30/2013 11:40 AM, Andreas Dilger wrote:
>> On Dec 30, 2013, at 12:18, Dave Hansen <dave.hansen@intel.com> wrote:
>>> Why is this necessary to do in the kernel?  Why not leave it to
>>> userspace to walk the filesystem(s)?
>>
>> I would suspect that trying to do it in userspace would be quite bad. It would require traversing the whole directory tree to issue cache flushed for each subdirectory, but it doesn't know when to stop traversal. That would mean the "cache flush" would turn into "cache pollute" and cause a lot of disk IO for subdirectories not in cache to begin with.
>
> That makes sense for dentries at least and is a pretty good reason.
> Probably good enough to to include some text in the patch description.
> ;)  Perhaps: "We need this interface because we have no way of
> determining what is in the dcache from userspace, and we do not want
> userspace to pollute the dcache going and looking for page cache to evict."
>
> One other thing that bothers me: POSIX_FADV_DONTNEED on a directory
> seems like it should do something with the _directory_.  It should undo
> the kernel's caching that happens as a result of readdir().
>
> Should this also be trying to drop the dentry/inode entries like "echo 2
>> .../drop_caches" does?
