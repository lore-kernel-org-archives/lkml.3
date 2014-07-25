Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758974AbaGYBT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 21:19:27 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:46364 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756924AbaGYBTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 21:19:15 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCHSET 0/7] perf tools: Honor column width setting (v2)
Date: Fri, 25 Jul 2014 10:18:51 +0900
Message-Id: <1406251138-6574-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset is to control perf report/top output column width by
-w/--column-widths option so that it can fit into the terminal size.
The -w option is there for perf report but it ignored by recent output
field changed due to some reason.  This patchset fixes it and supports
perf top also.

This is sometimes useful if your terminal is small and there's some
C++ applications which have amazingly long symbol names.  Without this
patchset user might not see those symbols on TUI, since it maps
left/right arrow keys to other functions.

The -w option sets column width starting from the first column
(overhead or optional overhead_children column unless -F option is
given).  It doesn't make sense to limit those overhead columns so it's
not a hard-limit for them.  But it *is* a hard-limit for other columns
such as comm, dso, symbol, and so on.  One can use 0 not to
limit/force a width for those columns.


For example:

  $ perf report --stdio -s comm,dso
  ...
  # Overhead  Command          Shared Object                                        
  # ........  ...............  .....................................................
  #
      71.08%  gnome-shell      perf-1497.map                                        
       9.23%  gnome-shell      swrast_dri.so                                        
       3.99%  Xorg             [unknown]                                            
       3.18%  Xorg             [kernel.kallsyms]                                    
       2.93%  gnome-shell      [kernel.kallsyms]                                    
       2.41%  swapper          [kernel.kallsyms]                                    
       1.55%  synergys         libpthread-2.15.so                                   
       1.08%  synergys         synergys                                             
       0.68%  systemd-journal  [kernel.kallsyms]                                    
       0.59%  synergys         libstdc++.so.6.0.17                                  
       0.58%  gnome-shell      libc-2.15.so                                         
       0.54%  kworker/0:2      [kernel.kallsyms]                                    
       0.20%  systemd-journal  [unknown]                                            
       0.19%  gnome-shell      libclutter-1.0.so.0.1000.8.#prelink#.1kh1we (deleted)
       0.18%  firefox          libxul.so (deleted)                                  
       0.17%  gnome-shell      libcogl.so.9.1.1.#prelink#.ZL3fn1 (deleted)          
       0.14%  firefox          [kernel.kallsyms]                                    
       0.14%  gnome-shell      libgobject-2.0.so.0.3200.4                           
       0.13%  gnome-shell      libpthread-2.15.so                                   
       0.11%  synergys         [kernel.kallsyms]                                    
       0.10%  perf             [kernel.kallsyms]                                    


  $ perf report --stdio -s comm,dso -w 0,10,20   # 0 means no limit
  ...
  # Overhead  Command     Shared Object       
  # ........  ..........  ....................
  #
      71.08%  gnome-shel  perf-1497.map       
       9.23%  gnome-shel  swrast_dri.so       
       3.99%  Xorg        [unknown]           
       3.18%  Xorg        [kernel.kallsyms]   
       2.93%  gnome-shel  [kernel.kallsyms]   
       2.41%  swapper     [kernel.kallsyms]   
       1.55%  synergys    libpthread-2.15.so  
       1.08%  synergys    synergys            
       0.68%  systemd-jo  [kernel.kallsyms]   
       0.59%  synergys    libstdc++.so.6.0.17 
       0.58%  gnome-shel  libc-2.15.so        
       0.54%  kworker/0:  [kernel.kallsyms]   
       0.20%  systemd-jo  [unknown]           
       0.19%  gnome-shel  libclutter-1.0.so.0.
       0.18%  firefox     libxul.so (deleted) 
       0.17%  gnome-shel  libcogl.so.9.1.1.#pr
       0.14%  firefox     [kernel.kallsyms]   
       0.14%  gnome-shel  libgobject-2.0.so.0.
       0.13%  gnome-shel  libpthread-2.15.so  
       0.11%  synergys    [kernel.kallsyms]   
       0.10%  perf        [kernel.kallsyms]   


 * changes in v2:
  - fix TUI alignment when no header is shown  (Jiri)
  - change printing order of pid sort key  (Jiri)


You can also get this from 'perf/width-v2' branch on my tree

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git


Thanks,
Namhyung


Namhyung Kim (7):
  perf tools: Left-align output contents
  perf tools: Make __hpp__fmt() receive an additional len argument
  perf tools: Save column length in perf_hpp_fmt
  perf report: Honor column width setting
  perf top: Add -w option for setting column width
  perf tools: Add name field into perf_hpp_fmt
  perf tools: Fix column alignment when headers aren't shown on TUI

 tools/perf/Documentation/perf-report.txt |   2 +-
 tools/perf/Documentation/perf-top.txt    |   6 +
 tools/perf/builtin-top.c                 |   3 +
 tools/perf/ui/browsers/hists.c           |  36 ++--
 tools/perf/ui/gtk/hists.c                |  18 +-
 tools/perf/ui/hist.c                     | 275 +++++++++++++++++++------------
 tools/perf/ui/stdio/hist.c               |   4 +-
 tools/perf/util/color.c                  |  16 ++
 tools/perf/util/color.h                  |   1 +
 tools/perf/util/hist.h                   |  17 +-
 tools/perf/util/sort.c                   |  55 ++++---
 11 files changed, 279 insertions(+), 154 deletions(-)

-- 
2.0.0

