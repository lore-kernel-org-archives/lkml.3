Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806Ab3AWG24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 01:28:56 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:53723 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab3AWG2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 01:28:53 -0500
Message-ID: <1358922520.5752.91.camel@marge.simpson.net>
Subject: Re: [RFC PATCH 0/2] sched: simplify the select_task_rq_fair()
From: Mike Galbraith <bitbucket@online.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
        mingo@kernel.org, a.p.zijlstra@chello.nl
Date: Wed, 23 Jan 2013 07:28:40 +0100
In-Reply-To: <50FF7086.4020509@linux.vnet.ibm.com>
References: <1356588535-23251-1-git-send-email-wangyun@linux.vnet.ibm.com>
	 <50ED384C.1030301@linux.vnet.ibm.com>
	 <1357977704.6796.47.camel@marge.simpson.net>
	 <1357985943.6796.55.camel@marge.simpson.net>
	 <1358155290.5631.19.camel@marge.simpson.net>
	 <50F79256.1010900@linux.vnet.ibm.com>
	 <1358654997.5743.17.camel@marge.simpson.net>
	 <50FCACE3.5000706@linux.vnet.ibm.com>
	 <1358743128.4994.33.camel@marge.simpson.net>
	 <50FCCCF5.30504@linux.vnet.ibm.com>
	 <1358750523.4994.55.camel@marge.simpson.net>
	 <1358752180.4994.65.camel@marge.simpson.net>
	 <50FCF212.3010504@linux.vnet.ibm.com>
	 <1358759355.4994.108.camel@marge.simpson.net>
	 <50FD08E1.8000302@linux.vnet.ibm.com>
	 <1358761496.4994.118.camel@marge.simpson.net>
	 <50FE0ADC.6060701@linux.vnet.ibm.com>
	 <1358841795.5782.255.camel@marge.simpson.net>
	 <50FE5433.1070801@linux.vnet.ibm.com>
	 <1358865692.5782.420.camel@marge.simpson.net>
	 <50FF4EA0.1070000@linux.vnet.ibm.com>
	 <1358915494.5752.46.camel@marge.simpson.net>
	 <50FF7086.4020509@linux.vnet.ibm.com>
Content-Type: multipart/mixed; boundary="=-0bFNyVy9yOrrEWZookDU"
X-Mailer: Evolution 3.2.3 
Mime-Version: 1.0
X-Provags-ID: V02:K0:TO9wLOSbG87PSRDpdAqomDrO6e+viBf040GeV4LZH5l
 /JvtB9uaUt1qaB1LKfoEaE8uvlT6PlwFD2KZRkR/3sEyG+nYxt
 6veRFNdoLUJj/as2Nt/n0xl7bocoG9W0kKeGUY0cR261AO1KJQ
 EEldz8fTFHRkwH2dhr2NHyqFzFZ9CSAcCBc9dhKJIp8lGCuUSP
 waQR613Zt5Pn2sg1cVw8Bqr30+U1J2/U5DnN3bNDty7njqkq77
 MBk/qXXj9ckUDyE9XBLX8iQFWOse8D4UI6vQazpvakjcCgrRy2
 wk2YkF9RZfn99lFKRZMYE0VVM0g6go8HZK3b9TMAcNxgllzK1Z
 HgTsoEhe3Du+RMCwHOyJKvzhhzpVNXtVK73nzBmsFnD1LXelJu
 cYU9sONqVv5Aw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0bFNyVy9yOrrEWZookDU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Wed, 2013-01-23 at 13:09 +0800, Michael Wang wrote: 
> On 01/23/2013 12:31 PM, Mike Galbraith wrote:

> > Another thing that wants fixing: root can set flags for _existing_
> > domains any way he likes,
> 
> Can he? on running time changing the domain flags? I do remember I used to
> send out some patch to achieve that but was refused since it's dangerous...

Yes, flags can be set any way you like, which works just fine when flags
are evaluated at runtime.

WRT dangerous: if root says "Let there be stupidity", stupidity should
appear immediately :)

> but when he invokes godly powers to rebuild
> > domains, he gets what's hard coded, which is neither clever (godly
> > wrath;), nor wonderful for godly runtime path decisions.
> 
> The purpose is to using a map to describe the sd topology of a cpu, it
> should be rebuild correctly according to the new topology when attaching
> new domain to a cpu.

Try turning FORK/EXEC/WAKE on/off.

echo [01] > [cpuset]/sched_load_balance will rebuild, but resulting
domains won't reflect flag your change. 

> For this case, it's really strange that level 2 was missed in topology,
> I found that in build_sched_domains(), the level was added one by one,
> and I don't know why it jumps here...sounds like some BUG to me.
> 
> Whatever, the sbm should still work properly by designed, even in such
> strange topology, if it's initialized correctly.
> 
> And below patch will do help on it, just based on the original patch set.
> 
> Could you please take a try on it, it's supposed to make the balance path
> correctly, and please apply below DEBUG patch too, so we could know how it
> changes, I think this time, we may be able to solve the issue by the right
> way ;-)

