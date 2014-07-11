Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbaGKUjY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 16:39:24 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:45026 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900AbaGKUjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 16:39:20 -0400
MIME-Version: 1.0
In-Reply-To: <20140711201012.GB18246@pd.tnic>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
	<1404925766-32253-2-git-send-email-hskinnemoen@google.com>
	<20140709191747.GB5249@pd.tnic>
	<CAFQmdRa5Spr0nX6qwzhDGEU9+H1_0vaCtF_NRV=p=OBDwin78A@mail.gmail.com>
	<20140710114222.GE2970@pd.tnic>
	<CAFQmdRZ1D4OWqkL-zpsiEjuGQaSBBmk36HqSw=q+hHNCRWZCKQ@mail.gmail.com>
	<CA+8MBbJ+FeQKZC9oVZsvrBptaY+24rVKWUXT02ETHMMoA-omuA@mail.gmail.com>
	<CAFQmdRY1=Yg7T15kQmiA+S0j1-xNKsF6Sze49BN7-VzbwW7V4w@mail.gmail.com>
	<20140711153541.GD17083@pd.tnic>
	<CAFQmdRajEjtGB4xXVzCmaUPA=qEjrzQTskJtpmD0cqKhKsEYsg@mail.gmail.com>
	<20140711201012.GB18246@pd.tnic>
Date: Fri, 11 Jul 2014 13:39:19 -0700
Message-ID: <CAFQmdRbpVfNjvyOPHo7RZ+W=2FTA6fEw2hWBebKNBX8LMPYfeQ@mail.gmail.com>
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

On Fri, Jul 11, 2014 at 1:10 PM, Borislav Petkov <bp@alien8.de> wrote:
> I'm going to reply with multiple mails so that we can keep the things
> separate and not let replies grow out of proportion.
>
> On Fri, Jul 11, 2014 at 11:56:11AM -0700, Havard Skinnemoen wrote:
>> So a short burst of CMCIs would send us instantly into polling mode,
>> which would probably be suboptimal if things are quiet after that.
>> Counting is a lot more robust against this.
>
> Yes, but CMCI_STORM_THRESHOLD is arbitrary too. How is getting 15 CMCIs
> per second an interrupt storm? Apparently boxes can handle couple of
> hundred CMCIs per second just fine...

Sorry, I was being unclear. I was actually arguing the opposite:
Getting 15 CMCIs per second is fine and shouldn't cause any switch to
polling mode, especially if the polling will happen at 100 times per
second. But your proposal would switch to polling if we ever see 2
CMCIs within a period, which seems way too trigger-happy, even if the
period is short.

I do agree there are already a lot of arbitrary numbers in the code.

>> If we see two errors every 2 seconds (for example due to a bug causing
>> us to see duplicate MCEs), we'd ping-pong back and forth between CMCI
>> and polling mode on every error, polling 51 times per second on
>> average. This seems a lot more expensive than just staying in CMCI
>> mode. And we risk losing information if there are instead, say, 4
>> errors every 2 seconds.
>>
>> > After a second where we haven't seen any errors, we switch back to CMCI.
>> > check_interval relaxes back to 5 min and all gets to its normal boring
>> > existence. Otherwise, we enter storm mode quickly again.
>>
>> Since the storm detection is now independent of check_interval, we
>> don't need to place any restrictions on it right?
>
> Ok, so my initial storm detection was dumb, ok. Counting the way we do
> it now is purely sucked out of thin air too.
>
> Instead, the criteria should probably be something like: what is the
> number of CMCIs per second which we can process while leaving system
> operation relatively unaffected? Anything above that number constitutes
> a CMCI storm.

That sounds good to me. But now you're talking about CMCIs per second,
which seems to imply some form of counting right?

> Now, how we'll come up with an answer to that question is a whole
> another story...

Right. If we can come up with an answer, that's great, but if we
don't, I think we're better off exporting a nice knob and letting the
user tune his system according to his needs.

Just to throw another number out, how about doing CMCI storm polling
at a fixed interval of 100 ms? Since check_interval is an integer
representing a number of seconds, it can never get lower than 10x this
number, so we won't need to restrict it any further.

If we see more than X CMCIs in a second, we switch to polling. If less
than Y out of 10 polls see an error, we switch back to CMCI.

Now, we still leave 3 magic numbers to be figured out...but I think
their range is somewhat more limited.

Havard
