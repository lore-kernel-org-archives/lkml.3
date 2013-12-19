Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab3LSMOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:14:45 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:48407 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814Ab3LSMOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 07:14:41 -0500
Date: Thu, 19 Dec 2013 13:14:35 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCHSET 0/6] perf tools: A couple of TUI improvements
Message-ID: <20131219121435.GB11279@gmail.com>
References: <1387436411-20160-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387436411-20160-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> Hello,
> 
> I was playing with TUI code and added two new windows.  One for
> showing log messages and another for showing header information.
> (Maybe they can be implemented on the GTK code too someday.)
> 
> Please try to use it! :)
> 
> I put the patches on 'perf/tui-v1' branch in my tree:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
> 
> Any feedbacks are more than welcome, thanks
> Namhyung

In the morning haze it took me some time to figure out that typing 'l' 
gives leads to the log window, 'i' to the header information.

'l' seems to work (no log messages though :-), but in perf-top 'i' 
segfaulted:

  comet:~/tip/tools/perf> perf top
  perf: Segmentation fault

Program received signal SIGSEGV, Segmentation fault.
[Switching to Thread 0x7ffff0d39700 (LWP 14785)]
perf_header__fprintf_info (session=session@entry=0x957bf0, fp=fp@entry=0x7fffec000a30, full=full@entry=true) at util/header.c:2195
2195            int fd = perf_data_file__fd(session->file);
Missing separate debuginfos, use: debuginfo-install audit-libs-2.3.2-1.fc19.x86_64 bzip2-libs-1.0.6-8.fc19.x86_64 elfutils-libelf-0.156-5.fc19.x86_64 elfutils-libs-0.156-5.fc19.x86_64 glibc-2.17-19.fc19.x86_64 libgcc-4.8.2-1.fc19.x86_64 libunwind-1.1-2.fc19.x86_64 nss-softokn-freebl-3.15.2-2.fc19.x86_64 numactl-libs-2.0.8-4.fc19.x86_64 perl-libs-5.16.3-266.fc19.x86_64 python-libs-2.7.5-9.fc19.x86_64 slang-2.2.4-8.fc19.x86_64 xz-libs-5.1.2-4alpha.fc19.x86_64 zlib-1.2.7-10.fc19.x86_64
(gdb) bt
#0  perf_header__fprintf_info (session=session@entry=0x957bf0, fp=fp@entry=0x7fffec000a30, full=full@entry=true) at util/header.c:2195
#1  0x00000000004ce3fe in tui__header_window (env=env@entry=0x957c30) at ui/browsers/header.c:92
#2  0x00000000004cbdfd in perf_evsel__hists_browse (evsel=evsel@entry=0x957560, nr_events=nr_events@entry=1, 
    helpline=helpline@entry=0x57db88 "For a higher level overview, try: perf top --sort comm,dso", ev_name=0x957870 "cycles", left_exits=left_exits@entry=false, 
    hbt=hbt@entry=0x7ffff0d38ea0, min_pcnt=min_pcnt@entry=0, env=env@entry=0x957c30) at ui/browsers/hists.c:1491
#3  0x00000000004cd5a5 in perf_evlist__tui_browse_hists (evlist=0x8e5930, help=help@entry=0x57db88 "For a higher level overview, try: perf top --sort comm,dso", 
    hbt=hbt@entry=0x7ffff0d38ea0, min_pcnt=0, env=0x957c30) at ui/browsers/hists.c:1957
#4  0x0000000000433b48 in display_thread_tui (arg=0x7fffffffb150) at builtin-top.c:584
#5  0x0000003e59407c53 in start_thread () from /lib64/libpthread.so.0
#6  0x0000003e590f5dbd in clone () from /lib64/libc.so.6
(gdb) 

I suspect it got surprised by perf top not having a header per se? 
Still it might make sense to also robustify 
perf_header__fprintf_info() against segfaulting and such.

But it's a nice feature nevertheless!

Btw., it would be nice if 'P' worked on these screens, so any 
interesting data can be extracted! Cut & paste is usually a PITA due 
to the graphical TUI characters.

Btw., in case you are taking TUI usability bugreports, here's a few I 
noticed while playing with your changes:

1)

In histogram view it would be nice if 'P' gave some status bar 
indication that it just wrote to perf.hist.0 or so - otherwise the 
user is kept in the dark.

2)

Likewise, in a TUI every keypress must produce some tangible feedback 
to the user. Try hitting 'o' for example - it should probably output 
into the status bar that 'o' is not a bound keypress or so.

3)

Same goes for page up / page down in histogram view if we are at the 
end of the list: some low-key, single-character feedback should be 
given that the keypress was seen but we are at the end of the list. 
For exampe the scrollbar 'diamond' character could briefly 
inverse-flash or so.

Thanks,

	Ingo
