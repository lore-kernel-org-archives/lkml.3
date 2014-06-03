Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260AbaFCN22 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 09:28:28 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:51443 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbaFCN20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 09:28:26 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Minchan Kim <minchan@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC 2/2] x86_64: expand kernel stack to 16K
Organization: D03
References: <1401260039-18189-1-git-send-email-minchan@kernel.org>
	<1401260039-18189-2-git-send-email-minchan@kernel.org>
	<CA+55aFxXdc22dirnE49UbQP_2s2vLQpjQFL+NptuyK7Xry6c=g@mail.gmail.com>
	<20140528223142.GO8554@dastard>
	<CA+55aFyRk6_v6COPGVvu6hvt=i2A8-dPcs1X3Ydn1g24AxbPkg@mail.gmail.com>
	<20140529013007.GF6677@dastard> <20140529015830.GG6677@dastard>
	<20140529233638.GJ10092@bbox> <20140530001558.GB14410@dastard>
	<20140530021247.GR10092@bbox>
X-Hashcash: 1:20:140603:linux-mm@kvack.org::vv19OTxOB+80FfgE:00000000000000000000000000000000000000000000cUD
X-Hashcash: 1:20:140603:david@fromorbit.com::2fxQO9YsgV9AcOa7:0000000000000000000000000000000000000000000IcL
X-Hashcash: 1:20:140603:minchan@kernel.org::onVjjUcRkHDNMhw4:000000000000000000000000000000000000000000001ZK
X-Hashcash: 1:20:140603:a.p.zijlstra@chello.nl::XxfVw6JgkP0KNnTS:0000000000000000000000000000000000000001FNH
X-Hashcash: 1:20:140603:akpm@linux-foundation.org::wB5yNH11tdiIAyhK:0000000000000000000000000000000000001axv
X-Hashcash: 1:20:140603:mingo@kernel.org::C6KOELj0dNuU/ick:02Y3b
X-Hashcash: 1:20:140603:rostedt@goodmis.org::usNVJqg01S71FBwQ:0000000000000000000000000000000000000000002iPX
X-Hashcash: 1:20:140603:rusty@rustcorp.com.au::5670RXWQ1gSePnkF:00000000000000000000000000000000000000002hV2
X-Hashcash: 1:20:140603:torvalds@linux-foundation.org::JvXQ1otFoIBC5adh:000000000000000000000000000000003Bgn
X-Hashcash: 1:20:140603:hannes@cmpxchg.org::C5HOrTmWE3gVoOHe:00000000000000000000000000000000000000000003iiF
X-Hashcash: 1:20:140603:mgorman@suse.de::kiz0ijd5aPu9OcPo:0085Tf
X-Hashcash: 1:20:140603:hpa@zytor.com::42HCRbB7iN0jPIlL:00007rnd
X-Hashcash: 1:20:140603:hughd@google.com::trhxoC0/SMzHi+rq:09ieY
X-Hashcash: 1:20:140603:dave.hansen@intel.com::uKc/0U67QMNEQIxd:00000000000000000000000000000000000000008QBr
X-Hashcash: 1:20:140603:riel@redhat.com::Z8qe6qBuuJm/ENfJ:00A7Oa
X-Hashcash: 1:20:140603:linux-kernel@vger.kernel.org::fKnJ8RqBKtHPsLVg:000000000000000000000000000000000CF/a
X-Hashcash: 1:20:140603:mst@redhat.com::Op7vP42VScd7XO7X:000L4bS
Date: Tue, 03 Jun 2014 15:28:22 +0200
In-Reply-To: <20140530021247.GR10092@bbox> (Minchan Kim's message of "Fri, 30
	May 2014 11:12:47 +0900")
Message-ID: <87mwduqg09.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Possibly stupid question: Is it true that any given task can only be
using one wait_queue_t at a time? If so, would it be an idea to put a
wait_queue_t into struct task_struct [maybe union'ed with a struct
wait_bit_queue] and avoid allocating this 40 byte structure repeatedly
on the stack.

E.g., in one of Minchan's stack traces, there are two calls of
mempool_alloc (which itself declares a wait_queue_t) and one
try_to_free_pages (which is the only caller of throttle_direct_reclaim,
which in turn uses wait_event_interruptible_timeout and
wait_event_killable).

Rasmus
