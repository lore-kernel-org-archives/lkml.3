Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbaKDPjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:39:45 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41000 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbaKDPjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:39:43 -0500
Date: Tue, 4 Nov 2014 15:39:41 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/4 v3] fs: Remove i_devices from struct inode
Message-ID: <20141104153940.GH7996@ZenIV.linux.org.uk>
References: <1415096851-17209-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415096851-17209-1-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 11:27:27AM +0100, Jan Kara wrote:
>   Hello,
> 
>   this patch set removes use of i_devices from block and character device
> code and thus we can remove the list head from struct inode thus saving two
> pointers in it. As Christoph has reviewed the series, can you please merge
> it Al? Thanks!
> 
> Since v2 I've added reviewed-by tags from Christoph and changed one variable
> name in cdev_forget().
> 
> Since v1 I have split the patches and properly handled character devices (I
> broke them last time as Christoph pointed out).

My problem with that is in buggered module refcounts (which was the reason
for doing those non-counting references back then).  Suppose you open
/dev/some_char_device and close it; having the module pinned down until
the inode of that sucker gets evicted by dcache/icache memory pressure
would be wrong - it _isn't_ in use, and there's no way short of forcing
the full eviction of VFS caches to get it possible to unload...
