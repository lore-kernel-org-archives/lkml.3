Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363AbaDAHWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 03:22:08 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:60586 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbaDAHWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 03:22:05 -0400
MIME-Version: 1.0
In-Reply-To: <533A4839.60406@hitachi.com>
References: <1396327677-3657-1-git-send-email-namhyung@kernel.org> <533A4839.60406@hitachi.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Tue, 1 Apr 2014 07:21:44 +0000
X-Google-Sender-Auth: 7tNJTNczNH0-T2NT-JMk7t6iipI
Message-ID: <CAM9d7cgtuh5BBi34WaZWxfJnNjnazZD+Aas37SsEad1pZxe_kg@mail.gmail.com>
Subject: Re: [PATCH] perf probe: Fix --line option behavior
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

(Also adding Jiri in CC and changing email of acme)

On Tue, Apr 1, 2014 at 5:01 AM, Masami Hiramatsu
<masami.hiramatsu.pt@hitachi.com> wrote:
> (2014/04/01 13:47), Namhyung Kim wrote:
>> The commit 5a62257a3ddd1 ("perf probe: Replace line_list with
>> intlist") replaced line_list to intlist but it has a problem that if a
>> same line was added again, it'd return -EEXIST rather than 1.
>
> Ah, right! that's a different behavior.
>
>> Since line_range_walk_cb() only checks the result being negative, it
>> resulted in failure or segfault sometimes.
>
> Could you give me an example input of the segfault? I'd like to trace
> it down.

Just used current acme/perf/core.

$ git log -1
commit 28b5724a61cc9d84f2cbef6675e8a85ae4b1bc57
Author: Arnaldo Carvalho de Melo <acme@redhat.com>
Date:   Thu Mar 27 17:36:14 2014 -0300

    MAINTAINERS: Change e-mail to kernel.org one

    Leaving ghostprotocols.net for old networking stuff.

...

$ perf --version
perf version 3.14.rc6.g28b572

$ perf probe -x ./perf -v -L map__load
Open Debuginfo file: /home/namhyung/project/linux/tools/perf/perf
fname: util/map.c, lineno:153
New line range: 153 to 2147483647
path: (null)
Segmentation fault (core dumped)


It seems like find_line_range_by_line() called for multiple times,
line_range_walk_cb returns 0 at first but as line_range_add_line()
returns -EEXIST, it freed lr->path and __show_line_range() ended up
accessing to NULL path.


(gdb) bt
#0  get_real_path (new_path=0x839ff8 <params+9272>,
    comp_dir=0x1f994f0 "/home/namhyung/project/linux/tools/perf",
    raw_path=0x0) at util/probe-event.c:518
#1  __show_line_range (module=<optimized out>, lr=0x839fd8 <params+9240>)
    at util/probe-event.c:641
#2  show_line_range (lr=lr@entry=0x839fd8 <params+9240>,
    module=<optimized out>) at util/probe-event.c:699
#3  0x000000000044667b in __cmd_probe (argc=<optimized out>,
    argv=argv@entry=0x7fff7a770ba0, prefix=<optimized out>)
    at builtin-probe.c:465
#4  0x00000000004469f4 in cmd_probe (argc=<optimized out>,
    argv=0x7fff7a770ba0, prefix=<optimized out>) at builtin-probe.c:520
#5  0x00000000004241b5 in run_builtin (p=p@entry=0x7ebde0 <commands+384>,
    argc=argc@entry=6, argv=argv@entry=0x7fff7a770ba0) at perf.c:319
#6  0x0000000000423a29 in handle_internal_command (argv=0x7fff7a770ba0,
    argc=6) at perf.c:376
#7  run_argv (argv=0x7fff7a7709a0, argcp=0x7fff7a7709ac) at perf.c:420
#8  main (argc=6, argv=0x7fff7a770ba0) at perf.c:529


Thanks,
Namhyung
