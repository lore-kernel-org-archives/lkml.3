Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbaGKUKZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 16:10:25 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50598 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313AbaGKUKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 16:10:23 -0400
Date: Fri, 11 Jul 2014 22:10:12 +0200
From: Borislav Petkov <bp@alien8.de>
To: Havard Skinnemoen <hskinnemoen@google.com>
Cc: Tony Luck <tony.luck@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ewout van Bekkum <ewout@google.com>,
        linux-edac <linux-edac@vger.kernel.org>
Subject: Re: [PATCH 1/6] x86-mce: Modify CMCI poll interval to adjust for
 small check_interval values.
Message-ID: <20140711201012.GB18246@pd.tnic>
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

I'm going to reply with multiple mails so that we can keep the things
separate and not let replies grow out of proportion.

On Fri, Jul 11, 2014 at 11:56:11AM -0700, Havard Skinnemoen wrote:
> So a short burst of CMCIs would send us instantly into polling mode,
> which would probably be suboptimal if things are quiet after that.
> Counting is a lot more robust against this.

Yes, but CMCI_STORM_THRESHOLD is arbitrary too. How is getting 15 CMCIs
per second an interrupt storm? Apparently boxes can handle couple of
hundred CMCIs per second just fine...

> If we see two errors every 2 seconds (for example due to a bug causing
> us to see duplicate MCEs), we'd ping-pong back and forth between CMCI
> and polling mode on every error, polling 51 times per second on
> average. This seems a lot more expensive than just staying in CMCI
> mode. And we risk losing information if there are instead, say, 4
> errors every 2 seconds.
> 
> > After a second where we haven't seen any errors, we switch back to CMCI.
> > check_interval relaxes back to 5 min and all gets to its normal boring
> > existence. Otherwise, we enter storm mode quickly again.
> 
> Since the storm detection is now independent of check_interval, we
> don't need to place any restrictions on it right?

Ok, so my initial storm detection was dumb, ok. Counting the way we do
it now is purely sucked out of thin air too.

Instead, the criteria should probably be something like: what is the
number of CMCIs per second which we can process while leaving system
operation relatively unaffected? Anything above that number constitutes
a CMCI storm.

Now, how we'll come up with an answer to that question is a whole
another story...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
