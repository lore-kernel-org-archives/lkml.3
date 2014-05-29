Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932935AbaE2U52 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 16:57:28 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:52040 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932140AbaE2U50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 16:57:26 -0400
Date: Thu, 29 May 2014 22:57:20 +0200
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Ken Moffat <zarniwhoop@ntlworld.com>, Dave Airlie <airlied@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Resume from suspend broken in 3.15. (bisected)
Message-ID: <20140529205720.GD19050@phenom.ffwll.local>
Mail-Followup-To: Alex Deucher <alexdeucher@gmail.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Ken Moffat <zarniwhoop@ntlworld.com>,
	Dave Airlie <airlied@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <20140528172521.GA9945@milliways>
 <20140528234927.GA18638@milliways>
 <CADnq5_PWigm5e4CwnfW+3TaohbFo82uDpiCMftL=OmRvCkJQzQ@mail.gmail.com>
 <20140529060311.GU17724@mwanda>
 <CADnq5_NxXDfGEquFZX_CnhNEAKEomijQCX+Hn3kQhAFBZOge1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADnq5_NxXDfGEquFZX_CnhNEAKEomijQCX+Hn3kQhAFBZOge1g@mail.gmail.com>
X-Originating-IP: [84.73.67.144]
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 10:47 PM, Alex Deucher <alexdeucher@gmail.com> wrote:
> On Thu, May 29, 2014 at 2:03 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>> On Wed, May 28, 2014 at 08:26:53PM -0400, Alex Deucher wrote:
>>> On Wed, May 28, 2014 at 7:49 PM, Ken Moffat <zarniwhoop@ntlworld.com> wrote:
>>> > On Wed, May 28, 2014 at 06:25:21PM +0100, Ken Moffat wrote:
>>> >> Hi Daniel,
>>> >>
>>> >
>>> >  [ correcting details, confirming that reverting this does fix the
>>> > problem, adding Cc:s ]
>>> >
>>> >>  I've only started full testing of 3.15 on one of my machines now
>>> >> that -rc7 has been released (this one had two issues in the radeon
>>> >> code, second was fixed in rc7).  Unfortunately, suspend to RAM
>>> >> (pm-suspend), or rather the wake-up, is broken on this box [ my
>>> >> other two boxes are fine in rc7 ].
>>> >>
>>> >> Bisection identified one of your commits -
>>> >>
>>> >> commit 25f397a429dfa43f22c278d0119a60a343aa568f
>>> >> Author: Daniel Vetter <daniel.vetter@ffwll.ch>
>>> >> Date:   Fri Jul 19 18:57:11 2013 +0200
>>> >>
>>> >>     drm/crtc-helper: explicit DPMS on after modeset
>>> >>
>>> >>     Atm the crtc helper implementation of set_config has really
>>> >>     inconsisten semantics: If just an fb update is good enough, dpms state
>>> >>     will be left as-is, but if we do a full modeset we force everything to
>>> >>     dpms on.
>>> >>
>>> >>     This change has already been applied to the i915 modeset code in
>>> >>
>>> >> ('git show' stops at that point)
>>> >
>>> >  update : I've no idea what was going on there, nor for the problem
>>> > with attempting to revert it.  I've now gone back into git,
>>> > extracted the full commit to a file with 'git show', and then used
>>> > git apply -R to revert it from 3.15-rc7.  That version wakes up from
>>> > suspend to RAM, 3.15-rc7 itself did not.
>>> >
>>> >  Maybe I was still in git log when I thought I was on the command
>>> > line.  Anyway, snipping git's view of my failed attempt to revert
>>> > it, and adding Dan and Alex who were CC'd on the commit.
>>> >
>>>
>>> Duplicate of:
>>> https://bugzilla.kernel.org/show_bug.cgi?id=74751
>>> and also reported here:
>>> https://lkml.org/lkml/2014/5/2/388
>>> Unless there is a good reason to keep the commit, I'd say let's just revert it.
>>>
>>
>> Yes.  Let's revert it.
>
> The actual bad commit is 177cf92de4aa97ec1435987e91696ed8b5023130, but
> for some reason git bisect always comes up with
> 25f397a429dfa43f22c278d0119a60a343aa568f which has been in the tree
> for almost a year now.  I don't know why.

Quick patch which is worth a shot before we revert 177cf.
-Daniel

diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index c2edb2d14030..cf5d299cc623 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -1534,11 +1534,6 @@ int radeon_resume_kms(struct drm_device *dev, bool resume, bool fbcon)
 
 	radeon_restore_bios_scratch_regs(rdev);
 
-	if (fbcon) {
-		radeon_fbdev_set_suspend(rdev, 0);
-		console_unlock();
-	}
-
 	/* init dig PHYs, disp eng pll */
 	if (rdev->is_atom_bios) {
 		radeon_atom_encoder_init(rdev);
@@ -1563,6 +1558,12 @@ int radeon_resume_kms(struct drm_device *dev, bool resume, bool fbcon)
 	}
 
 	drm_kms_helper_poll_enable(dev);
+
+	if (fbcon) {
+		radeon_fbdev_set_suspend(rdev, 0);
+		console_unlock();
+	}
+
 	return 0;
 }
 
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
