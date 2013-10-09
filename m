Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab3JIV0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 17:26:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986Ab3JIV0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 17:26:47 -0400
Date: Wed, 9 Oct 2013 18:26:33 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, gleb@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] pvclock: detect watchdog reset at pvclock read
Message-ID: <20131009212633.GB24695@amt.cnet>
References: <20131008010515.516032211@amt.cnet>
 <20131008010552.779616517@amt.cnet>
 <20131008133705.GR227855@redhat.com>
 <20131008220811.GC16625@amt.cnet>
 <20131009135519.GF227855@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009135519.GF227855@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 09:55:19AM -0400, Don Zickus wrote:
> On Tue, Oct 08, 2013 at 07:08:11PM -0300, Marcelo Tosatti wrote:
> > On Tue, Oct 08, 2013 at 09:37:05AM -0400, Don Zickus wrote:
> > > On Mon, Oct 07, 2013 at 10:05:17PM -0300, Marcelo Tosatti wrote:
> > > > Implement reset of kernel watchdogs at pvclock read time. This avoids
> > > > adding special code to every watchdog.
> > > > 
> > > > This is possible for watchdogs which measure time based on sched_clock() or 
> > > > ktime_get() variants.
> > > > 
> > > > Suggested by Don Zickus.
> > > > 
> > > > Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> > > 
> > > Awesome.  Thanks for figuring this out Marcelo.  Does that mean we can
> > > revert commit 5d1c0f4a now? :-)
> > 
> > Unfortunately no: soft lockup watchdog does not measure time based on
> > sched_clock but on hrtimer interrupt count :-(
> 
> I believe it does.  See __touch_watchdog() which calls get_timestamp() -->
> local_clock().  That is how it calculates the duration of the softlockup.
> 
> Now with your patch, it just sets the timestamp to zero with
> touch_softlockup_watchdog_sync(), which is fine.  It will just sync up the
> clock, set a new timestamp, and check again in the next hrtimer interrupt.
> 
> So I guess I am confused what that commit does compared to this patch.
> 
> > (see the the softlockup code in question, perhaps you can point to 
> > something that i'm missing).
> > 
> > BTW, are you OK with printing additional steal time information?
> > https://lkml.org/lkml/2013/6/27/755
> 
> Well, I thought this patch was supposed to replace that patch?  Why do you
> still need that patch?

>From https://lkml.org/lkml/2013/7/3/675:

"Agree. However, can't see how there is a way around "having custom
kvm/paravirt splat all over", for watchdogs that do:

1. check for watchdog resets
2. read time via sched_clock or xtime.
3. based on 2, decide whether there has been a longer delay than
acceptable.

This is the case for the softlockup timer interrupt. So the splat there
is necessary (otherwise any potential notification of vm-pause event 
noticed at 2 might be missed because its checked at 1).

For watchdogs that measure time based on interrupt event (such as hung
task, rcu_cpu_stall, checking for the notification at sched_clock or
lower is fine)."

