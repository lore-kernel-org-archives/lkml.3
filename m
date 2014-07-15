Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932698AbaGORhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:37:16 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:41407 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078AbaGORhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:37:13 -0400
Date: Tue, 15 Jul 2014 13:37:06 -0400
From: Jerome Glisse <j.glisse@gmail.com>
To: "Bridgman, John" <John.Bridgman@amd.com>
Cc: Dave Airlie <airlied@gmail.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <deathsimple@vodafone.de>,
        "Lewycky, Andrew" <Andrew.Lewycky@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/83] AMD HSA kernel driver
Message-ID: <20140715173704.GA3421@gmail.com>
References: <20140710222423.GA14219@gmail.com>
 <019CCE693E457142B37B791721487FD91809E4C2@storexdag01.amd.com>
 <20140711211850.GU1870@gmail.com>
 <019CCE693E457142B37B791721487FD9180A193B@storexdag01.amd.com>
 <20140713035535.GB5301@gmail.com>
 <D89D60253BB73A4E8C62F9FD18A939CA0103C0EB@storexdag02.amd.com>
 <20140713164901.GB10624@gmail.com>
 <53C396D3.9000600@vodafone.de>
 <CAPM=9txM=0Rd8sP56X1v2sXhAYiRJDoz-j8+N0wXpam-+kYJ8Q@mail.gmail.com>
 <D89D60253BB73A4E8C62F9FD18A939CA01050131@storexdag02.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <D89D60253BB73A4E8C62F9FD18A939CA01050131@storexdag02.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 05:06:56PM +0000, Bridgman, John wrote:
> >From: Dave Airlie [mailto:airlied@gmail.com]
> >Sent: Tuesday, July 15, 2014 12:35 AM
> >To: Christian König
> >Cc: Jerome Glisse; Bridgman, John; Lewycky, Andrew; linux-
> >kernel@vger.kernel.org; dri-devel@lists.freedesktop.org; Deucher,
> >Alexander; akpm@linux-foundation.org
> >Subject: Re: [PATCH 00/83] AMD HSA kernel driver
> >
> >On 14 July 2014 18:37, Christian König <deathsimple@vodafone.de> wrote:
> >>> I vote for HSA module that expose ioctl and is an intermediary with
> >>> the kernel driver that handle the hardware. This gives a single point
> >>> for HSA hardware and yes this enforce things for any hardware
> >manufacturer.
> >>> I am more than happy to tell them that this is it and nothing else if
> >>> they want to get upstream.
> >>
> >> I think we should still discuss this single point of entry a bit more.
> >>
> >> Just to make it clear the plan is to expose all physical HSA capable
> >> devices through a single /dev/hsa device node to userspace.
> >
> >This is why we don't design kernel interfaces in secret foundations, and
> >expect anyone to like them.
> 
> Understood and agree. In this case though this isn't a cross-vendor interface designed by a secret committee, it's supposed to be more of an inoffensive little single-vendor interface designed *for* a secret committee. I'm hoping that's better ;)
> 
> >
> >So before we go any further, how is this stuff planned to work for multiple
> >GPUs/accelerators?
> 
> Three classes of "multiple" :
> 
> 1. Single CPU with IOMMUv2 and multiple GPUs:
> 
> - all devices accessible via /dev/kfd
> - topology information identifies CPU + GPUs, each has "node ID" at top of userspace API, "global ID" at user/kernel interface
>  (don't think we've implemented CPU part yet though)
> - userspace builds snapshot from sysfs info & exposes to HSAIL runtime, which in turn exposes the "standard" API

This is why i do not like the sysfs approach, it would be lot nicer to have
device file per provider and thus hsail can listen on device file event and
discover if hardware is vanishing or appearing. Periodicaly going over sysfs
files is not the right way to do that.

> - kfd sets up ATC aperture so GPUs can access system RAM via IOMMUv2 (fast for APU, relatively less so for dGPU over PCIE)
> - to-be-added memory operations allow allocation & residency control (within existing gfx driver limits) of buffers in VRAM & carved-out system RAM
> - queue operations specify a node ID to userspace library, which translates to "global ID" before calling kfd
> 
> 2. Multiple CPUs connected via fabric (eg HyperTransport) each with 0 or more GPUs:
> 
> - topology information exposes CPUs & GPUs, along with affinity info showing what is connected to what
> - everything else works as in (1) above
> 

This is suppose to be part of HSA ? This is lot broader than i thought.

> 3. Multiple CPUs not connected via fabric (eg a blade server) each with 0 or more GPUs
> 
> - no attempt to cover this with HSA topology, each CPU and associated GPUs is accessed independently via separate /dev/kfd instances
> 
> >
> >Do we have a userspace to exercise this interface so we can see how such a
> >thing would look?
> 
> Yes -- initial IP review done, legal stuff done, sanitizing WIP, hoping for final approval this week
> 
> There's a separate test harness to exercise the userspace lib calls, haven't started IP review or sanitizing for that but legal stuff is done
> 
> >
> >Dave.
