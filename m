Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab3ISIm4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 04:42:56 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:46522 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab3ISImx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 04:42:53 -0400
Date: Thu, 19 Sep 2013 10:42:49 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Vince Weaver <vince@deater.net>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        adrian.hunter@intel.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf: Fix broken union in ' struct
 perf_event_mmap_page'
Message-ID: <20130919084249.GA14112@gmail.com>
References: <1372425741-1676-2-git-send-email-adrian.hunter@intel.com>
 <tip-860f085b74e9f0075de8140ed3a1e5b5e3e39aa8@git.kernel.org>
 <alpine.DEB.2.02.1309171617400.13303@pianoman.cluster.toy>
 <alpine.DEB.2.02.1309171632180.13443@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1309171632180.13443@pianoman.cluster.toy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vince Weaver <vince@deater.net> wrote:

> On Tue, 17 Sep 2013, Vince Weaver wrote:
> 
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
> 
> To follow up, the original case:
> 
>         union {
>                 __u64   capabilities;
>                 __u64   cap_usr_time  : 1,
>                         cap_usr_rdpmc : 1,
>                         cap_____res   : 62;
>         };
> 
>         Then mmap->usr_rdpmc=1; gets assembled as
> 
>         400420:       80 0d 11 05 20 00 02    orb    $0x2,0x200511(%rip)        

Hm, how can it be 0x2? Didn't you mix up the two assemblies accidentally?

> 
> The new version
> 
>        union {
>                 __u64   capabilities;
>                 struct {
>                         __u64   cap_usr_time            : 1,
>                                 cap_usr_rdpmc           : 1,
>                                 cap_usr_time_zero       : 1,
>                                 cap_____res             : 61;
>                 };
>         };
> 
>         mmap->usr_rdpmc=1; gets assembled as
> 
> 
>        400427:       80 0d 02 05 20 00 01    orb    $0x1,0x200502(%rip)        
> 
> note the difference in the or value.

Here the value should be 0x2, as cap_usr_rdpmc move to the second bit.

Right?

	Ingo
