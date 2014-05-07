Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbaEGV7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 17:59:18 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:39119 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaEGV7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 17:59:17 -0400
Date: Wed, 7 May 2014 14:59:11 -0700
From: josh@joshtriplett.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 21/45] torture: Report diagnostics from
 qemu
Message-ID: <20140507215911.GM27924@cloud>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1398731133-18925-21-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398731133-18925-21-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 05:25:09PM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> The current script does record qemu diagnostics, but the user has to
> know where to look for them.  This commit therefore puts them into the
> Warnings file so that kvm-recheck.sh will display them.  This change is
> especially useful if you are in the habit of killing the qemu process
> when you realize that you messed something up, but then later on wonder
> why the process terminated early.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

A couple of issues below.

> @@ -172,6 +172,14 @@ do
>  		if test $kruntime -lt $seconds
>  		then
>  			echo Completed in $kruntime vs. $seconds >> $resdir/Warnings 2>&1
> +			grep "^(qemu) qemu:" $resdir/kvm-test-1-run.sh.out >> $resdir/Warnings 2>&1
> +			killpid="`grep "^(qemu) qemu: terminating on signal [0-9]* from pid" $resdir/kvm-test-1-run.sh.out`"

You already searched for lines like this and put them in Warnings in the
previous line, so you don't need to search the entire output.  Also, you
use grep here and sed below; you could just use sed here to directly
obtain the PID:

killpid="$(sed -n "s/^(qemu) qemu: terminating on signal [0-9]* from pid \([0-9]*\).*$/\1/p" $resdir/Warnings)"

> +			if test -n "$killpid"
> +			then
> +				pscmd="`echo $killpid | sed -e 's/^.*from pid/ps -ef | grep/'`"
> +				echo $pscmd >> $resdir/Warnings
> +				echo $pscmd | sh >> $resdir/Warnings 2>&1
> +			fi

Grepping for a PID is a bad idea; it'll turn up anything that contains
that PID anywhere on the line, including as a substring.  Given the
above change to obtain a numeric $killpid, you can instead pass the PID
to ps directly:
			if test -n "$killpid"
			then
				ps -fp $killpid >> $resdir/Warnings 2>&1
			fi

