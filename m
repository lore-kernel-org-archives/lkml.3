Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbaKFSsv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 13:48:51 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:44605 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbaKFSst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 13:48:49 -0500
Date: Thu, 6 Nov 2014 10:48:43 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Alexander Graf <agraf@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Heiko Stuebner <heiko@sntech.de>, Lee Jones <lee.jones@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH v5 00/48] kernel: Add support for power-off handler call
 chain
Message-ID: <20141106184843.GA31712@roeck-us.net>
References: <1415292213-28652-1-git-send-email-linux@roeck-us.net>
 <20141106170818.GA30177@roeck-us.net>
 <CA+55aFxMu_MTfXd-EFG=QJ6aCWpb+OX5tyM-XWZC=WHJ=pFiTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxMu_MTfXd-EFG=QJ6aCWpb+OX5tyM-XWZC=WHJ=pFiTA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020208.545BC291.007E,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 2
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 10:02:54AM -0800, Linus Torvalds wrote:
> On Thu, Nov 6, 2014 at 9:08 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> >>
> >> Merge plan is to send the entire series directly to Linus during the next commit
> >> window, except for the last patch. The last patch would then be part of another
> >> pull request after -rc1, which would include any changes necessary due to newly
> >> merged power-off handling code.
> >
> > I should have added that I plan to have the series (except for the last patch)
> > added to -next shortly.
> >
> > Linus,
> >
> > are you ok with this plan ?
> 
> Do people actually agree that the code makes sense at all?
> 
The series has Acks from 24 different people, so I would think
that there is a decent level of agreement.

> Because quite frankly, every time somebody adds this kind of "register
> callback" stuff, the end result tends to end up being an unmitigated
> disaster. People care about ordering etc, and there seems to be no
> sane support for that. Then people do random ugly hacks for their
> insane platforms. You already did that by having the "priority" thing,
> but that just makes me think that people will pick random priorities.
> TYou seem to even *encourage* that random behavior by spreading out
> the "named" priorities, so that people can randomly say "I'm one
> higher than LOW".
> 
Yes, that is actually the idea. Keep in mind this is for power-off, so
(hopefully) only the handler with highest priority will actually be executed.
The larger number space is an added benefit here, not a disadvantage -
I _want_ people to be able to say "my priority is one higher than X because
I _want_ this method to power off the system to be tried first".

> What kind of games are the actual new users already doing wrt this? I
> have a bad feeling about it all.

Currently there is a single exported pointer, "pm_power_off", which is set
by architecture code and various drivers, and called from machine_power_off
to turn off power. 'git grep "pm_power_off =" | wc' returns 146, so there
are a lot of those. In linux-next the number is 150, so there are now four
more (all in drivers if I recall correctly). A patch pending for powerpc,
which targets the possibility that there can be more than one power-off
handler for this architecture, will increase the number by another 21.

Sometimes the pm_power_off pointer it is set conditionally if it is non-null,
sometimes it is set unconditionally. Sometimes it is set from drivers
and cleared to NULL on unload, sometimes those drivers restore the previous
setting, sometimes the drivers do not clear the pointer at all on unload.

The point here is that the _current_ solution has a problem, since there can
be more than one power-off handler in a system, there is no ordering at all,
and insertion/removal is racy. The priority field is trying to introduce some
execution order. If multiple handlers install a handler with the same priority,
it does not matter (much) since all handlers will be executed, and one will
hopefully succeed to power off the system. Ultimately, the priority is just
an added benefit - much more importantly, the code is not racy anymore.
Sure, people can say "my power-off priority is one above LOW", but that only
means that the code will be executed before the handler(s) with priority "LOW"
are executed. Hopefully one of them really powers off the system. Note in this
context that I introduced the named priorities because several reviewers asked
for it. The original code used notifier callbacks and numbered priorities
as specified for notifiers.

Having said that, the new solution may not be perfect, but it is the best
I have been able come up with. If you have a better idea for being able to
support multiple power-off handlers with different priorities, with non-racy
registration and unregistration, please let me know, and I'll be happy to
implement it.

Thanks,
Guenter
