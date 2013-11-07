Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab3KGION (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 03:14:13 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:54686 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab3KGIOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 03:14:08 -0500
Date: Thu, 7 Nov 2013 09:14:04 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf: Fix version when building out of tree - v2
Message-ID: <20131107081404.GB32438@gmail.com>
References: <1383753335-25782-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383753335-25782-1-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> When building perf out of tree
>     make perf-tar-src-pkg
>     tar -xf perf-<ver>.tar -C /tmp
>     cd /tmp/perf<ver>
>     make -C tools/perf
> 
> you get the warning message:
>     make[1]: *** No rule to make target `kernelversion'.  Stop.
> 
> Fix by saving the perf version in the tar file and using that for the
> out of tree builds.
> 
> v2: removed short form request and fixed up version string from usual output
> 
> Suggested-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> ---
>  scripts/package/Makefile         | 4 +++-
>  tools/perf/util/PERF-VERSION-GEN | 3 +++
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/scripts/package/Makefile b/scripts/package/Makefile
> index a4f31c900fa6..c5d473393816 100644
> --- a/scripts/package/Makefile
> +++ b/scripts/package/Makefile
> @@ -115,7 +115,9 @@ git --git-dir=$(srctree)/.git archive --prefix=$(perf-tar)/         \
>  	-o $(perf-tar).tar;                                         \
>  mkdir -p $(perf-tar);                                               \
>  git --git-dir=$(srctree)/.git rev-parse HEAD > $(perf-tar)/HEAD;    \
> -tar rf $(perf-tar).tar $(perf-tar)/HEAD;                            \
> +(cd $(srctree)/tools/perf;                                          \
> +util/PERF-VERSION-GEN ../../$(perf-tar)/ 2>/dev/null);              \
> +tar rf $(perf-tar).tar $(perf-tar)/HEAD $(perf-tar)/PERF-VERSION-FILE; \
>  rm -r $(perf-tar);                                                  \
>  $(if $(findstring tar-src,$@),,                                     \
>  $(if $(findstring bz2,$@),bzip2,                                    \
> diff --git a/tools/perf/util/PERF-VERSION-GEN b/tools/perf/util/PERF-VERSION-GEN
> index 15a77b7c0e36..00d88be4e50c 100755
> --- a/tools/perf/util/PERF-VERSION-GEN
> +++ b/tools/perf/util/PERF-VERSION-GEN
> @@ -19,6 +19,9 @@ if test -d ../../.git -o -f ../../.git
>  then
>  	TAG=$(git describe --abbrev=0 --match "v[0-9].[0-9]*" 2>/dev/null )
>  	CID=$(git log -1 --abbrev=4 --pretty=format:"%h" 2>/dev/null) && CID="-g$CID"
> +elif test -f ../../PERF-VERSION-FILE
> +then
> +	TAG=$(cut -d' ' -f3 ../../PERF-VERSION-FILE | sed -e 's/\"//g')
>  fi
>  if test -z "$TAG"
>  then

Nice!

Reviewed-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
