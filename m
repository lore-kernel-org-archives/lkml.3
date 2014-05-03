Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548AbaECK3D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 06:29:03 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:61514 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbaECK3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 06:29:00 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <536101C9.9090601@gmail.com>
References: <536101C9.9090601@gmail.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Sat, 3 May 2014 12:28:39 +0200
Message-ID: <CAKgNAkhaFoMMzo1JB7wfgZ2Qwkgjvf8Tp8c77ih99=1qcDoNKg@mail.gmail.com>
Subject: Re: recvmmsg() timeout behavior strangeness [RESEND]
To: Arnaldo Carvalho de Melo <acme@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?T25kxZllaiBCw61sa2E=?= <neleai@seznam.cz>,
        Caitlin Bestler <caitlin.bestler@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Elie De Brauwer <eliedebrauwer@gmail.com>,
        David Miller <davem@davemloft.net>,
        Steven Whitehouse <steve@chygwyn.com>,
        =?UTF-8?Q?R=C3=A9mi_Denis=2DCourmont?= 
	<remi.denis-courmont@nokia.com>,
        Paul Moore <paul@paul-moore.com>,
        Chris Friesen <chris.friesen@windriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo,

On Wed, Apr 30, 2014 at 3:59 PM, Michael Kerrisk (man-pages)
<mtk.manpages@gmail.com> wrote:
> Arnaldo,
>
> I raised this issue somewhat more than a year ago, here:
> http://thread.gmane.org/gmane.linux.man/3477
> but got no reply from you. (Chris Friesen in that thread agreed
> that there is a problem though.)
>
> Here, a slightly revised version of that mail, since I've just bumper
> into a related problem in a different context...
>
> As part of his attempt to better document the recvmmsg() syscall that
> you added in commit a2e2725541fad72416326798c2d7fa4dafb7d337, Elie de
> Brauwer alerted to me to some strangeness in the timeout behavior of
> the syscall. I suspect there's a bug that needs fixing, as detailed
> below.
>
> AFAICT, the timeout argument was added to this syscall as a result of
> the discussion here:
> http://markmail.org/message/m5l2ap4hiiimut6k#query:+page:1+mid:m5l2ap4hiiimut6k+state:results
> (20-21 May 2009, "[RFC 1/2] net: Introduce recvmmsg...")
>
> If I understand correctly, the *intended* purpose of the timeout
> argument is to set a limit on how long to wait for additional
> datagrams after the arrival of an initial datagram. However, the
> syscall behaves in quite a different way. Instead, it potentially
> blocks forever, regardless of the timeout. The way the timeout seems
> to work is as follows:

So that the report does not get lost, I've created
https://bugzilla.kernel.org/show_bug.cgi?id=75371
to track it

Reinvestigating the problem, I see that I got my description of the
behavior slightly wrong, although the fundamental problem remains.
Here's my improved formulation:

int recvmmsg(int sockfd, struct mmsghdr *msgvec, unsigned int vlen,

unsigned int flags, struct timespec *timeout);

As currently implemented, the recvmmsg() timeout feature appears to be
fit for no sane use. The timeout argument is implemented as follows:

    Timer is armed at the time of the call

    while (datagrams-received < vlen) {
        Wait for the next datagram

        Check if timeout has been exceeded; if yes, break out of loop
    }


Since the timeout is only checked after the arrival of each datagram,
we can have scenarios like the following:

0. Assume a timeout of 10 (T) seconds, that vlen is 5, and the call
   is made at time X

1. First datagram arrives at time X+2.

2. Second datagram arrives at time X+4 secs

3. Third datagram arrives at time X+6 secs

4. No more datagrams arrive.

In this case, the call blocks forever. It hardly seems that this could
be intended behavior. The problem, of course is that the timeout is
checked only after receipt of a datagram.

Basically, if up to vlen-1 datagrams arrive before X+T, but then no
more datagrams arrive, the call will remain blocked forever. If it's
intended behavior (seems unlikely), the rationale needs to be
elaborated so that it can be documented in the man page. If not, a fix
seems to be needed, since otherwise, it's hard to see how the
recvmmsg() timeout argument can sanely be used.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
