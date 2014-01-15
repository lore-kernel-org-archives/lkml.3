Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbaAOOA0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 09:00:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53447 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbaAOOAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 09:00:23 -0500
Date: Wed, 15 Jan 2014 14:59:26 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, namhyung@kernel.org, mingo@kernel.org,
        dsahern@gmail.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: Implement lbr-as-callgraph v3
Message-ID: <20140115135926.GD8350@krava.redhat.com>
References: <1389661461-18996-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1389661461-18996-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 05:04:15PM -0800, Andi Kleen wrote:
> This patchkit implements lbr-as-callgraphs in per freport,
> as an alternative way to present LBR information.
> 
> Current perf report does a histogram over the branch edges,
> which is useful to look at basic blocks, but doesn't tell
> you anything about the larger control flow behaviour.
> 
> This patchkit adds a new option --branch-history that
> adds the branch paths to the callgraph history instead.
> 
> This allows to reason about individual branch paths leading
> to specific samples.
> 
> Updates to v1:
> - rebased on perf/core
> - fix various issues
> - rename the option to --branch-history
> - various fixes to display the information more concise
> 
> Updates to v3:
> - White space changes
> - Consolidate some patches
> - Update some descriptions
> 
> Example output:
> 
>     % perf record -b -g ./tsrc/tcall
>     [ perf record: Woken up 1 times to write data ]
>     [ perf record: Captured and wrote 0.044 MB perf.data (~1923 samples) ]
>     % perf report --branch-history
>     ...
>         54.91%  tcall.c:6  [.] f2                      tcall
>                 |
>                 |--65.53%-- f2 tcall.c:5
>                 |          |
>                 |          |--70.83%-- f1 tcall.c:11
>                 |          |          f1 tcall.c:10
>                 |          |          main tcall.c:18
>                 |          |          main tcall.c:18
>                 |          |          main tcall.c:17
>                 |          |          main tcall.c:17
>                 |          |          f1 tcall.c:13
>                 |          |          f1 tcall.c:13
>                 |          |          f2 tcall.c:7
>                 |          |          f2 tcall.c:5
>                 |          |          f1 tcall.c:12
>                 |          |          f1 tcall.c:12
>                 |          |          f2 tcall.c:7
>                 |          |          f2 tcall.c:5
>                 |          |          f1 tcall.c:11
> 
> 

the tui output needs some cleanup:

+  26.38%  :0  [.] _IO_file_xsputn@@GLIBC_2.2.5    libc-2.17.so                                                                           ◆
+  20.43%  :0  [.] __strlen_sse2                   libc-2.17.so                                                                           ▒
+  15.94%  yes.c:83  [.] main                            yes                                                                              ▒
+  12.16%  :0  [.] fputs_unlocked                  libc-2.17.so                                                                           ▒
+  10.27%  stdio.h:107  [.] main                            yes                                                                           ▒
+  10.09%  :0  [.] __GI___mempcpy                  libc-2.17.so                                                                           ▒
+   2.63%  yes.c:84  [.] main                            yes                                                                              ▒
+   1.71%  yes[4012f0]  [.] fputs_unlocked@plt              yes                                                                           ▒
+   0.25%  yes.c:85  [.] main                            yes                                                                              ▒
+   0.03%  [kernel.kallsyms][ffffffff81757eb0]  [k] system_call                     [kernel.kallsyms]                                     ▒
+   0.02%  :0  [.] _IO_file_write@@GLIBC_2.2.5     libc-2.17.so                                                                           ▒
+   0.02%  :0  [.] _IO_do_write@@GLIBC_2.2.5       libc-2.17.so                                                                           ▒
+   0.02%  [kernel.kallsyms][ffffffff81758b40]  [k] apic_timer_interrupt            [kernel.kallsyms]                                     ▒
+   0.02%  :0  [.] _IO_default_xsputn              libc-2.17.so                                                                           ▒
+   0.01%  :0  [.] _IO_file_overflow@@GLIBC_2.2.5  libc-2.17.so                                                                           ▒
+   0.01%  :0  [.] __GI___libc_write               libc-2.17.so                                                                           ▒
+   0.00%  [kernel.kallsyms][ffffffff8174f020]  [k] page_fault                      [kernel.kallsyms]                                     ▒
+   0.00%  :0  [.] getenv                          libc-2.17.so                                                                           ▒
+   0.00%  :0  [.] _nl_load_locale_from_archive    libc-2.17.so                                                                           ▒
+   0.00%  ld-2.17.so[3407c0af52]  [.] _dl_setup_hash                  ld-2.17.so                                                         ▒
+   0.00%  ld-2.17.so[3407c01420]  [.] _start                          ld-2.17.so                      


when we cannot get source and line number we could output address not ':0':

-   2.63%  yes.c:84  [.] main                            yes                                                                              ▒
   - main stdio.h:107                                                                                                                     ▒
   - main yes.c:84                                                                                                                        ▒
   - main yes.c:84                                                                                                                        ▒
   - fputs_unlocked :0                                                                                                                    ▒
   - fputs_unlocked :0                                                                                                                    ▒
   - _IO_file_xsputn@@GLIBC_2.2.5 :0                                                                                                      ▒
      - 99.78% _IO_file_xsputn@@GLIBC_2.2.5 :0                                                                                            ▒
           __GI___mempcpy :0                                                                                                              ▒
           __GI___mempcpy :0                                                                                                              ▒
           __GI___mempcpy :0                                                                                                              ▒
           __GI___mempcpy :0                                         


at some samples I could not get see  source/address info, just:

     0.03%  [kernel.kallsyms][ffffffff810a7b4f]  [k] __srcu_read_lock                [kernel.kallsyms]
            |
            --- __srcu_read_lock
                fsnotify
                fsnotify
                fsnotify
                fsnotify
                fsnotify
                fsnotify
                fsnotify
                fsnotify

going to check the patches now ;-)

jirka
