Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab3IROIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 10:08:49 -0400
Received: from smtpauth02.mfg.siteprotect.com ([64.26.60.136]:56604 "EHLO
	smtpauth02.mfg.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751494Ab3IROIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 10:08:48 -0400
Date: Wed, 18 Sep 2013 10:10:22 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Adrian Hunter <adrian.hunter@intel.com>
cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf: Fix broken union in ' struct
 perf_event_mmap_page'
In-Reply-To: <52396EB5.6050104@intel.com>
Message-ID: <alpine.DEB.2.02.1309180950420.22814@pianoman.cluster.toy>
References: <1372425741-1676-2-git-send-email-adrian.hunter@intel.com> <tip-860f085b74e9f0075de8140ed3a1e5b5e3e39aa8@git.kernel.org> <alpine.DEB.2.02.1309171617400.13303@pianoman.cluster.toy> <52396EB5.6050104@intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020202.5239B3F0.0037,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Sep 2013, Adrian Hunter wrote:

> On 17/09/13 23:23, Vince Weaver wrote:
> > 
> > This patch somehow breaks the perf-ABI.
> > 
> > If I take a program that reads "mmap->cap_usr_rdpmc" and compile it
> > against the new header with this change (say from 3.12-rc1)
> > and then run it on an old kernel (say 3.11) then I get "0" for
> > cap_usr_rdpmc.
> > 
> > If I take the same program and recompile against the old (without this 
> > patch) header and run it on 3.11, I get the expected "1" value.
> > 
> > So something about this changed the bit pattern in an incompatible 
> > fashion.
> 
> 
> cap_usr_time and cap_usr_rdpmc were occupying the same bit position i.e. bit 0
> 
> That means that cap_usr_time and cap_usr_rdpmc were both unreliable.

well then I have to say this patch wins today's award for "least 
useful commit message".  Why wasn't this important info there?
>From what it originally sounded like this was just some shuffling of
low-level C minutia, not a hard-to-resolve break in the perf ABI.

> Possible improvements are one or both of:
> 1. Add cap_usr_fixed to identify kernels that have the capabilities bits fixed
> 2. Swap the positions of cap_usr_time and cap_usr_rdpmc so that
> cap_usr_rdpmc remains in bit 0

Or just create two new fields and mark the old ones as obsolete somehow.

The problem with just making this change silently is now tools like PAPI 
that care about cap_usr_rdpmc will behave in hard-to-debug ways.

For example, code compiled against new headers but run with old kernels 
won't detect rdpmc properly

Code compiled against old headers but run with new kernels won't detect 
rdpmc properly.

It's true existing code could have problems if you ran on a machine with 
conflicting rdpmc/usr_time, but my tests never noticed that, presumably 
because rdpmc and usr_time were added at the same time (in 3.4), x86 
always enables rdpmc, and none of my code uses usr_time so I never see 
wrong time results.

Vince

