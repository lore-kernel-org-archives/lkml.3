Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbaEHAHw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 20:07:52 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:45582 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbaEHAHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 20:07:51 -0400
Date: Wed, 7 May 2014 17:07:44 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: josh@joshtriplett.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 18/45] torture: Make "--dryrun script" use
 same environment as normal run
Message-ID: <20140508000744.GW8754@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1398731133-18925-18-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140507213327.GJ27924@cloud>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140507213327.GJ27924@cloud>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050800-6688-0000-0000-000001A738C9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 02:33:27PM -0700, josh@joshtriplett.org wrote:
> On Mon, Apr 28, 2014 at 05:25:06PM -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > In a normal torture-test run, the script inherits its environment
> > variables, but this does not work when producing a script that is
> > to run later.  Therefore, definitions and exports are prepended to
> > a dryrun script but not to a script that is run immediately.  This
> > commit reconciles this by placing definitions and exports at the
> > beginning of the script in both cases.
> 
> Cleanup idea, not needed in this commit: This has gotten sufficiently
> long to warrant a loop over a list of environment variables, or possibly
> a loop over all environment variable starting with TORTURE_* .

Makes sense on both counts, thank you!  Give or take quoting, anyway!  ;-)

							Thanx, Paul

> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> 
> > ---
> >  tools/testing/selftests/rcutorture/bin/kvm.sh | 28 ++++++++++++---------------
> >  1 file changed, 12 insertions(+), 16 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
> > index 8aa62a2dccb5..93a6c5a8517d 100644
> > --- a/tools/testing/selftests/rcutorture/bin/kvm.sh
> > +++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
> > @@ -241,8 +241,19 @@ END {
> >  
> >  # Generate a script to execute the tests in appropriate batches.
> >  cat << ___EOF___ > $T/script
> > -TORTURE_SUITE="$TORTURE_SUITE"; export TORTURE_SUITE
> > +CONFIGFRAG="$CONFIGFRAG"; export CONFIGFRAG
> > +KVM="$KVM"; export KVM
> > +KVPATH="$KVPATH"; export KVPATH
> > +PATH="$PATH"; export PATH
> > +TORTURE_BUILDONLY="$TORTURE_BUILDONLY"; export TORTURE_BUILDONLY
> >  TORTURE_DEFCONFIG="$TORTURE_DEFCONFIG"; export TORTURE_DEFCONFIG
> > +TORTURE_INITRD="$TORTURE_INITRD"; export TORTURE_INITRD
> > +TORTURE_KMAKE_ARG="$TORTURE_KMAKE_ARG"; export TORTURE_KMAKE_ARG
> > +TORTURE_QEMU_CMD="$TORTURE_QEMU_CMD"; export TORTURE_QEMU_CMD
> > +TORTURE_QEMU_INTERACTIVE="$TORTURE_QEMU_INTERACTIVE";
> > +	export TORTURE_QEMU_INTERACTIVE
> > +TORTURE_QEMU_MAC="$TORTURE_QEMU_MAC"; export TORTURE_QEMU_MAC
> > +TORTURE_SUITE="$TORTURE_SUITE"; export TORTURE_SUITE
> >  if ! test -e $resdir
> >  then
> >  	mkdir -p "$resdir" || :
> > @@ -371,21 +382,6 @@ ___EOF___
> >  
> >  if test "$dryrun" = script
> >  then
> > -	# Dump out the script, but define the environment variables that
> > -	# it needs to run standalone.
> > -	echo CONFIGFRAG="$CONFIGFRAG; export CONFIGFRAG"
> > -	echo KVM="$KVM; export KVM"
> > -	echo KVPATH="$KVPATH; export KVPATH"
> > -	echo PATH="$PATH; export PATH"
> > -	echo TORTURE_BUILDONLY="$TORTURE_BUILDONLY; export TORTURE_BUILDONLY"
> > -	echo TORTURE_INITRD="$TORTURE_INITRD; export TORTURE_INITRD"
> > -	echo TORTURE_KMAKE_ARG="$TORTURE_KMAKE_ARG; export TORTURE_KMAKE_ARG"
> > -	echo TORTURE_QEMU_CMD="$TORTURE_QEMU_CMD; export TORTURE_QEMU_CMD"
> > -	echo TORTURE_QEMU_INTERACTIVE="$TORTURE_QEMU_INTERACTIVE;
> > -		export TORTURE_QEMU_INTERACTIVE"
> > -	echo TORTURE_QEMU_MAC="$TORTURE_QEMU_MAC; export TORTURE_QEMU_MAC"
> > -	echo "mkdir -p "$resdir" || :"
> > -	echo "mkdir $resdir/$ds"
> >  	cat $T/script
> >  	exit 0
> >  elif test "$dryrun" = sched
> > -- 
> > 1.8.1.5
> > 
> 

