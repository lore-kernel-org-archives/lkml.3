Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbaGBNr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 09:47:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297AbaGBNrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 09:47:25 -0400
Message-ID: <53B40D2B.7090406@redhat.com>
Date: Wed, 02 Jul 2014 09:46:19 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH RFC tip/core/rcu] Parallelize and economize NOCB kthread
 wakeups
References: <20140627142038.GA22942@linux.vnet.ibm.com> <20140702123412.GD19379@twins.programming.kicks-ass.net>
In-Reply-To: <20140702123412.GD19379@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 07/02/2014 08:34 AM, Peter Zijlstra wrote:
> On Fri, Jun 27, 2014 at 07:20:38AM -0700, Paul E. McKenney wrote:
>> An 80-CPU system with a context-switch-heavy workload can require
>> so many NOCB kthread wakeups that the RCU grace-period kthreads
>> spend several tens of percent of a CPU just awakening things.
>> This clearly will not scale well: If you add enough CPUs, the RCU
>> grace-period kthreads would get behind, increasing grace-period
>> latency.
>> 
>> To avoid this problem, this commit divides the NOCB kthreads into
>> leaders and followers, where the grace-period kthreads awaken the
>> leaders each of whom in turn awakens its followers.  By default,
>> the number of groups of kthreads is the square root of the number
>> of CPUs, but this default may be overridden using the
>> rcutree.rcu_nocb_leader_stride boot parameter. This reduces the
>> number of wakeups done per grace period by the RCU grace-period
>> kthread by the square root of the number of CPUs, but of course
>> by shifting those wakeups to the leaders.  In addition, because 
>> the leaders do grace periods on behalf of their respective
>> followers, the number of wakeups of the followers decreases by up
>> to a factor of two. Instead of being awakened once when new
>> callbacks arrive and again at the end of the grace period, the
>> followers are awakened only at the end of the grace period.
>> 
>> For a numerical example, in a 4096-CPU system, the grace-period
>> kthread would awaken 64 leaders, each of which would awaken its
>> 63 followers at the end of the grace period.  This compares
>> favorably with the 79 wakeups for the grace-period kthread on an
>> 80-CPU system.
> 
> Urgh, how about we kill the entire nocb nonsense and try again?
> This is getting quite rediculous.

Some observations.

First, the rcuos/N threads are NOT bound to CPU N at all, but are
free to float through the system.

Second, the number of RCU callbacks at the end of each grace period
is quite likely to be small most of the time.

This suggests that on a system with N CPUs, it may be perfectly
sufficient to have a much smaller number of rcuos threads.

One thread can probably handle the RCU callbacks for as many as
16, or even 64 CPUs...

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTtA0rAAoJEM553pKExN6D3IkIAKFZjAWhopcwPppzGWsT7OA/
3y7fnAvBcJ6AEwE1igzbJyCPjdOJECY/9iUdvuB9CbBD82kyfm4qnuREpdt+hqQp
Vi8EDB9UdyI2I42hbfRVOS4NgAl8ZYsDVQ+QiEM1cMp+LqEKPg7adwoNTPQL4eZn
ANcNh3B3eSpxnZ+ZbEBYJmQXIVP2S5t5M/EMizqUJEBI2/2zB68eeFkgvuW1yg1a
/J4L9w+Iqbu+is+6JK9ibQAR/tTS6Exmuc6RnKDH/nkj1jefKdH1z2p+r69u4AK1
JVDl40lra4n6XHsfjDWDHDXBsiD/JDJJ6Zxf77NWwg1aRT77HZPiMOu98hpFxWs=
=OSUn
-----END PGP SIGNATURE-----
