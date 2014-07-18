Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932563AbaGRG2o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 02:28:44 -0400
Received: from ozlabs.org ([103.22.144.67]:36158 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753615AbaGRG2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 02:28:43 -0400
Message-ID: <1405664920.17297.4.camel@concordia>
Subject: Re: [PATCH 07/11] perf, tools: Add perf download to download event
 files
From: Michael Ellerman <mpe@ellerman.id.au>
To: Andi Kleen <andi@firstfloor.org>
Cc: jolsa@redhat.com, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        acme@infradead.org, Andi Kleen <ak@linux.intel.com>
Date: Fri, 18 Jul 2014 16:28:40 +1000
In-Reply-To: <1405123165-22666-8-git-send-email-andi@firstfloor.org>
References: <1405123165-22666-1-git-send-email-andi@firstfloor.org>
	 <1405123165-22666-8-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-11 at 16:59 -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Add a downloader to automatically download the right
> files from a download site.
...
> diff --git a/tools/perf/Documentation/perf-download.txt b/tools/perf/Documentation/perf-download.txt
> new file mode 100644
> index 0000000..9e5b28e
> --- /dev/null
> +++ b/tools/perf/Documentation/perf-download.txt
> @@ -0,0 +1,31 @@
> +perf-download(1)
> +===============
> +
> +NAME
> +----
> +perf-download - Download event files for current CPU.
> +
> +SYNOPSIS
> +--------
> +[verse]
> +'perf download' [vendor-family-model]

Can you make that arch agnostic? eg:

> +'perf download' [cpu-identifier]

> diff --git a/tools/perf/perf-download.sh b/tools/perf/perf-download.sh
> new file mode 100755
> index 0000000..269dc96
> --- /dev/null
> +++ b/tools/perf/perf-download.sh
> @@ -0,0 +1,57 @@
> +#!/bin/bash
> +# download event files for current cpu for perf
> +
> +CURLOPT=${CURLOPT:- --max-time 5 -#}
> +
> +set -e
> +
> +if ! type curl > /dev/null ; then
> +	echo "please install curl"
> +	exit 1
> +fi
> +
> +if [ "$1" == "" ] ; then
> +	S=$(awk '
> +/^vendor/     		{ V=$3 }
> +/^model/ && $2 == ":" 	{ M=$3 }
> +/^cpu family/ 		{ F = $4 }
> +END	      		{ printf("%s-%s-%X", V, F, M) }' /proc/cpuinfo)
> +else
> +	S="$1"
> +fi
> +V=$(echo $S  | ( IFS=- read v f m ; echo $v) )

This obviously needs a bit of work to support other arches. I'm thinking we use
uname -m to do a top level switch? eg:

  ARCH=$(uname -m | sed -e s/i.86/i386/ -e s/ppc.*/powerpc/)
  
  if [ "$ARCH" == "x86_64" ] || [ "$ARCH" == "i386" ]; then
          S=$(awk '/^vendor/              { V=$3 }
                   /^model/ && $2 == ":"  { M=$3 }
                   /^cpu family/          { F = $4 }
                   END                    { printf("%s-%s-%X", V, F, M) }' /proc/cpuinfo)
  elif [ "$ARCH" == "powerpc" ]; then
          ...
  fi

> +case "$V" in
> +GenuineIntel)
> +	echo "Downloading models file"
> +	URLBASE=${URLBASE:-https://download.01.org/perfmon}
> +	MAPFILE=${MAPFILE:-mapfile.csv}
> +	echo "Downloading readme.txt"
> +	curl $CURLOPT $URLBASE/readme.txt -o readme.txt
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
> +curl $CURLOPT $URLBASE/$MAPFILE -o $MAPFILE
> +
> +echo "Downloading events file"
> +awk -v urlbase=$URLBASE -v cpu="$S" -F, \
> +	'$1 == cpu && $4 == "core" { print "url = \"" urlbase $3 "\""; exit 0 }' \
> +	$MAPFILE > url$$
> +if [ -s url$$ ] ; then
> +	curl $CURLOPT -K url$$ -o $S-core.json
> +else
> +	echo "CPU $S not found"
> +fi

I'm not 100% sure, but I think we will want to use our PVR register as the
lookup key. That's just a hex value, with major and minor versions.

To make that work I think we will want a loop in the map lookup to handle
chopping off the low bits.

So for example it would check the MAPFILE for:
  003e0301
  003e030
  003e03
  003e0

etc.

So we might need another arch specific chunk in there.

cheers


