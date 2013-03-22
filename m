Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab3CVFd3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 01:33:29 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:57054 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab3CVFd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 01:33:28 -0400
MIME-Version: 1.0
In-Reply-To: <20130322051817.GM21522@ZenIV.linux.org.uk>
References: <20130321233630.GE21522@ZenIV.linux.org.uk>
	<CA+55aFyLJ9vVm1T994EaE4tnEbV8rHj43m+cWsFFBi_qndao1A@mail.gmail.com>
	<CA+55aFyWNkOnrQ41xCAU8q5sVXdq1-u2P8n+quLY50OdiFo3Zw@mail.gmail.com>
	<20130322001257.GH21522@ZenIV.linux.org.uk>
	<CA+55aFz5Ce7h2ja0m++tENXuG-1d346VNu9N=ZKy2UfojaSf0g@mail.gmail.com>
	<20130322012208.GJ21522@ZenIV.linux.org.uk>
	<CA+55aFzPD08kJi=x8wLBi5FAjr1TqSGXWbv5KXy5Ymm0PJL0wA@mail.gmail.com>
	<20130322014037.GK21522@ZenIV.linux.org.uk>
	<20130322043715.GL21522@ZenIV.linux.org.uk>
	<CA+55aFzUobqDR0RSh8t18m32BdTvm4k7j2PCseXpFVCH_gR=Fw@mail.gmail.com>
	<20130322051817.GM21522@ZenIV.linux.org.uk>
Date: Thu, 21 Mar 2013 22:33:27 -0700
X-Google-Sender-Auth: IQOe1dUn8c4xFoPfci_oDJUv9OQ
Message-ID: <CA+55aFzbV81KQh_f0=wti9=_6=PXu37z0+NJymhDvzv13GgpuA@mail.gmail.com>
Subject: Re: [CFT] Re: VFS deadlock ?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 10:18 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>>
>> This seems too simple, but I don't see why iget_locked() would be any
>> better. It just wastes time hashing the inode that we aren't really
>> interested in hashing. The inode is always filled by the caller
>> anyway, so we migth as well just get a fresh pseudo-filesystem inode
>> without any crazy hashing..
>
> Umm...
> static int proc_delete_dentry(const struct dentry * dentry)
> {
>         return 1;
> }
>
> static const struct dentry_operations proc_dentry_operations =
> {
>         .d_delete       = proc_delete_dentry,
> };
>
> IOW, dcache retention in procfs is inexistent and the damn thing tries
> to cut down on the amount of inode allocation/freeing/filling.

Ok, that's kind of ugly, but shouldn't be a correctness issue. It
should still work - just cycle through inodes quite aggressivelydue to
no longer re-using them - so I suspect Dave could test it (with the
extra line removed I pointed out just a moment ago).

And I wonder how big of a deal the aggressive dentry deletion is.
Maybe it's even ok to allocate/free the inodes all the time. The whole
"get the inode hash lock and look it up there" can't be all that
wonderful either. It takes the inode->i_lock for each entry it finds
on the hash list, which looks horrible. I suspect our slab allocator
isn't much worse than that, although the RCU freeing of the inodes
could end up being problematic.

                    Linus
