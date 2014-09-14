Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbaINMZw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 08:25:52 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:63194 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbaINMZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 08:25:50 -0400
Message-ID: <54158949.8080009@gmail.com>
Date: Sun, 14 Sep 2014 15:25:45 +0300
From: Boaz Harrosh <openosd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Ross Zwisler <ross.zwisler@linux.intel.com>, willy@linux.intel.com
Subject: Re: [PATCH v10 20/21] ext4: Add DAX functionality
References: <cover.1409110741.git.matthew.r.wilcox@intel.com> <5422062f87eb5606f4632fd06575254379f40ddc.1409110741.git.matthew.r.wilcox@intel.com> <20140903111302.GG20473@dastard> <54108124.9030707@gmail.com> <20140911043815.GP20518@dastard>
In-Reply-To: <20140911043815.GP20518@dastard>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2014 07:38 AM, Dave Chinner wrote:
<>
> 
> And so ext4 is buggy, because what ext4 does ....
> 
> ... is not a retry - it falls back to a fundamentally different
> code path. i.e:
> 
> sys_write()
> ....
> 	new_sync_write
> 	  ext4_file_write_iter
> 	    __generic_file_write_iter(O_DIRECT)
> 	      written = generic_file_direct_write()
> 	      if (error || complete write)
> 	        return
> 	      /* short write! do buffered IO to finish! */
> 	      generic_perform_write()
> 	        loop {
> 			ext4_write_begin
> 			ext4_write_end
> 		}
> 
> and so we allocate pages in the page cache and do buffered IO into
> them because DAX doesn't hook ->writebegin/write_end as we are
> supposed to intercept all buffered IO at a higher level.
> 
> This causes data corruption when tested at ENOSPC on DAX enabled
> ext4 filesystems. I think that it's an oversight and hence a bug
> that needs to be fixed but I'm first asking Willy to see if it was
> intentional or not because maybe I missed sometihng in the past 4
> months since I've paid really close attention to the DAX code.
> 
> And in saying that, Boaz, I'd suggest you spend some time looking at
> the history of the DAX patchset. Pay careful note to who came up
> with the original idea and architecture that led to the IO path you
> are so stridently defending.....
> 

Yes! you are completely right, and I have not seen this bug. The same bug
exist with ext2 as well. I think this is a bug in patch:
	[PATCH v10 07/21] Replace XIP read and write with DAX I/O

It needs a:
@@ -2584,7 +2584,7 @@ ssize_t __generic_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		loff_t endbyte;
 
 		written = generic_file_direct_write(iocb, from, pos);
-		if (written < 0 || written == count)
+		if (written < 0 || written == count || IS_DAX(inode))
 			goto out;
 
 		/*

Or something like that. Is that what you meant?

(You have commented on the ext4 patch but this is already earlier in ext2
 so I did not see it, sorry. "If you explain slow I finally get it ;-)" )

> Cheers,
> Dave.

Yes I agree this is a very bad data corruption bug. I also think that the
read path should not be allowed to fall back to buffered IO just the same
for the same reason. We must not allow any real data in page_cache for a
DAX file.

Thanks for explaining
Boaz


