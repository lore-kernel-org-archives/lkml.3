Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaIJQOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 12:14:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:24123 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbaIJQOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 12:14:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,499,1406617200"; 
   d="scan'208";a="571220185"
Message-ID: <541077DF.1060609@intel.com>
Date: Wed, 10 Sep 2014 09:10:07 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Boaz Harrosh <boaz@plexistor.com>,
        Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@fb.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-nvdimm@ml01.01.org, Toshi Kani <toshi.kani@hp.com>,
        linux-mm@kvack.org
CC: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/9] mm: Let sparse_{add,remove}_one_section receive a
 node_id
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com> <540F1EC6.4000504@plexistor.com> <540F20AB.4000404@plexistor.com> <540F48BA.2090304@intel.com> <541022DB.9090000@plexistor.com>
In-Reply-To: <541022DB.9090000@plexistor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2014 03:07 AM, Boaz Harrosh wrote:
> On 09/09/2014 09:36 PM, Dave Hansen wrote:
>> On 09/09/2014 08:45 AM, Boaz Harrosh wrote:
>>> This is for add_persistent_memory that will want a section of pages
>>> allocated but without any zone associated. This is because belonging
>>> to a zone will give the memory to the page allocators, but
>>> persistent_memory belongs to a block device, and is not available for
>>> regular volatile usage.
>>
>> I don't think we should be taking patches like this in to the kernel
>> until we've seen the other side of it.  Where is the page allocator code
>> which will see a page belonging to no zone?  Am I missing it in this set?
> 
> It is not missing. It will never be.
> 
> These pages do not belong to any allocator. They are not allocate-able
> pages. In fact they are not "memory" they are "storage"
> 
> These pages belong wholesomely to a block-device. In turn the block
> device grants ownership of a partition of this pages to an FS.
> The FS loaded has its own block allocation schema. Which internally
> circulate each pages usage around. But the page never goes beyond its
> FS.

I'm mostly worried about things that start with an mmap().

Imagine you mmap() a persistent memory file, fault some pages in, then
'cat /proc/$pid/numa_maps'.  That code will look at the page to see
which zone and node it is in.

Or, consider if you mmap() then put a futex in the page.  The page will
have get_user_pages() called on it by the futex code, and a reference
taken.  The reference can outlast the mmap().  We either have to put the
file somewhere special and scan the page's reference occasionally, or we
need to hook something under put_page() to make sure that we keep the
page out of the normal allocator.

>> I see about 80 or so calls to page_zone() in the kernel.  How will a
>> zone-less page look to all of these sites?
> 
> None of these 80 call site will be reached! the pages are always used
> below the FS, like send them on the network, or send them to a slower
> block device via a BIO. I have a full fledge FS on top of this code
> and it all works very smoothly, and stable. (And fast ;))

Does the fs support mmap()?

The idea of layering is a nice one, but mmap() is a big fat layering
violation. :)
