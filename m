Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbaIRHpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 03:45:21 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58686 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755786AbaIRHpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 03:45:20 -0400
Date: Thu, 18 Sep 2014 09:45:07 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dave Hansen <dave@sr71.net>
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, hpa@linux.intel.com,
        brice.goglin@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/6] fix topology for multi-NUMA-node CPUs
Message-ID: <20140918074507.GD24842@nazgul.tnic>
References: <20140917223310.026BCC2C@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140917223310.026BCC2C@viggo.jf.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 03:33:10PM -0700, Dave Hansen wrote:
> This is a big fat RFC.  It takes quite a few liberties with the
> multi-core topology level that I'm not completely comfortable
> with.
> 
> It has only been tested lightly.
> 
> Full dmesg for a Cluster-on-Die system with this set applied,
> and sched_debug on the command-line is here:
> 
> 	http://sr71.net/~dave/intel/full-dmesg-hswep-20140917.txt

So how do I find out what topology this system has?

[    0.175294] .... node  #0, CPUs:        #1
[    0.190970] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.191813]   #2  #3  #4  #5  #6  #7  #8
[    0.290753] .... node  #1, CPUs:    #9 #10 #11 #12 #13 #14 #15 #16 #17
[    0.436162] .... node  #2, CPUs:   #18 #19 #20 #21 #22 #23 #24 #25 #26
[    0.660795] .... node  #3, CPUs:   #27 #28 #29 #30 #31 #32 #33 #34 #35
[    0.806365] .... node  #0, CPUs:   #36 #37 #38 #39 #40 #41 #42 #43 #44
[    0.933573] .... node  #1, CPUs:   #45 #46 #47 #48 #49 #50 #51 #52 #53
[    1.061079] .... node  #2, CPUs:   #54 #55 #56 #57 #58 #59 #60 #61 #62
[    1.188491] .... node  #3, CPUs:   #63
[    1.202620] x86: Booted up 4 nodes, 64 CPUs

SRAT says 4 nodes but I'm guessing from the context those 4 nodes are
actually in pairs in two physical sockets, right?

Btw, you'd need to increase NR_CPUS because you obviously have more
APICs than 64.

So if we pick a cpu at random:

[    1.350640] CPU49 attaching sched-domain:
[    1.350641]  domain 0: span 13,49 level SMT
[    1.350642]   groups: 49 (cpu_capacity = 588) 13 (cpu_capacity = 588)
[    1.350644]   domain 1: span 9-17,45-53 level MC
[    1.350645]    groups: 13,49 (cpu_capacity = 1176) 14,50 (cpu_capacity = 1176) 15,51 (cpu_capacity = 1176) 16,52 (cpu_capa
city = 1176) 17,53 (cpu_capacity = 1176) 9,45 (cpu_capacity = 1176) 10,46 (cpu_capacity = 1177) 11,47 (cpu_capacity = 1176) 1
2,48 (cpu_capacity = 1176)
[    1.350654]    domain 2: span 0-17,36-53 level NUMA
[    1.350655]     groups: 9-17,45-53 (cpu_capacity = 10585) 0-8,36-44 (cpu_capacity = 10589)
[    1.350659]     domain 3: span 0-63 level NUMA
[    1.350660]      groups: 0-17,36-53 (cpu_capacity = 21174) 18-35,54-63 (cpu_capacity = 19944)

domain level 1 MC is what tells me which cores are on the internal nodes
of a socket? Or how do we find that out? Or even, do we need that info
at all...?

It might be useful for RAS and when we want to disable cores or whatever...

Thanks.

-- 
Regards/Gruss,
    Boris.
--
