Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab3HEGy7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 02:54:59 -0400
Received: from rrzmta2.uni-regensburg.de ([194.94.155.52]:47120 "EHLO
	rrzmta2.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489Ab3HEGy5 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:2:1>);
	Mon, 5 Aug 2013 02:54:57 -0400
Message-Id: <51FF685C020000A10001222B@gwsmtp1.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Mon, 05 Aug 2013 08:54:52 +0200
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To: "Hugh Dickins" <hughd@google.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Antw: Re: Possible mmap() write() problem in SLES11 SP2 kernel
References: <51FA6455020000A100012182@gwsmtp1.uni-regensburg.de>
 <alpine.LNX.2.00.1308031516010.11134@eggly.anvils>
In-Reply-To: <alpine.LNX.2.00.1308031516010.11134@eggly.anvils>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Hugh Dickins <hughd@google.com> schrieb am 04.08.2013 um 00:37 in Nachricht
<alpine.LNX.2.00.1308031516010.11134@eggly.anvils>:
> On Thu, 1 Aug 2013, Ulrich Windl wrote:
>> Hi folks!
>> 
>> I think I'd let you know (maybe I'm wrong, and the kernel is right):
>> 
>> I write a C-program that maps a file into an private writable map. Then I 
> modify the area a bit and use one write to write that area back to a file.
>> 
>> This worked fine in SLES11 kernel 3.0.74-0.6.10. However with kernel  
> 3.0.80-0.7 the write() fails with EFAULT if the output file is the same as 
> the input file.
> 
> I wonder if you actually did exactly the same on both kernels.

Hi!

thanks for replying! Actually id did the sam a few thousand times (with different files and different lengths) in the previous kernel, weher it never failed, just as with the newer kernel where it always fails (it seems).

> 
>> 
>> The strace is amazingly short (I removed the unrelated calls):
> 
> Providing that was very helpful.
> 
>> open("xxx", O_RDONLY)                   = 3
>> fstat(3, {st_mode=S_IFREG|0644, st_size=4416, ...}) = 0
>> mmap(NULL, 4416, PROT_READ|PROT_WRITE, MAP_PRIVATE, 3, 0) = 0x7f85ac045000
>> close(3)                                = 0
>> open("xxx", O_WRONLY|O_CREAT|O_TRUNC, 0666) = 3
> 
> The crucial point is the above O_TRUNC when you now open the file for
> writing: that truncates the file to 0-length, which unmaps any pages
> mapped from it into userspace.  Even the privately modified COW pages:

Well, but the mapping is PRIVATE, so I guessed once mapped, changes to the map won't affect the file, just as changes to the file won't affect the map. Specifically when re-opening the file for writing with O_TRUNC I did not expect the map to become invalid. Also note that the unmap still returns no error.
My manual page vaguely says: "It is unspecified whether changes made to the file after the mmap() call are visible in the mapped region."
> that often seems surprising, but it is how mmap versus truncate is
> specified to work.
> 
>> write(3, 0x7f85ac045000, 4414)          = -1 EFAULT (Bad address)
> 
> If your program now touched a part of the mapping, it would get
> SIGBUS, there being no pages of underlying object to page in from.
> But since you're accessing the area from within a system call,
> that simply fails with EFAULT.

OK, if things are like this, the older kernel must have been faulty.

> 
>> close(3)                                = 0
>> munmap(0x7f85ac045000, 4414)            = 0
>> 
>> I want to have your attention if this should work, and you get my attention 
> if this should not work.
> 
> It should not work.
> 
>> Note that the input file is closed before it's opened for write again. As 
> the output file is typically shorter than the input, I didn't want to use a 
> non-private mapping and a truncate, just in case you wonder...
> 
> (I didn't understand your logic there.)

The alternative to write() a part of the PRIVATE area would be to work with a non-PRIVATE area that is truncated after flushing the changes. In principle the same blocks could be written multiple times (when you move data from later parts to earlier parts (i.e.: from the far end closer to the beginning)), so I thought a PRIVATE mapping plus one write() would avoid that. I had the coice of truncate while opening, or to truncate the extra data after write(). I chose the first alternative.

Maybe I'll re-design...

Thanks,
Ulrich

> 
> Hugh



