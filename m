Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761500Ab3DBN1j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 09:27:39 -0400
Received: from us02smtp2.synopsys.com ([198.182.60.77]:64439 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760072Ab3DBN1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 09:27:37 -0400
Message-ID: <515ADC96.7090908@synopsys.com>
Date: Tue, 2 Apr 2013 18:56:46 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: lkml <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        "Ingo Molnar" <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: n_tty_write() going into schedule but NOT coming out
References: <5156DC21.20901@synopsys.com> <5159925B.5050806@synopsys.com> <1364829008.3617.21.camel@thor.lan>
In-Reply-To: <1364829008.3617.21.camel@thor.lan>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.41]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2013 08:40 PM, Peter Hurley wrote:
> On Mon, 2013-04-01 at 19:27 +0530, Vineet Gupta wrote:
>> Hi,
>>
>> Any thoughts: I observe the same issue even with CONFIG_PREEMPT and
>> CONFIG_PREEMPT_COUNT
>>
>> -Vineet
>>
>> On 03/30/2013 06:05 PM, Vineet Gupta wrote:
>>> Hi,
>>>
>>> I've been stress testing ARC Linux 3.8 (same happens for 3.9-rc3 as well). The
>>> setup has 3 telnet sessions, each running find . -name "*" in a loop.
>>> The platform is a FPGA @ 80 MHz, running a single core ARC700 so kernel .config
>>> has !SMP and PREEMPT_NONE.
>>>
>>> After ~10 mins of run, I see that one of the telnet session gets stuck (and later
>>> the 2nd one as well), while system is still alive, 3rd telnet is running find merrily.
>>>
>>> [ARCLinux]$ ps
>>> ....
>>>     7 root       0:00 inetd
>>>    62 root       0:00 -/bin/sh
>>>    64 root       1:34 telnetd -i -l /bin/sh
>>>    65 root       0:00 /bin/sh
>>>    75 root       1:47 telnetd -i -l /bin/sh
>>>    76 root       0:00 /bin/sh
>>>    79 root       0:53 telnetd -i -l /bin/sh
>>>    80 root       0:00 /bin/sh
>>>   281 root       0:00 find / -name *	<--- stuck
>>>   358 root       0:03 find / -name *	<--- stuck
>>>   377 root       0:00 find / -name *
>>>   378 root       0:00 ps
>>>
>>> Hung find task is sitting in the schedule() call in n_tty_write()
>>>
>>> [ARCLinux]$ cat /proc/281/stack
>>> [<8065945e>] n_tty_write+0x23a/0x424
>>> [<80655cd4>] tty_write+0x1ac/0x2d4
>>> [<805976ba>] vfs_write+0x92/0x110
>>> [<80597816>] sys_write+0x4e/0x88
>>> [<8050e780>] ret_from_system_call+0x0/0x4
> Likely the writer is stuck because the receive buffer is full and the
> reader is hung. What are the respective shells and telnetd doing?

I've added a couple of printk's around that schedule() call and in one pathetic
case all 3 find tasks never return:

S     0    58    47  1768   488 0:0   00:00 00:03:50 telnetd -i -l /bin/sh
S     0    59    58  1768   520 pts0  00:00 00:00:01 /bin/sh
S     0    61    47  1768   488 0:0   00:00 00:03:45 telnetd -i -l /bin/sh
S     0    62    61  1768   528 pts1  00:00 00:00:01 /bin/sh
S     0    65    47  1768   488 0:0   00:00 00:03:23 telnetd -i -l /bin/sh
S     0    66    65  1776   528 pts2  00:00 00:00:01 /bin/sh
S     0   833    66  1840   488 pts2  00:58 00:00:01 find / -name *        <--
S     0   871    62  1832   480 pts1  01:01 00:00:00 find / -name *        <--
S     0   881    59  1840   488 pts0  01:01 00:00:02 find / -name *        <--


---> 833 8e21c580
<--- 833 8e21c580
---> 833 8e21c580

---> 871 8e21c840
<--- 871 8e21c840
---> 871 8e21c840

---> 881 8e21c2c0
<--- 881 8e21c2c0
---> 881 8e21c2c0

I don't undersand how the receive buffer full/empty is coming into play - that
schedule() call is not a wait queue or something, it's an unconditional yield,
expecting sched to unconditionally return at some point - unless ofcourse - that
itself relies on some buffer r/w ISR semantics triggering an ISR, which makes the
task runnable again causing schdule() to return.

-Vineet
