Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996Ab3ETOil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 10:38:41 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:56918 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756749Ab3ETOic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 10:38:32 -0400
Date: Mon, 20 May 2013 07:37:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: [PATCH tip/core/rcu 0/8] v2 RCU callback-numbering simplifications
 for 3.11
Message-ID: <20130520143739.GA29365@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052014-7282-0000-0000-000017650C1F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series takes advantage of callback numbering to simplify RCU's
grace-period machinery, in some cases also reducing the number of
lock acquisitions (though the resulting change in performance is not
perceptible).  The individual patches are as follows:

1.	Move code to make way for the code-combining in later patches.
	This commit makes no changes, just moves code.

2.	Make __note_new_gpnum() also check for the ends of prior grace
	periods, thus eliminating the earlier possibility of a given
	CPU becoming aware of the start of the next grace period before
	becoming aware of the end of the previous grace period.  Yes,
	the code did handle this correctly, but now it doesn't need to.
	More important, now I don't need to think about how it handles
	this correctly.

3.	Rename note_new_gpnum() to note_gp_changes() in preparation for
	later merge of rcu_process_gp_end() into this function.

4.	Change calls to rcu_process_gp_end() to instead call
	note_gp_changes(), and also remove the now-used rcu_process_gp_end().

5.	Remove duplicate code by merging __rcu_process_gp_end() into
	__note_gp_changes().

6.	Eliminate now-redundant call to check_for_new_grace_period().  This
	leaves only a single caller, so inline check_for_new_grace_period().

7.	Given that rcu_start_gp_per_cpu() is a trivial wrapper function
	with only one caller, inline it into its sole remaining call site.

8.	Eliminate now-redundant call to note_gp_changes().

Changes since v1:

o	Added Reviewed-bys.

							Thanx, Paul

 b/kernel/rcutree.c        |  262 ++++++++++++++--------------------------------
 b/kernel/rcutree_plugin.h |    2 
 2 files changed, 85 insertions(+), 179 deletions(-)

