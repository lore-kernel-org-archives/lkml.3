Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189AbaJ2UOW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 16:14:22 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:26574 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756787AbaJ2UOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 16:14:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmU4AHRJUVR5LbBUPGdsb2JhbABcgw6BLII2hQeyZgEBAQEBAQaVU4VqBAICgR0XAQEBAQEGAQEBATg7hAMBAQQ6HCMQCAMYCSUPBSUDBxoTiEDIKAErGIYeiloHhEsFnWmBMoZ5kiIpL4JLAQEB
Date: Thu, 30 Oct 2014 07:14:17 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Jason B. Akers" <jason.b.akers@intel.com>
Cc: linux-ide@vger.kernel.org, axboe@fb.com, dan.j.williams@intel.com,
        kapil.karkra@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] Enable use of Solid State Hybrid Drives
Message-ID: <20141029201417.GK16186@dastard>
References: <20141029180454.4879.75088.stgit@stg-AndroidDev-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141029180454.4879.75088.stgit@stg-AndroidDev-VirtualBox>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 11:23:38AM -0700, Jason B. Akers wrote:
> The following series enables the use of Solid State hybrid drives
> ATA standard 3.2 defines the hybrid information feature, which provides a means for the host driver to provide hints to the SSHDs to guide what to place on the SSD/NAND portion and what to place on the magnetic media.
> 
> This implementation allows user space applications to provide the cache hints to the kernel using the existing ionice syscall. 
> 
> An application can pass a priority number coding up bits 11, 12, and 15 of the ionice command to form a 3 bit field that encodes the following priorities:
> 	OPRIO_ADV_NONE,
> 	IOPRIO_ADV_EVICT, /* actively discard cached data */
> 	IOPRIO_ADV_DONTNEED, /* caching this data has little value */
> 	IOPRIO_ADV_NORMAL, /* best-effort cache priority (default) */
> 	IOPRIO_ADV_RESERVED1, /* reserved for future use */
> 	IOPRIO_ADV_RESERVED2,
> 	IOPRIO_ADV_RESERVED3,
> 	IOPRIO_ADV_WILLNEED, /* high temporal locality */
> 
> For example the following commands from the user space will make dd IOs to be generated with a hint of IOPRIO_ADV_DONTNEED assuming the SSHD is /dev/sdc.
> 
> ionice -c2 -n4096 dd if=/dev/zero of=/dev/sdc bs=1M count=1024
> ionice -c2 -n4096 dd if=/dev/sdc of=/dev/null bs=1M count=1024

This looks to be the wrong way to implement per-IO priority
information.

How does a filesystem make use of this to make sure it's
metadata ends up with IOPRIO_ADV_WILLNEED to store frequently
accessed metadata in flash. Conversely, journal writes need to
be issued with IOPRIO_ADV_DONTNEED so they don't unneceessarily
consume flash space as they are never-read IOs...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
