Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab3GAIY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 04:24:27 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38662 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969Ab3GAIYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 04:24:25 -0400
Date: Mon, 1 Jul 2013 10:24:18 +0200
From: Borislav Petkov <bp@alien8.de>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Robert Richter <rric@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@calxeda.com>
Subject: Re: [PATCH] perf tools: Fix perf version generation
Message-ID: <20130701082417.GA23539@pd.tnic>
References: <1368006214-12912-1-git-send-email-rric@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1368006214-12912-1-git-send-email-rric@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey acme,

is this one in some queue already?

I just saw the same problem on 3.10 because git-tag sorts the output
alphanumerically so that all tags starting with "v3.10" do not appear
last and thus the "tail -1" doesn't work anymore.

So on 3.10 you end up with perf version 3.9.rc8.g8bb495.

On Wed, May 08, 2013 at 11:43:34AM +0200, Robert Richter wrote:
> From: Robert Richter <robert.richter@calxeda.com>
> 
> The tag of the perf version is wrongly determined, always the latest
> tag is taken regardless of the HEAD commit:
> 
>  $ perf --version
>  perf version 3.9.rc8.gd7f5d3
>  $ git describe d7f5d3
>  v3.9-rc7-154-gd7f5d33
>  $ head -n 4 Makefile
>  VERSION = 3
>  PATCHLEVEL = 9
>  SUBLEVEL = 0
>  EXTRAVERSION = -rc7
> 
> In other cases no tag might be found.
> 
> This patch fixes this.
> 
> This new implementation handles also the case if there are no tags at
> all found in the git repo but there is a commit id.
> 
> Signed-off-by: Robert Richter <robert.richter@calxeda.com>
> ---
>  tools/perf/util/PERF-VERSION-GEN | 21 +++++++++++++++------
>  1 file changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/perf/util/PERF-VERSION-GEN b/tools/perf/util/PERF-VERSION-GEN
> index 055fef3..15a77b7 100755
> --- a/tools/perf/util/PERF-VERSION-GEN
> +++ b/tools/perf/util/PERF-VERSION-GEN
> @@ -13,13 +13,22 @@ LF='
>  # First check if there is a .git to get the version from git describe
>  # otherwise try to get the version from the kernel Makefile
>  #
> -if test -d ../../.git -o -f ../../.git &&
> -	VN=$(git tag 2>/dev/null | tail -1 | grep -E "v[0-9].[0-9]*")
> +CID=
> +TAG=
> +if test -d ../../.git -o -f ../../.git
>  then
> -	VN=$(echo $VN"-g"$(git log -1 --abbrev=4 --pretty=format:"%h" HEAD))
> -	VN=$(echo "$VN" | sed -e 's/-/./g');
> -else
> -	VN=$(MAKEFLAGS= make -sC ../.. kernelversion)
> +	TAG=$(git describe --abbrev=0 --match "v[0-9].[0-9]*" 2>/dev/null )
> +	CID=$(git log -1 --abbrev=4 --pretty=format:"%h" 2>/dev/null) && CID="-g$CID"
> +fi
> +if test -z "$TAG"
> +then
> +	TAG=$(MAKEFLAGS= make -sC ../.. kernelversion)
> +fi
> +VN="$TAG$CID"
> +if test -n "$CID"
> +then
> +	# format version string, strip trailing zero of sublevel:
> +	VN=$(echo "$VN" | sed -e 's/-/./g;s/\([0-9]*[.][0-9]*\)[.]0/\1/')
>  fi
>  
>  VN=$(expr "$VN" : v*'\(.*\)')
> -- 
> 1.8.1.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
