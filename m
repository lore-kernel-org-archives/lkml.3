Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993AbaGKS4N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 14:56:13 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:60280 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbaGKS4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 14:56:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140711153541.GD17083@pd.tnic>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
	<1404925766-32253-2-git-send-email-hskinnemoen@google.com>
	<20140709191747.GB5249@pd.tnic>
	<CAFQmdRa5Spr0nX6qwzhDGEU9+H1_0vaCtF_NRV=p=OBDwin78A@mail.gmail.com>
	<20140710114222.GE2970@pd.tnic>
	<CAFQmdRZ1D4OWqkL-zpsiEjuGQaSBBmk36HqSw=q+hHNCRWZCKQ@mail.gmail.com>
	<CA+8MBbJ+FeQKZC9oVZsvrBptaY+24rVKWUXT02ETHMMoA-omuA@mail.gmail.com>
	<CAFQmdRY1=Yg7T15kQmiA+S0j1-xNKsF6Sze49BN7-VzbwW7V4w@mail.gmail.com>
	<20140711153541.GD17083@pd.tnic>
Date: Fri, 11 Jul 2014 11:56:11 -0700
Message-ID: <CAFQmdRajEjtGB4xXVzCmaUPA=qEjrzQTskJtpmD0cqKhKsEYsg@mail.gmail.com>
Subject: Re: [PATCH 1/6] x86-mce: Modify CMCI poll interval to adjust for
 small check_interval values.
From: Havard Skinnemoen <hskinnemoen@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Tony Luck <tony.luck@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ewout van Bekkum <ewout@google.com>,
        linux-edac <linux-edac@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 8:35 AM, Borislav Petkov <bp@alien8.de> wrote:
> So, with roughly few hundred CMCIs per second, we can be generous and
> say we can handle 100 CMCIs per second just fine. Which would mean, if
> the CMCI handler takes 10ms, with 100 CMCIs per second, we spend the
> whole time handling CMCIs. And we don't want that so we better poll.
> Those numbers are which tell us whether we should poll or not.
>
> But since we're very cautious, we go an order of magnitude up and say,
> if we get a second CMCI in under 100ms, we switch to polling. Or as Tony
> says, we switch to polling if we see a second CMCI in the same minute.
> Let's put the exact way of determining that aside for now.

So a short burst of CMCIs would send us instantly into polling mode,
which would probably be suboptimal if things are quiet after that.
Counting is a lot more robust against this.

> Then, we start polling. We poll every min interval, say 10ms for, say,
> a second. We do this relatively long so that we save us unnecessary
> ping-ponging between CMCI and poll.
>
> If during that second we have seen errors, we extend the polling
> interval by another second. And so on...

If we see two errors every 2 seconds (for example due to a bug causing
us to see duplicate MCEs), we'd ping-pong back and forth between CMCI
and polling mode on every error, polling 51 times per second on
average. This seems a lot more expensive than just staying in CMCI
mode. And we risk losing information if there are instead, say, 4
errors every 2 seconds.

> After a second where we haven't seen any errors, we switch back to CMCI.
> check_interval relaxes back to 5 min and all gets to its normal boring
> existence. Otherwise, we enter storm mode quickly again.

Since the storm detection is now independent of check_interval, we
don't need to place any restrictions on it right?

> This way we change the heuristic when we switch to storm mode from based
> on the number of CMCIs per interval to closeness of occurrence of CMCIs.
> They're similar but the second method will get us in storm mode pretty
> quickly and get us polling.
>
> The more important follow up from this is that if we can decide upon
>
> * duration of CMCI, i.e. the 10ms above
>
> * max number of CMCIs per second a system can sustain fine, i.e. the 100
> above

What's the definition of "fine"? 1% performance hit? 10%? How can we
make that decision without knowing how hard the users are pushing
their systems?

> * total polling duration during storm, i.e. the 1 second above
>
> and if those are chosen generously for every system out there, then we
> don't need to dynamically adjust the polling interval.

I'm not sure how we can be generous when there's a tradeoff involved.
If we make the interval "generously low", we end up hurting
performance. if we make it "generously high", we'll lose information.

> Basically the scheme becomes the following:
>
> * We switch to polling if we detect a second CMCI under an interval X
> * We poll Y times, each polling with a duration Z.
> * If during those Y*Z msec of polling, we've encountered errors, we
> enlarge the polling interval to additional Y*Z msec.
>
>
> check_interval will be capped on the low end to something bigger than
> the polling duration Y*Z and only the storm detection code will be
> allowed to go to lower intervals and switch to polling.
>
> At least something like that. In general, I'd like to make it more
> robust for every system without the need for user interaction, i.e.
> adjusting check_interval and where it just works.

But at the same time, this scheme introduces even more variables that
need careful tuning, e.g. storm polling interval and storm duration,
while not really doing anything to make check_interval superfluous. Do
you really think we can tune these variables correctly for every
system out there?

Or if we want to be generous: How about we just hardcode
check_interval to 5 seconds. Would that be fine with everyone?

> I don't know whether any of the above makes sense - I hope that the
> gist of it at least shows what IO think we should be doing: instead
> of letting users configure the check_interval and influence the CMCI
> polling interval, we should rely purely on machine characteristics to
> set minimum values under which we poll and above which, we do the normal
> duration enlarging dance.

I think the scheme may work, although I'm worried about the burstiness
mentioned above.

But I don't really buy that pulling a handful of numbers out of thin
air and saying it should work for everyone is going to work. Either we
need solid data to back up those numbers, or we need to make them
configurable so people can experiment and find what works best for
them.

Havard
