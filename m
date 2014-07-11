Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbaGKUWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 16:22:20 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46793 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755172AbaGKUWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 16:22:18 -0400
Date: Fri, 11 Jul 2014 22:22:07 +0200
From: Borislav Petkov <bp@alien8.de>
To: Havard Skinnemoen <hskinnemoen@google.com>
Cc: Tony Luck <tony.luck@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ewout van Bekkum <ewout@google.com>,
        linux-edac <linux-edac@vger.kernel.org>
Subject: Re: [PATCH 1/6] x86-mce: Modify CMCI poll interval to adjust for
 small check_interval values.
Message-ID: <20140711202207.GC18246@pd.tnic>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAFQmdRajEjtGB4xXVzCmaUPA=qEjrzQTskJtpmD0cqKhKsEYsg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 11:56:11AM -0700, Havard Skinnemoen wrote:
> > * max number of CMCIs per second a system can sustain fine, i.e. the 100
> > above
> 
> What's the definition of "fine"? 1% performance hit? 10%? How can we
> make that decision without knowing how hard the users are pushing
> their systems?

Those are definitely unchartered territories we're moving into so yes,
answering that won't be easy.

Let's try it: if the anount of time we spend per second in the CMCI
handler becomes higher than the amount of time we spend polling for that
same second, then we might just as well poll and save us the interrupt
load.

So, for example, say for 10ms poll rate and single poll duration of
2ms, if time spent in CMCI exceeds 200ms for that second, we switch to
polling. Hypothetical numbers, of course.

Can we measure it on every system? Probably not. So we need to
approximate it somehow.

> 
> > * total polling duration during storm, i.e. the 1 second above
> >
> > and if those are chosen generously for every system out there, then we
> > don't need to dynamically adjust the polling interval.
> 
> I'm not sure how we can be generous when there's a tradeoff involved.
> If we make the interval "generously low", we end up hurting
> performance. if we make it "generously high", we'll lose information.

Yeah, by "generous" I meant, choose values which fit all. But I realize
now that this is a dumb idea. Maybe we could measure it on each system,
read the TSC on CMCI entry and exit and thus get an average CMCI
duration...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
