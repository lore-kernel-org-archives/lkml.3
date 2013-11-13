Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759518Ab3KMUK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 15:10:58 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47132 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759271Ab3KMUKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 15:10:46 -0500
Date: Wed, 13 Nov 2013 20:10:43 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>
Subject: Re: sysfs_bin_mmap lockdep trace.
Message-ID: <20131113201043.GE13318@ZenIV.linux.org.uk>
References: <20131113184538.GA7269@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131113184538.GA7269@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 01:45:38PM -0500, Dave Jones wrote:
> Al, is this one also known ? Also seen on v3.12-7033-g42a2d923cc34

Umm...  I've seen something like that reported after sysfs merge went in
(right after 3.12), but I hadn't looked into details.

> -> #3 (&mm->mmap_sem){++++++}:

	[sr_block_ioctl() grabs sr_mutex and does copy_from_user() under it]

> -> #2 (sr_mutex){+.+.+.}:
	[sr_block_open() grabs sr_mutex under ->bd_mutex]

> -> #1 (&bdev->bd_mutex){+.+.+.}:
	[sysfs_blk_trace_attr_show() grabs ->bd_mutex and is called under
sysfs_open_file ->mutex]

> -> #0 (&of->mutex){+.+.+.}:
	[sysfs_open_file ->mutex is grabbed by ->mmap()]

Cute...  AFAICS, it came from "sysfs: copy bin mmap support from fs/sysfs/bin.c
to fs/sysfs/file.c".  The first impression is that sysfs_bin_mmap() is
checking for battr->mmap too late, but I'm not sure whether we need of->mutex
to stabilize it...  Tejun, any comments?
