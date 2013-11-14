Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab3KNUu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 15:50:58 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:34583 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821Ab3KNUut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 15:50:49 -0500
MIME-Version: 1.0
Date: Thu, 14 Nov 2013 21:50:49 +0100
Message-ID: <CABPqkBTiBHF4wZ3c_Czkh3JgvXGNWJW1LH42Jh4NG_ZJkGkbgw@mail.gmail.com>
Subject: [BUG] perf stat: explicit grouping yields unexpected results
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>, David Ahern <dsahern@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri,

I was trying the grouping support in perf stat and I was surprised
to see that if I create a group that is too big to be scheduled, and
where only N out of P events can fit, perf stat still yields counts
for the N events. I was expecting 0 counts or <not supported>.

The kernel semantic is to schedule all the events in a group or none.
Perf does something different and this is confusing. If you use explicit
grouping then I think you want to group to fail if not all the events can
be scheduled:

On an IvyBridge:
$ perf stat --g -e
'{cycles,instructions,branches,branches,branches,branches,branches}'
noploop 1
     3 229 417 079 cycles
     3 223 919 023 instructions              #    1,00  insns per cycle
     3 220 868 098 branches
     3 220 868 098 branches
     3 220 868 098 branches
     3 220 868 098 branches
   <not supported> branches

I think it should be: <not supported> for all events.
