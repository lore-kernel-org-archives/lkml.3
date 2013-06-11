Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab3FKBvw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 21:51:52 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49069 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab3FKBvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 21:51:51 -0400
Date: Tue, 11 Jun 2013 02:51:49 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: binfmt_misc broken
Message-ID: <20130611015149.GB4165@ZenIV.linux.org.uk>
References: <Pine.LNX.4.64.1306102137560.3200@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1306102137560.3200@boston.corp.fedex.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 09:52:44PM +0800, Jeff Chua wrote:
> 
> 
> According to Documentation/binfmt_misc.txt, the 'magic' and 'mask'
> can be set by echoing it to /proc/sys/fs/binfmt_misc/register.
> 
> Here's the problem I can across while working on ARM.
> 
> # echo ':arm:M::\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:/usr/bin/qemu-arm-static:'
> >/proc/sys/fs/binfmt_misc/register
> 
> # cat /proc/sys/fs/binfmt_misc/arm
> wrong ...
> magic 7f454c46010101
> mask ffffffffffffff
> 
> right ...
> magic 7f454c4601010100000000000000000002002800
> mask ffffffffffffff00fffffffffffffffffeffffff
> 
> 
> binfmt_misc is truncating e->size, so once ARM's magic is loaded,
> 32-bit x86 can no longer run.
> 
> Here's a patch for it. It's looking for the delimiter ":" instead of
> \0. Now 32-bit x86 can run concurrent while qemu-arm is handling
> ARM's magic.

Patch is complete BS and I really wonder what kernel have you observed that bug on -
with mainline on amd64 your example yields
root@kvm-amd64:~# cat /proc/sys/fs/binfmt_misc/arm 
enabled
interpreter /usr/bin/qemu-arm-static
flags: 
offset 0
magic 7f454c4601010100000000000000000002002800
mask ffffffffffffff00fffffffffffffffffeffffff

A reproducer, please...  As for the memcmp() Linus has suggested - it's !Magic case, i.e.
what we are comparing there is not the file contents, it's the extension.  IOW, strcmp()
is the right thing to use there - pathnames do not contain NULs in the middle...
