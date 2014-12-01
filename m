Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825AbaLAWhT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 17:37:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026AbaLAWhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 17:37:16 -0500
Date: Mon, 1 Dec 2014 20:29:19 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0/8] perf buildid-cache: Add clean command
Message-ID: <20141201222919.GC6774@redhat.com>
References: <1417460789-13874-1-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417460789-13874-1-git-send-email-jolsa@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 01, 2014 at 08:06:21PM +0100, Jiri Olsa escreveu:
> hi,
> adding 'perf buildid-cache clean' command to allow removal
> files from '~/.debug` cache plus other fixes.
> 
> Basically the clean command allows to display/remove cache
> files/sizes like:
> 
> Display cache files older than 3 days:
>   $ perf buildid-cache clean 3d

This is confusing, I went on parsing and the above command meant: clean
the files that are 3 days or older.

Right now we have:

 usage: perf buildid-cache [<options>]

    -a, --add <file list>
                          file(s) to add
    -k, --kcore <file>    kcore file to add
    -r, --remove <file list>
                          file(s) to remove
    -M, --missing <file>  to find missing build ids in the cache
    -f, --force           don't complain, do it
    -u, --update <file list>
                          file(s) to update
    -v, --verbose         be more verbose

[acme@sandy wb]$ 

If we keep the way it is, I think it would be clearer to add a -l/--list
command and that would:

  perf buildid-cache --list  # list all the files in the cache
  perf buildid-cache --list 3d  # list 3 days old files
  perf buildid-cache --list +3d  # list files 3 days or more older
  perf buildid-cache --list -3d  # list files up to 3 days old

And all these would print the sum of the matching files, i.e. the space
those files use in the filesystem.
 
> Remove cache files older than 3 days:
>   $ perf buildid-cache clean 3d -r

  perf buildid-cache --remove [-+]Nd # Same semantics as above

>     
> Total cache removal:
>   $ perf buildid-cache clean -r

 perf buildid-cache --remove '*'
 
> Remove and display items bigger than 200M
>   $ perf buildid-cache clean -r -a 200M

But yeah, perhaps we could switch to having subcommands and add:

  perf buildid-cache [add|remove|update|list]

What do you think?

Also in this process, we should rename buildid-cache to a shorter form,
'cache', i.e. 'perf cache', or we can leave this for later, for Masami's
patchkit we discussed recently.

- Arnaldo
 
> 
> Also available in here:
>   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
>   perf/core_buildid_cache_clean
> 
> thanks,
> jirka
> 
> 
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Stephane Eranian <eranian@google.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
> Jiri Olsa (8):
>       perf tools: Use single strcmp call instead of two
>       perf tools: Remove extra debugdir variables
>       perf tools: Add --buildid-dir option to set cache directory
>       perf buildid-cache: Add clean command
>       perf buildid-cache: Add automated tests
>       perf buildid cache: Fix -a segfault
>       perf buildid-cache: Fix kallsyms removal
>       perf buildid-cache: Try to remove empty directories
> 
>  tools/perf/Documentation/perf-buildid-cache.txt |  59 +++++++++++
>  tools/perf/Documentation/perf.txt               |   4 +
>  tools/perf/Makefile.perf                        |   7 +-
>  tools/perf/builtin-buildid-cache.c              | 501 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
>  tools/perf/perf.c                               |  14 ++-
>  tools/perf/tests/buildid-cache.c                |  88 ++++++++++++++++
>  tools/perf/tests/buildid-cache.sh               |  60 +++++++++++
>  tools/perf/tests/builtin-test.c                 |   8 ++
>  tools/perf/tests/tests.h                        |   1 +
>  tools/perf/util/build-id.c                      |  53 ++++++++--
>  tools/perf/util/config.c                        |  10 +-
>  tools/perf/util/util.h                          |   2 +-
>  12 files changed, 781 insertions(+), 26 deletions(-)
>  create mode 100644 tools/perf/tests/buildid-cache.c
>  create mode 100755 tools/perf/tests/buildid-cache.sh
