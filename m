Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233AbaISQZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 12:25:27 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:57572 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756002AbaISQZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 12:25:26 -0400
From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/2] perf session: Add option to copy events when queueing
References: <1411060059-23589-1-git-send-email-yarygin@linux.vnet.ibm.com>
	<1411060059-23589-2-git-send-email-yarygin@linux.vnet.ibm.com>
	<20140918185345.GJ2770@kernel.org> <541B3ECD.8000706@gmail.com>
	<541B40A8.8020406@gmail.com> <87r3z86lnu.fsf@linux.vnet.ibm.com>
	<541C3BEF.4010907@gmail.com>
Date: Fri, 19 Sep 2014 20:25:17 +0400
In-Reply-To: <541C3BEF.4010907@gmail.com> (David Ahern's message of "Fri, 19
	Sep 2014 08:21:35 -0600")
Message-ID: <87k34z7f2q.fsf@linux.vnet.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091916-3548-0000-0000-000001897B32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 9/19/14, 2:48 AM, Alexander Yarygin wrote:
>> It did't work. Turned out that there is at least one event alive after
>> finished_round(), usually I get more - ~20. Not sure why, maybe it's
>> another problem which should be solved at first?
>
> hmm.... perf_evlist__mmap_consume is not at the event level, but at
> the mmap level -- it assumes everything read has been processed which
> is not true for this case.
>
> David

So, in general, we know when each event has been processed, but at that
time there is no reference to appropriate mmap. To create that link we
still need to allocate something per event.


I'm confused by the applying perf_evlist__mmap_consume() for each
perf_evlist__mmap_read, shouldn't it be for each perf_kvm__mmap_read_idx()?

	for (i = 0; i < kvm->evlist->nr_mmaps; i++) {
		n = perf_kvm__mmap_read_idx(kvm, i, &mmap_time);
		perf_evlist__mmap_consume(kvm->evlist, idx); /* <-- here? */
		if (n < 0)
			return -1;

