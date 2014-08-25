Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbaHYIu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 04:50:29 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:35697 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbaHYIuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 04:50:25 -0400
Date: Mon, 25 Aug 2014 10:50:20 +0200
From: Vincent Donnefort <vdonnefort@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Bryan Wu <cooloney@gmail.com>, Hugh Dickins <hughd@google.com>,
        Valdis.Kletnieks@vt.edu,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] leds: make led_blink_set IRQ safe
Message-ID: <20140825085020.GA5071@ns3274321.ip-5-39-88.eu>
References: <alpine.LSU.2.11.1408161946450.1064@eggly.anvils>
 <1408453101-30290-1-git-send-email-vdonnefort@gmail.com>
 <1408453101-30290-2-git-send-email-vdonnefort@gmail.com>
 <alpine.LSU.2.11.1408191835200.3003@eggly.anvils>
 <CAK5ve-Kc8mjdbN0Nn-pGVjp2pj6ZV_FCBpeOtO5N92CkJZX3=g@mail.gmail.com>
 <20140823172456.GH13540@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140823172456.GH13540@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 23, 2014 at 01:24:56PM -0400, Tejun Heo wrote:
> Hello,
> 
> On Fri, Aug 22, 2014 at 05:21:30PM -0700, Bryan Wu wrote:
> > On Tue, Aug 19, 2014 at 6:51 PM, Hugh Dickins <hughd@google.com> wrote:
> > > On Tue, 19 Aug 2014, Vincent Donnefort wrote:
> > >
> > >> This patch introduces a work which take care of reseting the blink workqueue and
> > >> avoid calling the cancel_delayed_work_sync function which may sleep, from an IRQ
> > >> context.
> > >>
> > 
> > Vincent, I'm just wandering can we use cancel_delayed_work() instead
> > of sync version here.
> > cancel_delayed_work() can be called from IRQ context.
> 
> But it doesn't wait for the currently running one to finish.  It
> should wait, right?
> 

It should indeed wait. Using the cancel_delayed_work() function was my first
thought, however as described into the function header, when calling
cancel_delayed_work(), the work may be running and since it re-arms
itself, the next work may still be queued.

> > > May I (most ungratefully!) say that your patch doesn't fill me with
> > > confidence that it's the right solution: adding yet another work_struct
> > > to get around the issue seemed dubious to me, I wonder if it might expose
> > > new races.
> > 
> > I agree with Hugh about this new cancel work_struct. But if we revert
> > it back, I saw led_blink_set() will call del_timer_sync() which might
> > also sleep and can't be used in IRQ context. Looks like we can't call
> > led_blink_set() in any IRQ/atomic context.
> 
> del_timer_sync() doesn't block but it does run from bh.  It naturally
> can't be waited from an IRQ context.  It may be sitting on top of a
> running instance.
> 
> > > But rest assured that I know nothing about this, and I'm not at all
> > > qualified to review your patch: I hope Bryan and others will do so.
> > 
> > Let me invite Tejun to give some advice on how to solve this problem.
> > 
> > Tejun, Vincent's commit 8b37e1bef5a6b60e949e28a4db3006e4b00bd758
> > convert a timer into work_struct, but Hugh found it will cause
> > sleeping BUGs [1]. Could you give some opinion about that?
> 
> Not knowing the code base, I'm not sure how helpful I can be but if
> something wants to synchronize against another thing which can block,
> that something needs to be able to block too.  There's no way around
> it and it holds the same for timers.  As long as all the work items
> are properly shut down at the end, there's nothing wrong with using
> multiple of them even when they form a dependency chain.
> 
> Heh, I think I need more specific questions to be actually useful. :)
> 
> Thanks.
> 
> -- 
> tejun
