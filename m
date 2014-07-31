Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558AbaGaONX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 10:13:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:34597 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843AbaGaONU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 10:13:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,772,1400050800"; 
   d="scan'208";a="551843228"
Date: Thu, 31 Jul 2014 10:13:15 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Boaz Harrosh <openosd@gmail.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 04/22] Change direct_access calling convention
Message-ID: <20140731141315.GT6754@linux.intel.com>
References: <cover.1406058387.git.matthew.r.wilcox@intel.com>
 <b78b33d94b669a5fbd02e06f2493b43dd5d77698.1406058387.git.matthew.r.wilcox@intel.com>
 <53D9174C.7040906@gmail.com>
 <20140730194503.GQ6754@linux.intel.com>
 <53DA165E.8040601@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53DA165E.8040601@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 01:11:42PM +0300, Boaz Harrosh wrote:
> >>> +	if (size < 0)
> >>
> >> 	if(size < PAGE_SIZE), No?
> > 
> > No, absolutely not.  PAGE_SIZE is unsigned long, which (if I understand
> > my C integer promotions correctly) means that 'size' gets promoted to
> > an unsigned long, and we compare them unsigned, so errors will never be
> > caught by this check.
> 
> Good point I agree that you need a cast ie.
> 
>  	if(size < (long)PAGE_SIZE)
> 
> The reason I'm saying this is because of a bug I actually hit when
> playing with partitioning and fdisk, it came out that the last partition's
> size was not page aligned, and code that checked for (< 0) crashed because
> prd returned the last two sectors of the partition, since your API is sector
> based this can happen for you here, before you are memseting a PAGE_SIZE
> you need to test there is space, No? 

Not in ext2/ext4.  It requires block size == PAGE_SIZE, so it's never
going to request the last partial block in a partition.
