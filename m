Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932698Ab3GPNSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 09:18:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932283Ab3GPNSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 09:18:37 -0400
Message-ID: <51E54764.4070106@redhat.com>
Date: Tue, 16 Jul 2013 09:15:16 -0400
From: Brian Foster <bfoster@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Niels de Vos <ndevos@redhat.com>
CC: Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [fuse-devel] [PATCH] fuse: fix occasional dentry leak when readdirplus
 is used
References: <1373893160-30601-1-git-send-email-ndevos@redhat.com> <51E456B6.8050601@redhat.com> <20130716103939.GL18803@ndevos-laptop.usersys.redhat.com>
In-Reply-To: <20130716103939.GL18803@ndevos-laptop.usersys.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2013 06:39 AM, Niels de Vos wrote:
> On Mon, Jul 15, 2013 at 04:08:22PM -0400, Brian Foster wrote:
>> On 07/15/2013 08:59 AM, Niels de Vos wrote:
...
> 
>>> ---
>>>  fs/fuse/dir.c |    4 +++-
>>>  1 files changed, 3 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
>>> index 0eda527..da67a15 100644
>>> --- a/fs/fuse/dir.c
>>> +++ b/fs/fuse/dir.c
>>> @@ -1246,7 +1246,9 @@ static int fuse_direntplus_link(struct file *file,
>>>  		if (err)
>>>  			goto out;
>>>  		dput(dentry);
>>> -		dentry = NULL;
>>> +	} else if (dentry) {
>>> +		/* this dentry does not have a d_inode, just drop it */
>>> +		dput(dentry);
>>>  	}
>>
>> I'm not really familiar with the dcache code, but is it appropriate to
>> also d_invalidate() the dentry in this case (as the previous code block
>> does)? Perhaps Miklos or somebody more familiar with dcache can confirm...
> 
> I do not *think* d_invalidate() is needed. The vmcores I have seem where 
> this BUG() happened, only have dentry->d_flags = 0x18 which translates 
> to (DCACHE_OP_DELETE | DCACHE_OP_PRUNE) and d_subdirs as an empty list.  
> d_invalidate() only calls __d_drop(), which only does something when the 
> dentry is hashed.
> 

I ran a little experiment to invoke a d_lookup() after the
fuse_direntplus_link() function has done its work in this particular
case. I do receive the newly allocated dentry.

Subsequently, I hacked __d_lookup_rcu() to continue iterating the list
after finding an entry to check for duplicates and print a message. What
I see is that after the dput() (via a subsequent lookup resulting from a
getxattr call), the negative dentry is still hashed and on the list (my
printk() kicks in after the existing d_unhashed() check). The flags for
both dentries are
(DCACHE_OP_REVALIDATE|DCACHE_REFERENCED|DCACHE_RCUACCESS). I'm not aware
of the steps involved in the original reproducer, but the simple
multi-mount test leads to this state. Running a d_invalidate() clears it
up. So perhaps it's required in some cases and not all.

That said, some of those flags seem to simply specify whether a dentry
op handler is defined for the particular operation or not.

> I am not sure if a dentry can be hashed, but still does not have a valid 
> non-NULL d_inode. If that is the case, d_invalidate() should indeed be 
> called.
> 

I'm not sure why it would need to have a valid inode. A dentry with a
NULL inode is valid, no? I think the question is whether the above state
(multiple, hashed dentries) can be valid for whatever reason. It
certainly looks suspicious.

Brian

> Thanks,
> Niels
> 
>> Brian
>>
>>>  
>>>  	dentry = d_alloc(parent, &name);
>>>
>>
> 

