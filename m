Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750900Ab3IFS0H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 14:26:07 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:20040 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab3IFS0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 14:26:05 -0400
Message-ID: <5229C939.8030108@hp.com>
Date: Fri, 06 Sep 2013 12:23:21 +0000
From: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Andreas Dilger <adilger@dilger.ca>
CC: "Theodore Ts'o" <tytso@mit.edu>, T Makphaibulchoke <tmac@hp.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org Devel" <linux-fsdevel@vger.kernel.org>,
        aswin@hp.com, Linus Torvalds <torvalds@linux-foundation.org>,
        aswin_proj@lists.hp.com
Subject: Re: [PATCH v3 0/2] ext4: increase mbcache scalability
References: <1374108934-50550-1-git-send-email-tmac@hp.com> <1378312756-68597-1-git-send-email-tmac@hp.com> <20130905023522.GA21268@thunk.org> <52285395.1070508@hp.com> <0787C579-7E2C-4864-B8F4-98816E1E50A2@dilger.ca>
In-Reply-To: <0787C579-7E2C-4864-B8F4-98816E1E50A2@dilger.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2013 05:10 AM, Andreas Dilger wrote:
> On 2013-09-05, at 3:49 AM, Thavatchai Makphaibulchoke wrote:
>> No, I did not do anything special, including changing an inode's size. I just used the profile data, which indicated mb_cache module as one of the bottleneck.  Please see below for perf data from one of th new_fserver run, which also shows some mb_cache activities.
>>
>>
>>                        |--3.51%-- __mb_cache_entry_find
>>                        |          mb_cache_entry_find_first
>>                        |          ext4_xattr_cache_find
>>                        |          ext4_xattr_block_set
>>                        |          ext4_xattr_set_handle
>>                        |          ext4_initxattrs
>>                        |          security_inode_init_security
>>                        |          ext4_init_security
> 
> Looks like this is some large security xattr, or enough smaller
> xattrs to exceed the ~120 bytes of in-inode xattr storage.  How
> big is the SELinux xattr (assuming that is what it is)?
> 

Sorry I'm familiar with SELinux enough to say how big its xattr is. Anyway, I'm positive that SELinux is what is generating these xattrs.  With SELinux disabled, there seems to be no call ext4_xattr_cache_find().

>> Looks like it's a bit harder to disable mbcache than I thought.
>> I ended up adding code to collect the statics.
>>
>> With selinux enabled, for new_fserver workload of aim7, there
>> are a total of 0x7e05420100000000 ext4_xattr_cache_find() calls
>> that result in a hit and 0xc100000000000000 calls that are not.
>> The number does not seem to favor the complete disabling of
>> mbcache in this case.
> 
> This is about a 65% hit rate, which seems reasonable.
> 
> You could try a few different things here:
> - disable selinux completely (boot with "selinux=0" on the kernel
>   command line) and see how much faster it is
> - format your ext4 filesystem with larger inodes (-I 512) and see
>   if this is an improvement or not.  That depends on the size of
>   the selinux xattrs and if they will fit into the extra 256 bytes
>   of xattr space these larger inodes will give you.  The performance
>   might also be worse, since there will be more data to read/write
>   for each inode, but it would avoid seeking to the xattr blocks.
> 

Thanks for the above suggestions. Could you please clarify if we are attempting to look for a workaround here? Since we agree the way mb_cache uses one global spinlock is incorrect and SELinux exposes the problem (which is not uncommon with Enterprise installations), I believe we should look at fixing it (patch 1/2). As you also mentioned, this will also impact both ext2 and ext3 filesystems.

Anyway, please let me know if you still think any of the above experiments is relevant.

Thanks,
Mak.


> Cheers, Andreas
> 
> 
> 
> 
> 

