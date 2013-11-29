Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab3K2NeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 08:34:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433Ab3K2NeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 08:34:22 -0500
Date: Fri, 29 Nov 2013 14:33:40 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [BUG] perf stat: explicit grouping yields unexpected results
Message-ID: <20131129133340.GA25751@krava.brq.redhat.com>
References: <CABPqkBTiBHF4wZ3c_Czkh3JgvXGNWJW1LH42Jh4NG_ZJkGkbgw@mail.gmail.com>
 <20131115063457.GB12442@gmail.com>
 <CABPqkBQ2wD_knJP9FQxThSxNng4DZhtRxeUUAW0efAs9=jBXEA@mail.gmail.com>
 <20131115103405.GA18264@gmail.com>
 <20131117034134.GA19762@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131117034134.GA19762@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 16, 2013 at 07:41:34PM -0800, Andi Kleen wrote:
> > I'd say that the default behavior should be what Jiri implemented: get 
> > the most out of the situation and inform. But you are right in that 
> > 'forcing' all elements of a group to be valid should be possible as 
> > well - if a special perf stat option or event format is used.
> 
> When something is multiplexed it can have a very 
> large measurement error. For workloads that fluctuate quite a bit, and the
> fluctuations do not line up well with the multiplexing interval,
> the default scaling does not give good results.
> 
> So you expect to get good data, but you get very bad data.
> 
> When collecting data for a large number of events it is important
> to group them correctly, so that events that are directly dependent
> on each other in equations are properly grouped.
> 
> When explicit groups were added the user likely considered this 
> problem, so it's not good to silently override the choices.
> 
> If a user doesn't care they can always not use groups.
> 
> > Even in that second case it shouldn't say <unsupported> for everything 
> > in the result, but should deny the run immediately and return with an 
> > error, and should tell the user how many events in the group fit and 
> > which ones didn't.
> 
> Returning this information would be great, but it would really 
> need an extended errno, or just a error string reported out.

(sry for late reply, I was still ooo, and missed this conversation)

I agree, when the last event fails sys_perf_event_open
due to the validate_group check, we will get just EINVAL

Was there any discussion about the error (or erorr string)
propagation from sys_perf_event_open?

Something like below? user space supply buffer for error string.

jirka


---
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index e1802d6..a827870 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -331,8 +331,8 @@ struct perf_event_attr {
 	 */
 	__u32	sample_stack_user;
 
-	/* Align to u64. */
-	__u32	__reserved_2;
+	__u32	errstr_size;
+	char	*errstr;
 };
 
 #define perf_flags(attr)	(*(&(attr)->read_format + 1))

