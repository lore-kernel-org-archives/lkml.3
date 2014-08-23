Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbaHWRZE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 13:25:04 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:45779 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbaHWRZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 13:25:00 -0400
Date: Sat, 23 Aug 2014 13:24:56 -0400
From: Tejun Heo <tj@kernel.org>
To: Bryan Wu <cooloney@gmail.com>
Cc: Hugh Dickins <hughd@google.com>, Vincent Donnefort <vdonnefort@gmail.com>,
        Valdis.Kletnieks@vt.edu,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] leds: make led_blink_set IRQ safe
Message-ID: <20140823172456.GH13540@mtj.dyndns.org>
References: <alpine.LSU.2.11.1408161946450.1064@eggly.anvils>
 <1408453101-30290-1-git-send-email-vdonnefort@gmail.com>
 <1408453101-30290-2-git-send-email-vdonnefort@gmail.com>
 <alpine.LSU.2.11.1408191835200.3003@eggly.anvils>
 <CAK5ve-Kc8mjdbN0Nn-pGVjp2pj6ZV_FCBpeOtO5N92CkJZX3=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK5ve-Kc8mjdbN0Nn-pGVjp2pj6ZV_FCBpeOtO5N92CkJZX3=g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Aug 22, 2014 at 05:21:30PM -0700, Bryan Wu wrote:
> On Tue, Aug 19, 2014 at 6:51 PM, Hugh Dickins <hughd@google.com> wrote:
> > On Tue, 19 Aug 2014, Vincent Donnefort wrote:
> >
> >> This patch introduces a work which take care of reseting the blink workqueue and
> >> avoid calling the cancel_delayed_work_sync function which may sleep, from an IRQ
> >> context.
> >>
> 
> Vincent, I'm just wandering can we use cancel_delayed_work() instead
> of sync version here.
> cancel_delayed_work() can be called from IRQ context.

But it doesn't wait for the currently running one to finish.  It
should wait, right?

> > May I (most ungratefully!) say that your patch doesn't fill me with
> > confidence that it's the right solution: adding yet another work_struct
> > to get around the issue seemed dubious to me, I wonder if it might expose
> > new races.
> 
> I agree with Hugh about this new cancel work_struct. But if we revert
> it back, I saw led_blink_set() will call del_timer_sync() which might
> also sleep and can't be used in IRQ context. Looks like we can't call
> led_blink_set() in any IRQ/atomic context.

del_timer_sync() doesn't block but it does run from bh.  It naturally
can't be waited from an IRQ context.  It may be sitting on top of a
running instance.

> > But rest assured that I know nothing about this, and I'm not at all
> > qualified to review your patch: I hope Bryan and others will do so.
> 
> Let me invite Tejun to give some advice on how to solve this problem.
> 
> Tejun, Vincent's commit 8b37e1bef5a6b60e949e28a4db3006e4b00bd758
> convert a timer into work_struct, but Hugh found it will cause
> sleeping BUGs [1]. Could you give some opinion about that?

Not knowing the code base, I'm not sure how helpful I can be but if
something wants to synchronize against another thing which can block,
that something needs to be able to block too.  There's no way around
it and it holds the same for timers.  As long as all the work items
are properly shut down at the end, there's nothing wrong with using
multiple of them even when they form a dependency chain.

Heh, I think I need more specific questions to be actually useful. :)

Thanks.

-- 
tejun
