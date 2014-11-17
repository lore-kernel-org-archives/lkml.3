Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbaKQVpV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 16:45:21 -0500
Received: from mga11.intel.com ([192.55.52.93]:47172 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbaKQVpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 16:45:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,405,1413270000"; 
   d="scan'208";a="633445357"
Date: Mon, 17 Nov 2014 13:45:18 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, kan.liang@intel.com,
        adrian.hunter@intel.com, markus.t.metzger@intel.com,
        mathieu.poirier@linaro.org, acme@infradead.org,
        Peter Zijlstra <peterz@infradead.org>,
        Michael Ellerman <michaele@au1.ibm.com>
Subject: Re: [PATCH v8 02/14] perf: Add AUX area to ring buffer for raw data
 streams
Message-ID: <20141117214518.GD10824@tassilo.jf.intel.com>
References: <1415972627-37514-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1415972627-37514-3-git-send-email-alexander.shishkin@linux.intel.com>
 <20141117212400.GB13111@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141117212400.GB13111@us.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 01:24:00PM -0800, Sukadev Bhattiprolu wrote:
> Alexander Shishkin [alexander.shishkin@linux.intel.com] wrote:
> | From: Peter Zijlstra <peterz@infradead.org>
> | 
> | This patch introduces "AUX space" in the perf mmap buffer, intended for
> | exporting high bandwidth data streams to userspace, such as instruction
> | flow traces.
> | 
> | AUX space is a ring buffer, defined by aux_{offset,size} fields in the
> | user_page structure, and read/write pointers aux_{head,tail}, which abide
> | by the same rules as data_* counterparts of the main perf buffer.
> 
> The "format" of this raw stream of data can differ across processors
> (and architecutres) correct ? i.e the perf tool processing of this
> aux data will also differ across processors ?

Yes.

The main caveat is that you need special handling code in perf.

> 
> Power8 processors support what we call 24x7 counters that collect info
> on a large number of events. The current 24x7 support in
> (arch/powerpc/perf/hv-24x7.c) currently uses reading one counter at a
> time using the pmu->read() interface.
> 
> We are looking for ways to export much larger number of counters through
> one pmu->read() or another call. I am trying to see if the hv-24x7 pmu
> could use this aux interface and then have/implement a helper in perf
> tool to extract the counter values.

It's probably only worth it if your amount of data is extremely
high and has to be to compressed (like in PT -- no choice, cannot do it
otherwise)

If your data amounts are more reasonable it will be a lot
simpler to stay with the current perf interfaces, even
though they have a bit higher overhead.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
