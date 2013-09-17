Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab3IQUVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 16:21:53 -0400
Received: from smtpauth02.mfg.siteprotect.com ([64.26.60.136]:39837 "EHLO
	smtpauth02.mfg.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753180Ab3IQUVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 16:21:52 -0400
Date: Tue, 17 Sep 2013 16:23:25 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, adrian.hunter@intel.com, tglx@linutronix.de
cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf: Fix broken union in ' struct
 perf_event_mmap_page'
In-Reply-To: <tip-860f085b74e9f0075de8140ed3a1e5b5e3e39aa8@git.kernel.org>
Message-ID: <alpine.DEB.2.02.1309171617400.13303@pianoman.cluster.toy>
References: <1372425741-1676-2-git-send-email-adrian.hunter@intel.com> <tip-860f085b74e9f0075de8140ed3a1e5b5e3e39aa8@git.kernel.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020205.5238B9DF.013D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch somehow breaks the perf-ABI.

If I take a program that reads "mmap->cap_usr_rdpmc" and compile it
against the new header with this change (say from 3.12-rc1)
and then run it on an old kernel (say 3.11) then I get "0" for
cap_usr_rdpmc.

If I take the same program and recompile against the old (without this 
patch) header and run it on 3.11, I get the expected "1" value.

So something about this changed the bit pattern in an incompatible 
fashion.

Vince




On Tue, 23 Jul 2013, tip-bot for Adrian Hunter wrote:

> Commit-ID:  860f085b74e9f0075de8140ed3a1e5b5e3e39aa8
> Gitweb:     http://git.kernel.org/tip/860f085b74e9f0075de8140ed3a1e5b5e3e39aa8
> Author:     Adrian Hunter <adrian.hunter@intel.com>
> AuthorDate: Fri, 28 Jun 2013 16:22:17 +0300
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Tue, 23 Jul 2013 12:17:10 +0200
> 
> perf: Fix broken union in 'struct perf_event_mmap_page'
> 
> The capabilities bits must not be "union'ed" together.
> Put them in a separate struct.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Link: http://lkml.kernel.org/r/1372425741-1676-2-git-send-email-adrian.hunter@intel.com
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
>  include/uapi/linux/perf_event.h | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
> index 00d8274..0041aed 100644
> --- a/include/uapi/linux/perf_event.h
> +++ b/include/uapi/linux/perf_event.h
> @@ -375,9 +375,11 @@ struct perf_event_mmap_page {
>  	__u64	time_running;		/* time event on cpu */
>  	union {
>  		__u64	capabilities;
> -		__u64	cap_usr_time  : 1,
> -			cap_usr_rdpmc : 1,
> -			cap_____res   : 62;
> +		struct {
> +			__u64	cap_usr_time		: 1,
> +				cap_usr_rdpmc		: 1,
> +				cap_____res		: 62;
> +		};
>  	};
>  
>  	/*
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
k