Done, previous changes backed out, new change applied on top of v2 set.
Full debug output attached.

Domain flags on this box (bogus CPU domain is still patched away).

monteverdi:/abuild/mike/aim7/:[127]# tune-sched-domains
usage: tune-sched-domains <val>
{cpu0/domain0:SIBLING} SD flag: 687
+   1: SD_LOAD_BALANCE:          Do load balancing on this domain
+   2: SD_BALANCE_NEWIDLE:       Balance when about to become idle
+   4: SD_BALANCE_EXEC:          Balance on exec
+   8: SD_BALANCE_FORK:          Balance on fork, clone
-  16: SD_BALANCE_WAKE:          Wake to idle CPU on task wakeup
+  32: SD_WAKE_AFFINE:           Wake task to waking CPU
-  64: SD_PREFER_LOCAL:          Prefer to keep tasks local to this domain
+ 128: SD_SHARE_CPUPOWER:        Domain members share cpu power
- 256: SD_POWERSAVINGS_BALANCE:  Balance for power savings
+ 512: SD_SHARE_PKG_RESOURCES:   Domain members share cpu pkg resources
-1024: SD_SERIALIZE:             Only a single load balancing instance
-2048: SD_ASYM_PACKING:          Place busy groups earlier in the domain
-4096: SD_PREFER_SIBLING:        Prefer to place tasks in a sibling domain
-8192: SD_PREFER_UTILIZATION:    Prefer utilization over SMP nice
{cpu0/domain1:MC} SD flag: 559
+   1: SD_LOAD_BALANCE:          Do load balancing on this domain
+   2: SD_BALANCE_NEWIDLE:       Balance when about to become idle
+   4: SD_BALANCE_EXEC:          Balance on exec
+   8: SD_BALANCE_FORK:          Balance on fork, clone
-  16: SD_BALANCE_WAKE:          Wake to idle CPU on task wakeup
+  32: SD_WAKE_AFFINE:           Wake task to waking CPU
-  64: SD_PREFER_LOCAL:          Prefer to keep tasks local to this domain
- 128: SD_SHARE_CPUPOWER:        Domain members share cpu power
- 256: SD_POWERSAVINGS_BALANCE:  Balance for power savings
+ 512: SD_SHARE_PKG_RESOURCES:   Domain members share cpu pkg resources
-1024: SD_SERIALIZE:             Only a single load balancing instance
-2048: SD_ASYM_PACKING:          Place busy groups earlier in the domain
-4096: SD_PREFER_SIBLING:        Prefer to place tasks in a sibling domain
-8192: SD_PREFER_UTILIZATION:    Prefer utilization over SMP nice
{cpu0/domain2:NUMA} SD flag: 9263
+   1: SD_LOAD_BALANCE:          Do load balancing on this domain
+   2: SD_BALANCE_NEWIDLE:       Balance when about to become idle
+   4: SD_BALANCE_EXEC:          Balance on exec
+   8: SD_BALANCE_FORK:          Balance on fork, clone
-  16: SD_BALANCE_WAKE:          Wake to idle CPU on task wakeup
+  32: SD_WAKE_AFFINE:           Wake task to waking CPU
-  64: SD_PREFER_LOCAL:          Prefer to keep tasks local to this domain
- 128: SD_SHARE_CPUPOWER:        Domain members share cpu power
- 256: SD_POWERSAVINGS_BALANCE:  Balance for power savings
- 512: SD_SHARE_PKG_RESOURCES:   Domain members share cpu pkg resources
+1024: SD_SERIALIZE:             Only a single load balancing instance
-2048: SD_ASYM_PACKING:          Place busy groups earlier in the domain
-4096: SD_PREFER_SIBLING:        Prefer to place tasks in a sibling domain
+8192: SD_PREFER_UTILIZATION:    Prefer utilization over SMP nice

Abbreviated test run:
Tasks    jobs/min  jti  jobs/min/task      real       cpu
  640   158044.01   81       246.9438     24.54    577.66   Wed Jan 23 07:14:33 2013
 1280    50434.33   39        39.4018    153.80   5737.57   Wed Jan 23 07:17:07 2013
 2560    47214.07   34        18.4430    328.58  12715.56   Wed Jan 23 07:22:36 2013


--=-0bFNyVy9yOrrEWZookDU
Content-Type: application/x-gzip; name="dmesg.gz"
Content-Disposition: attachment; filename="dmesg.gz"
Content-Transfer-Encoding: base64

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
yICRCnxQ7DwJfFDufJc3ysbx/wEsseZeVgwCAB==


--=-0bFNyVy9yOrrEWZookDU--

