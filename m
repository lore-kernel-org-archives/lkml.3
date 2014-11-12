Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbaKLWNw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 17:13:52 -0500
Received: from gproxy9-pub.mail.unifiedlayer.com ([69.89.20.122]:51232 "HELO
	gproxy9-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752273AbaKLWNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 17:13:50 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Nov 2014 17:13:50 EST
X-Authority-Analysis: v=2.1 cv=b7chvL2x c=1 sm=1 tr=0
 a=9W6Fsu4pMcyimqnCr1W0/w==:117 a=9W6Fsu4pMcyimqnCr1W0/w==:17 a=cNaOj0WVAAAA:8
 a=f5113yIGAAAA:8 a=kj9zAlcOel0A:10 a=TBVoxVdAAAAA:8 a=GhZ5P8ky69gA:10
 a=noBwr2J6l1kA:10 a=wkt-CnUX7WkRnzVWUtUA:9 a=CjuIK1q_8ugA:10
Date: Wed, 12 Nov 2014 14:07:41 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Joerg Roedel <jroedel@suse.de>
Cc: Oded Gabbay <oded.gabbay@amd.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: export find_extend_vma and handle_mm_fault for
 driver use
Message-ID: <20141112140741.0ebef398@jbarnes-hsw>
In-Reply-To: <20141106130122.GJ8354@suse.de>
References: <1414179271-7621-1-git-send-email-jbarnes@virtuousgeek.org>
	<20141027151327.GE9734@suse.de>
	<544E61A1.7090400@amd.com>
	<20141027083552.4af5753f@jbarnes-hsw>
	<5450B472.1020301@amd.com>
	<20141105120351.GH8354@suse.de>
	<20141105135109.39ea54fe@jbarnes-hsw>
	<20141106130122.GJ8354@suse.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Nov 2014 14:01:22 +0100
Joerg Roedel <jroedel@suse.de> wrote:

> On Wed, Nov 05, 2014 at 01:51:09PM -0800, Jesse Barnes wrote:
> > On Wed, 5 Nov 2014 13:03:51 +0100
> > Joerg Roedel <jroedel@suse.de> wrote:
> > > Thanks for testing Oded. Jesse, the patch looks good to me, except the
> > > task accounting for the page-faults. I'd like to get rid of using
> > > task_struct in the IOMMUv2 driver entirely if possible. Also it is not
> > > really the CPU task causing the faults, but some non-CPU process.
> > 
> > Hm, but the CPU task initiates the activity on the GPU, so we should
> > account for it somewhere, right?  I guess I had been thinking of the
> > "task" as spanning the CPUs and GPUs and other devices in the system,
> > rather than just representing the CPU activity.
> 
> One problem is that the task that called amd_iommu_bind_pasid() isn't
> necessarily the same task (thread) that queues the jobs to the device.
> The thread that called amd_iommu_bind_pasid() might even exit while
> other threads still use the mappings.
> 
> Besides that, from an abstract point of view, what is running on the
> device (GPU) is a logically seperate 'thread' of the process which we
> should account for seperatly. If we want accounting for these off-CPU
> threads we should probably introduce some concept of a non-CPU task to
> the kernel and do the accounting there?

Yeah those are good points; I hadn't been thinking of multi-threaded
stuff.  Logically the GPU stuff really is a separate thread in that
sense, so monitoring faults separately makes sense.

I wonder if we need a new "device_task_struct" or
"coprocessor_task_struct" or something to wrap some simple stuff on
non-CPU devices.  They could be sub-classed by drivers that needed
additional driver specific data.

-- 
Jesse Barnes, Intel Open Source Technology Center
