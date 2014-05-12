Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbaELGyJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 02:54:09 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:51581 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbaELGyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 02:54:07 -0400
Message-ID: <53707007.3080003@gmail.com>
Date: Mon, 12 May 2014 08:53:59 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mtk.manpages@gmail.com, Juri Lelli <juri.lelli@gmail.com>,
        Dario Faggioli <raistlin@linux.it>, Ingo Molnar <mingo@elte.hu>,
        lkml <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: [BUG] sched_setattr() SCHED_DEADLINE hangs system
References: <536F8F0E.7020301@gmail.com>
In-Reply-To: <536F8F0E.7020301@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2014 04:54 PM, Michael Kerrisk (man-pages) wrote:
> [Dave: I wonder if there's anything trinity can add in the way of 
> a test here?]
> 
> Hi Peter,
> 
> This looks like another bug in sched_setattr(). Using the program
> below (which you might find generally helpful for testing), I'm 
> able to reliably freeze up my x64 (Intel Core i7-3520M Processor) 
> system for up to about a minute when I run with the following 
> command line:
> 
> $ time sudo ./t_sched_setattr d 18446744072 18446744072 18446744073
> 
> 'd' here means use SCHED_DEADLINE, then the remaining arguments
> are the Runtime, Deadline, and Period, expressed in *seconds*.
> (Those number by the way are just a little below 2^64.)
> 
> Aside from interpreting its command-line arguments, all that the 
> program does is call sched_setattr() and displays elapsed times.
> (By the way, on my system I see some weird effects for time(2), 
> presumably VDSO effects.)
> 
> Here's sample run:
> 
> time sudo ./t_sched_setattr d 18446744072 18446744072 18446744073
> Runtime  =      18446744072000000000
> Deadline =      18446744072000000000
> Period   =      18446744073000000000
> About to call sched_setattr()
> Successful return from sched_setattr() [6 seconds]
> 
> real	0m40.421s
> user	0m3.097s
> sys	0m30.804s
> 
> After unfreezing the machine is fine, while the program is running,
> the machine is pretty unresponsive.
> 
> I'm on kernel 3.15-rc4.

Hi Peter,

I realize my speculation was completely off the mark. time(2) really 
is reporting the truth, and the sched_setattr() call returns immediately.
But it looks like with these settings the deadline scheduler gets itself
into a confused state. The process chews up a vast amount of CPU time
for the few actions (including process teardown) that occur after
the sched_setattr() call, and since the SCHED_DEADLINE process has
priority over everything else, the system locks up.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
