Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762Ab3CMELF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 00:11:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36152 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab3CMELD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 00:11:03 -0400
Date: Tue, 12 Mar 2013 21:11:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shuge <shugelinux@gmail.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-ext4@vger.kernel.org,
        Kevin <kevin@allwinnertech.com>, Jan Kara <jack@suse.cz>,
        "Theodore Ts'o" <tytso@mit.edu>, Jens Axboe <axboe@kernel.dk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] bounce:fix bug, avoid to flush dcache on slab page from
 jbd2.
Message-Id: <20130312211138.a2824b7e.akpm@linux-foundation.org>
In-Reply-To: <513FF3F3.2000509@gmail.com>
References: <5139DB90.5090302@gmail.com>
	<20130312153221.0d26fe5599d4885e51bb0c7c@linux-foundation.org>
	<20130313011020.GA5313@blackbox.djwong.org>
	<513FF3F3.2000509@gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Mar 2013 11:35:15 +0800 Shuge <shugelinux@gmail.com> wrote:

> Hi all
> >>> The bounce accept slab pages from jbd2, and flush dcache on them.
> >>> When enabling VM_DEBUG, it will tigger VM_BUG_ON in page_mapping().
> >>> So, check PageSlab to avoid it in __blk_queue_bounce().
> >>>
> >>> Bug URL: http://lkml.org/lkml/2013/3/7/56
> >>>
> >>> ...
> >>>
> >> ......
> >>
> > That sure is strange.  I didn't see any obvious reasons why we'd end up with a
> >
> ......
> 
>      Well, this problem not only appear in arm64, but also arm32. And my 
> kernel version is 3.3.0, arch is arm32.
> Following the newest kernel, the problem shoulde be exist.
>      I agree with Darrick's modification. Hum, if 
> CONFIG_NEED_BOUNCE_POOL is not set, it also flush dcahce on
> the pages of b_frozen_data, some of them are allocated by kmem_cache_alloc.
>      As we know, jbd2_alloc allocate a buffer from jbd2_xk slab pool, 
> when the size is smaller than PAGE_SIZE.
> The b_frozen_data  is not mapped to usrspace, not aliasing cache. It cat 
> be lazy flush or other. Is it right?

Please reread my email.  The page at b_frozen_data was allocated with
GFP_NOFS.  Hence it should not need bounce treatment (if arm is
anything like x86).

And yet it *did* receive bounce treatment.  Why?
