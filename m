Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbaHEORf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 10:17:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:19439 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041AbaHEORe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 10:17:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,804,1400050800"; 
   d="scan'208";a="580303037"
Date: Tue, 5 Aug 2014 07:17:33 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 05/33] perf record: Allow the user to disable time stamps
Message-ID: <20140805141733.GH5803@tassilo.jf.intel.com>
References: <1407169064-25625-1-git-send-email-acme@kernel.org>
 <1407169064-25625-6-git-send-email-acme@kernel.org>
 <20140805060856.GA9453@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140805060856.GA9453@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Time stamps are always implicitely enabled for record currently.  The
> > old --time/-T option is a nop.
> > 
> > Allow the user to disable timestamps by using --no-time
> > 
> > This can cause some minor misaccounting (by missing mmaps), but
> > significantly lowers the size of perf.data
> 
> I'm not any big change in size:
> 
>  -rw------- 1 mingo mingo 384768 Aug  5 08:01 perf.data.timestamps
>  -rw------- 1 mingo mingo 336952 Aug  5 08:00 perf.data.notimestamps

It will depend on your workload. What period did you use
(or did it automatically use) and what kind of 
workload was it?

The smaller the period, the higher the benefit.

There are some classes of workloads where using a smaller
period is especially beneficial, essentially anything
with lots of small events, instead of long loops.

You also get a higher benefit if you use -c or -F, because
without that each sample is smaller (no period reported)

You also get higher benefit for longer traces, and traces
that do not start a lot of programs, as those
tend to be dominated by MMAP events and other overhead.

> So either remove the --time option altogether, or fix its 
> 'misaccounting' so that the profile can be relied on.

I don't know how to fix it. Do you?

I guess one possible way to mitigate would be to lower the perf
buffer sizes, then the worst case out of ordering
would be less (I believe any potential problem
just comes from out of order events). However that may
impact performance.

-Andi
