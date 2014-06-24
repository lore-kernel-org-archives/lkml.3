Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbaFXUZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 16:25:50 -0400
Received: from mail.kernel.org ([198.145.19.201]:39632 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607AbaFXUZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 16:25:48 -0400
Date: Tue, 24 Jun 2014 17:25:41 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: David Laight <David.Laight@aculab.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Ondrej =?iso-8859-1?Q?B=EDlka?= <neleai@seznam.cz>,
        Caitlin Bestler <caitlin.bestler@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Elie De Brauwer <eliedebrauwer@gmail.com>,
        David Miller <davem@davemloft.net>,
        Steven Whitehouse <steve@chygwyn.com>,
        =?iso-8859-1?Q?R=E9mi?= Denis-Courmont 
	<remi.denis-courmont@nokia.com>,
        Paul Moore <paul@paul-moore.com>,
        Chris Friesen <chris.friesen@windriver.com>
Subject: Re: [PATCH/RFC] Re: recvmmsg() timeout behavior strangeness [RESEND]
Message-ID: <20140624202541.GD3456@kernel.org>
References: <20140527203010.GA2764@kernel.org>
 <5385D47A.3070401@gmail.com>
 <20140528150720.GB2764@kernel.org>
 <063D6719AE5E284EB5DD2968C1650D6D1724F2A0@AcuExch.aculab.com>
 <20140528195004.GD2764@kernel.org>
 <063D6719AE5E284EB5DD2968C1650D6D1724FB67@AcuExch.aculab.com>
 <20140529135547.GG2764@kernel.org>
 <063D6719AE5E284EB5DD2968C1650D6D1724FC78@AcuExch.aculab.com>
 <20140529141705.GI2764@kernel.org>
 <CAKgNAkj-MVfeqEeffWKMNok0yO-Rm1kyY+zhXEy-U9NkB+aLow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgNAkj-MVfeqEeffWKMNok0yO-Rm1kyY+zhXEy-U9NkB+aLow@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jun 16, 2014 at 11:58:51AM +0200, Michael Kerrisk (man-pages) escreveu:
> Hi Arnaldo,
> 
> Things have gone quiet ;-). What's the current state of this patch?

Yeah, I kept meaning to prod the other people on this thread about what
they thought about my last messages, patches, etc. :-)

Can I have acked-by or even tested-by on those? Is it ok?

- Arnaldo

> Thanks,
> 
> Michael
> 
> 
> On Thu, May 29, 2014 at 4:17 PM, Arnaldo Carvalho de Melo
> <acme@ghostprotocols.net> wrote:
> > Em Thu, May 29, 2014 at 02:06:04PM +0000, David Laight escreveu:
> >> From: 'Arnaldo Carvalho de Melo'
> >> ...
> >> > > I remember some discussions from an XNET standards meeting (I've forgotten
> >> > > exactly which errors on which calls were being discussed).
> >> > > My recollection is that you return success with a partial transfer
> >> > > count for ANY error that happens after some data has been transferred.
> >> > > The actual error will be returned when it happens again on the next
> >> > > system call - Note the AGAIN, not a saved error.
> >
> >> > A saved error, for the right entity, in the recvmmsg case, that
> >> > basically is batching multiple recvmsg syscalls, doesn't sound like a
> >> > problem, i.e. the idea is to, as much as possible, mimic what multiple
> >> > recvmsg calls would do, but reduce its in/out kernel (and inside kernel
> >> > subsystems) overhead.
> >
> >> > Perhaps we can have something in between, i.e. for things like EFAULT,
> >> > we should report straight away, effectively dropping whatever datagrams
> >> > successfully received in the current batch, do you agree?
> >
> >> Not unreasonable - EFAULT shouldn't happen unless the application
> >> is buggy.
> >
> > Ok.
> >
> >> > For transient errors the existing mechanism, fixed so that only per
> >> > socket errors are saved for later, as today, could be kept?
> >
> >> I don't think it is ever necessary to save an errno value for the
> >> next system call at all.
> >> Just process the next system call and see what happens.
> >
> >> If the call returns with less than the maximum number of datagrams
> >> and with a non-zero timeout left - then the application can infer
> >> that it was terminated by an abnormal event of some kind.
> >> This might be a signal.
> >
> > Then it could use getsockopt(SO_ERROR) perhaps? I.e. we don't return the
> > error on the next call, but we provide a way for the app to retrieve the
> > reason for the smaller than expected batch?
> >
> >> I'm not sure if an icmp error on a connected datagram socket could
> >> generate a 'disconnect'. It might happen if the interface is being
> >> used for something like SCTP.
> >> In either case the next call will detect the error.
> >
> > - Arnaldo
> 
> 
> 
> -- 
> Michael Kerrisk
> Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
> Linux/UNIX System Programming Training: http://man7.org/training/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
