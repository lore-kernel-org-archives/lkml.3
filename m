Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933053AbaKMOnH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 09:43:07 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41829 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932705AbaKMOnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 09:43:06 -0500
Date: Thu, 13 Nov 2014 14:43:03 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: load FS modules before pinning the mountpoint
Message-ID: <20141113144303.GJ7996@ZenIV.linux.org.uk>
References: <1415888073-1827-1-git-send-email-dh.herrmann@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415888073-1827-1-git-send-email-dh.herrmann@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 03:14:33PM +0100, David Herrmann wrote:
> Several pseudo file-systems create default mountpoints in /sys/fs/ or
> /sys/kernel/, including:
>     /sys/kernel/debug
>     /sys/fs/mqueue
>     /sys/fs/cgroup
>     /sys/fs/pstore
> 
> If the given pseudo file-system is available as a module, user-space can
> rely on mount(2) to load the module on-demand (assuming MODULE_ALIAS_FS).
> However, in case the default mount-point is created by the file-system
> itself, mount(2) will fail as it cannot pin the mountpoint.
> 
> This patch makes mount(2) load any requested file-systems before pinning
> the target mount-point. This way, a file-system module can create default
> mount-points in the module instead of creating them statically in the
> core kernel.

I'm not taking that until I see a module that would attempt to do such
mountpoint creation *and* managed to get it race-free.

Besides, I really don't like the way you do this lookup only to never use
the result other than for pinning the damn module.  But that's secondary -
the main issue is with the amount of fun races in the whole "let module
create that default mountpoint" approach.
