Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391Ab3HTLPc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 07:15:32 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:60576 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab3HTLPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 07:15:31 -0400
Date: Tue, 20 Aug 2013 14:14:26 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Subject: [sched next] overflowed cpu time for kernel threads in /proc/PID/stat
Message-ID: <20130820111426.GA27828@swordfish.datadirectnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
3.11.0-rc6-next-20130820

at some point an overflowed cpu time is reported in /proc/PID/stat

cat /proc/10/stat
10 (rcu_preempt) S 2 0 0 0 -1 2129984 0 0 0 0 0 406 0 0 20 0 1 0 10 0 0 18446744073709551615 0 0 0 0 0 0 0 2147483647 0 18446744073709551615 0 0 17 0 0 0 0 0 0 0 0 0 0 0 0 0 0
cat /proc/10/stat
10 (rcu_preempt) S 2 0 0 0 -1 2129984 0 0 0 0 0 406 0 0 20 0 1 0 10 0 0 18446744073709551615 0 0 0 0 0 0 0 2147483647 0 18446744073709551615 0 0 17 0 0 0 0 0 0 0 0 0 0 0 0 0 0
cat /proc/10/stat
10 (rcu_preempt) S 2 0 0 0 -1 2129984 0 0 0 0 0 407 0 0 20 0 1 0 10 0 0 18446744073709551615 0 0 0 0 0 0 0 2147483647 0 18446744073709551615 0 0 17 0 0 0 0 0 0 0 0 0 0 0 0 0 0
cat /proc/10/stat
10 (rcu_preempt) S 2 0 0 0 -1 2129984 0 0 0 0 0 407 0 0 20 0 1 0 10 0 0 18446744073709551615 0 0 0 0 0 0 0 2147483647 0 18446744073709551615 0 0 17 0 0 0 0 0 0 0 0 0 0 0 0 0 0
cat /proc/10/stat
10 (rcu_preempt) S 2 0 0 0 -1 2129984 0 0 0 0 1844674407370 477 0 0 20 0 1 0 10 0 0 18446744073709551615 0 0 0 0 0 0 0 2147483647 0 18446744073709551615 0 0 17 0 0 0 0 0 0 0 0 0 0 0 0 0 0
						^^^^^^^^^
cat /proc/10/stat
10 (rcu_preempt) S 2 0 0 0 -1 2129984 0 0 0 0 1844674407370 597 0 0 20 0 1 0 10 0 0 18446744073709551615 0 0 0 0 0 0 0 2147483647 0 18446744073709551615 0 0 17 0 0 0 0 0 0 0 0 0 0 0 0 0 0

(seems there are several more -1UL in output)


oddly enough, I see this happening only for RCU

 ps aux | grep rcu
 root         8  0.0  0.0      0     0 ?        S    12:42   0:00  [rcuc/0]
 root         9  0.0  0.0      0     0 ?        S    12:42   0:00  [rcub/0]
 root        10 62422329  0.0  0     0 ?        R    12:42 21114581:37  [rcu_preempt]
 root        11  0.1  0.0      0     0 ?        S    12:42   0:02  [rcuop/0]
 root        12 62422329  0.0  0     0 ?        S    12:42 21114581:35  [rcuop/1]

	-ss
