Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab3FRL4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:56:48 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:36259 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585Ab3FRL4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:56:45 -0400
Message-ID: <51C04AFE.3010201@imag.fr>
Date: Tue, 18 Jun 2013 13:56:46 +0200
From: Nicolas Palix <nicolas.palix@imag.fr>
Organization: UJF Polytech / LIG
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130216 Thunderbird/17.0.3
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Gilles Muller <Gilles.Muller@lip6.fr>, linux-doc@vger.kernel.org,
        cocci@systeme.lip6.fr, Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH] coccicheck: span checks across CPUs
References: <20130617230655.GA21273@www.outflux.net>
In-Reply-To: <20130617230655.GA21273@www.outflux.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kees,

This is indeed something that was on my TO-DO list! :)
Thank you a lot.

Could you consider merging with the following or
something equivalent for handling running spatch processes
when make is interrupted ?

For the resubmission, please add Michal Marek (in CC)
who will apply it to the misc branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git

Regards,

diff --git a/scripts/coccicheck b/scripts/coccicheck
index a222e92..907f11e 100755
--- a/scripts/coccicheck
+++ b/scripts/coccicheck
@@ -2,6 +2,17 @@

 SPATCH="`which ${SPATCH:=spatch}`"

+trap kill_running SIGTERM SIGINT
+declare -a SPATCH_RUN
+
+kill_running() {
+       for i in $(seq 0 $(( NPROC - 1)) ); do
+               if [ $V -eq 2 ] ; then echo "Killing ${SPATCH_RUN[$i]}" ; fi
+               kill ${SPATCH_RUN[$i]}
+       done
+       wait
+}
+
 # The verbosity may be set by the environmental parameter V=
 # as for example with 'make V=1 coccicheck'

@@ -80,7 +91,9 @@ run_cmd() {
                echo "Running ($NPROC in parallel): $@"
        fi
        for i in $(seq 0 $(( NPROC - 1)) ); do
-               eval $@ -max $NPROC -index $i &
+               eval "$@ -max $NPROC -index $i &"
+               SPATCH_RUN[$i]=$!
+               if [ $V -eq 2 ] ; then echo "${SPATCH_RUN[$i]} running" ; fi
        done
        wait
 }

Le 6/18/13 1:06 AM, Kees Cook a écrit :
> This adds parallelism by default to the "coccicheck" target using
> spatch's "-max" and "-index" arguments.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  Documentation/coccinelle.txt |    5 +++++
>  scripts/coccicheck           |   14 ++++++++++++--
>  2 files changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/coccinelle.txt b/Documentation/coccinelle.txt
> index 18de785..408439d 100644
> --- a/Documentation/coccinelle.txt
> +++ b/Documentation/coccinelle.txt
> @@ -91,6 +91,11 @@ To enable verbose messages set the V= variable, for example:
>  
>     make coccicheck MODE=report V=1
>  
> +By default, coccicheck tries to run as parallel as possible. To change
> +the parallelism, set the J= variable. For example, to run across 4 CPUs:
> +
> +   make coccicheck MODE=report J=4
> +
>  
>   Using Coccinelle with a single semantic patch
>  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> diff --git a/scripts/coccicheck b/scripts/coccicheck
> index 06fcb33..077e5b2 100755
> --- a/scripts/coccicheck
> +++ b/scripts/coccicheck
> @@ -11,6 +11,12 @@ else
>  	VERBOSE=0
>  fi
>  
> +if [ -z "$J" ]; then
> +	NPROC=$(getconf _NPROCESSORS_ONLN)
> +else
> +	NPROC="$J"
> +fi
> +
>  FLAGS="$SPFLAGS -very_quiet"
>  
>  # spatch only allows include directories with the syntax "-I include"
> @@ -61,10 +67,14 @@ if [ "$ONLINE" = "0" ] ; then
>  fi
>  
>  run_cmd() {
> +	local i
>  	if [ $VERBOSE -ne 0 ] ; then
> -		echo "Running: $@"
> +		echo "Running ($NPROC in parallel): $@"
>  	fi
> -	eval $@
> +	for i in $(seq 0 $(( NPROC - 1)) ); do
> +		eval $@ -max $NPROC -index $i &
> +	done
> +	wait
>  }
>  
>  
> 

