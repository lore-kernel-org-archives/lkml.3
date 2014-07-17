Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbaGQNbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:31:55 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:33663 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933259AbaGQNbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:31:38 -0400
Date: Thu, 17 Jul 2014 15:31:46 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Oded Gabbay <oded.gabbay@amd.com>, Jerome Glisse <j.glisse@gmail.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [PATCH 08/83] drm/radeon: Add calls to initialize and finalize
 kfd from radeon
Message-ID: <20140717133146.GM15237@phenom.ffwll.local>
Mail-Followup-To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Oded Gabbay <oded.gabbay@amd.com>,
	Jerome Glisse <j.glisse@gmail.com>,
	Andrew Lewycky <Andrew.Lewycky@amd.com>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Alex Deucher <alexander.deucher@amd.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
 <1405029027-6085-7-git-send-email-oded.gabbay@amd.com>
 <20140711163627.GI1870@gmail.com>
 <53C7BA12.20703@amd.com>
 <53C7C18F.2070803@amd.com>
 <53C7C1EA.3080002@amd.com>
 <53C7C555.8040402@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53C7C555.8040402@amd.com>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 02:45:09PM +0200, Christian König wrote:
> Am 17.07.2014 14:30, schrieb Oded Gabbay:
> >On 17/07/14 15:29, Christian König wrote:
> >>Am 17.07.2014 13:57, schrieb Oded Gabbay:
> >>>On 11/07/14 19:36, Jerome Glisse wrote:
> >>>>On Fri, Jul 11, 2014 at 12:50:08AM +0300, Oded Gabbay wrote:
> >>>>>The KFD driver should be loaded when the radeon driver is loaded and
> >>>>>should be finalized when the radeon driver is removed.
> >>>>>
> >>>>>This patch adds a function call to initialize kfd from radeon_init
> >>>>>and a function call to finalize kfd from radeon_exit.
> >>>>>
> >>>>>If the KFD driver is not present in the system, the initialize call
> >>>>>fails and the radeon driver continues normally.
> >>>>>
> >>>>>This patch also adds calls to probe, initialize and finalize a kfd
> >>>>>device
> >>>>>per radeon device using the kgd-->kfd interface.
> >>>>>
> >>>>>Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
> >>>>
> >>>>It might be nice to allow to build radeon without HSA so i think an
> >>>>CONFIG_HSA should be added and have other thing depends on it.
> >>>>Otherwise this one is.
> >>>>
> >>>>Reviewed-by: Jérôme Glisse <jglisse@redhat.com>
> >>>>
> >>>We do allow it :)
> >>>There is no problem building radeon without the kfd. In that case,
> >>>when radeon
> >>>finds out that kfd is not available, it simply moves on with its
> >>>initialization procedure.
> >>
> >>At least off hand I don't see how this should work. Radeon directly
> >>calls
> >>radeon_kfd_(probe|init|fini) and so has a direct dependency on it.
> >>
> >>Christian.
> >But radeon_kfd.c is now a permanent part of the radeon driver. I talked
> >with Alex about it and we both agreed on that. So radeon_kfd_* functions
> >are *always* there when you build radeon.
> 
> Ah, I see. So radeon_kfd_init then tries to load the other module through
> symbol_request(). Long story short that's a bad idea for a couple of
> reasons.
> 
> First of all it only works when you build everything as module and second by
> doing so the radeon<->kfd interface must be handled as internal stable
> interface.
> 
> Only a very few drivers/subsystem do use symbol_request() and to see how to
> use it correctly please take a look at (for example)
> sound/pci/hda/hda_codec.c.

We do this in i915 to coordinate a bunch of things with the snd_hda
driver. And it's a major pain. Imo the proper way to do this is for one
driver to expose a platform driver with a bunch of specific interfaces and
for the other driver to register as a platform driver against that device.

Then all the usual linux hotplug infrastructure will make sure that this
all works and there's a clear runtime depency. For i915 that's what I've
requested the audio guys to look into, and also what I'll require for
other such sub-driver stuff (e.g. we have a non-intel video codec on vlv
gfx). Well for audio it will be a bit fancier since we also want some
standardized stuff to allow userspace to see the association between the
gfx output and the audio side. Atm you can only guess if you have more
than one screen connected.

This approach gives you full flexibility and you can e.g. blacklist the
subdriver for debugging, without a kernel recompile.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
