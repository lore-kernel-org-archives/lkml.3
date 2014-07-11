Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbaGKPfx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 11:35:53 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42535 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902AbaGKPfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 11:35:52 -0400
Date: Fri, 11 Jul 2014 17:35:41 +0200
From: Borislav Petkov <bp@alien8.de>
To: Havard Skinnemoen <hskinnemoen@google.com>,
        Tony Luck <tony.luck@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Ewout van Bekkum <ewout@google.com>,
        linux-edac <linux-edac@vger.kernel.org>
Subject: Re: [PATCH 1/6] x86-mce: Modify CMCI poll interval to adjust for
 small check_interval values.
Message-ID: <20140711153541.GD17083@pd.tnic>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
 <1404925766-32253-2-git-send-email-hskinnemoen@google.com>
 <20140709191747.GB5249@pd.tnic>
 <CAFQmdRa5Spr0nX6qwzhDGEU9+H1_0vaCtF_NRV=p=OBDwin78A@mail.gmail.com>
 <20140710114222.GE2970@pd.tnic>
 <CAFQmdRZ1D4OWqkL-zpsiEjuGQaSBBmk36HqSw=q+hHNCRWZCKQ@mail.gmail.com>
 <CA+8MBbJ+FeQKZC9oVZsvrBptaY+24rVKWUXT02ETHMMoA-omuA@mail.gmail.com>
 <CAFQmdRY1=Yg7T15kQmiA+S0j1-xNKsF6Sze49BN7-VzbwW7V4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAFQmdRY1=Yg7T15kQmiA+S0j1-xNKsF6Sze49BN7-VzbwW7V4w@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 03:45:22PM -0700, Havard Skinnemoen wrote:
> I'm not arguing that's a _sensible_ value, just that there's no point
> in seting it to anything lower than that.

Ok,

right now, during the CMCI interrupt, we increment the count of how
many times we fire. If during one CMCI_STORM_INTERVAL we fire more than
CMCI_STORM_THRESHOLD times, we declare storm.

And this is count-based and does not necessarily mean that with more
than CMCI_STORM_THRESHOLD CMCIs, we can't continue using CMCI instead of
switching to polling.

An IRQ->POLL switch, however, is normally done because the interrupt
fires too often and with an overhead where we just as well can simply
poll.

So how about we change the whole scheme a bit, maybe even simplify it in
the process:

So, with roughly few hundred CMCIs per second, we can be generous and
say we can handle 100 CMCIs per second just fine. Which would mean, if
the CMCI handler takes 10ms, with 100 CMCIs per second, we spend the
whole time handling CMCIs. And we don't want that so we better poll.
Those numbers are which tell us whether we should poll or not.

But since we're very cautious, we go an order of magnitude up and say,
if we get a second CMCI in under 100ms, we switch to polling. Or as Tony
says, we switch to polling if we see a second CMCI in the same minute.
Let's put the exact way of determining that aside for now.

Then, we start polling. We poll every min interval, say 10ms for, say,
a second. We do this relatively long so that we save us unnecessary
ping-ponging between CMCI and poll.

If during that second we have seen errors, we extend the polling
interval by another second. And so on...

After a second where we haven't seen any errors, we switch back to CMCI.
check_interval relaxes back to 5 min and all gets to its normal boring
existence. Otherwise, we enter storm mode quickly again.

This way we change the heuristic when we switch to storm mode from based
on the number of CMCIs per interval to closeness of occurrence of CMCIs.
They're similar but the second method will get us in storm mode pretty
quickly and get us polling.

The more important follow up from this is that if we can decide upon

* duration of CMCI, i.e. the 10ms above

* max number of CMCIs per second a system can sustain fine, i.e. the 100
above

* total polling duration during storm, i.e. the 1 second above

and if those are chosen generously for every system out there, then we
don't need to dynamically adjust the polling interval.

Basically the scheme becomes the following:

* We switch to polling if we detect a second CMCI under an interval X
* We poll Y times, each polling with a duration Z.
* If during those Y*Z msec of polling, we've encountered errors, we
enlarge the polling interval to additional Y*Z msec.


check_interval will be capped on the low end to something bigger than
the polling duration Y*Z and only the storm detection code will be
allowed to go to lower intervals and switch to polling.

At least something like that. In general, I'd like to make it more
robust for every system without the need for user interaction, i.e.
adjusting check_interval and where it just works.

I don't know whether any of the above makes sense - I hope that the
gist of it at least shows what IO think we should be doing: instead
of letting users configure the check_interval and influence the CMCI
polling interval, we should rely purely on machine characteristics to
set minimum values under which we poll and above which, we do the normal
duration enlarging dance.

So, flame away... :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
