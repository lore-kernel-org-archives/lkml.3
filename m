Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812Ab3FZBLc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 21:11:32 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:64325 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab3FZBLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 21:11:30 -0400
Message-ID: <51CA3FBF.6080201@amacapital.net>
Date: Tue, 25 Jun 2013 18:11:27 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH RFC nohz_full 0/8] Provide infrastructure for full-system
 idle
References: <20130625213721.GA19452@linux.vnet.ibm.com> <alpine.DEB.2.02.1306252345210.4013@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1306252345210.4013@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2013 02:49 PM, Thomas Gleixner wrote:
> On Tue, 25 Jun 2013, Paul E. McKenney wrote:
>> Note that this version pays attention to CPUs that have taken an NMI
>> from idle.  It is not clear to me that NMI handlers can safely access
>> the time on a system that is long-term idle.  Unless someone tells me
>> that it is somehow safe to access time from an NMI from idle, I will
>> remove NMI support in the next version.
> 
> NMI cannot access any time related functions independent of NOHZ, long
> term idle or whatever you come up with:
> 
>        write_seqcount_begin(&timekeeper_seq);
> 
> ---> NMI
> 	...
> 	do {
> 	   seq = read_seqcount_begin(&timekeeper_seq);
> 	} while (read_seqcount_retry(&timekeeper_seq, seq));
> 
> Guess how well that works ....
> 
> Thanks,
> 
> 	tglx
> 

Is this something worth fixing?  One of the things on my infinitely long
todo list is to replace that seqcount with a wait-free data structure,
in which case this would be okay.  I don't care about NMIs, but this
would mean that clock_gettime would never stall just because the
timekeeping code was running somewhere -- at worse you'd get a couple
extra cache misses.

The data structure is described here:

http://link.springer.com/chapter/10.1007%2F978-3-540-92221-6_40

(Sorry, this was my first paper and is therefore not so well written.
Also, it costs $30, although I think I'm allowed to email copies out and
probably even host them on a website somewhere.)

The main downside would be a possible loss of monotonicity, like this:

Thread a: read the timekeeping data
Thread b: update the timekeeping data
Thread c: start and finish reading the time (using new data)
Thread a: read new raw clock value but compute using old timekeeping data

This would be fixable.

The data structure is essentially an array of copies of the protected
data, which can be called bin 0, 1, 2, ..., N.  The data is versioned,
just like with seqcount.  Bin i contains the most recent copy of the
data that had a version number that's a multiple of 2^i, but any bin can
also be marked as invalid if it's being written.

To write: update all bins that need updating (that is 1 + num trailing
zeros in the new version number), starting at the highest number.

To read starting at bin i: try to read bin i (just like with a
seqcount).  If that fails, then recursively read starting at bin i+1.
As a double-check, re-try bin i.  If the retry fails but the recursive
read succeeded, return the value from the recursive read.

The only way this can fail is if you race with ~2^N writes.  You can try
to read in a loop to avoid this problem.

Unlike a seqcount, you need to race with more than 1 write, which
eliminates this deadlock -- writers have to make continuous progress for
readers to get stuck.  But it's extremely unlikely that a reader ever
has to loop.

--Andy
