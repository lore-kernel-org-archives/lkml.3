Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab3IRUGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 16:06:21 -0400
Received: from smtpauth05h.mfg.siteprotect.com ([64.26.60.146]:38780 "EHLO
	smtpauth05.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751675Ab3IRUGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 16:06:20 -0400
Date: Wed, 18 Sep 2013 16:07:52 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Peter Zijlstra <peterz@infradead.org>
cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        adrian.hunter@intel.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org, eranian@googlemail.com
Subject: Re: [tip:perf/core] perf: Fix broken union in ' struct
 perf_event_mmap_page'
In-Reply-To: <20130918154224.GK9326@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.02.1309181556370.26402@pianoman.cluster.toy>
References: <1372425741-1676-2-git-send-email-adrian.hunter@intel.com> <tip-860f085b74e9f0075de8140ed3a1e5b5e3e39aa8@git.kernel.org> <alpine.DEB.2.02.1309171617400.13303@pianoman.cluster.toy> <20130918085722.GL12926@twins.programming.kicks-ass.net>
 <alpine.DEB.2.02.1309181013100.23210@pianoman.cluster.toy> <20130918154224.GK9326@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020201.523A07BB.0172,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Sep 2013, Peter Zijlstra wrote:

> On Wed, Sep 18, 2013 at 10:19:32AM -0400, Vince Weaver wrote:
> > Can you point to any code that is fixed by the commit?
> 
> I have some, but I don't think a lot of people use it.
> 
> Would you be ok with something like the below? It should preserve
> functionality for code that only cares about cap_usr_rdpmc (PAPI).
> 
> Stephane, does libpfm use any of these?
> 
> --- a/include/uapi/linux/perf_event.h
> +++ b/include/uapi/linux/perf_event.h
> @@ -380,8 +380,8 @@ struct perf_event_mmap_page {
>  	union {
>  		__u64	capabilities;
>  		struct {
> -			__u64	cap_usr_time		: 1,
> -				cap_usr_rdpmc		: 1,
> +			__u64	cap_usr_rdpmc		: 1,
> +				cap_usr_time		: 1,
>  				cap_usr_time_zero	: 1,
>  				cap_____res		: 61;
>  		};
> 

It would be nice if there was some way to detect this change; I liked the 
idea of a "cap_usr_fixed" bit.

Even with your change you can't have code that can reliably detect both 
cap_usr_time and cap_usr_rdpmc unless you can guarantee that both 
perf_event.h and the kernel are 3.12 or newer, and it gets more 
complicated if distros backport this patch.

Tools like PAPI often carry around their own copy of perf_event.h and 
people like to move around binaries between machines with different kernel 
versions so things get complicated quickly.

Vince
