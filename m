Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbaDQQs5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 12:48:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbaDQQst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 12:48:49 -0400
Subject: Re: [PATCH 2/2] net: Implement SO_PASSCGROUP to enable passing
 cgroup path
From: Simo Sorce <ssorce@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Daniel J Walsh <dwalsh@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        David Miller <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lpoetter@redhat.com, cgroups@vger.kernel.org, kay@redhat.com,
        Network Development <netdev@vger.kernel.org>
In-Reply-To: <CALCETrWNWvumFg9Qba0GEOjYop4WYe530tCPtakrhnoCrHqhUQ@mail.gmail.com>
References: <CALCETrURHNmLyccRiF_W8o2ozRMR4AaCjUE=_PU8z1+Pq6X2jQ@mail.gmail.com>
	 <20140416002010.GA5035@redhat.com>
	 <CALCETrWzHYN3kKcmDTFDfGhZqE4u9+6XDtiOu5nncbK_7KKH0g@mail.gmail.com>
	 <20140416.085743.1614257692560892039.davem@davemloft.net>
	 <CALCETrVv8SPM5xjOVGy7qO2aq3FKtG2uG57J49nO7Wy0-gg0Ew@mail.gmail.com>
	 <1397664837.19767.410.camel@willson.li.ssimo.org>
	 <CALCETrXn7b6UuALpGUVoyQYfR2uzk5tj2ABV=dkvtFNgqM5sxQ@mail.gmail.com>
	 <20140416180642.GG31074@redhat.com>
	 <CALCETrVUw5+vCCONy1VTXpskbY_eZFo2CtbehwV5Mhj4d4+icw@mail.gmail.com>
	 <20140416185936.GJ31074@redhat.com> <534FF61B.4010901@redhat.com>
	 <1397750674.2628.44.camel@willson.li.ssimo.org>
	 <CALCETrUrj2LtAoXp600BD2ANgE2UUEbTYQrK8hHqDR=qpeFPcg@mail.gmail.com>
	 <1397751853.2628.50.camel@willson.li.ssimo.org>
	 <CALCETrWNWvumFg9Qba0GEOjYop4WYe530tCPtakrhnoCrHqhUQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Apr 2014 12:48:43 -0400
Message-ID: <1397753323.2628.60.camel@willson.li.ssimo.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-17 at 09:37 -0700, Andy Lutomirski wrote:
> On Thu, Apr 17, 2014 at 9:24 AM, Simo Sorce <ssorce@redhat.com> wrote:
> > On Thu, 2014-04-17 at 09:11 -0700, Andy Lutomirski wrote:
> >>
> >> No.  The logging daemon thinks it wants to know who the writer is, but
> >> the logging daemon is wrong.  It actually wants to know who composed a
> >> log message destined to it.  The caller of write(2) may or may not be
> >> the same entity.
> >
> > This works both ways, and doesn't really matter, you are *no* better off
> > w/o this interface.
> >
> >> If this form of SO_PASSCGROUP somehow makes it into a pull request for
> >> Linus, I will ask him not to pull it and/or to revert it.  I think
> >> he'll agree that write(2) MUST NOT care who called it.
> >
> > And write() does not, there is no access control check being performed
> > here. This call is the same as getting the pid of the process and
> > crawling /proc with that information, just more efficient and race-free.
> 
> Doing it using the pid of writer is wrong.  So is doing it with the
> cgroup of the writer.  The fact that it's even possible to use the pid
> of the caller of write(2) is a mistake, but that particular mistake
> is, unfortunately, well-enshrined in history.
> 
> >
> > I repeat, it is *not* access control.
> >
> 
> Sure it is.
> 
> Either correct attribution of logs doesn't matter, in which case it
> makes little difference how you do it, or it does matter, in which
> case it should be done right.

Well journald can *also* get  SO_PEERCGROUP and log anomalies if the 2
differ. That is if the log happens on a connected socket.

If the log happens on a unix datagram* then SO_PEERCGROUP is not
available because there is no connect(), however write() cannot be used
either, only sendmsg() AFAIK, so the "setuid" binary attack does not
apply.

> Here's a real world example from my industry.  Suppose I used journald
> for logging on a production trading system.  The ability to write a
> log line that says "I just bought 100000 EUR/USD for
> such-and-such-price" attributed to a trading program is absolutely a
> security-sensitive operation and must be subject to access control.

Eh well if SCM_CREDNTIALS passed the euid you'd se a different user in
the logs from the one that is supposed to be writing the log ... but
that send the real uid instead oups ... but I think the point is moot
for logs, given the previous explanation.

> If Common Criteria doesn't say that audit logs need to be resistant to
> spoofing, then that's just one more reason that Common Criteria is
> broken.

IT does say a lot about audit logs, but journald is not classified as an
audit log under CC, and I am not sure it can ever be.

> I don't use journald for trading logs, and I'd be absolutely daft to
> use ordinary syslog, because ordinary syslog doesn't even pretend to
> be secure.

Right.

>   But if you're going to design something that claims to be
> secure, "well, I can't see how this issue would be exploited" is not
> good enough.

Did anyone claim the journal is secure to the level you claim it should
be. Regardless, systemd can be that secure if it uses also SO_PEERCGROUP
in the vulnerable case (when you have a connected socket).


Simo.


* I think this is the case that matters for journald

