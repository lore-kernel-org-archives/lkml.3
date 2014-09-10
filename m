Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbaIJS2u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 14:28:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:8098 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282AbaIJS2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 14:28:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,500,1406617200"; 
   d="scan'208";a="601005399"
Message-ID: <54109845.3050309@intel.com>
Date: Wed, 10 Sep 2014 11:28:21 -0700
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
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com> <540F1EC6.4000504@plexistor.com> <540F20AB.4000404@plexistor.com> <540F48BA.2090304@intel.com> <541022DB.9090000@plexistor.com> <541077DF.1060609@intel.com> <5410899C.3030501@plexistor.com>
In-Reply-To: <5410899C.3030501@plexistor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2014 10:25 AM, Boaz Harrosh wrote:
> Yes the block_allocator of the pmem-FS always holds the final REF on this
> page, as long as there is valid data on this block. Even cross boots, the
> mount code re-initializes references. The only internal state that frees
> these blocks is truncate, which only then return these pages to the block
> allocator, all this is common practice in filesystems so the page-ref on
> these blocks only ever drops to zero after they loose all visibility. And
> yes the block allocator uses a special code to drop the count to zero
> not using put_page().

OK, so what happens when a page is truncated out of a file and this
"last" block reference is dropped while a get_user_pages() still has a
reference?

> On 09/10/2014 07:10 PM, Dave Hansen wrote:
>> Does the fs support mmap()?
>>
> No!
> 
> Yes the FS supports mmap, but through the DAX patchset. Please see
> Matthew's DAX patchset how he implements mmap without using pages
> at all, direct PFN to virtual_addr. So these pages do not get exposed
> to the top of the FS.
> 
> My FS uses his technics exactly only when it wants to spill over to
> slower device it will use these pages copy-less.

>From my perspective, DAX is complicated, but it is necessary because we
don't have a 'struct page'.  You're saying that even if we pay the cost
of a 'struct page' for the memory, we still don't get the benefit of
having it like getting rid of this DAX stuff?

Also, about not having a zone for these pages.  Do you intend to support
32-bit systems?  If so, I believe you will require the kmap() family of
functions to map the pages in order to copy data in and out.  kmap()
currently requires knowing the zone of the page.
