Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab3IKTiG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 15:38:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754387Ab3IKTiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 15:38:04 -0400
Message-ID: <5230C5A7.2030206@redhat.com>
Date: Wed, 11 Sep 2013 14:33:59 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>,
        Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>,
        T Makphaibulchoke <tmac@hp.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org Devel" <linux-fsdevel@vger.kernel.org>,
        aswin@hp.com, Linus Torvalds <torvalds@linux-foundation.org>,
        aswin_proj@lists.hp.com
Subject: Re: [PATCH v3 0/2] ext4: increase mbcache scalability
References: <1374108934-50550-1-git-send-email-tmac@hp.com> <1378312756-68597-1-git-send-email-tmac@hp.com> <20130905023522.GA21268@thunk.org> <52285395.1070508@hp.com> <0787C579-7E2C-4864-B8F4-98816E1E50A2@dilger.ca> <5229C939.8030108@hp.com> <62D71A85-C7EE-4F5F-B481-5329F0282044@dilger.ca> <20130910210250.GH29237@thunk.org> <522FDFCC.1070007@redhat.com> <20130911113001.GB13315@thunk.org> <52309F27.8060008@redhat.com>
In-Reply-To: <52309F27.8060008@redhat.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/11/13 11:49 AM, Eric Sandeen wrote:
> On 9/11/13 6:30 AM, Theodore Ts'o wrote:
>> On Tue, Sep 10, 2013 at 10:13:16PM -0500, Eric Sandeen wrote:
>>>
>>> Above doesn't tell us the prevalence of various contexts on the actual system,
>>> but they are all under 100 bytes in any case.
>>
>> OK, so in other words, on your system i_file_acl and i_file_acl_high
>> (which is where we store the block # for the external xattr block),
>> should always be zero for all inodes, yes?
> 
> Oh, hum - ok, so that would have been the better thing to check (or at
> least an additional thing).
> 
> # find / -xdev -exec filefrag -x {} \; | awk -F : '{print $NF}' | sort | uniq -c
> 
> Finds quite a lot that claim to have external blocks, but it seems broken:
> 
> # filefrag -xv /var/lib/yum/repos/x86_64/6Server/epel
> Filesystem type is: ef53
> File size of /var/lib/yum/repos/x86_64/6Server/epel is 4096 (1 block, blocksize 4096)
>  ext logical physical expected length flags
>    0       0 32212996252             100 not_aligned,inline
> /var/lib/yum/repos/x86_64/6Server/epel: 1 extent found
> 
> So _filefrag_ says it has a block (at a 120T physical address not on my fs!)

Oh, this is the special-but-not-documented "print inline extents in bytes
not blocks"  :(

I'll send a patch to ignore inline extents on fiemap calls to make this
easier, but in the meantime, neither my RHEL6 root nor my F17 root have
any out-of-inode selinux xattrs on 256-byte-inode filesystems.

So selinux alone should not be exercising mbcache much, if at all, w/ 256 byte
inodes.

-Eric
