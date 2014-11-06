Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350AbaKFNB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 08:01:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49772 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbaKFNBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 08:01:25 -0500
Date: Thu, 6 Nov 2014 14:01:22 +0100
From: Joerg Roedel <jroedel@suse.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Oded Gabbay <oded.gabbay@amd.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: export find_extend_vma and handle_mm_fault for
 driver use
Message-ID: <20141106130122.GJ8354@suse.de>
References: <1414179271-7621-1-git-send-email-jbarnes@virtuousgeek.org>
 <20141027151327.GE9734@suse.de>
 <544E61A1.7090400@amd.com>
 <20141027083552.4af5753f@jbarnes-hsw>
 <5450B472.1020301@amd.com>
 <20141105120351.GH8354@suse.de>
 <20141105135109.39ea54fe@jbarnes-hsw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141105135109.39ea54fe@jbarnes-hsw>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 01:51:09PM -0800, Jesse Barnes wrote:
> On Wed, 5 Nov 2014 13:03:51 +0100
> Joerg Roedel <jroedel@suse.de> wrote:
> > Thanks for testing Oded. Jesse, the patch looks good to me, except the
> > task accounting for the page-faults. I'd like to get rid of using
> > task_struct in the IOMMUv2 driver entirely if possible. Also it is not
> > really the CPU task causing the faults, but some non-CPU process.
> 
> Hm, but the CPU task initiates the activity on the GPU, so we should
> account for it somewhere, right?  I guess I had been thinking of the
> "task" as spanning the CPUs and GPUs and other devices in the system,
> rather than just representing the CPU activity.

One problem is that the task that called amd_iommu_bind_pasid() isn't
necessarily the same task (thread) that queues the jobs to the device.
The thread that called amd_iommu_bind_pasid() might even exit while
other threads still use the mappings.

Besides that, from an abstract point of view, what is running on the
device (GPU) is a logically seperate 'thread' of the process which we
should account for seperatly. If we want accounting for these off-CPU
threads we should probably introduce some concept of a non-CPU task to
the kernel and do the accounting there?


	Joerg

