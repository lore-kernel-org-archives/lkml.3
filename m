Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935601AbaH0PeE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:34:04 -0400
Received: from p02c12o141.mxlogic.net ([208.65.145.74]:55770 "EHLO
	p02c12o141.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934998AbaH0PeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:34:00 -0400
X-MXL-Hash: 53fdfa682108ee17-18be05dc683b701a01b3e3d6d6517f7f06b9348c
X-MXL-Hash: 53fdfa5156ffad55-94b634aeeaee1330910353c6fe42a6c5df72ed24
Date: Wed, 27 Aug 2014 11:33:26 -0400
From: Joe Lawrence <joe.lawrence@stratus.com>
To: Jens Axboe <axboe@kernel.dk>
CC: Jeff Moyer <jmoyer@redhat.com>, <linux-kernel@vger.kernel.org>,
        "Jiri Kosina" <jkosina@suse.cz>, Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH v3 0/2] block,scsi: fixup blk_get_request dead queue
 scenarios
Message-ID: <20140827113326.4531d0dd@jlaw-desktop.mno.stratus.com>
In-Reply-To: <53FDE621.2050009@kernel.dk>
References: <1404329718-19367-1-git-send-email-joe.lawrence@stratus.com>
	<x49egw36u55.fsf@segfault.boston.devel.redhat.com>
	<53FCF9DB.6010501@kernel.dk>
	<x49mwar54ca.fsf@segfault.boston.devel.redhat.com>
	<53FCFD40.2010903@kernel.dk>
	<53FCFE01.8080701@kernel.dk>
	<x49iole6hcc.fsf@segfault.boston.devel.redhat.com>
	<53FDE621.2050009@kernel.dk>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-AnalysisOut: [v=2.1 cv=IPIWC2fG c=1 sm=1 tr=0 a=VNTQBUOG7PJoPU2GWtE7Ww==]
X-AnalysisOut: [:117 a=VNTQBUOG7PJoPU2GWtE7Ww==:17 a=2KTiUk5DT3cA:10 a=AeS]
X-AnalysisOut: [L823i6SsA:10 a=_KQqW7t0BisA:10 a=BLceEmwcHowA:10 a=kj9zAlc]
X-AnalysisOut: [Oel0A:10 a=uelBKuKpAAAA:8 a=YlVTAMxIAAAA:8 a=OLL_FvSJAAAA:]
X-AnalysisOut: [8 a=eTfr7xuFwfrJcRmXuRAA:9 a=CjuIK1q_8ugA:10 a=p7CWjncfN08]
X-AnalysisOut: [A:10]
X-Spam: [F=0.5000000000; CM=0.500; MH=0.500(2014082705); S=0.200(2014051901)]
X-MAIL-FROM: <joe.lawrence@stratus.com>
X-SOURCE-IP: [134.111.1.17]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2014 08:07:29 -0600
Jens Axboe <axboe@kernel.dk> wrote:
> On 08/26/2014 04:01 PM, Jeff Moyer wrote:
> >> Additionally, there's still quite a few places that call
> >> blk_get_request() and don't check the error return if __GFP_WAIT is set.
> >> Since most of the point of this is to fix segfaulting on queue dead
> >> scenarios, why aren't they all converted?
> > 
> > Odd, I thought they all were converted last I checked.  They definitely
> > should be.
> 
> drivers/ide/ide-park:issue_park_cmd() (patch oddly converts just the one?!)
> drivers/ide/ide-pm.c:generic_ide_suspend()
> drivers/ide/ide-pm.c:generic_ide_resume()
> drivers/ide/ide-cd.c:ide_cd_queue_pc()
> drivers/ide/ide-atapi.c:ide_queue_pc_tail()
> drivers/ide/ide-ioctls.c:ide_cmd_ioctl()
> drivers/ide/ide-ioctls.c:generic_drive_reset()
> drivers/ide/ide-taskfile.c:ide_raw_taskfile()
> drivers/ide/ide-tape.c:idetape_queue_rw_tail()
> drivers/ide/ide-cd_ioctls.c:ide_cdrom_reset()
> drivers/ide/ide-disk.c:set_multcount()
> drivers/ide/ide-devsets.c:ide_devset_execute()
> 
> Why only one location in ide-park.c was converted and the rest of IDE
> left untouched, I don't know. But there are definitely lots of them left
> in there.

These files didn't seem to have much recent development going on, so my
thinking was that if one were to bother checking the return from
blk_get_request, I would update it.  If the code didn't include such
check in the first place, then I let it be.

> There's also a bug in osd_initiator.c, _init_blk_request(). We jump to
> 'out' for IS_ERR(req), which attempts to print or->request, which hasn't
> been assigned yet. This is my primary concern with this patch, basically
> every single of these call sites must be verified or it will do more
> harm than good. Have they been?

So the _init_blk_request bug has been there since c29b70f6 when the
_make_request wrapper was introduced -- I missed that when inspecting
the surrounding areas that the patch modified.

Given the scope of the changes, I agree that the probability of
introducing another bug is real.  I think either you or James suggested
splitting this fix into two parts: the first patch avoiding the crash I
originally saw, the second modifying ABI to propagate out additional
information required to discern why blk_get_request failed. 

As I mentioned in [1], the call chain into blk_get_request is pretty
wide.  I did my best trying to hunt down the callers callers callers,
etc. to figure out how the returns are handled.  Without testing every
single site, I can't be 100% sure.  In the end, I'd be happy with patch
1 to avoid the original crash report.  Patch 2 was the for
truth-and-beauty approach.  Whether you think it's worth the risk is a
judgment call on your part.

[1] http://www.spinics.net/lists/kernel/msg1776335.html

-- Joe
