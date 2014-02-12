Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714AbaBLSm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 13:42:58 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:34371 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752178AbaBLSm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 13:42:57 -0500
Date: Wed, 12 Feb 2014 18:42:37 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        dri-devel@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG] Circular locking dependency - DRM/CMA/MM/hotplug/...
Message-ID: <20140212184237.GR26684@n2100.arm.linux.org.uk>
References: <20140211183543.GK26684@n2100.arm.linux.org.uk> <52FB9602.1000805@samsung.com> <20140212163317.GQ26684@n2100.arm.linux.org.uk> <20140212182901.GX17001@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212182901.GX17001@phenom.ffwll.local>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 07:29:01PM +0100, Daniel Vetter wrote:
> On Wed, Feb 12, 2014 at 04:33:17PM +0000, Russell King - ARM Linux wrote:
> > On Wed, Feb 12, 2014 at 04:40:50PM +0100, Marek Szyprowski wrote:
> > >> -> #3 (console_lock){+.+.+.}:
> > >>         [<c0066f04>] __lock_acquire+0x151c/0x1ca0
> > >>         [<c0067c28>] lock_acquire+0xa0/0x130
> > >>         [<c006edcc>] console_lock+0x60/0x74
> > >>         [<c006f7b8>] console_cpu_notify+0x28/0x34
> > >>         [<c004904c>] notifier_call_chain+0x4c/0x8c
> > >>         [<c004916c>] __raw_notifier_call_chain+0x1c/0x24
> > >>         [<c0024124>] __cpu_notify+0x34/0x50
> > >>         [<c002424c>] cpu_notify_nofail+0x18/0x24
> > >>         [<c068e168>] _cpu_down+0x100/0x244
> > >>         [<c068e2dc>] cpu_down+0x30/0x44
> > >>         [<c036ef8c>] cpu_subsys_offline+0x14/0x18
> > >>         [<c036af28>] device_offline+0x94/0xbc
> > >>         [<c036b030>] online_store+0x4c/0x74
> > >>         [<c0368d3c>] dev_attr_store+0x20/0x2c
> > >>         [<c016b2e0>] sysfs_kf_write+0x54/0x58
> > >>         [<c016eaa4>] kernfs_fop_write+0xc4/0x160
> > >>         [<c0105a54>] vfs_write+0xbc/0x184
> > >>         [<c0105dfc>] SyS_write+0x48/0x70
> > >>         [<c000e6e0>] ret_fast_syscall+0x0/0x48
> > 
> > cpu_down() takes cpu_hotplug.lock, so here we have:
> > 
> > 	cpu_hotplug.lock
> > 	console_lock
> 
> The patche I've linked in my other mail will break the chain here, so
> should solve this. And apparently with cpu hotplug we can hit this, too.
> And having banged my head against the console_lock wall I think doing a
> trylock here is generally the sanest option.
> 
> So imo we can just blame console_lock, not need to either beat up v4l,
> drm, cma or anyone else really ;-)

I don't think CMA needs to hold its lock across the allocations/frees
though - given the size of this, I think it's best if /everyone/ tries
to reduce the locking interactions where possible.

The CMA issue needs to be done anyway - what it currently means is that
all CMA allocations in the kernel are serialised, even if an allocation
attempt sleeps, another allocation gets blocked.

So, sorting that out breaks the dependency there, and if it can be broken
elsewhere, that's an added bonus and will help prevent other issues
like this.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
