Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbaDQSEm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 14:04:42 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:36513 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbaDQSEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 14:04:30 -0400
MIME-Version: 1.0
In-Reply-To: <1397757169.2628.75.camel@willson.li.ssimo.org>
References: <20140416180642.GG31074@redhat.com> <CALCETrVUw5+vCCONy1VTXpskbY_eZFo2CtbehwV5Mhj4d4+icw@mail.gmail.com>
 <20140416185936.GJ31074@redhat.com> <534FF61B.4010901@redhat.com>
 <1397750674.2628.44.camel@willson.li.ssimo.org> <CALCETrUrj2LtAoXp600BD2ANgE2UUEbTYQrK8hHqDR=qpeFPcg@mail.gmail.com>
 <1397751853.2628.50.camel@willson.li.ssimo.org> <CALCETrWNWvumFg9Qba0GEOjYop4WYe530tCPtakrhnoCrHqhUQ@mail.gmail.com>
 <1397753323.2628.60.camel@willson.li.ssimo.org> <CALCETrXj6kD3E+vsaWmkrSbaQYTu=c-Hsw640jh4O+FbojYk2g@mail.gmail.com>
 <20140417171256.GB25334@redhat.com> <CALCETrVq4HRpfWOAbZAQbyjuraQd=OxnW=WjSoe5JgBzRStiKg@mail.gmail.com>
 <1397757169.2628.75.camel@willson.li.ssimo.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 17 Apr 2014 11:04:08 -0700
Message-ID: <CALCETrUon7mZzp12th2bZ=cJyTjn8ePwg_VtPWL_bykjnnpKLw@mail.gmail.com>
Subject: Re: [PATCH 2/2] net: Implement SO_PASSCGROUP to enable passing cgroup path
To: Simo Sorce <ssorce@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Daniel J Walsh <dwalsh@redhat.com>,
        David Miller <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lpoetter@redhat.com, cgroups@vger.kernel.org, kay@redhat.com,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 10:52 AM, Simo Sorce <ssorce@redhat.com> wrote:
> On Thu, 2014-04-17 at 10:26 -0700, Andy Lutomirski wrote:
>> On Thu, Apr 17, 2014 at 10:12 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > On Thu, Apr 17, 2014 at 09:55:08AM -0700, Andy Lutomirski wrote:
>> >> On Thu, Apr 17, 2014 at 9:48 AM, Simo Sorce <ssorce@redhat.com> wrote:
>> >> > On Thu, 2014-04-17 at 09:37 -0700, Andy Lutomirski wrote:
>> >> >> On Thu, Apr 17, 2014 at 9:24 AM, Simo Sorce <ssorce@redhat.com> wrote:
>> >> >> > On Thu, 2014-04-17 at 09:11 -0700, Andy Lutomirski wrote:
>> >> >> >>
>> >> >> >> No.  The logging daemon thinks it wants to know who the writer is, but
>> >> >> >> the logging daemon is wrong.  It actually wants to know who composed a
>> >> >> >> log message destined to it.  The caller of write(2) may or may not be
>> >> >> >> the same entity.
>> >> >> >
>> >> >> > This works both ways, and doesn't really matter, you are *no* better off
>> >> >> > w/o this interface.
>> >> >> >
>> >> >> >> If this form of SO_PASSCGROUP somehow makes it into a pull request for
>> >> >> >> Linus, I will ask him not to pull it and/or to revert it.  I think
>> >> >> >> he'll agree that write(2) MUST NOT care who called it.
>> >> >> >
>> >> >> > And write() does not, there is no access control check being performed
>> >> >> > here. This call is the same as getting the pid of the process and
>> >> >> > crawling /proc with that information, just more efficient and race-free.
>> >> >>
>> >> >> Doing it using the pid of writer is wrong.  So is doing it with the
>> >> >> cgroup of the writer.  The fact that it's even possible to use the pid
>> >> >> of the caller of write(2) is a mistake, but that particular mistake
>> >> >> is, unfortunately, well-enshrined in history.
>> >> >>
>> >> >> >
>> >> >> > I repeat, it is *not* access control.
>> >> >> >
>> >> >>
>> >> >> Sure it is.
>> >> >>
>> >> >> Either correct attribution of logs doesn't matter, in which case it
>> >> >> makes little difference how you do it, or it does matter, in which
>> >> >> case it should be done right.
>> >> >
>> >> > Well journald can *also* get  SO_PEERCGROUP and log anomalies if the 2
>> >> > differ. That is if the log happens on a connected socket.
>> >> >
>> >> > If the log happens on a unix datagram* then SO_PEERCGROUP is not
>> >> > available because there is no connect(), however write() cannot be used
>> >> > either, only sendmsg() AFAIK, so the "setuid" binary attack does not
>> >> > apply.
>> >> >
>> >>
>> >> Or you could only send SCM_CGROUP when the writer asks sendmsg to send
>> >> it, in which case this whole problem goes away.
>> >
>> > Sending SCM_CGROUP explicitly is also sending cgroup info at write(2) time
>> > and if receiver uses that info for access control, it can be problematic.
>> >
>>
>> Not really.  write(2) can't send SCM_CGROUP.  Callers of sendmsg(2)
>> who supply SCM_CGROUP are explicitly indicating that they want their
>> cgroup associated with that message.  Callers of write(2) and send(2)
>> are simply indicating that they have some bytes that they want to
>> shove into whatever's at the other end of the fd.
>
> So you are telling me that you want to change all code that writes to
> stderr to be changed to use sendmsg() instead of write() in order to get
> that information ?

No.  I'm telling you that I want whoever writes the logging code to
change *the logging code* to use sendmsg.

>
> If you are using datagram sockets then the sender explicitly has to use
> sendmsg() already and if a setuid binary can be convinced to send
> arbitrary data to an arbitrary datagram sokcet you have bigger problems
> in that binary, and said binary will send you whatever cgroup it is in.

Really?

--Andy
