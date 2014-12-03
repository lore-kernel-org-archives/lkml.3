Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842AbaLCPZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 10:25:49 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48266 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbaLCPZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 10:25:48 -0500
Date: Wed, 3 Dec 2014 16:25:45 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Dave Chinner <david@fromorbit.com>
Cc: "Jason B. Akers" <jason.b.akers@intel.com>, linux-ide@vger.kernel.org,
        axboe@fb.com, dan.j.williams@intel.com, kapil.karkra@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] Enable use of Solid State Hybrid Drives
Message-ID: <20141203152544.GA21586@amd>
References: <20141029180454.4879.75088.stgit@stg-AndroidDev-VirtualBox>
 <20141029201417.GK16186@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141029201417.GK16186@dastard>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-10-30 07:14:17, Dave Chinner wrote:
> On Wed, Oct 29, 2014 at 11:23:38AM -0700, Jason B. Akers wrote:
> > The following series enables the use of Solid State hybrid drives
> > ATA standard 3.2 defines the hybrid information feature, which provides a means for the host driver to provide hints to the SSHDs to guide what to place on the SSD/NAND portion and what to place on the magnetic media.
> > 
> > This implementation allows user space applications to provide the cache hints to the kernel using the existing ionice syscall. 
> > 
> > An application can pass a priority number coding up bits 11, 12, and 15 of the ionice command to form a 3 bit field that encodes the following priorities:
> > 	OPRIO_ADV_NONE,
> > 	IOPRIO_ADV_EVICT, /* actively discard cached data */
> > 	IOPRIO_ADV_DONTNEED, /* caching this data has little value */
> > 	IOPRIO_ADV_NORMAL, /* best-effort cache priority (default) */
> > 	IOPRIO_ADV_RESERVED1, /* reserved for future use */
> > 	IOPRIO_ADV_RESERVED2,
> > 	IOPRIO_ADV_RESERVED3,
> > 	IOPRIO_ADV_WILLNEED, /* high temporal locality */
> > 
> > For example the following commands from the user space will make dd IOs to be generated with a hint of IOPRIO_ADV_DONTNEED assuming the SSHD is /dev/sdc.
> > 
> > ionice -c2 -n4096 dd if=/dev/zero of=/dev/sdc bs=1M count=1024
> > ionice -c2 -n4096 dd if=/dev/sdc of=/dev/null bs=1M count=1024
> 
> This looks to be the wrong way to implement per-IO priority
> information.
> 
> How does a filesystem make use of this to make sure it's
> metadata ends up with IOPRIO_ADV_WILLNEED to store frequently
> accessed metadata in flash. Conversely, journal writes need to
> be issued with IOPRIO_ADV_DONTNEED so they don't unneceessarily
> consume flash space as they are never-read IOs...

Well, that makes sense, but we still want some kind of per-application
priority.

I'd like ~/.chromium directory cached in the SSD part, but I don't
neccessarily want /data/backup directory cached in the SSD...

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
