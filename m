Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbaIOJlj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 05:41:39 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:43746 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610AbaIOJlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 05:41:37 -0400
Message-ID: <5416B447.8030606@gmail.com>
Date: Mon, 15 Sep 2014 12:41:27 +0300
From: Boaz Harrosh <openosd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Ross Zwisler <ross.zwisler@linux.intel.com>, willy@linux.intel.com
Subject: Re: [PATCH v10 20/21] ext4: Add DAX functionality
References: <cover.1409110741.git.matthew.r.wilcox@intel.com> <5422062f87eb5606f4632fd06575254379f40ddc.1409110741.git.matthew.r.wilcox@intel.com> <20140903111302.GG20473@dastard> <54108124.9030707@gmail.com> <20140911043815.GP20518@dastard> <54158949.8080009@gmail.com> <20140915061534.GF4322@dastard>
In-Reply-To: <20140915061534.GF4322@dastard>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2014 09:15 AM, Dave Chinner wrote:
> On Sun, Sep 14, 2014 at 03:25:45PM +0300, Boaz Harrosh wrote:
<>
> 
> Well, that's one way of working around the immediate issue, but I
> don't think it solves the whole problem. e.g. what do you do with the
> bit of the partial write that failed? We may have allocated space
> for it but not written data to it, so to simply fail exposes stale
> data in the file(*).
> 

I'm confused. From what you said and what I read of the dax_do_io
code the only possible error is ENOSPC from getblock. 
(since ->direct_access() and memcopy cannot fail.)

Is it possible to fail with ENOSPC and still allocate an unwritten
block?

> Hence it's not clear to me that simply returning the short write is
> a valid solution for DAX-enabled filesystems. I think that the
> above - initially, at least - is much better than falling back to
> buffered IO but filesystems are going to have to be updated to work
> correctly without that fallback.
> 

The way I read dax_do_io it will call getblock, write or zero it
and continue to the next one only after that.
If not we should establish an handshake that will at least zero out
any error blocks, and or d-allocates them. But can you see such code
path in dax_do_io?

>> Yes I agree this is a very bad data corruption bug. I also think
>> that the read path should not be allowed to fall back to buffered
>> IO just the same for the same reason. We must not allow any real
>> data in page_cache for a DAX file.
> 
> Right, I didn't check the read path for the same issue as XFS won't
> return a short read on direct IO unless the read spans EOF. And in
> that case it won't ever do buffered reads. ;)
> 

Right read is less problematic. I guess. But we should not attempt
a buffered read anyway.

> Cheers,
> Dave.
> 
> (*) XFS avoids this problem by always using unwritten extents for
> direct IO allocation, but I'm pretty sure that ext4 doesn't do this.
> Using unwritten extents means that we don't expose stale data in the
> event we don't end up writing to the allocated space.
> 
If only we had an xfstest for this ?

Thanks
Boaz

