Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580AbaE2OHO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:07:14 -0400
Received: from mx0.aculab.com ([213.249.233.131]:40945 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757484AbaE2OHJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 10:07:09 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Arnaldo Carvalho de Melo'" <acme@kernel.org>
CC: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        =?Windows-1252?Q?Ondrej_B=EDlka?= <neleai@seznam.cz>,
        Caitlin Bestler <caitlin.bestler@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Elie De Brauwer" <eliedebrauwer@gmail.com>,
        David Miller <davem@davemloft.net>,
        "Steven Whitehouse" <steve@chygwyn.com>,
        =?Windows-1252?Q?R=E9mi_Denis-Courmont?= 
	<remi.denis-courmont@nokia.com>,
        Paul Moore <paul@paul-moore.com>,
        "Chris Friesen" <chris.friesen@windriver.com>
Subject: RE: [PATCH/RFC] Re: recvmmsg() timeout behavior strangeness [RESEND]
Thread-Topic: [PATCH/RFC] Re: recvmmsg() timeout behavior strangeness
 [RESEND]
Thread-Index: AQHPeoaBBF42JoL2CUKh/KaMaW27r5tWGHxAgAA9vQCAAQahgIAAKLeAgAARU2A=
Date: Thu, 29 May 2014 14:06:04 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1724FC78@AcuExch.aculab.com>
References: <20140526211706.GA25474@kernel.org> <5384BEC5.2080607@gmail.com>
 <20140527192115.GD25474@kernel.org>
 <CAKgNAkht1vubHueYPpkRu_W5B8OYW3rPUkHeLEq5WMVbCvO47w@mail.gmail.com>
 <20140527203010.GA2764@kernel.org> <5385D47A.3070401@gmail.com>
 <20140528150720.GB2764@kernel.org>
 <063D6719AE5E284EB5DD2968C1650D6D1724F2A0@AcuExch.aculab.com>
 <20140528195004.GD2764@kernel.org>
 <063D6719AE5E284EB5DD2968C1650D6D1724FB67@AcuExch.aculab.com>
 <20140529135547.GG2764@kernel.org>
In-Reply-To: <20140529135547.GG2764@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: 'Arnaldo Carvalho de Melo'
...
> > I remember some discussions from an XNET standards meeting (I've forgotten
> > exactly which errors on which calls were being discussed).
> > My recollection is that you return success with a partial transfer
> > count for ANY error that happens after some data has been transferred.
> > The actual error will be returned when it happens again on the next
> > system call - Note the AGAIN, not a saved error.
> 
> A saved error, for the right entity, in the recvmmsg case, that
> basically is batching multiple recvmsg syscalls, doesn't sound like a
> problem, i.e. the idea is to, as much as possible, mimic what multiple
> recvmsg calls would do, but reduce its in/out kernel (and inside kernel
> subsystems) overhead.
> 
> Perhaps we can have something in between, i.e. for things like EFAULT,
> we should report straight away, effectively dropping whatever datagrams
> successfully received in the current batch, do you agree?

Not unreasonable - EFAULT shouldn't happen unless the application
is buggy.

> For transient errors the existing mechanism, fixed so that only per
> socket errors are saved for later, as today, could be kept?

I don't think it is ever necessary to save an errno value for the
next system call at all.
Just process the next system call and see what happens.

If the call returns with less than the maximum number of datagrams
and with a non-zero timeout left - then the application can infer
that it was terminated by an abnormal event of some kind.
This might be a signal.
I'm not sure if an icmp error on a connected datagram socket could
generate a 'disconnect'. It might happen if the interface is being
used for something like SCTP.
In either case the next call will detect the error.

	David



