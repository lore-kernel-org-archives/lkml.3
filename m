Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751406AbaLPEvJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 23:51:09 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:65119 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaLPEvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 23:51:08 -0500
MIME-Version: 1.0
Date: Mon, 15 Dec 2014 23:51:07 -0500
Message-ID: <CABPqkBS-iWehgyp0xEkeJLygeTOg7Ci-3jugRNMJ9Medz=2A1w@mail.gmail.com>
Subject: [BUG] perf: sampling with precise=2 broken in 3.18
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, "Liang, Kan" <kan.liang@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        dave.hansen@linux.intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was running some perf mem test for an upcoming patch when
I realize that precise=2 was broken on 3.18. It seems it never
(or extremely rarely) correct the off-by-one error, when until 3.18-rc4
it was 100% on the same program. So something was introduced
that broke the asm walker in perf_event_intel_ds.c.

Looking at the log of that file, I can see one change that could have
some impact:

Author: Dave Hansen <dave.hansen@linux.intel.com>
6ba48ff x86: Remove arbitrary instruction size limit in instruction decoder

if I use a kernel without this fix (prior to that commit), then correction
works. Any kernel after fails. I have not investigated why but may you
have an idea.

To reproduce try using perf mem -t load rec my_load_test, then use
perf report to navigate to the assembly view, the samples should be
on load instructions, not on the instructions following them. If you use
perf mem -t load rec -vv you can verify that precise=2. So something
is not working anymore in the instruction decoder that the fixup routine
bails out.

Any clue?
