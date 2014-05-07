Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbaEGXwr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 19:52:47 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:34903 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbaEGXwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 19:52:45 -0400
Date: Wed, 7 May 2014 16:52:40 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: josh@joshtriplett.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 07/45] torture: Allow variations of
 "defconfig" to be specified
Message-ID: <20140507235240.GQ8754@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1398731133-18925-7-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140507212219.GC27924@cloud>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140507212219.GC27924@cloud>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050723-3532-0000-0000-00000197929E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 02:22:19PM -0700, josh@joshtriplett.org wrote:
> On Mon, Apr 28, 2014 at 05:24:55PM -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > Some environments require some variation on "make defconfig" to initialize
> > the .config file.  This commit therefore adds a --defconfig argument to
> > allow this to be specified.  The default value is of course "defconfig".
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> <bikeshed color="blue">
> "--defconfig randconfig" or "--defconfig allyesconfig" or similar seems
> rather odd; how about calling it --kconfig or similar?
> </bikeshed>

Some day I am going to have to feed that to a browser and see what
happens.  ;-)

I must confess that I hadn't considered feeding randconfig or allyesconfig
to that argument, partly because I figured that I would have to also
supply Kconfig constraints in those cases in order to ensure that the
resulting kernel would actually run under qemu.  I was instead thinking
in terms of a --configs option beginning with "RAND", which would pick
up the Kconfig constraints from the appropriate configs directory,
for example:

	tools/testing/selftests/rcutorture/configs/rcu/RAND1

That said, I haven't thought that far down that path.

So for the --defconfig argument, I was thinking more in terms of things
like pseries_defconfig or versatile_defconfig.

							Thanx, Paul

> >  tools/testing/selftests/rcutorture/bin/configinit.sh | 2 +-
> >  tools/testing/selftests/rcutorture/bin/kvm.sh        | 8 ++++++++
> >  2 files changed, 9 insertions(+), 1 deletion(-)
> > 
> > diff --git a/tools/testing/selftests/rcutorture/bin/configinit.sh b/tools/testing/selftests/rcutorture/bin/configinit.sh
> > index a1be6e62add1..9c3f3d39b934 100755
> > --- a/tools/testing/selftests/rcutorture/bin/configinit.sh
> > +++ b/tools/testing/selftests/rcutorture/bin/configinit.sh
> > @@ -62,7 +62,7 @@ grep '^grep' < $T/u.sh > $T/upd.sh
> >  echo "cat - $c" >> $T/upd.sh
> >  make mrproper
> >  make $buildloc distclean > $builddir/Make.distclean 2>&1
> > -make $buildloc defconfig > $builddir/Make.defconfig.out 2>&1
> > +make $buildloc $TORTURE_DEFCONFIG > $builddir/Make.defconfig.out 2>&1
> >  mv $builddir/.config $builddir/.config.sav
> >  sh $T/upd.sh < $builddir/.config.sav > $builddir/.config
> >  cp $builddir/.config $builddir/.config.new
> > diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
> > index a52a077ee258..59945b7793d9 100644
> > --- a/tools/testing/selftests/rcutorture/bin/kvm.sh
> > +++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
> > @@ -38,6 +38,7 @@ dur=30
> >  dryrun=""
> >  KVM="`pwd`/tools/testing/selftests/rcutorture"; export KVM
> >  PATH=${KVM}/bin:$PATH; export PATH
> > +TORTURE_DEFCONFIG=defconfig
> >  TORTURE_INITRD="$KVM/initrd"; export TORTURE_INITRD
> >  RCU_KMAKE_ARG=""; export RCU_KMAKE_ARG
> >  TORTURE_SUITE=rcu
> > @@ -56,6 +57,7 @@ usage () {
> >  	echo "       --configs \"config-file list\""
> >  	echo "       --cpus N"
> >  	echo "       --datestamp string"
> > +	echo "       --defconfig string"
> >  	echo "       --dryrun sched|script"
> >  	echo "       --duration minutes"
> >  	echo "       --interactive"
> > @@ -96,6 +98,11 @@ do
> >  		ds=$2
> >  		shift
> >  		;;
> > +	--defconfig)
> > +		checkarg --defconfig "defconfigtype" "$#" "$2" '^[^/][^/]*$' '^--'
> > +		TORTURE_DEFCONFIG=$2
> > +		shift
> > +		;;
> >  	--dryrun)
> >  		checkarg --dryrun "sched|script" $# "$2" 'sched\|script' '^--'
> >  		dryrun=$2
> > @@ -259,6 +266,7 @@ END {
> >  # Generate a script to execute the tests in appropriate batches.
> >  cat << ___EOF___ > $T/script
> >  TORTURE_SUITE="$TORTURE_SUITE"; export TORTURE_SUITE
> > +TORTURE_DEFCONFIG="$TORTURE_DEFCONFIG"; export TORTURE_DEFCONFIG
> >  ___EOF___
> >  awk < $T/cfgcpu.pack \
> >  	-v CONFIGDIR="$CONFIGFRAG/$kversion/" \
> > -- 
> > 1.8.1.5
> > 
> 

