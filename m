Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980AbaLCIN2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 03:13:28 -0500
Received: from mail-oi0-f49.google.com ([209.85.218.49]:46901 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbaLCIN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 03:13:26 -0500
MIME-Version: 1.0
In-Reply-To: <20141202141028.GD6774@redhat.com>
References: <1417460789-13874-1-git-send-email-jolsa@kernel.org>
 <20141201222919.GC6774@redhat.com> <20141202122518.GA7744@krava.brq.redhat.com>
 <20141202141028.GD6774@redhat.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Wed, 3 Dec 2014 17:13:06 +0900
X-Google-Sender-Auth: r1Dv3LanqYBZUjgguodxzT3eCFg
Message-ID: <CAM9d7cihz5Ywf_129=sm0EOpwRQBdoDA9sHn+TA0EfmhTU1Tmw@mail.gmail.com>
Subject: Re: [PATCH 0/8] perf buildid-cache: Add clean command
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo and Jiri,

On Tue, Dec 2, 2014 at 11:10 PM, Arnaldo Carvalho de Melo
<acme@redhat.com> wrote:
> Em Tue, Dec 02, 2014 at 01:25:18PM +0100, Jiri Olsa escreveu:
>> On Mon, Dec 01, 2014 at 08:29:19PM -0200, Arnaldo Carvalho de Melo wrote:
>
>> SNIP
>
>> > [acme@sandy wb]$
>
>> > If we keep the way it is, I think it would be clearer to add a -l/--list
>> > command and that would:
>
>> >   perf buildid-cache --list  # list all the files in the cache
>> >   perf buildid-cache --list 3d  # list 3 days old files
>> >   perf buildid-cache --list +3d  # list files 3 days or more older
>> >   perf buildid-cache --list -3d  # list files up to 3 days old
>
>> ok, I was up to old files (and big files) removal only.. not sure
>> the other way will be actually needed.. but it's easy enought to
>> add
>
> Right, I was thinking something along the lines of checking how much
> space would be needed if I wanted to keep X days of cache, not how much
> space I would free if I purged files older than Y days.

Btw, which timestamp do you use for the checking?  It'd be great if we
can use atime but some system might use the noatime..


>
>
>> > And all these would print the sum of the matching files, i.e. the space
>> > those files use in the filesystem.
>
>> > > Remove cache files older than 3 days:
>> > >   $ perf buildid-cache clean 3d -r
>
>> >   perf buildid-cache --remove [-+]Nd # Same semantics as above
>
>> > >
>> > > Total cache removal:
>> > >   $ perf buildid-cache clean -r
>
>> >  perf buildid-cache --remove '*'
>>
>> hum, maybe '--removal all' might be better
>
> Humm, lemme see how ccache does this operation... That would be an
> existing cache management workflow that we could reuse:
>
>
> [acme@zoo linux]$ ccache --help
> Usage:
>   ccache [options]
>   ccache compiler [compiler options]
>   compiler [compiler options]          (via symbolic link)
>
> Options:
>     -c, --cleanup        delete old files and recalculate size counters
>                          (normally not needed as this is done automatically)
>     -C, --clear          clear the cache completely
>     -F, --max-files=N    set maximum number of files in cache to N (use 0 for
>                          no limit)
>     -M, --max-size=SIZE  set maximum size of cache to SIZE (use 0 for no
>                          limit; available suffixes: G, M and K; default
>                          suffix: G)
>     -s, --show-stats     show statistics summary
>     -z, --zero-stats     zero statistics counters
>
>     -h, --help           print this help text
>     -V, --version        print version and copyright information
>
>   See also <http://ccache.samba.org>.
>   [acme@zoo linux]$
>
> So, there you go, the 'clear' keywoard being used for doing what you
> called 'removeall' and I called --remove '*'. Perhaps asking if the user
> really wants to do that while, just like with the time limited 'remove'
> operations showing how much space it will release (albeit that could
> take some time to calculate...)?

Yeah, I think we also need to have the stats option/command.  And some
kind of cache management policies too - like max size and max days? -
so that it can trigger auto cleanup.. ;-)


>
>> >
>> > > Remove and display items bigger than 200M
>> > >   $ perf buildid-cache clean -r -a 200M
>
>> > But yeah, perhaps we could switch to having subcommands and add:
>
>> >   perf buildid-cache [add|remove|update|list]
>
>> > What do you think?
>
>> yep, those commands seem nicer..
>
>> let's see of there're other comments and I'll come up with
>> new interface after..

I also like the subcommand style..  What about git-like format to
specify time range?

perf buildid-cache list --since '3 days ago'
perf buildidi-cache remove --before '1 month ago'


Thanks,
Namhyung
