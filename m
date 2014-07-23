Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbaGWGtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 02:49:55 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46668 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362AbaGWGty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 02:49:54 -0400
Date: Wed, 23 Jul 2014 08:49:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Random panic in load_balance() with 3.16-rc
Message-ID: <20140723064948.GK3935@laptop>
References: <53C77BB8.6030804@daenzer.net>
 <20140717075820.GE19379@twins.programming.kicks-ass.net>
 <53C8E90F.1010306@daenzer.net>
 <53CE00EF.70108@daenzer.net>
 <53CF31AE.30403@daenzer.net>
 <CA+55aFwyURgG717kmuAXzKcHddN_63GirtwHZB4ePKH+8qVtJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFwyURgG717kmuAXzKcHddN_63GirtwHZB4ePKH+8qVtJw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 09:21:40PM -0700, Linus Torvalds wrote:
> On Tue, Jul 22, 2014 at 8:53 PM, Michel Dänzer <michel@daenzer.net> wrote:
> >
> > Just happened again with the same change on top of 3.16-rc6.
> 
> The (maybe) related bugzilla entry is just odd. Bruno Wolff reports
> that the BUG_ON() in his added patch triggers:
> 
> +               cpumask_clear(sched_group_cpus(sg));
> +               sg->sgc->capacity = 0;
> +               BUG_ON(!cpumask_empty(sched_group_cpus(sg)));
> 
> where it *just* did a cpumask_clear(), and now the BUG_ON() triggers
> that it's no longer empty?
> 
> That would imply an allocation error, but all the sched groups seem to
> be properly allocated with the proper addition of cpumask_size().
> 
> And his config file even has NR_CPUS being 32, so it should be a
> single word of bitmap, which triggers all the simple code.
> 
> Completely insane, in other words.

So we've had this other thread where the same happened:

 lkml.kernel.org/r/20140716145546.GA6922@wolff.to

(pointed Michel to that earlier)

And that seems to be sorted now (just found positive feedback in my
Inbox this morning), it was a question of the arch code supplying
completely 'broken' topology information, and the scheduler trusting it
too much.

The real fix in that thread is:

 lkml.kernel.org/r/20140722133514.GM12054@laptop.lan

And I'll also add this to make the scheduler less trusting:

 lkml.kernel.org/r/20140722094740.GJ12054@laptop.lan

Michael, that's not going to tell us what's wrong with your machine, as
you've not got the ancient dual P4 Xeon Bruno's got. Seeing how your
cpuinfo says:

model name      : AMD A10-7850K Radeon R7, 12 Compute Cores 4C+8G

but we can start the same debugging session I suppose.

Could you run with this patch on top:

 lkml.kernel.org/r/20140718101633.GP9918@twins.programming.kicks-ass.net

And provide us with the dmesg after boot?
