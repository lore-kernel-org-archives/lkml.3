Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310AbaGLFdM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 01:33:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:59324 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbaGLFdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 01:33:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,647,1400050800"; 
   d="scan'208";a="560813267"
Message-ID: <53C0C891.5070405@intel.com>
Date: Sat, 12 Jul 2014 08:33:05 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        "Shishkin, Alexander" <alexander.shishkin@intel.com>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: perf tools: Call graph from Intel BTS
References: <53BFF679.2030006@intel.com> <20140711151818.GG8014@kernel.org>
In-Reply-To: <20140711151818.GG8014@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2014 6:18 p.m., Arnaldo Carvalho de Melo wrote:
> Em Fri, Jul 11, 2014 at 05:36:41PM +0300, Adrian Hunter escreveu:
>> There are many perf tools patches and it would be helpful to start
>> considering how to get them into mainline.  Many need to wait for
>> the driver, but others could be taken sooner.
>
> We can go on looking at each of the patches to see which ones can be
> cherry picked, i.e. the ones that are fixes and not related to the work
> you're doing, like:
>
> commit 244c87b15b124914827f3ce28d8e70c8d147c9d0
> Author: Adrian Hunter <adrian.hunter@intel.com>
> Date:   Wed Jun 11 09:33:17 2014 +0300
>
>      perf tools: Fix the value used for unknown pids
>
>      The value used for unknown pids cannot be zero
>      because that is used by the "idle" task.
>      Use -1 instead.  Also handle the unknown pid
>      case when creating map groups.
>
>      Note that, threads with an unknown pid should not
>      occur because fork (or synthesized) events precede
>      the thread's existence.
>
>      Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>
> But then one by one they need to be reviewed to check if the changes were made
> to the whole tools/perf/ tree and if perhaps something new came along since you
> changed some assumption, like 0 meaning unknown thread, in the above patch:
>
> [acme@ssdandy linux]$ find tools -name "*.[ch]" | xargs grep machine__findnew_thread | grep 0
> tools/perf/util/session.c:	thread = machine__findnew_thread(&session->machines.host, 0, 0);

That's the idle thread.

> tools/perf/tests/thread-mg-share.c:	leader = machine__findnew_thread(machine, 0, 0);
> tools/perf/tests/thread-mg-share.c:	t1     = machine__findnew_thread(machine, 0, 1);
> tools/perf/tests/thread-mg-share.c:	t2     = machine__findnew_thread(machine, 0, 2);
> tools/perf/tests/thread-mg-share.c:	t3     = machine__findnew_thread(machine, 0, 3);

Those are valid pids for that test.

> [acme@ssdandy linux]$
>
> So I think that one way to reduce the size of that branch is to do just that:
> start fresh from tip/perf/core, and go cherry picking those patches, making sure that they
> take into account the whole current tools/perf/ tree, then ask for this patch to be pulled.
>
> You could then rebase the old branch on top of the resulting branch once it is
> merged upstream, rinse repeat.

Sounds good, thanks!  It is currently based on tip/perf/core from a few days ago, so the
current patches should be mostly ok.  I will make a selection and check them again.
