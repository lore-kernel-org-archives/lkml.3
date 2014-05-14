Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbaENFR7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 01:17:59 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:42861 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbaENFR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 01:17:57 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
        eranian@google.com, jolsa@redhat.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 5/9] perf, tools: Add perf download to download event files v2
References: <1399935074-25167-1-git-send-email-andi@firstfloor.org>
	<1399935074-25167-6-git-send-email-andi@firstfloor.org>
Date: Wed, 14 May 2014 14:17:55 +0900
In-Reply-To: <1399935074-25167-6-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Mon, 12 May 2014 15:51:10 -0700")
Message-ID: <87zjilkkfw.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2014 15:51:10 -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> Add a downloader to automatically download the right
> files from a download site.
>
> This is implemented as a script calling wget, similar to
> perf archive. The perf driver automatically calls the right
> binary. The downloader is extensible, but currently only
> implements an Intel event download.  It would be straightforward
> to add other sites too for other vendors.
>
> The downloaded event files are put into ~/.cache/pmu-events, where the
> builtin event parser in util/* can find them automatically.
>
> Cc: Use ~/.cache

???


[SNIP]
> @@ -0,0 +1,52 @@
> +#!/bin/bash
> +# download event files for current cpu for perf
> +
> +WGETOPT=${WGETOPT:---no-verbose --timeout 5}

Could you please extend this script to support curl also?  It seems the
wget is not installed by default on my system.

> +
> +set -e
> +
> +if [ "$1" == "" ] ; then
> +	S=$(awk '
> +/^vendor/     		{ V=$3 }
> +/^model/ && $2 == ":" 	{ M=$3 }
> +/^cpu family/ 		{ F = $4 }

Inconsistency in using whitespace..

Thanks,
Namhyung


> +END	      { printf("%s-%s-%X", V, F, M) }' /proc/cpuinfo)
> +else
> +	S="$1"
> +fi
> +V=$(echo $S  | ( IFS=- read v f m ; echo $v) )
> +
> +CACHEDIR=${XDG_CACHE_HOME:-~/.cache}
> +[ ! -d $CACHEDIR/pmu-events ] && mkdir -p $CACHEDIR/pmu-events
> +cd $CACHEDIR/pmu-events
> +
> +case "$V" in
> +GenuineIntel)
> +	echo "Downloading models file"
> +	URLBASE=${URLBASE:-https://download.01.org/perfmon}
> +	MAPFILE=${MAPFILE:-mapfile.csv}
> +	echo "Downloading readme.txt"
> +	wget -N $WGETOPT $URLBASE/readme.txt
> +	;;
> +
> +# Add more CPU vendors here
> +
> +*)
> +	echo "Unsupported CPU vendor $V"
> +	exit 1
> +	;;
> +esac
> +
> +wget -N $WGETOPT $URLBASE/$MAPFILE
> +
> +echo "Downloading events file"
> +awk -v urlbase=$URLBASE -v cpu="$S" -F, \
> +	'$1 == cpu && $4 == "core" { print urlbase $3; exit 0 }' \
> +	$MAPFILE > url$$
> +if [ -s url$$ ] ; then
> +	wget $WGETOPT -q -i url$$ -O $S-core.json
> +else
> +	echo "CPU $S not found"
> +fi
> +rm -f url$$
> +
