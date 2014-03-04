Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbaCDCm0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 21:42:26 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56380 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755929AbaCDCmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 21:42:19 -0500
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: [RFC 00/10] perf report: Add -F option for specifying output fields
Date: Tue,  4 Mar 2014 11:42:06 +0900
Message-Id: <1393900936-22977-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is a patchset implementing -F/--field option to setup output
field/column as Ingo requested.

The -F option can receive any sort keys that -s option recognize, plus
following fields (name can be changed):

  overhead, overhead_sys, overhead_us, sample, period

The overhead_guest_sys and overhead_guest_us might be avaiable when
you profile guest machines.

Output will be sorted by in order of fields and sort keys passed by -s
option will be added to the output field list automatically.  If you
want to change the order of sorting you can give -s option in addition
to -F option.  To support old behavior, it'll also prepend 'overhead'
field to the sort keys unless you give -F option explicitly.


  $ perf report -s dso,sym
  ...
  # Overhead  Shared Object                      Symbol
  # ........  .............  ..........................
  #
      13.75%  ld-2.17.so     [.] strcmp                
      10.00%  abc            [.] a                     
      10.00%  abc            [.] b                     
      10.00%  abc            [.] c                     
       8.75%  abc            [.] main                  
       7.50%  libc-2.17.so   [.] _setjmp               
       6.25%  abc            [.] _init                 
       6.25%  abc            [.] frame_dummy           
       5.00%  abc            [.] __libc_csu_init       
       5.00%  ld-2.17.so     [.] _dl_name_match_p      
       3.75%  libc-2.17.so   [.] __new_exitfn          
       2.50%  libc-2.17.so   [.] __cxa_atexit          
       1.25%  ld-2.17.so     [.] _dl_check_map_versions
       1.25%  ld-2.17.so     [.] _dl_setup_hash        
       1.25%  ld-2.17.so     [.] _dl_sysdep_start      
       1.25%  ld-2.17.so     [.] brk                   
       1.25%  ld-2.17.so     [.] calloc@plt            
       1.25%  ld-2.17.so     [.] dl_main               
       1.25%  ld-2.17.so     [.] match_symbol          
       1.25%  ld-2.17.so     [.] sbrk                  
       1.25%  ld-2.17.so     [.] strlen                


  $ perf report -F sym,sample,overhead
  ...
  #                     Symbol       Samples  Overhead
  # ..........................  ............  ........
  #
    [.] __cxa_atexit                       2     2.50%
    [.] __libc_csu_init                    4     5.00%
    [.] __new_exitfn                       3     3.75%
    [.] _dl_check_map_versions             1     1.25%
    [.] _dl_name_match_p                   4     5.00%
    [.] _dl_setup_hash                     1     1.25%
    [.] _dl_sysdep_start                   1     1.25%
    [.] _init                              5     6.25%
    [.] _setjmp                            6     7.50%
    [.] a                                  8    10.00%
    [.] b                                  8    10.00%
    [.] brk                                1     1.25%
    [.] c                                  8    10.00%
    [.] calloc@plt                         1     1.25%
    [.] dl_main                            1     1.25%
    [.] frame_dummy                        5     6.25%
    [.] main                               7     8.75%
    [.] match_symbol                       1     1.25%
    [.] sbrk                               1     1.25%
    [.] strcmp                            11    13.75%
    [.] strlen                             1     1.25%


  $ perf report -F sym,sample -s overhead
  ...
  #                     Symbol       Samples  Overhead
  # ..........................  ............  ........
  #
    [.] strcmp                            11    13.75%
    [.] a                                  8    10.00%
    [.] b                                  8    10.00%
    [.] c                                  8    10.00%
    [.] main                               7     8.75%
    [.] _setjmp                            6     7.50%
    [.] _init                              5     6.25%
    [.] frame_dummy                        5     6.25%
    [.] __libc_csu_init                    4     5.00%
    [.] _dl_name_match_p                   4     5.00%
    [.] __new_exitfn                       3     3.75%
    [.] __cxa_atexit                       2     2.50%
    [.] _dl_check_map_versions             1     1.25%
    [.] _dl_setup_hash                     1     1.25%
    [.] _dl_sysdep_start                   1     1.25%
    [.] brk                                1     1.25%
    [.] calloc@plt                         1     1.25%
    [.] dl_main                            1     1.25%
    [.] match_symbol                       1     1.25%
    [.] sbrk                               1     1.25%
    [.] strlen                             1     1.25%


I pushed the patch series on the 'perf/field-v1' branch in my tree

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git


Any comments are welcome, please test!

Thanks,
Namhyung


Namhyung Kim (10):
  perf tools: Add ->cmp(), ->collapse() and ->sort() to perf_hpp_fmt
  perf tools: Convert sort entries to hpp formats
  perf tools: Use hpp formats to sort hist entries
  perf tools: Support event grouping in hpp ->sort()
  perf tools: Use hpp formats to sort final output
  perf tools: Consolidate output field handling to hpp format routines
  perf ui: Get rid of callback from __hpp__fmt()
  perf tools: Allow hpp fields to be sort keys
  perf report: Add -F option to specify output fields
  perf tools: Add ->sort() member to struct sort_entry

 tools/perf/Documentation/perf-report.txt |  10 ++
 tools/perf/builtin-report.c              |   8 +
 tools/perf/ui/browsers/hists.c           |  66 +++-----
 tools/perf/ui/gtk/hists.c                |  33 +---
 tools/perf/ui/hist.c                     | 189 +++++++++++++++++++---
 tools/perf/ui/stdio/hist.c               |  52 ++----
 tools/perf/util/hist.c                   |  78 ++-------
 tools/perf/util/hist.h                   |  18 ++-
 tools/perf/util/sort.c                   | 269 ++++++++++++++++++++++++++++++-
 tools/perf/util/sort.h                   |   3 +
 10 files changed, 520 insertions(+), 206 deletions(-)

-- 
1.7.11.7

