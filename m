Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab3JINzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 09:55:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515Ab3JINzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 09:55:21 -0400
Date: Wed, 9 Oct 2013 09:55:19 -0400
From: Don Zickus <dzickus@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, gleb@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] pvclock: detect watchdog reset at pvclock read
Message-ID: <20131009135519.GF227855@redhat.com>
References: <20131008010515.516032211@amt.cnet>
 <20131008010552.779616517@amt.cnet>
 <20131008133705.GR227855@redhat.com>
 <20131008220811.GC16625@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008220811.GC16625@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 07:08:11PM -0300, Marcelo Tosatti wrote:
> On Tue, Oct 08, 2013 at 09:37:05AM -0400, Don Zickus wrote:
> > On Mon, Oct 07, 2013 at 10:05:17PM -0300, Marcelo Tosatti wrote:
> > > Implement reset of kernel watchdogs at pvclock read time. This avoids
> > > adding special code to every watchdog.
> > > 
> > > This is possible for watchdogs which measure time based on sched_clock() or 
> > > ktime_get() variants.
> > > 
> > > Suggested by Don Zickus.
> > > 
> > > Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> > 
> > Awesome.  Thanks for figuring this out Marcelo.  Does that mean we can
> > revert commit 5d1c0f4a now? :-)
> 
> Unfortunately no: soft lockup watchdog does not measure time based on
> sched_clock but on hrtimer interrupt count :-(

I believe it does.  See __touch_watchdog() which calls get_timestamp() -->
local_clock().  That is how it calculates the duration of the softlockup.

Now with your patch, it just sets the timestamp to zero with
touch_softlockup_watchdog_sync(), which is fine.  It will just sync up the
clock, set a new timestamp, and check again in the next hrtimer interrupt.

So I guess I am confused what that commit does compared to this patch.

> (see the the softlockup code in question, perhaps you can point to 
> something that i'm missing).
> 
> BTW, are you OK with printing additional steal time information?
> https://lkml.org/lkml/2013/6/27/755

Well, I thought this patch was supposed to replace that patch?  Why do you
still need that patch?


Perhaps my confusion is centered around which softlockups are the problem
the VM's or the host's.

>From the host perspective, I didn't think you would have any problem
because the VM is just another process that runs in its time slice.

>From the VM perspective, the whole overcommit/'wait a couple of minutes to
run again', could easily cause lockups.  But I thought this patch set
detected that and touched the watchdogs early enough that when the next
iteration of the hrtimer came through, it would _not_ cause a softlockup
(it would delay it an hrtimer cycle).



So, if I am misunderstanding the problems (which I probably am :-) ), I
could use a pointer or a quick explaination to remind what the issues are
again and why you think the other patches are still necessary. :-)

Cheers,
Don
