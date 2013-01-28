Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605Ab3A1Rt7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 12:49:59 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:39506 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756991Ab3A1Rt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 12:49:56 -0500
MIME-Version: 1.0
In-Reply-To: <1359307995-30640-1-git-send-email-jolsa@redhat.com>
References: <1359307995-30640-1-git-send-email-jolsa@redhat.com>
Date: Mon, 28 Jan 2013 18:49:55 +0100
Message-ID: <CABPqkBSKGMUAdbqRGUWoaMH1McLDGgZUfHw3P4BAAOLSDYjH8Q@mail.gmail.com>
Subject: Re: [RFC/PATCH] perf x86: Add off-core event constraints for
 Sandy/IvyBridge micro architecture
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 27, 2013 at 6:33 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> hi,
> I was looking at the offcore stuff and it looks like we might
> be missing some constraints for offcore response events on
> Sandy/IvyBridge.
>
> The table 18.8.5 (Off-core Response Performance Monitoring)
> in Intel SDM states PMC0 for 0xb7 and PMC3 for 0xbb, but
> there's no other explanation or related description.
>
> I can't say/ack if the counters looks bad or right with or
> without the patch so far.. so just curious ;-)
>
Those are artificial constraints which should not be there.
Remember that offcore_rsp uses an extra MSR which has
to be shared by all the counters on the PMU. So a way to
handle the sharing of that extra MSR is to impose an
artificial constraint on the event itself. If it can only run
on one counter, then you get the management of the
extra MSR for free, i.e., only one event gets it.

In perf_events, we use a more sophisticated dynamic scheme
which does not use this artificial constraint. We can measure
the event multiple times and share the extra MSR if possible
(same value). Why multiple times you might ask? For instance,
with different priv levels.


Hope this helps.

> ---
> The Intel SDM (18.8.5 Off-core Response Performance Monitoring)
> states the off-core events MSR_OFFCORE_RSP_0/MSR_OFFCORE_RSP_03
> to be defined only for PMC0/PMC3 respectively.
>
> Adding related constraints.
>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Stephane Eranian <eranian@google.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index 5dc54fc..d1f240f 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -105,6 +105,8 @@ static struct event_constraint intel_snb_event_constraints[] __read_mostly =
>         INTEL_EVENT_CONSTRAINT(0x48, 0x4), /* L1D_PEND_MISS.PENDING */
>         INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PREC_DIST */
>         INTEL_EVENT_CONSTRAINT(0xcd, 0x8), /* MEM_TRANS_RETIRED.LOAD_LATENCY */
> +       INTEL_EVENT_CONSTRAINT(0xb7, 0x1), /* MSR_OFFCORE_RSP_0 - PMC0 only*/
> +       INTEL_EVENT_CONSTRAINT(0xbb, 0x8), /* MSR_OFFCORE_RSP_1 - PMC3 only*/
>         EVENT_CONSTRAINT_END
>  };
>
> --
> 1.7.11.7
>
