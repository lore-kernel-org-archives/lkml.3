Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759052AbaD3N7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 09:59:44 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:55447 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758836AbaD3N7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 09:59:42 -0400
Message-ID: <536101C9.9090601@gmail.com>
Date: Wed, 30 Apr 2014 15:59:37 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
CC: mtk.manpages@gmail.com,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?T25kxZllaiBCw61sa2E=?= <neleai@seznam.cz>,
        Caitlin Bestler <caitlin.bestler@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Elie De Brauwer <eliedebrauwer@gmail.com>,
        David Miller <davem@davemloft.net>,
        Steven Whitehouse <steve@chygwyn.com>,
        =?UTF-8?B?UsOpbWkgRGVuaXMtQ291cm1v?= =?UTF-8?B?bnQ=?= 
	<remi.denis-courmont@nokia.com>,
        Paul Moore <paul@paul-moore.com>,
        Chris Friesen <chris.friesen@windriver.com>
Subject: recvmmsg() timeout behavior strangeness [RESEND]
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo,

I raised this issue somewhat more than a year ago, here:
http://thread.gmane.org/gmane.linux.man/3477
but got no reply from you. (Chris Friesen in that thread agreed 
that there is a problem though.)

Here, a slightly revised version of that mail, since I've just bumper 
into a related problem in a different context...

As part of his attempt to better document the recvmmsg() syscall that
you added in commit a2e2725541fad72416326798c2d7fa4dafb7d337, Elie de
Brauwer alerted to me to some strangeness in the timeout behavior of
the syscall. I suspect there's a bug that needs fixing, as detailed
below.

AFAICT, the timeout argument was added to this syscall as a result of
the discussion here:
http://markmail.org/message/m5l2ap4hiiimut6k#query:+page:1+mid:m5l2ap4hiiimut6k+state:results
(20-21 May 2009, "[RFC 1/2] net: Introduce recvmmsg...")

If I understand correctly, the *intended* purpose of the timeout
argument is to set a limit on how long to wait for additional
datagrams after the arrival of an initial datagram. However, the
syscall behaves in quite a different way. Instead, it potentially
blocks forever, regardless of the timeout. The way the timeout seems
to work is as follows:

1. The timeout, T, is armed on receipt of first diagram, starting at time X.
2. After each further datagram is received, a check is made if we have
reached time X+T. If we have reached that time, then the syscall
returns.

Since the timeout is only checked after the arrival of each datagram,
we can have scenarios like the following:

0. Assume a timeout of 10 seconds, and that vlen is 5.
1. First datagram arrives at time X.
2. Second datagram arrives at time X+2 secs
3. No more datagrams arrive.

In this case, the call blocks forever. Is that intended behavior?
(Basically, if up to vlen-1 datagrams arrive before X+T, but then no 
more datagrams arrive, the call will remain blocked forever.) If it's
intended behavior, could you elaborate the use case, since it would be
good to add that to the man page. If not, a fix seems to be needed,
since otherwise, it's hard to see how the recvmmsg() timeout argument
can sanely be used.

Thanks,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
