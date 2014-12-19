Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422AbaLSVdl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 16:33:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42903 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaLSVdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 16:33:40 -0500
Date: Fri, 19 Dec 2014 13:33:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org,
        ext4 development <linux-ext4@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Al Viro <viro@ZenIV.linux.org.uk>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH] fs: make generic_block_fiemap sig-tolerant PING2...
Message-Id: <20141219133339.5c8afaa0c47760e9b141df49@linux-foundation.org>
In-Reply-To: <87egrwf1dd.fsf@openvz.org>
References: <1413552269-32203-1-git-send-email-dmonakhov@openvz.org>
	<871toikt7c.fsf@openvz.org>
	<87zjavehsx.fsf@openvz.org>
	<20141218151247.b6ccd73351f40db66818c07e@linux-foundation.org>
	<87egrwf1dd.fsf@openvz.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Dec 2014 12:13:50 +0300 Dmitry Monakhov <dmonakhov@openvz.org> wrote:

> --- a/Documentation/filesystems/fiemap.txt
> +++ b/Documentation/filesystems/fiemap.txt
> @@ -196,7 +196,8 @@ struct fiemap_extent_info {
>  };
>  
>  It is intended that the file system should not need to access any of this
> -structure directly.
> +structure directly. Filesystem handlers should be tolerant to signals and return
> +EINTR once fatal signal received.

Thanks.  I was concerned about userspace effects and back-compatibility
issues, because I'd misread fatal_signal_pending() as signal_pending().

Because it uses fatal_signal_pending(), the effects of this change
should be indiscernible to userspace, yes?

I'm now wondering if the above doc update is unneeded and incorrect. 
Is it likely that the fs handler (fiemap_fill_next_extent) will ever
consume a large amount of time?  If not then we can leave the logic in
__generic_block_fiemap() and not bother callees.



The fix only addresses filesystems which use generic_block_fiemap(). 
Presumably ocfs2, btrfs, nilfs2, lustre and xfs remain vulnerable to
the problem you identified?

