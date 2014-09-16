Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbaIPQgH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 12:36:07 -0400
Received: from www.sr71.net ([198.145.64.142]:50252 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754676AbaIPQgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 12:36:05 -0400
Message-ID: <541866F2.4020108@sr71.net>
Date: Tue, 16 Sep 2014 09:36:02 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
CC: Chuck Ebbert <cebbert.lkml@gmail.com>, linux-kernel@vger.kernel.org,
        borislav.petkov@amd.com, andreas.herrmann3@amd.com,
        hpa@linux.intel.com, ak@linux.intel.com
Subject: Re: [PATCH] x86: Consider multiple nodes in a single socket to be
 "sane"
References: <20140915222641.D640BD8A@viggo.jf.intel.com> <20140916032920.GH2840@worktop.localdomain> <20140916013845.390833b9@as> <20140916064403.GC14807@gmail.com> <20140916155928.GA2848@worktop.localdomain>
In-Reply-To: <20140916155928.GA2848@worktop.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2014 08:59 AM, Peter Zijlstra wrote:
> On Tue, Sep 16, 2014 at 08:44:03AM +0200, Ingo Molnar wrote:
>> Note that that's not really a 'NUMA node' in the way lots of 
>> places in the kernel assume it: permanent placement assymetry 
>> (and access cost assymetry) of RAM.
> 
> Agreed, that is not NUMA, both groups will have the exact same local
> DRAM latency (unlike the AMD thing which has two memory busses on the
> single package, and therefore really has two nodes on a single chip).

I don't think this is correct.

>From my testing, each ring of CPUs has a "close" and "far" memory
controller in the socket.

> This also means the CoD thing sets up the NUMA masks incorrectly.

I used this publicly-available Intel tool:

https://software.intel.com/en-us/articles/intelr-memory-latency-checker

And ran various combinations pinning the latency checker to various CPUs
and NUMA nodes.

Here's what I think the SLIT table should look like with cluster-on-die
disabled.  There is one node per socket and the latency to the other
node is 1.5x the latency to the local node:

*      0     1
0     10    15
1     15    10

or, measured in ns:
*      0     1
0     76   119
1    114    76

Enabling cluster-on-die, we get 4 nodes.  The local memory in thesame
socket gets faster, and remote memory in the same socket gets both
absolutely and relatively slower:

*      0     1     2     3
0     10    20    26    26
1     20    10    26    26
2     26    26    10    20
3     26    26    20    10

and in ns:
*      0     1     2     3
0   74.8 152.3 190.6 200.4
1  146.2  75.6 190.8 200.6
2  185.1 195.5  74.5 150.1
3  186.6 195.6 147.3  75.6

So I think it really is reasonable to say that there are 2 NUMA nodes in
a socket.

BTW, these numbers are only approximate.  They were not run under
particularly controlled conditions and I don't even remember what kernel
they were under.

