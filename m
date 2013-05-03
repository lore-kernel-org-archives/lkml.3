Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934337Ab3ECUby (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 16:31:54 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:46883 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763474Ab3ECUbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 16:31:52 -0400
Date: Fri, 3 May 2013 16:31:49 -0400
From: Josh Boyer <jwboyer@gmail.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dave Airlie <airlied@linux.ie>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: Re: [git pull] drm for 3.10-rc1
Message-ID: <20130503203149.GD8320@zod.gha.chartermi.net>
References: <alpine.DEB.2.00.1305030224580.12778@skynet.skynet.ie>
 <20130503143951.GB8320@zod.gha.chartermi.net>
 <CAKMK7uF46a87KDg=n-rLhq2kjuPCpexHGwfR9UcPc_smZjqQzg@mail.gmail.com>
 <20130503165720.GC8320@zod.gha.chartermi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130503165720.GC8320@zod.gha.chartermi.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 12:57:20PM -0400, Josh Boyer wrote:
>On Fri, May 03, 2013 at 06:08:52PM +0200, Daniel Vetter wrote:
>>On Fri, May 3, 2013 at 4:39 PM, Josh Boyer <jwboyer@gmail.com> wrote:
>>> On Fri, May 03, 2013 at 02:25:57AM +0100, Dave Airlie wrote:
>>>>The following changes since commit b6a9b7f6b1f21735a7456d534dc0e68e61359d2c:
>>>>
>>>>  mm: prevent mmap_cache race in find_vma() (2013-04-04 11:46:28 -0700)
>>>>
>>>>are available in the git repository at:
>>>>
>>>>  git://people.freedesktop.org/~airlied/linux.git drm-next
>>>>
>>>>for you to fetch changes up to 307b9c022720f9de90d58e51743e01e9a42aec59:
>>>>
>>>>  qxl: update to new idr interfaces. (2013-05-03 10:37:20 +1000)
>>>>
>>>>----------------------------------------------------------------
>>>
>>> So something in this batch of commits breaks a Macbook Pro Retina I have
>>> sitting here.  If I boot a Fedora kernel based on  Linux
>>> v3.9-8153-g5a148af, things boot up as they did previously with 3.9.0 and
>>> are generally working fine.  If I boot with a kernel based on Linux
>>> v3.9-8933-gce85722, it will boot but as soon as plymouth starts, I get
>>> nothing but static on the screen (like 1950s TV static).
>>>
>>> This machine is using i915 graphics, so I booted with nomodeset and did
>>> the 'modprobe drm debug=15; modprobe i915 modeset=1' trick and it
>>> repeated the failure with that.  I've gathered a bunch of data like
>>> dmesg, an intel_reg_snapshot, etc.  It's all attached below.
>>>
>>> I'll start bisecting to see if I can narrow down the commit that broke
>>> things, but I thought I would give a heads up now in case anyone has any
>>> ideas.
>>
>>Looked through the log files and didn't see a clue. And usually DP
>>tends to fail pretty noisily. So I think the bisect result would be
>>interestin. Meanwhile:
>
>Yeah, working on that.

OK.  Git bisect tells me this:

57c219633275c7e7413f8bc7be250dc092887458 is the first bad commit
commit 57c219633275c7e7413f8bc7be250dc092887458
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Thu Apr 4 17:19:37 2013 +0200

    drm/i915: revert eDP bpp clamping code changes
    
    The behaviour around handling the eDP bpp value from vbt has been
    slightly changed in
    
    commit 3600836585e3fdef0a1410d63fe5ce4015007aac
    Author: Daniel Vetter <daniel.vetter@ffwll.ch>
    Date:   Wed Mar 27 00:44:59 2013 +0100
    
        drm/i915: convert DP autodither code to new infrastructure
    
    The old behaviour was that we used the plane's bpp (usually 24bpp) for
    computing the dp link bw, but set up the pipe with the bpp value from
    vbt if available. This takes the vbt bpp override into account even
    for the dp link bw configuration.
    
    On Paulo's hsw machine this resulted in a slower link clock and a
    black screen - but the mode actually /should/ fit even with the lower
    clock. Until we've cleared up simply stay bug-for-bug compatible with
    the old code.
    
    While at it, also restore a debug message lost in:
    
    commit 4e53c2e010e531b4a014692199e978482d471c7e
    Author: Daniel Vetter <daniel.vetter@ffwll.ch>
    Date:   Wed Mar 27 00:44:58 2013 +0100
    
        drm/i915: precompute pipe bpp before touching the hw
    
    Cc: Paulo Zanoni <przanoni@gmail.com>
    Reviewed-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
    Tested-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>

:040000 040000 a7529c568073885302e5ca03cce5bd224e244b57 d5d860a0d4b04ad98d77abb1df774c1448bd1697 M	drivers

The bisect log is below.  I can try to revert it directly on top of
Linus' latest tree later.

>>- do you have drm.debug=0xe dmesg for a working kernel, too?
>
>No, but I can try and get one.

I haven't gotten to this quite yet.  I'll try to get to it over the
weekend.

josh

[jwboyer@obiwan linux]$ git bisect log
git bisect start
# good: [5a148af66932c31814e263366094b5812210b501] Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc
git bisect good 5a148af66932c31814e263366094b5812210b501
# bad: [ce857229e0c3adc211944a13a5579ef84fd7b4af] ipc: fix GETALL/IPC_RM race for sysv semaphores
git bisect bad ce857229e0c3adc211944a13a5579ef84fd7b4af
# bad: [4ed108352d9b60a723a5071ed05e722826c2b72f] drm/radeon: put UVD PLLs in bypass mode
git bisect bad 4ed108352d9b60a723a5071ed05e722826c2b72f
# bad: [dc652f90e088798bfa31f496ba994ddadd5d5680] drm/i915: ensure single initialization and cleanup of backlight device
git bisect bad dc652f90e088798bfa31f496ba994ddadd5d5680
# good: [bb60b9695ced58768ba05b2d88fb4ee815df18f4] drm/i915: emit a hotplug event on resume
git bisect good bb60b9695ced58768ba05b2d88fb4ee815df18f4
# good: [8b47047bd103c9fdb50440790a2ef17fa69a35c4] drm/i915: rip out superflous is_dp&is_cpu_edp tracking
git bisect good 8b47047bd103c9fdb50440790a2ef17fa69a35c4
# bad: [4615d4c9e27eda42c3e965f208a4b4065841498c] drm/i915: Use MLC (l3$) for context objects
git bisect bad 4615d4c9e27eda42c3e965f208a4b4065841498c
# bad: [40c7ead980945ac96eadbd6d99b050458d797e2b] drm/i915: PCH_NOP
git bisect bad 40c7ead980945ac96eadbd6d99b050458d797e2b
# good: [9c8e09b7a551fc81842a2d9cdc3e42a5b729820f] drm/i915: Set PIPECONF color range bit on Valleyview
git bisect good 9c8e09b7a551fc81842a2d9cdc3e42a5b729820f
# bad: [57c219633275c7e7413f8bc7be250dc092887458] drm/i915: revert eDP bpp clamping code changes
git bisect bad 57c219633275c7e7413f8bc7be250dc092887458
# good: [2af8898bed4d127a2b0d9f5109f6089f7f60e424] Revert "drm/i915: fix DP get_hw_state return value"
git bisect good 2af8898bed4d127a2b0d9f5109f6089f7f60e424
[jwboyer@obiwan linux]$ 

