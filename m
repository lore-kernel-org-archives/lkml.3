Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758632Ab3GaAnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 20:43:22 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:4222 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752847Ab3GaAnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 20:43:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlgMACtd+FF5LPxHgWdsb2JhbABbvGyFN4EeFw4BARYmKASCIAEBBTocIxAIAw4KCSUPBSUDIROID7hwFo9oB4MYcQOXXooiilEq
Date: Wed, 31 Jul 2013 10:43:03 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>
Subject: Re: [PATCH V8 00/33] loop: Issue O_DIRECT aio using bio_vec
Message-ID: <20130731004303.GA7118@dastard>
References: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com>
 <20130730142820.313f1af6827276df31913106@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130730142820.313f1af6827276df31913106@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 02:28:20PM -0700, Andrew Morton wrote:
> On Thu, 25 Jul 2013 12:50:26 -0500 Dave Kleikamp <dave.kleikamp@oracle.com> wrote:
> 
> > This patch series adds a kernel interface to fs/aio.c so that kernel code can
> > issue concurrent asynchronous IO to file systems.  It adds an aio command and
> > file system methods which specify io memory with pages instead of userspace
> > addresses.
> > 
> > This series was written to reduce the current overhead loop imposes by
> > performing synchronus buffered file system IO from a kernel thread.  These
> > patches turn loop into a light weight layer that translates bios into iocbs.
> 
> Do you have any performance numbers?
> 
> Does anyone care much about loop performance?  What's the value here?

Yes. Anyone using loopback devices for file-backed devices exposed
to containers and VMs cares about the memory and CPU overhead
the double caching the existing loop device has.

Or those of us how use loopback devices to examine metadumps from
broken filesystems and run repair/fsck on the filesystem image via
loopback devices. When I'm dealing with images containing tens to
hundreds of gigabytes of metadata, caching a second time in the
backing file is a significant overhead. It's especially annoying
when the application is already using direct IO because the kernel
based block device caching isn't at all efficient and just consumes
needless amount of memory holding on to pages that are never going
to be read again.

And on small memory machines xfstests can trigger OOM killer when it
uses loopback devices in certain tests. Thats generally caused by
the writeback of a dirty page causing a new page to be allocated and
dirtied and so writeback of dirty memory under memory pressure can
a) increase memory usage, and b) increase the percentage of dirty
memory that can't be reclaimed immediately....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
