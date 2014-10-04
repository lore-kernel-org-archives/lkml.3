Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398AbaJDTCr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 15:02:47 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:39577 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbaJDTCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 15:02:46 -0400
X-Originating-IP: 50.43.33.188
Date: Sat, 4 Oct 2014 12:02:37 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcutorture: Remove obsolete kversion param in kvm.sh
Message-ID: <20141004190237.GA15520@thin>
References: <1412442255-3685-1-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412442255-3685-1-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 04, 2014 at 01:04:15PM -0400, Pranith Kumar wrote:
> Now that we have removed configs based on kernel version, we can also remove the
> kversion parameter in kvm.sh.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  .../selftests/rcutorture/bin/kvm-test-1-run.sh        |  2 +-
>  tools/testing/selftests/rcutorture/bin/kvm.sh         | 19 +++++--------------
>  2 files changed, 6 insertions(+), 15 deletions(-)
> 
> diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
> index e0f8969..8ca9f21 100755
> --- a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
> +++ b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
> @@ -45,7 +45,7 @@ trap 'rm -rf $T' 0
>  touch $T
>  
>  . $KVM/bin/functions.sh
> -. $KVPATH/ver_functions.sh
> +. $CONFIGFRAG/ver_functions.sh
>  
>  config_template=${1}
>  config_dir=`echo $config_template | sed -e 's,/[^/]*$,,'`
> diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
> index e527dc9..368d64a 100755
> --- a/tools/testing/selftests/rcutorture/bin/kvm.sh
> +++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
> @@ -47,7 +47,6 @@ resdir=""
>  configs=""
>  cpus=0
>  ds=`date +%Y.%m.%d-%H:%M:%S`
> -kversion=""
>  
>  . functions.sh
>  
> @@ -64,7 +63,6 @@ usage () {
>  	echo "       --duration minutes"
>  	echo "       --interactive"
>  	echo "       --kmake-arg kernel-make-arguments"
> -	echo "       --kversion vN.NN"
>  	echo "       --mac nn:nn:nn:nn:nn:nn"
>  	echo "       --no-initrd"
>  	echo "       --qemu-args qemu-system-..."
> @@ -128,11 +126,6 @@ do
>  		TORTURE_KMAKE_ARG="$2"
>  		shift
>  		;;
> -	--kversion)
> -		checkarg --kversion "(kernel version)" $# "$2" '^v[0-9.]*$' '^error'
> -		kversion=$2
> -		shift
> -		;;
>  	--mac)
>  		checkarg --mac "(MAC address)" $# "$2" '^\([0-9a-fA-F]\{2\}:\)\{5\}[0-9a-fA-F]\{2\}$' error
>  		TORTURE_QEMU_MAC=$2
> @@ -170,11 +163,10 @@ do
>  done
>  
>  CONFIGFRAG=${KVM}/configs/${TORTURE_SUITE}; export CONFIGFRAG
> -KVPATH=${CONFIGFRAG}/$kversion; export KVPATH
>  
>  if test -z "$configs"
>  then
> -	configs="`cat $CONFIGFRAG/$kversion/CFLIST`"
> +	configs="`cat $CONFIGFRAG/CFLIST`"
>  fi
>  
>  if test -z "$resdir"
> @@ -186,10 +178,10 @@ fi
>  touch $T/cfgcpu
>  for CF in $configs
>  do
> -	if test -f "$CONFIGFRAG/$kversion/$CF"
> +	if test -f "$CONFIGFRAG/$CF"
>  	then
> -		cpu_count=`configNR_CPUS.sh $CONFIGFRAG/$kversion/$CF`
> -		cpu_count=`configfrag_boot_cpus "$TORTURE_BOOTARGS" "$CONFIGFRAG/$kversion/$CF" "$cpu_count"`
> +		cpu_count=`configNR_CPUS.sh $CONFIGFRAG/$CF`
> +		cpu_count=`configfrag_boot_cpus "$TORTURE_BOOTARGS" "$CONFIGFRAG/$CF" "$cpu_count"`
>  		echo $CF $cpu_count >> $T/cfgcpu
>  	else
>  		echo "The --configs file $CF does not exist, terminating."
> @@ -252,7 +244,6 @@ END {
>  cat << ___EOF___ > $T/script
>  CONFIGFRAG="$CONFIGFRAG"; export CONFIGFRAG
>  KVM="$KVM"; export KVM
> -KVPATH="$KVPATH"; export KVPATH
>  PATH="$PATH"; export PATH
>  TORTURE_BOOT_IMAGE="$TORTURE_BOOT_IMAGE"; export TORTURE_BOOT_IMAGE
>  TORTURE_BUILDONLY="$TORTURE_BUILDONLY"; export TORTURE_BUILDONLY
> @@ -285,7 +276,7 @@ then
>  fi
>  ___EOF___
>  awk < $T/cfgcpu.pack \
> -	-v CONFIGDIR="$CONFIGFRAG/$kversion/" \
> +	-v CONFIGDIR="$CONFIGFRAG/" \
>  	-v KVM="$KVM" \
>  	-v ncpus=$cpus \
>  	-v rd=$resdir/$ds/ \
> -- 
> 1.9.1
> 
