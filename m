Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab3LLTFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 14:05:36 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:51154 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab3LLTFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 14:05:32 -0500
Date: Thu, 12 Dec 2013 16:05:25 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v0 07/71] perf tools: Record whether a dso is 64-bit
Message-ID: <20131212190525.GA11191@ghostprotocols.net>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1386765443-26966-8-git-send-email-alexander.shishkin@linux.intel.com>
 <52A8BC5D.2030603@gmail.com>
 <52A9A672.9050509@intel.com>
 <52A9E826.1020909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A9E826.1020909@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Dec 12, 2013 at 09:45:26AM -0700, David Ahern escreveu:
> On 12/12/13, 5:05 AM, Adrian Hunter wrote:
> 
> >>>diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
> >>>index 384f2d9..62680e1 100644
> >>>--- a/tools/perf/util/dso.h
> >>>+++ b/tools/perf/util/dso.h
> >>>@@ -91,6 +91,7 @@ struct dso {
> >>>       u8         annotate_warned:1;
> >>>       u8         sname_alloc:1;
> >>>       u8         lname_alloc:1;
> >>>+    u8         is_64_bit:1;
> >>
> >>The is_64_bit name seems a bit hardcoded. We need something similar for
> >>perf-trace to set the audit machine type for resolving syscalls. How about
> >>having this field set a machine type rather than a "64-bit" flag?
> >
> >I am not sure what you mean by "machine type".  For itrace the
> >implementation only deals with its own architecture (e.g. the intel_pt
> >pmu is only on Intel architecture) so it is not necessary to record
> >the architecture.
> >
> >is_64_bit corresponds to ELFCLASS64 (vs ELFCLASS32) which is needed
> >to determine whether the instruction set is 64-bit.  That should
> >work for other architectures too.
> >
> 
> perf-trace needs something similar -- an audit machine type to know
> how to convert syscall numbers to functions. One of the following
> per task:
> 
> typedef enum {
>     MACH_X86=0,
>     MACH_86_64,
>     MACH_IA64,
>     MACH_PPC64,
>     MACH_PPC,
>     MACH_S390X,
>     MACH_S390,
>     MACH_ALPHA,
>     MACH_ARMEB
> } machine_t;
> 
> I was pondering how the 2 can be combined into a common flag.

Well, if we can pass somehow the magic number of an executable mmap
in the PERF_RECORD_MMAP2 record, we would be able, together with the
data we already have in the perf.data header (uname in a live session),
to figure that out, no?

I.e. we wouldn't be limiting ourselves to the ELF executable format.

Time to read the kernel loader for the various formats we support...

- Arnaldo
