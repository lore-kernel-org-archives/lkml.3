Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761801Ab3JPSWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:22:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761310Ab3JPSWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 14:22:13 -0400
Date: Wed, 16 Oct 2013 14:22:09 -0400
From: Don Zickus <dzickus@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, gleb@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] pvclock: detect watchdog reset at pvclock read
Message-ID: <20131016182209.GI227855@redhat.com>
References: <20131008010515.516032211@amt.cnet>
 <20131008010552.779616517@amt.cnet>
 <20131008133705.GR227855@redhat.com>
 <20131008220811.GC16625@amt.cnet>
 <20131009135519.GF227855@redhat.com>
 <20131009212633.GB24695@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009212633.GB24695@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 06:26:33PM -0300, Marcelo Tosatti wrote:
> From https://lkml.org/lkml/2013/7/3/675:
> 
> "Agree. However, can't see how there is a way around "having custom
> kvm/paravirt splat all over", for watchdogs that do:
> 
> 1. check for watchdog resets
> 2. read time via sched_clock or xtime.
> 3. based on 2, decide whether there has been a longer delay than
> acceptable.
> 
> This is the case for the softlockup timer interrupt. So the splat there
> is necessary (otherwise any potential notification of vm-pause event 
> noticed at 2 might be missed because its checked at 1).
> 
> For watchdogs that measure time based on interrupt event (such as hung
> task, rcu_cpu_stall, checking for the notification at sched_clock or
> lower is fine)."
> 

Sorry for the delay, I was trying to spend time understanding the problem
again.  Rik van Riel helped me (as I could just walk over to him).

I was trying to figure out if there was a way to convert the softlockup to
something more virt-friendly mechanism.  I was toying with the idea of
having the softlockup use schedule_timeout and then have the
touch_softlockup routine keep rescheduling (delay) the timeout.  The idea
was that if it actually timed out, it was guaranteed to be a lockup.  This
removed the need for the duration calculation but more importantly, I
believe the schedule_timeout routine was guest time aware.

But I haven't had the chance to think through the whole thing to know if
that was the right way to go or if there was pitfalls.  Just busy with
other stuff.

Regardless, I think this patchset solves a particular problem and I am ok
with it (even v2 I believe).

Cheers,
Don

