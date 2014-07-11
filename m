Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbaGKUgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 16:36:20 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58327 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040AbaGKUgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 16:36:19 -0400
Date: Fri, 11 Jul 2014 22:36:07 +0200
From: Borislav Petkov <bp@alien8.de>
To: Havard Skinnemoen <hskinnemoen@google.com>
Cc: Tony Luck <tony.luck@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ewout van Bekkum <ewout@google.com>,
        linux-edac <linux-edac@vger.kernel.org>
Subject: Re: [PATCH 1/6] x86-mce: Modify CMCI poll interval to adjust for
 small check_interval values.
Message-ID: <20140711203607.GD18246@pd.tnic>
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
> > Basically the scheme becomes the following:
> >
> > * We switch to polling if we detect a second CMCI under an interval X
> > * We poll Y times, each polling with a duration Z.
> > * If during those Y*Z msec of polling, we've encountered errors, we
> > enlarge the polling interval to additional Y*Z msec.
> >
> >
> > check_interval will be capped on the low end to something bigger than
> > the polling duration Y*Z and only the storm detection code will be
> > allowed to go to lower intervals and switch to polling.
> >
> > At least something like that. In general, I'd like to make it more
> > robust for every system without the need for user interaction, i.e.
> > adjusting check_interval and where it just works.
> 
> But at the same time, this scheme introduces even more variables that
> need careful tuning, e.g. storm polling interval and storm duration,
> while not really doing anything to make check_interval superfluous. Do

Oh, we can't make check_interval superfluous - it is API to userspace
for a long time now.

> you really think we can tune these variables correctly for every
> system out there?

Right, I was trying to figure out a scheme first where polling intervals
and thresholds would actually make sense and not be arbitrary.

We probably won't be able to have the exact values for each system but a
smart approximation could do the job nicely enough.

> Or if we want to be generous: How about we just hardcode
> check_interval to 5 seconds. Would that be fine with everyone?

We could but again, it is an API to userspace exported through sysfs.

Besides, on a healthy system, you see errors so seldomly that 5sec is
pure waste of energy.

> > I don't know whether any of the above makes sense - I hope that the
> > gist of it at least shows what IO think we should be doing: instead
> > of letting users configure the check_interval and influence the CMCI
> > polling interval, we should rely purely on machine characteristics to
> > set minimum values under which we poll and above which, we do the normal
> > duration enlarging dance.
> 
> I think the scheme may work, although I'm worried about the burstiness
> mentioned above.
>
> But I don't really buy that pulling a handful of numbers out of thin
> air and saying it should work for everyone is going to work.

No no, absolutely not. This is exactly what I think should be fixed as
the current numbers are likely pulled out of thin air. Simply because
figuring the optimal ones is a very hard task, as we come to realize.

> Either we need solid data to back up those numbers, or we need to make
> them configurable so people can experiment and find what works best
> for them.

..., or, we could measure them on each system and approximate them to
the ones close to optimal for that particular system, over the course of
its runtime.

Thanks for taking the time and humouring me with that crazy
brainstorming!

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
