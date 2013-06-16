Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514Ab3FPVen (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 17:34:43 -0400
Received: from www.meduna.org ([92.240.244.38]:32868 "EHLO meduna.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488Ab3FPVel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 17:34:41 -0400
Message-ID: <51BE2F5C.8070408@meduna.org>
Date: Sun, 16 Jun 2013 23:34:20 +0200
From: Stanislav Meduna <stano@meduna.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Hai Huang <hhuang@redhat.com>
Subject: Re: [PATCH] mm: fix up a spurious page fault whenever it happens
References: <5195ED8B.7060002@meduna.org>  <1369183168.6828.168.camel@gandalf.local.home>  <519CBB30.3060200@redhat.com>  <CA+55aFxMqvDvcVtLW-yD2PuU_CcjPOC30Zk07Kuk6S25WCzbHQ@mail.gmail.com>  <20130522134111.33a695c5@cuia.bos.redhat.com> <519D08B0.8050707@meduna.org> <1369246316.6828.176.camel@gandalf.local.home> <519D0CAB.7020800@meduna.org> <519D0FF8.5080200@redhat.com> <519D118B.6010306@zytor.com> <519D11BF.5000604@redhat.com> <519DCE2A.4010801@meduna.org> <519E095A.4000105@redhat.com> <519F24DD.5060700@meduna.org> <519F65DB.2020305@redhat.com>
In-Reply-To: <519F65DB.2020305@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Authenticated-User: stano@meduna.org
X-Authenticator: dovecot_plain
X-Spam-Score: -6.9
X-Spam-Score-Int: -68
X-Exim-Version: 4.72 (build at 25-Oct-2012 18:35:58)
X-Date: 2013-06-16 23:34:30
X-Connected-IP: 95.105.165.4:9047
X-Message-Linecount: 90
X-Body-Linecount: 68
X-Message-Size: 3979
X-Body-Size: 2529
X-Received-Count: 1
X-Recipient-Count: 10
X-Local-Recipient-Count: 10
X-Local-Recipient-Defer-Count: 0
X-Local-Recipient-Fail-Count: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I was able to reproduce the page fault problem with
a relatively simple application, for now on the
Geode platform. It can be downloaded at

  http://www.meduna.org/tmp/PageFault.tar.gz

Basically the test application does:

- 4 threads that do nothing but periodically sleep
- 1 thread looping in a timerfd loop doing nothing
- 4 threads doing nonblocking TCP connects to an address
  in the local network that does not exist, i.e. all that
  happens are ARP requests.
- additionally a non-existing TCP congestion algorithm is
  requested resulting in repeated futile requests to load
  the module. This looks to be an important part in reproducing
  it, but the problem also occasionally happened with kernels
  that did not have modules enabled at all, so it is
  probably just pushing some probabilities.
- the application is statically linked - this might or might
  not be relevant, I just wanted the text-segment to be bigger

I know it is a weird mix, I was just trying to mimic what
our application did in the form that was able to trigger
the faults most often.

In my few tests this repeatably triggered the problem in hours,
max a day.

My feeling is that the problem is triggered best if there
is little network traffic and no other connections to the
machine, but this is only a subjective feeling.

The kernel configuration, cpuinfo, meminfo and lspci
are included in the tarball. The kernel configuration is not
very clean, it is a kernel intended to work on both Geode
and Celeron and is also a snapshot of what reproduced the
problem the best.

The environment is a current 3.4-rt with following tweaks:

 chrt -f -p 37 <pid of ksoftirqd/0>
 chrt -o -p 0 <pid of irq/14-pata>  [because of a pata_cs5536 bug]
 renice -15 <pid of irq/14-pata>
 ulimit -s 512

Before compiling change the CONNECT_ADDR define to an address
that is in the local LAN but is not present.

Other than this application a lightweight mix of usual Debian
processes is running. There are no servers except openssh and ntp.
A shell script that wakes each 2 seconds and does some
housekeeping is running, that probably recovers the system
when it enters the page-fault loop followed by the
RT throttling.

Right now a test with the same kernel with preempt none
is running to see whether the problem also happens with this
application there (due to the timing sensitivity only a positive
result has a significance). I did not have a chance to test
on an Intel processor yet.

Thanks
-- 
                                       Stano

