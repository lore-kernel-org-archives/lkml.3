Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab3KFNsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 08:48:50 -0500
Received: from smtpauth03h.mfg.siteprotect.com ([64.26.60.134]:36382 "EHLO
	smtpauth03.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932196Ab3KFNsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 08:48:47 -0500
Date: Wed, 6 Nov 2013 08:50:47 -0500 (EST)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: mingo@kernel.org, hpa@zytor.com, anton@samba.org,
        mathieu.desnoyers@polymtl.ca, linux-kernel@vger.kernel.org,
        peterz@infradead.org, michael@ellerman.id.au,
        paulmck@linux.vnet.ibm.com, benh@kernel.crashing.org,
        fweisbec@gmail.com, VICTORK@il.ibm.com, tglx@linutronix.de,
        oleg@redhat.com, mikey@neuling.org
cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] tools/perf: Add required memory barriers
In-Reply-To: <tip-a94d342b9cb09edfe888ea972af0883b6a8d992b@git.kernel.org>
Message-ID: <alpine.DEB.2.02.1311060847340.27224@pianoman.cluster.toy>
References: <20131030104246.GH16117@laptop.programming.kicks-ass.net> <tip-a94d342b9cb09edfe888ea972af0883b6a8d992b@git.kernel.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020208.527A48BE.011F,ss=1,re=0.100,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Nov 2013, tip-bot for Peter Zijlstra wrote:

> Commit-ID:  a94d342b9cb09edfe888ea972af0883b6a8d992b
> Gitweb:     http://git.kernel.org/tip/a94d342b9cb09edfe888ea972af0883b6a8d992b
> Author:     Peter Zijlstra <peterz@infradead.org>
> AuthorDate: Wed, 30 Oct 2013 11:42:46 +0100
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Wed, 6 Nov 2013 12:34:26 +0100
> 
> tools/perf: Add required memory barriers
> 
> To match patch bf378d341e48 ("perf: Fix perf ring buffer memory
> ordering") change userspace to also adhere to the ordering outlined.

...

> +++ b/tools/perf/util/evlist.h
> @@ -177,7 +177,7 @@ int perf_evlist__strerror_open(struct perf_evlist *evlist, int err, char *buf, s
>  static inline unsigned int perf_mmap__read_head(struct perf_mmap *mm)
>  {
>  	struct perf_event_mmap_page *pc = mm->base;
> -	int head = pc->data_head;
> +	int head = ACCESS_ONCE(pc->data_head);
>  	rmb();
>  	return head;

so is this ACCESS_ONCE required now for proper access to the mmap buffer?

remember that there are users trying to use this outside of the kernel 
where we don't necessarily have access to internal kernl macros.  Some of 
these users aren't necessarily GPLv2 compatible either (PAPI for example 
is more or less BSD licensed) so just cutting and pasting chunks of 
internal kernel macros isn't always the best route either.

Vince

