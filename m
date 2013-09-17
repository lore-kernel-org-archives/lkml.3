Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab3IQUd7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 16:33:59 -0400
Received: from smtpauth05h.mfg.siteprotect.com ([64.26.60.146]:51283 "EHLO
	smtpauth05.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753007Ab3IQUd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 16:33:58 -0400
Date: Tue, 17 Sep 2013 16:35:30 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, adrian.hunter@intel.com, tglx@linutronix.de
cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf: Fix broken union in ' struct
 perf_event_mmap_page'
In-Reply-To: <alpine.DEB.2.02.1309171617400.13303@pianoman.cluster.toy>
Message-ID: <alpine.DEB.2.02.1309171632180.13443@pianoman.cluster.toy>
References: <1372425741-1676-2-git-send-email-adrian.hunter@intel.com> <tip-860f085b74e9f0075de8140ed3a1e5b5e3e39aa8@git.kernel.org> <alpine.DEB.2.02.1309171617400.13303@pianoman.cluster.toy>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020208.5238BCB5.01EF,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Sep 2013, Vince Weaver wrote:

> 
> This patch somehow breaks the perf-ABI.
> 
> If I take a program that reads "mmap->cap_usr_rdpmc" and compile it
> against the new header with this change (say from 3.12-rc1)
> and then run it on an old kernel (say 3.11) then I get "0" for
> cap_usr_rdpmc.
> 
> If I take the same program and recompile against the old (without this 
> patch) header and run it on 3.11, I get the expected "1" value.

To follow up, the original case:

        union {
                __u64   capabilities;
                __u64   cap_usr_time  : 1,
                        cap_usr_rdpmc : 1,
                        cap_____res   : 62;
        };

        Then mmap->usr_rdpmc=1; gets assembled as

        400420:       80 0d 11 05 20 00 02    orb    $0x2,0x200511(%rip)        

The new version

       union {
                __u64   capabilities;
                struct {
                        __u64   cap_usr_time            : 1,
                                cap_usr_rdpmc           : 1,
                                cap_usr_time_zero       : 1,
                                cap_____res             : 61;
                };
        };

        mmap->usr_rdpmc=1; gets assembled as


       400427:       80 0d 02 05 20 00 01    orb    $0x1,0x200502(%rip)        

note the difference in the or value.

Vince
