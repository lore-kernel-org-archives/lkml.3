Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab3HCWh3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 18:37:29 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:39871 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab3HCWhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 18:37:25 -0400
Date: Sat, 3 Aug 2013 15:37:11 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: Possible mmap() write() problem in SLES11 SP2 kernel
In-Reply-To: <51FA6455020000A100012182@gwsmtp1.uni-regensburg.de>
Message-ID: <alpine.LNX.2.00.1308031516010.11134@eggly.anvils>
References: <51FA6455020000A100012182@gwsmtp1.uni-regensburg.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Aug 2013, Ulrich Windl wrote:
> Hi folks!
> 
> I think I'd let you know (maybe I'm wrong, and the kernel is right):
> 
> I write a C-program that maps a file into an private writable map. Then I modify the area a bit and use one write to write that area back to a file.
> 
> This worked fine in SLES11 kernel 3.0.74-0.6.10. However with kernel  3.0.80-0.7 the write() fails with EFAULT if the output file is the same as the input file.

I wonder if you actually did exactly the same on both kernels.

> 
> The strace is amazingly short (I removed the unrelated calls):

Providing that was very helpful.

> open("xxx", O_RDONLY)                   = 3
> fstat(3, {st_mode=S_IFREG|0644, st_size=4416, ...}) = 0
> mmap(NULL, 4416, PROT_READ|PROT_WRITE, MAP_PRIVATE, 3, 0) = 0x7f85ac045000
> close(3)                                = 0
> open("xxx", O_WRONLY|O_CREAT|O_TRUNC, 0666) = 3

The crucial point is the above O_TRUNC when you now open the file for
writing: that truncates the file to 0-length, which unmaps any pages
mapped from it into userspace.  Even the privately modified COW pages:
that often seems surprising, but it is how mmap versus truncate is
specified to work.

> write(3, 0x7f85ac045000, 4414)          = -1 EFAULT (Bad address)

If your program now touched a part of the mapping, it would get
SIGBUS, there being no pages of underlying object to page in from.
But since you're accessing the area from within a system call,
that simply fails with EFAULT.

> close(3)                                = 0
> munmap(0x7f85ac045000, 4414)            = 0
> 
> I want to have your attention if this should work, and you get my attention if this should not work.

It should not work.

> Note that the input file is closed before it's opened for write again. As the output file is typically shorter than the input, I didn't want to use a non-private mapping and a truncate, just in case you wonder...

(I didn't understand your logic there.)

Hugh
