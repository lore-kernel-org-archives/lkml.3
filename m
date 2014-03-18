Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbaCRCRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 22:17:23 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:55469 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996AbaCRCRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 22:17:12 -0400
Date: Mon, 17 Mar 2014 19:17:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, josh@joshtriplett.org, laijs@cn.fujitsu.com,
        linux-kernel@vger.kernel.org
Subject: Re: cond_resched() and RCU CPU stall warnings
Message-ID: <20140318021706.GE4420@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140316015914.GA22102@linux.vnet.ibm.com>
 <20140317101300.GA27965@twins.programming.kicks-ass.net>
 <20140317165806.GG21124@linux.vnet.ibm.com>
 <20140317171434.GJ25546@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140317171434.GJ25546@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031802-3532-0000-0000-0000006311AA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 06:14:34PM +0100, Peter Zijlstra wrote:
> On Mon, Mar 17, 2014 at 09:58:07AM -0700, Paul E. McKenney wrote:
> > @@ -4111,6 +4115,7 @@ int __sched __cond_resched_softirq(void)
> >  {
> >  	BUG_ON(!in_softirq());
> >  
> > +	rcu_cond_resched();
> 
> Don't you have to enable BHs before doing that? And if not; that needs a
> comment for sure! :-)

No need to enable BHs, just RCU marking quiescent states.  But yes,
the name does look a bit scary in that context, doesn't it?  Added
a comment, please see below for updated patch.

> >  	if (should_resched()) {
> >  		local_bh_enable();
> >  		__cond_resched();
> > 

------------------------------------------------------------------------

torture: Better summary diagnostics for build failures

The reaction of kvm-recheck.sh is obscure at best, and easy to miss
completely.  This commit therefore prints "BUG: Build failed" in the
summary at the end of a run.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/tools/testing/selftests/rcutorture/bin/kvm-recheck-lock.sh b/tools/testing/selftests/rcutorture/bin/kvm-recheck-lock.sh
index 829186e19eb1..7f1ff1a8fc4b 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-recheck-lock.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-recheck-lock.sh
@@ -35,7 +35,7 @@ configfile=`echo $i | sed -e 's/^.*\///'`
 ncs=`grep "Writes:  Total:" $i/console.log 2> /dev/null | tail -1 | sed -e 's/^.* Total: //' -e 's/ .*$//'`
 if test -z "$ncs"
 then
-	echo $configfile
+	echo "$configfile -------"
 else
 	title="$configfile ------- $ncs acquisitions/releases"
 	dur=`sed -e 's/^.* locktorture.shutdown_secs=//' -e 's/ .*$//' < $i/qemu-cmd 2> /dev/null`
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-recheck-rcu.sh b/tools/testing/selftests/rcutorture/bin/kvm-recheck-rcu.sh
index d75b1dc5ae53..307c4b95f325 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-recheck-rcu.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-recheck-rcu.sh
@@ -35,7 +35,7 @@ configfile=`echo $i | sed -e 's/^.*\///'`
 ngps=`grep ver: $i/console.log 2> /dev/null | tail -1 | sed -e 's/^.* ver: //' -e 's/ .*$//'`
 if test -z "$ngps"
 then
-	echo $configfile
+	echo "$configfile -------"
 else
 	title="$configfile ------- $ngps grace periods"
 	dur=`sed -e 's/^.* rcutorture.shutdown_secs=//' -e 's/ .*$//' < $i/qemu-cmd 2> /dev/null`
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh b/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
index 26d78b7eaccf..ee1f6cae3d70 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
@@ -25,6 +25,7 @@
 # Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
 
 PATH=`pwd`/tools/testing/selftests/rcutorture/bin:$PATH; export PATH
+. tools/testing/selftests/rcutorture/bin/functions.sh
 for rd in "$@"
 do
 	firsttime=1
@@ -39,13 +40,24 @@ do
 		fi
 		TORTURE_SUITE="`cat $i/../TORTURE_SUITE`"
 		kvm-recheck-${TORTURE_SUITE}.sh $i
-		configcheck.sh $i/.config $i/ConfigFragment
-		parse-build.sh $i/Make.out $configfile
-		parse-torture.sh $i/console.log $configfile
-		parse-console.sh $i/console.log $configfile
-		if test -r $i/Warnings
+		if test -f "$i/console.log"
 		then
-			cat $i/Warnings
+			configcheck.sh $i/.config $i/ConfigFragment
+			parse-build.sh $i/Make.out $configfile
+			parse-torture.sh $i/console.log $configfile
+			parse-console.sh $i/console.log $configfile
+			if test -r $i/Warnings
+			then
+				cat $i/Warnings
+			fi
+		else
+			if test -f "$i/qemu-cmd"
+			then
+				print_bug qemu failed
+			else
+				print_bug Build failed
+			fi
+			echo "   $i"
 		fi
 	done
 done
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
index 7a95f86cc85a..51c34a91a375 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
@@ -106,6 +106,7 @@ then
 	fi
 else
 	cp $builddir/Make*.out $resdir
+	cp $builddir/.config $resdir || :
 	echo Build failed, not running KVM, see $resdir.
 	if test -f $builddir.wait
 	then

