Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294AbaKYLtH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:49:07 -0500
Received: from mta-out1.inet.fi ([62.71.2.195]:35656 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581AbaKYLtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 06:49:04 -0500
Date: Tue, 25 Nov 2014 13:48:46 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Chanho Min <chanho.min@lge.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Kirill A. Shutemov'" <kirill.shutemov@linux.intel.com>,
        "'Hugh Dickins'" <hughd@google.com>, "'Michal Hocko'" <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        "'HyoJun Im'" <hyojun.im@lge.com>, "'Gunho Lee'" <gunho.lee@lge.com>,
        "'Wonhong Kwon'" <wonhong.kwon@lge.com>
Subject: Re: [PATCH] mm: add parameter to disable faultaround
Message-ID: <20141125114846.GA10150@node.dhcp.inet.fi>
References: <1416898318-17409-1-git-send-email-chanho.min@lge.com>
 <20141124230502.30f9b6f0.akpm@linux-foundation.org>
 <547465d2.0937460a.7739.fffff2baSMTPIN_ADDED_BROKEN@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547465d2.0937460a.7739.fffff2baSMTPIN_ADDED_BROKEN@mx.google.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 08:19:40PM +0900, Chanho Min wrote:
> > > The faultaround improves the file read performance, whereas pages which
> > > can be dropped by drop_caches are reduced. On some systems, The amount of
> > > freeable pages under memory pressure is more important than read
> > > performance.
> > 
> > The faultaround pages *are* freeable.  Perhaps you meant "free" here.
> > 
> > Please tell us a great deal about the problem which you are trying to
> > solve.  What sort of system, what sort of workload, what is bad about
> > the behaviour which you are observing, etc.
> 
> We are trying to solve two issues.
> 
> We drop page caches by writing to /proc/sys/vm/drop_caches at specific point
> and make suspend-to-disk image. The size of this image is increased if faultaround
> is worked.

drop_caches should never be used outside debugging process. If you use it
as part of usual workflow you're doing something wrong.

I'm not aware about details on how suspend-to-disk works, but I don't see
much point in saving page cache pages into suspend-to-disk image. Dirty
pages should be write out and we can read them back after resume on first
use. Possible exception is mlocked pages.

> Under memory pressure, we want to drop many page caches as possible.
> But, The number of dropped pages are reduced compared to non-faultaround kernel.

The reason why you see more pages in page cache after drop_pages with
faultaround enabled is that drop_pages doesn't touch mapped pages. And
with faultaround we obviously have more pages mapped.

It's not a reason to have faultaround disable. You should take a closer
look on suspend process.

-- 
 Kirill A. Shutemov
