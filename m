Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935317Ab3E2W2G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 18:28:06 -0400
Received: from mga14.intel.com ([143.182.124.37]:15899 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935277Ab3E2W15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 18:27:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,766,1363158000"; 
   d="scan'208";a="248386631"
Subject: [v3][PATCH 0/4] Work around perf NMI-induced hangs
To: a.p.zijlstra@chello.nl
Cc: mingo@redhat.com, paulus@samba.org, acme@ghostprotocols.net,
        tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
        Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Wed, 29 May 2013 15:27:56 -0700
Message-Id: <20130529222756.25535229@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from v2:

2/4:
 * Only warn on the longest NMIs.  Don't print when over
   a threshhold.
 * Output in ms as opposed to ns
4/4:
 * Add some Documentation/ for the tracepoint
 * keep tracepoint delta in a s64 instead of an int, and
   vall it 'delta_ns' instead of 'len'

Changes from v1:

 * keep a running average instead of taking a single value
   for determining NMI lengths.
 * Fixed some of the math converting from ns to/from
   percentages (it was backwards)
 * Included nmi length tracepoint at end of series 

--

If root or an unprivileged user runs 'perf top', my system hangs.
If I'm lucky, I get a warning out to dmesg, along these lines:

	hrtimer: interrupt took 13915457 ns cpu: 132

or a hard-lockup message on occasion.

The proxmiate cause of this is that perf_event_nmi_handler() has
been observed to take tens of ms on occasion.  That needs to get
fixed, and I'm working on tracking the root cause down.

But, These patches make the situation better: perf can no longer
simply wedge the box, and we have a safe, controlled exit path
when things go wrong.
