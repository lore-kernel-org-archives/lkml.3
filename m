Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbaKDTwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 14:52:46 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:63152 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbaKDTwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 14:52:45 -0500
MIME-Version: 1.0
In-Reply-To: <54592D49.4070704@amacapital.net>
References: <1415096851-17209-1-git-send-email-jack@suse.cz>
 <20141104153940.GH7996@ZenIV.linux.org.uk> <54592D49.4070704@amacapital.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 4 Nov 2014 11:52:22 -0800
Message-ID: <CALCETrViY8biMs=D9XKAJx-9m5iEEUCbpzmOR2QFVyxcdoczxQ@mail.gmail.com>
Subject: Re: [PATCH 0/4 v3] fs: Remove i_devices from struct inode
To: Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 4, 2014 at 11:47 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On 11/04/2014 07:39 AM, Al Viro wrote:
>> On Tue, Nov 04, 2014 at 11:27:27AM +0100, Jan Kara wrote:
>>>   Hello,
>>>
>>>   this patch set removes use of i_devices from block and character device
>>> code and thus we can remove the list head from struct inode thus saving two
>>> pointers in it. As Christoph has reviewed the series, can you please merge
>>> it Al? Thanks!
>>>
>>> Since v2 I've added reviewed-by tags from Christoph and changed one variable
>>> name in cdev_forget().
>>>
>>> Since v1 I have split the patches and properly handled character devices (I
>>> broke them last time as Christoph pointed out).
>>
>> My problem with that is in buggered module refcounts (which was the reason
>> for doing those non-counting references back then).  Suppose you open
>> /dev/some_char_device and close it; having the module pinned down until
>> the inode of that sucker gets evicted by dcache/icache memory pressure
>> would be wrong - it _isn't_ in use, and there's no way short of forcing
>> the full eviction of VFS caches to get it possible to unload...
>>
>
> At the risk of asking what may be a rather dumb question...
>
> Why do device node inodes need to be cached at all?  In other words,
> when you try open a device node, can't the kernel materialize the inode
> from just information that's in the dentry without touching the
> filesystem at all?  If that's true, couldn't all device inodes be
> dropped from icache as soon as they're unreferenced?
>
> (Yes, there's mtime, but I never understood why tracking mtime on device
> nodes made any sense in the first place.)

On further reflection, this is indeed a dumb question.  i_rdev is in
the inode, so of course the inode is useful.

Let me try again, though: what if a chardev inode replaced i_cdev with
NULL and dropped its kobj reference in iput_final?  This would add a
bit over overhead to things that repeatedly open and close the same
device node, but I doubt this matters much.

--Andy
