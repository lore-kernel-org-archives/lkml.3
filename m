Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908AbaGNO50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:57:26 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36667 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755689AbaGNO5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:57:18 -0400
Date: Mon, 14 Jul 2014 16:57:01 +0200
From: Borislav Petkov <bp@alien8.de>
To: Havard Skinnemoen <hskinnemoen@google.com>
Cc: Tony Luck <tony.luck@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ewout van Bekkum <ewout@google.com>,
        linux-edac <linux-edac@vger.kernel.org>
Subject: Re: [PATCH 1/6] x86-mce: Modify CMCI poll interval to adjust for
 small check_interval values.
Message-ID: <20140714145701.GC25115@pd.tnic>
References: <20140709191747.GB5249@pd.tnic>
 <CAFQmdRa5Spr0nX6qwzhDGEU9+H1_0vaCtF_NRV=p=OBDwin78A@mail.gmail.com>
 <20140710114222.GE2970@pd.tnic>
 <CAFQmdRZ1D4OWqkL-zpsiEjuGQaSBBmk36HqSw=q+hHNCRWZCKQ@mail.gmail.com>
 <CA+8MBbJ+FeQKZC9oVZsvrBptaY+24rVKWUXT02ETHMMoA-omuA@mail.gmail.com>
 <CAFQmdRY1=Yg7T15kQmiA+S0j1-xNKsF6Sze49BN7-VzbwW7V4w@mail.gmail.com>
 <20140711153541.GD17083@pd.tnic>
 <CAFQmdRajEjtGB4xXVzCmaUPA=qEjrzQTskJtpmD0cqKhKsEYsg@mail.gmail.com>
 <20140711201012.GB18246@pd.tnic>
 <CAFQmdRbpVfNjvyOPHo7RZ+W=2FTA6fEw2hWBebKNBX8LMPYfeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAFQmdRbpVfNjvyOPHo7RZ+W=2FTA6fEw2hWBebKNBX8LMPYfeQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 01:39:19PM -0700, Havard Skinnemoen wrote:
> Sorry, I was being unclear. I was actually arguing the opposite:
> Getting 15 CMCIs per second is fine and shouldn't cause any switch to
> polling mode, especially if the polling will happen at 100 times per
> second. But your proposal would switch to polling if we ever see 2
> CMCIs within a period, which seems way too trigger-happy, even if the
> period is short.
>
> I do agree there are already a lot of arbitrary numbers in the code.

Yes, triggerhappy is no good either.

The thing is, even if we would come up with a correct number now, who's
to say that that same number would be correct on future uarches? I like
the idea of approximating storm entry point on each system and I, like
you, worry about complexity. This needs to be done really conservatively
and without rushing...

Thankfully, this thread has some nice starting ideas. :)

> > Instead, the criteria should probably be something like: what is the
> > number of CMCIs per second which we can process while leaving system
> > operation relatively unaffected? Anything above that number constitutes
> > a CMCI storm.
> 
> That sounds good to me. But now you're talking about CMCIs per second,
> which seems to imply some form of counting right?

<thinking out loud>

Well, I was thinking of measuring the average duration of the CMCI
interrupt handler (which basically is machine_check_poll) and then maybe
allowing x% of that per second. Any higher count above x% switches to
storm.

So we'll probably end up counting again but CMCI_STORM_THRESHOLD will be
determined dynamically by doing:

	CMCI_STORM_THRESHOLD = (1000ms / average duration of CMCI in ms) * x%

Then, making that x user-configurable would probably be fine too. It'll
basically allow users to say what percentage of time they'd want the
system to spend handling CMCIs before polling.

And, it'll have a sane, conservative default for the majority of people
who don't want to deal with this at all.

The usual conserns about exporting stuff to userspace apply, see below.

</thinking out loud>

> > Now, how we'll come up with an answer to that question is a whole
> > another story...
> 
> Right. If we can come up with an answer, that's great, but if we
> don't, I think we're better off exporting a nice knob and letting the
> user tune his system according to his needs.

Yeah, just remember that exporting all kinds of knobs means we're forced
to support it forever. So I'm very cautious with exposing anything to
userspace as it becomes an API and we're stuck with it.

> Just to throw another number out, how about doing CMCI storm polling
> at a fixed interval of 100 ms? Since check_interval is an integer
> representing a number of seconds, it can never get lower than 10x this
> number, so we won't need to restrict it any further.

Yep, this is basically the approach where we do find a static number
default for all machines out there. It could be a temporary solution ...

> If we see more than X CMCIs in a second, we switch to polling. If less
> than Y out of 10 polls see an error, we switch back to CMCI.
> 
> Now, we still leave 3 magic numbers to be figured out...but I think
> their range is somewhat more limited.

Makes sense.

So X will always be < 10, (== 10 means we automatically switch to
polling).

The Y could contain a historic aspect by setting it to some value and
decrementing it by one if we haven't seen an error and incrementing it
if we saw an error during the last poll. It will saturate at Y errors
and when it reaches 0, it will switch back to CMCI.

Hrrm, sounds interesting :)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
