Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936252Ab3DHVYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 17:24:12 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:64383 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762574Ab3DHVYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 17:24:10 -0400
Message-ID: <5163356F.50406@gmail.com>
Date: Mon, 08 Apr 2013 23:23:59 +0200
From: Gabriel <g2p.code@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Kent Overstreet <koverstreet@google.com>
CC: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gabriel <g2p.code+bcache@gmail.com>
Subject: Re: [PATCH] bcache: Take data offset from the bdev superblock.
References: <51629766.6030805@gmail.com> <1365415866-16344-1-git-send-email-g2p.code+bcache@gmail.com> <20130408204956.GH15749@google.com>
In-Reply-To: <20130408204956.GH15749@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lun. 08 avril 2013 22:49:56 CEST, Kent Overstreet a écrit :
> On Mon, Apr 08, 2013 at 12:11:06PM +0200, Gabriel wrote:
>> Add a new superblock version, and consolidate related defines.
>
> So, I think BDEV_WITH_OFFSET looks ok, but what's the use case for it? I
> was going to add it way back but we decided not to implement the hack we
> thought we needed it for - if you or someone is going to use it I'll go
> ahead and apply it.

It's for converting existing devices to bcache.

https://github.com/g2p/blocks converts a partition to bcache by putting
a bcache superblock immediately before and shifting the partition start
to the left by exactly 1MB.  The 1MB alignment is to play nice with 
other partitioning tools and drives with 4k sectors.

blocks also converts logical volumes to bcache, and for that it has to 
insert exactly 4MB (an LVM physical extent) before the filesystem data.

I'm already using the new format, it allowed me to get rid of some 
complicated stuff that sandwiched a partition table on top of an LV so 
that the original filesystem data was at the start of its container device.

> As for BCACHE_SB_VERSION_CDEV_WITH_UUID, can you explain why you added
> that? I suspect it's needed but I can't remember why I didn't add it
> when I added the new UUID format (or perhaps I just forgot)

I took the name from a comment in the kernel-side bcache.h.
BCACHE_SB_VERSION_CDEV is the version make-bcache writes, and 
BCACHE_SB_VERSION_CDEV_WITH_UUID is what the kernel updates it too; I 
just changed the version names so that user-side and kernel-side were 
more consistent, internally and with each other.
The kernel doesn't discriminate these two versions when opening, so it 
should be possible to define only the latter and deprecate the other.
