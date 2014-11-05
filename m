Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbaKERbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:31:39 -0500
Received: from mga03.intel.com ([134.134.136.65]:57568 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755011AbaKERbh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:31:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,321,1413270000"; 
   d="scan'208";a="632058101"
From: "Liang, Kan" <kan.liang@intel.com>
To: Namhyung Kim <namhyung@kernel.org>
CC: "acme@kernel.org" <acme@kernel.org>, "jolsa@kernel.org" <jolsa@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>
Subject: RE: [PATCH 1/1] perf tools: perf diff for different binaries
Thread-Topic: [PATCH 1/1] perf tools: perf diff for different binaries
Thread-Index: AQHP+MJIkXF1b6uO30GrqYg9DeXxZ5xSOZBA
Date: Wed, 5 Nov 2014 17:28:25 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F07701654561@SHSMSX103.ccr.corp.intel.com>
References: <1414757172-20064-1-git-send-email-kan.liang@intel.com>
	<87tx2f5xpo.fsf@sejong.aot.lge.com>
	<37D7C6CF3E00A74B8858931C1DB2F07701653813@SHSMSX103.ccr.corp.intel.com>
 <87d292w41p.fsf@sejong.aot.lge.com>
In-Reply-To: <87d292w41p.fsf@sejong.aot.lge.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Hi Kan,
> 
> On Tue, 4 Nov 2014 17:07:43 +0000, Kan Liang wrote:
> > Hi Namhyung,
> >
> >> >                             tchain_edit        [.] f1
> >> >      0.14%        3.913444  tchain_edit        [.] f2
> >> >     99.82%        1.005478  tchain_edit        [.] f3
> >>
> >> Hmm.. I think it should be a default behavior for perf diff,
> >> otherwise -s symbol is almost meaningless IMHO.
> >
> > I think we need both instruction level and function level diff.
> > For debugging scaling issue, I think we need to do deeper analysis for
> > some cache or lock issue. The function level is too high granularity.
> >
> > The new option can be used to debug scaling regression issue.
> > If the binary/kernel is updated, it doesn't make sense to compare the
> > symbol address, since it should be changed. So comparing the function
> > should be more useful.
> >
> >
> >> What about setting the
> >> sort_sym.se_collapse in data_process() so that hists__match() can use
> >> symbol names?
> >
> > Yes, we can set it if we only do function level diff. But I'd like to
> > keep both. So I defined two sort keys.
> > "symbol" means "symbol address executed at the time of sample "
> > "symbol_name" means "name of function executed at the time of
> sample"
> 
> Hmm.. I don't think the symbol sort key provides the instruction level diff
> that you want.  If it finds a symbol it just use the start address of the
> symbol, not the exact address of the sample.  Am I missing something?
> 

No, the meaning of symbol in perf diff is different as in perf report. It uses
the exact address of the sample.

Here is current perf diff result and objdump fragment of the first binary.
You can see the exact address of the sample in function f3 was used, not the
start address.
33.55%                  [unknown]          [.] 0x0000000000400554
48.13%                  [unknown]          [.] 0x000000000040056b

[perf-test]#./perf diff -s dso,symbol --compute ratio ../../../v1_1_6perf.data
../../../v2_1_7perf.data
# Event 'cycles'
#
# Baseline           Ratio  Shared Object      Symbol
# ........  ..............  .................  .........................
#
                            [kernel.kallsyms]  [k] __update_cpu_load
                            [kernel.kallsyms]  [k] mod_timer
     0.01%                  [kernel.kallsyms]  [k] native_write_msr_safe
     0.01%                  [kernel.kallsyms]  [k] notifier_call_chain
     0.01%                  [kernel.kallsyms]  [k] perf_event_task_tick
                            [kernel.kallsyms]  [k] rt_mutex_slowlock
     0.01%                  [kernel.kallsyms]  [k] run_posix_cpu_timers
     0.01%                  [kernel.kallsyms]  [k] run_timer_softirq
     0.01%                  [kernel.kallsyms]  [k] trigger_load_balance
     0.01%                  [kernel.kallsyms]  [k] update_vsyscall
                            [kernel.kallsyms]  [k] wait_for_common
                            [kernel.kallsyms]  [k] 0x000000000028482a
     0.05%                  [unknown]          [.] 0x0000000000400540
     0.04%                  [unknown]          [.] 0x0000000000400541
     0.03%                  [unknown]          [.] 0x000000000040054b
     0.04%                  [unknown]          [.] 0x0000000000400552
    33.55%                  [unknown]          [.] 0x0000000000400554
     1.22%                  [unknown]          [.] 0x000000000040055a
     8.00%                  [unknown]          [.] 0x000000000040055e
     0.02%                  [unknown]          [.] 0x0000000000400562
     8.41%                  [unknown]          [.] 0x0000000000400564
    48.13%                  [unknown]          [.] 0x000000000040056b
     0.16%                  [unknown]          [.] 0x0000000000400570
     0.17%                  [unknown]          [.] 0x0000000000400571
                            [unknown]          [.] 0x0000000000400580
                            [unknown]          [.] 0x0000000000400581
     0.01%                  [unknown]          [.] 0x0000000000400583
     0.01%                  [unknown]          [.] 0x0000000000400588
                            [unknown]          [.] 0x000000000040058b
     0.01%     1240.990221  [unknown]          [.] 0x000000000040058d
                            [unknown]          [.] 0x0000000000400590
     0.06%                  [unknown]          [.] 0x0000000000400591
                            [unknown]          [.] 0x0000000000400593
     0.04%                  [unknown]          [.] 0x0000000000400595
     0.01%     1240.603148  [unknown]          [.] 0x0000000000400597
                            [unknown]          [.] 0x000000000040059b
                            [unknown]          [.] 0x000000000040059d
                            [unknown]          [.] 0x00000000004005a1
                            [unknown]          [.] 0x00000000004005a5
                            [unknown]          [.] 0x00000000004005a7
                            [unknown]          [.] 0x00000000004005a8
                            [unknown]          [.] 0x00000000004005aa
                            [unknown]          [.] 0x00000000004005ba
                            [unknown]          [.] 0x00000000004005bf
                            [unknown]          [.] 0x00000000004005c4
                            [unknown]          [.] 0x00000000004005c9
                            [unknown]          [.] 0x00000000004005ce
                            [unknown]          [.] 0x00000000004005d2
                            [unknown]          [.] 0x00000000004005d6
                            [unknown]          [.] 0x00000000004005d8
                            [unknown]          [.] 0x00000000004005f5


[perf-test]#objdump -d tchain_edit_1

0000000000400540 <f3>:
  400540:       55                      push   %rbp
  400541:       48 89 e5                mov    %rsp,%rbp
  400544:       c7 45 f8 e8 03 00 00    movl   $0x3e8,-0x8(%rbp)
  40054b:       c7 45 fc 00 00 00 00    movl   $0x0,-0x4(%rbp)
  400552:       eb 14                   jmp    400568 <f3+0x28>
  400554:       8b 45 fc                mov    -0x4(%rbp),%eax
  400557:       83 e0 01                and    $0x1,%eax
  40055a:       85 c0                   test   %eax,%eax
  40055c:       74 06                   je     400564 <f3+0x24>
  40055e:       83 45 fc 01             addl   $0x1,-0x4(%rbp)
  400562:       eb 04                   jmp    400568 <f3+0x28>
  400564:       83 45 fc 01             addl   $0x1,-0x4(%rbp)
  400568:       8b 45 fc                mov    -0x4(%rbp),%eax
  40056b:       3b 45 f8                cmp    -0x8(%rbp),%eax
  40056e:       7c e4                   jl     400554 <f3+0x14>
  400570:       5d                      pop    %rbp
  400571:       c3                      retq


Thanks,
Kan

> Thanks,
> Namhyung
