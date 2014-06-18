Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbaFRRg3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 13:36:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:31997 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753499AbaFRRg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 13:36:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,501,1400050800"; 
   d="scan'208";a="559683416"
Message-ID: <53A1CE19.7040103@intel.com>
Date: Wed, 18 Jun 2014 10:36:25 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: LKML <linux-kernel@vger.kernel.org>, Josh Triplett <josh@joshtriplett.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [bisected] pre-3.16 regression on open() scalability
References: <539B594C.8070004@intel.com> <20140613224519.GV4581@linux.vnet.ibm.com> <53A0CAE5.9000702@intel.com> <20140618001836.GV4669@linux.vnet.ibm.com> <53A132D4.60408@intel.com> <20140618125831.GB4669@linux.vnet.ibm.com>
In-Reply-To: <20140618125831.GB4669@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2014 05:58 AM, Paul E. McKenney wrote:
>> > This is the previous kernel, plus RCU tracing, so it's not 100%
>> > apples-to-apples (and it peaks a bit lower than the other kernel).  But
>> > here's the will-it-scale open1 throughput on the y axis vs
>> > RCU_COND_RESCHED_EVERY_THIS_JIFFIES on x:
>> > 
>> > 	http://sr71.net/~dave/intel/jiffies-vs-openops.png
>> > 
>> > This was a quick and dirty single run with very little averaging, so I
>> > expect there to be a good amount of noise.  I ran it from 1->100, but it
>> > seemed to peak at about 30.
> OK, so a default setting on the order of 20-30 jiffies looks promising.

For the biggest machine I have today, yeah.  But, we need to be a bit
careful here.  The CPUs I'm running it on were released 3 years ago and
I think we need to be planning at _least_ for today's large systems.  I
would guess that by raising ...EVERY_THIS_JIFFIES, we're shifting this
curve out to the right:

	http://sr71.net/~dave/intel/3.16-open1regression-0.png

so that we're _just_ before the regression hits us.  But that just
guarantees I'll hit this again when I get new CPUs. :)

If we go this route, I think we should probably take it up in to the
100-200 range, or even scale it to something on the order of what the
rcu stall timeout is.  Other than the stall detector, is there some
other reason to be forcing frequent quiescent states?
