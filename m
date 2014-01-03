Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbaACMwL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 07:52:11 -0500
Received: from mail.fireflyinternet.com ([87.106.93.118]:62910 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751835AbaACMv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 07:51:58 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
Date: Fri, 3 Jan 2014 12:51:51 +0000
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: ben@bwidawsk.net, daniel.vetter@ffwll.ch, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915: Fix refcount leak and possible NULL
 pointerdereference.
Message-ID: <20140103125151.GA4367@nuc-i3427.alporthouse.com>
References: <201312242050.CGH78112.JQFOSVMLOFtHOF@I-love.SAKURA.ne.jp>
 <20131225215249.GA3832@nuc-i3427.alporthouse.com>
 <201401032042.BJF09317.FJFQOFOVtSOLMH@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201401032042.BJF09317.FJFQOFOVtSOLMH@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 03, 2014 at 08:42:18PM +0900, Tetsuo Handa wrote:
> Chris Wilson wrote:
> > On Tue, Dec 24, 2013 at 08:50:23PM +0900, Tetsuo Handa wrote:
> > > >From 482be6384379072eb4c0d45d0ab8a25df4f59ed7 Mon Sep 17 00:00:00 2001
> > > From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> > > Date: Tue, 24 Dec 2013 18:04:14 +0900
> > > Subject: [PATCH] drm/i915: Fix refcount leak and possible NULL pointer dereference.
> > > 
> > > Since get_pid_task() grabs a reference on the task_struct, we have to drop the
> > > refcount after reading that task's comm name. Also, directly reading like
> > > get_pid_task()->comm can trigger an oops when get_pid_task() returned NULL.
> > 
> > The second issue is moot as file itself cannot exist if the task_struct
> > is NULL, and the task_struct cannot be destroyed until we finish the
> > function. The simpler fix would appear to be s/get_pid_task/pid_task/
> 
> If I understand correctly, priv->pid = get_pid(task_pid(current)); in
> drm_open_helper() grabs a reference on "struct pid" before adding to
> &dev->filelist, and put_pid(file_priv->pid); in drm_release() releases that
> reference after removing from &dev->filelist.
> 
> So, you meant that mutex_lock_interruptible(&dev->struct_mutex); in
> i915_gem_object_info() prevents drm_release() from calling put_pid() ?

Right, my understanding is that since we take the struct_mutex during
release of the filp (and across this list walker) that is sufficient
serialisation to prevent the task struct from disappearing from
underneath us.
 
> Then, this file->pid in &dev->filelist keeps at least one reference.
> OK. Updated patch follows.

Looks good to me, and the comment is great.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
