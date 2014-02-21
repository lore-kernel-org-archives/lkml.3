Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbaBUFvw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 00:51:52 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:51624 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaBUFvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 00:51:50 -0500
Message-ID: <1392961903.5451.58.camel@marge.simpson.net>
Subject: Re: [PATCH v2] sched: keep quiescent cpu out of idle balance loop
From: Mike Galbraith <bitbucket@online.de>
To: Lei Wen <leiwen@marvell.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@redhat.com,
        preeti.lkml@gmail.com, daniel.lezcano@linaro.org,
        viresh.kumar@linaro.org, xjian@marvell.com,
        linux-kernel@vger.kernel.org
Date: Fri, 21 Feb 2014 06:51:43 +0100
In-Reply-To: <1392949390-9867-1-git-send-email-leiwen@marvell.com>
References: <20140220122311.GO27965@twins.programming.kicks-ass.net>
	 <1392949390-9867-1-git-send-email-leiwen@marvell.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:RknM6BOd3CX0tRz53/2BUtUR0dnoRv54b5zfliHDv92
 aQYj2X63g4shAth66M30T4mYiIw/4Oni/C02Fnu8mJ6J/Iaohi
 2YNXBO0esyhLXPG5tfny+UOyb7MTpZdTdZ7KvcGSSTOqpT1VJm
 WcgjZ3Qs+Q6ts8CkmZDeAdu1l3sxQQ2y3lYyHjdjH+1S5CJNuD
 /NEBer2bujMDfsG0RO9eleRkUuyXq+Uo7WiysC5OM/Id01fBW6
 l92wE8xckbjLx8VcH9AQElN/kRCItNzNWJfmBEOJT2FnXc4jhu
 zePsdfQiq83MFiNynwGqYf6IYX7McL5nTxopJ4oe0nvHz7ZRtp
 Yd+sNQRBhlKLBq/yqunuVC9AmlxGJKsa+j8KPsqfwm+ngr8aBa
 h1rzf+lZzcXjQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-21 at 10:23 +0800, Lei Wen wrote: 
> Cpu which is put into quiescent mode, would remove itself
> from kernel's sched_domain, and want others not disturb its
> task running. But current scheduler would not checking whether
> that cpu is setting in such mode, and still insist the quiescent
> cpu to response the nohz load balance.

Let's isolate some CPUs.

Setup:
/-----"system" CPU0
\
  \---"rtcpus" CPUs1-3

crash> runqueues
PER-CPU DATA TYPE:
  struct rq runqueues;
PER-CPU ADDRESSES:
  [0]: ffff88022fc12c00
  [1]: ffff88022fc92c00
  [2]: ffff88022fd12c00
  [3]: ffff88022fd92c00 
crash> struct rq ffff88022fd92c00 | grep sd
  sd = 0x0,  <== yup, CPU3 is isolated bit of silicon
crash> struct rq ffff88022fd92c00 | grep rd
  rd = 0xffffffff81bffe60 <def_root_domain>,
crash> struct -x root_domain 0xffffffff81bffe60
...
  span = {{
      bits = {0xe} <== "rtcpus"
    }},
crash> struct rq ffff88022fc12c00 | grep rd
  rd = 0xffff8802242c5800, 
crash> struct -x root_domain 0xffff8802242c5800
... 
  span = {{
      bits = {0x1} <== "system"
    }},

Turn off load balancing in "system" as well now, CPU0 loses its 'sd',
and becomes an isolated island identical to "rtcpus" CPUs, and thus..

  span = {{
      bits = {0xf} <== oh darn
    }},

.."system" and "rtcpus" merge, all CPUs having NULL sd, as they are now
all remote silicon islands, but they now also share rd again, as if you
had never diddled domains in the first place.

-Mike

