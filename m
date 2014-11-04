Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944AbaKDTrk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 14:47:40 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:58143 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbaKDTri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 14:47:38 -0500
Message-ID: <54592D49.4070704@amacapital.net>
Date: Tue, 04 Nov 2014 11:47:21 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>
CC: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/4 v3] fs: Remove i_devices from struct inode
References: <1415096851-17209-1-git-send-email-jack@suse.cz> <20141104153940.GH7996@ZenIV.linux.org.uk>
In-Reply-To: <20141104153940.GH7996@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2014 07:39 AM, Al Viro wrote:
> On Tue, Nov 04, 2014 at 11:27:27AM +0100, Jan Kara wrote:
>>   Hello,
>>
>>   this patch set removes use of i_devices from block and character device
>> code and thus we can remove the list head from struct inode thus saving two
>> pointers in it. As Christoph has reviewed the series, can you please merge
>> it Al? Thanks!
>>
>> Since v2 I've added reviewed-by tags from Christoph and changed one variable
>> name in cdev_forget().
>>
>> Since v1 I have split the patches and properly handled character devices (I
>> broke them last time as Christoph pointed out).
> 
> My problem with that is in buggered module refcounts (which was the reason
> for doing those non-counting references back then).  Suppose you open
> /dev/some_char_device and close it; having the module pinned down until
> the inode of that sucker gets evicted by dcache/icache memory pressure
> would be wrong - it _isn't_ in use, and there's no way short of forcing
> the full eviction of VFS caches to get it possible to unload...
> 

At the risk of asking what may be a rather dumb question...

Why do device node inodes need to be cached at all?  In other words,
when you try open a device node, can't the kernel materialize the inode
from just information that's in the dentry without touching the
filesystem at all?  If that's true, couldn't all device inodes be
dropped from icache as soon as they're unreferenced?

(Yes, there's mtime, but I never understood why tracking mtime on device
nodes made any sense in the first place.)

--Andy
