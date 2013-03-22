Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933651Ab3CVOhO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 10:37:14 -0400
Received: from www.sr71.net ([198.145.64.142]:60194 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933396Ab3CVOhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 10:37:09 -0400
Message-ID: <514C6CE3.5080201@sr71.net>
Date: Fri, 22 Mar 2013 07:38:27 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2, RFC 04/30] radix-tree: implement preload for multiple
 contiguous elements
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com> <1363283435-7666-5-git-send-email-kirill.shutemov@linux.intel.com> <514B2D94.8040206@sr71.net> <20130322094745.E20D9E0085@blue.fi.intel.com>
In-Reply-To: <20130322094745.E20D9E0085@blue.fi.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2013 02:47 AM, Kirill A. Shutemov wrote:
> Dave Hansen wrote:
>> On 03/14/2013 10:50 AM, Kirill A. Shutemov wrote:
>>> +#define RADIX_TREE_PRELOAD_NR		512 /* For THP's benefit */
>>
>> This eventually boils down to making the radix_tree_preload array
>> larger.  Do we really want to do this unconditionally if it's only for
>> THP's benefit?
> 
> It will be useful not only for THP. Batching can be useful to solve
> scalability issues.

Still, it seems like something that little machines with no THP support
probably don't want to pay the cost for.  Perhaps you could enable it
for THP||NR_CPUS>$FOO.

>> For those of us too lazy to go compile a kernel and figure this out in
>> practice, how much bigger does this make the nodes[] array?
> 
> We have three possible RADIX_TREE_MAP_SHIFT:
> 
> #ifdef __KERNEL__
> #define RADIX_TREE_MAP_SHIFT	(CONFIG_BASE_SMALL ? 4 : 6)
> #else
> #define RADIX_TREE_MAP_SHIFT	3	/* For more stressful testing */
> #endif
> 
> On 64-bit system:
> For RADIX_TREE_MAP_SHIFT=3, old array size is 43, new is 107.
> For RADIX_TREE_MAP_SHIFT=4, old array size is 31, new is 63.
> For RADIX_TREE_MAP_SHIFT=6, old array size is 21, new is 30.
> 
> On 32-bit system:
> For RADIX_TREE_MAP_SHIFT=3, old array size is 21, new is 84.
> For RADIX_TREE_MAP_SHIFT=4, old array size is 15, new is 46.
> For RADIX_TREE_MAP_SHIFT=6, old array size is 11, new is 19.
> 
> On most machines we will have RADIX_TREE_MAP_SHIFT=6.

Could you stick that in your patch description?  The total cost is
"array size" * sizeof(void*) * NR_CPUS, right?

-- Dave Hansen, Intel OTC Scalability Team
