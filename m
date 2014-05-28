Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbaE1PSn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 11:18:43 -0400
Received: from mx0.aculab.com ([213.249.233.131]:49301 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753998AbaE1PSm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 11:18:42 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Arnaldo Carvalho de Melo'" <acme@kernel.org>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        =?iso-8859-2?Q?Ondrej_B=EDlka?= <neleai@seznam.cz>,
        Caitlin Bestler <caitlin.bestler@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Elie De Brauwer" <eliedebrauwer@gmail.com>,
        David Miller <davem@davemloft.net>,
        "Steven Whitehouse" <steve@chygwyn.com>,
        =?iso-8859-2?Q?R=E9mi_Denis-Courmont?= 
	<remi.denis-courmont@nokia.com>,
        Paul Moore <paul@paul-moore.com>,
        "Chris Friesen" <chris.friesen@windriver.com>
Subject: RE: [PATCH/RFC] Re: recvmmsg() timeout behavior strangeness [RESEND]
Thread-Topic: [PATCH/RFC] Re: recvmmsg() timeout behavior strangeness
 [RESEND]
Thread-Index: AQHPeoaBBF42JoL2CUKh/KaMaW27r5tWGHxA
Date: Wed, 28 May 2014 15:17:40 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1724F2A0@AcuExch.aculab.com>
References: <20140512143451.GB13801@kernel.org>
 <20140521210535.GA5414@kernel.org> <537E0961.8040005@gmail.com>
 <20140526134647.GB8176@kernel.org> <20140526211706.GA25474@kernel.org>
 <5384BEC5.2080607@gmail.com> <20140527192115.GD25474@kernel.org>
 <CAKgNAkht1vubHueYPpkRu_W5B8OYW3rPUkHeLEq5WMVbCvO47w@mail.gmail.com>
 <20140527203010.GA2764@kernel.org> <5385D47A.3070401@gmail.com>
 <20140528150720.GB2764@kernel.org>
In-Reply-To: <20140528150720.GB2764@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo
...
> > But, another question...
> >
> > In the case that the call is interrupted by a signal handler and some
> > datagrams have already been received, then the call succeeds, and
> > returns the number of datagrams received, and 'timeout' is updated with
> > the remaining time. Maybe that's the right behavior, but I just want to
> 
> Note that what the comment in the existing code says should apply here,
> namely that the next recv (m or mmsg) syscall on this socket will return
> what is in sock->sk->sk_err, that is the signal:
> 
...
> 
> So, yes, the user _can_ process the packets already copied to userspace,
> i.e. no packet loss, and then, on the next call, will receive the signal
> notification.

The application shouldn't need to see an EINTR response, any signal handler
should be run when the system call returns to user (regardless of the
system call result code).
If that doesn't happen Linux is badly broken!
>From an application point of view this is exactly the same as the signal
occurring just before/after the kernel entry/exit for the system call.

The call should just return early with success status.
No need to preserve the EINTR response for later.

The same might be appropriate for other errors - maybe including EFAULT
copying non-initial messages to userspace.
Put the message being processed back on the socket queue and return
success with the (non-zero) partial message count.

	David



