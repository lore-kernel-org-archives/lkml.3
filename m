Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab3BDG0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 01:26:53 -0500
Received: from mga09.intel.com ([134.134.136.24]:44259 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058Ab3BDG0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 01:26:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,597,1355126400"; 
   d="scan'208";a="257227134"
Message-ID: <1359959205.2250.56.camel@rzhang1-mobl4>
Subject: Re: [Intel-gfx] [RFC PATCH 3/3] i915: ignore lid open event when
 resuming
From: Zhang Rui <rui.zhang@intel.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-acpi@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        rjw@sisk.pl, lenb@kernel.org
Date: Mon, 04 Feb 2013 14:26:45 +0800
In-Reply-To: <20130129101027.GJ14766@phenom.ffwll.local>
References: <1359300060-2967-1-git-send-email-rui.zhang@intel.com>
	 <1359300060-2967-3-git-send-email-rui.zhang@intel.com>
	 <CAKMK7uF4u-3XFogzdQQCBqA2Q61D1s3PhVF7BOT90d88TkqT0g@mail.gmail.com>
	 <1359340583.2249.14.camel@rzhang1-mobl4>
	 <CAKMK7uFWqtcnvkExz2_+0Vm+6pSREhRJ1szpHi2_CEmmHL6Nzg@mail.gmail.com>
	 <1359367598.2089.18.camel@rzhang1-mobl4>
	 <20130129101027.GJ14766@phenom.ffwll.local>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-29 at 11:10 +0100, Daniel Vetter wrote:
> On Mon, Jan 28, 2013 at 06:06:38PM +0800, Zhang Rui wrote:
> > On Mon, 2013-01-28 at 09:31 +0100, Daniel Vetter wrote:
> > > On Mon, Jan 28, 2013 at 3:36 AM, Zhang Rui <rui.zhang@intel.com> wrote:
> > > >> Given that this essentially requires users to manually set this module
> > > >> option to make stuff work I don't like this.
> > > >>
> > > > sorry, I do not understand.
> > > > this patch just disables modeset_on_lid during suspend.
> > > 
> > > Pardon me, the misunderstanding is on my side - I've mixed up
> > > dev_priv->modeset_on_lid with the corresponding module option.
> > > 
> > > Is my understanding correct that only with the new SCI pm state this
> > > can happen, since that still allows acpi events to be processed (and
> > > so our lid_notifier being called?
> > > 
> > yep.
> > 
> > > >> I see a few possible options:
> > > >> - plug the races between all the different parts - I've never really
> > > >> understood why acpi sends us events before the resume code has
> > > >> completed ... If that's indeed intentional, we could delay the
> > > >> handling a bit until at least the i915 resume code completed.
> > > >
> > > > IMO, the real question is that, during a suspend/resume cycle, if we
> > > > need to take care of the lid open event or not.
> > > > To me, the answer is no, because when resuming from STR, i915 is not
> > > > aware of such an event, and the i915 resume code works well, right?
> > > > so I do not think it is a problem to ignore the lid event for another
> > > > lightweight suspend state, which is introduced in Patch 1/3 in this
> > > > series.
> > > >
> > > >> - Judging from the diff context you're not on the latest 3.8-rc
> > > >> codebase - we've applied a few fixes to this lid hack recently. Please
> > > >> retest on a kernel with
> > > >>
> > > > the patch is based on 3.8.0-rc3, which already includes the commit
> > > > below.
> > > > And yes, the problem still exists.
> > > 
> > > Ok, I think I see the issue now. But I suspect that we need some
> > > additional locking to make this solid, since currently
> > > dev_priv->modeset_on_lid updates can race with our lid notifier
> > > handler. Let me think about this a bit more.
> > 
> > hmm,
> > with this patch, intel_lid_notify() will return immediately if
> > modeset_on_lid is set to -1. So the only problem in my mind is that we
> > got a lid open event during i915_suspend().
> > 
> > Say,
> > lid is opened -> i915_lid_notify() is invoked (modeset_on_lid is 1 at
> > this time) -> i915_suspend() set modeset_on_lid to -1, just before
> > intel_modeset_setup_hw_state() being invoked in i915_lid_notify() ->
> > intel_modeset_setup_hw_state() breaks the system.
> > 
> > but my first question would be is this (lid open on suspend) possible in
> > real world?
> > If the answer is yes, then my second question is that, this problem
> > exists for STR as well because SCI is still valid at this time when
> > suspending to memory, have we seen such issues for STR before?
> > 
> > Anyway, if the current code does not break STR, this patch should be
> > enough for the new suspend state.
> > what do you think?
> 
> I think I have two wishlist changes for your patch ;-)
> 
> - Convert dev_priv->modeset_on_lid to an enum, so that we have descriptive
>   names instead of magic numbers.
> 
sure, will update in next version.

> - I think we can close all races by adding a new lid_notifier mutex (I
>   prefer a new lock instead of overloading an existing one with). If we
>   hold that in the suspend/resume paths just for changing modeset_on_lid
>   and also for the entire lid notifier callback (i.e. grab the lock before
>   first looking at modest_on_lid, only drop it once the modeset fixup has
>   been completed at the end of the function) we should be race-free in all
>   cases.
> 
>   Also, I think we should move the modeset_on_lid updates in the
>   suspend/resume paths to the very beginning/end.
> 
> Can you pls update your patch with these changes? Or do you see an
> additional race we need to plug somewhere?
> 
yep. will send out V2 soon.
thanks for your comments.

-rui

