Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbaIPP7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 11:59:38 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53628 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbaIPP7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 11:59:37 -0400
Date: Tue, 16 Sep 2014 17:59:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Chuck Ebbert <cebbert.lkml@gmail.com>, Dave Hansen <dave@sr71.net>,
        linux-kernel@vger.kernel.org, borislav.petkov@amd.com,
        andreas.herrmann3@amd.com, hpa@linux.intel.com, ak@linux.intel.com
Subject: Re: [PATCH] x86: Consider multiple nodes in a single socket to be
 "sane"
Message-ID: <20140916155928.GA2848@worktop.localdomain>
References: <20140915222641.D640BD8A@viggo.jf.intel.com>
 <20140916032920.GH2840@worktop.localdomain>
 <20140916013845.390833b9@as>
 <20140916064403.GC14807@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140916064403.GC14807@gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 08:44:03AM +0200, Ingo Molnar wrote:
> 
> * Chuck Ebbert <cebbert.lkml@gmail.com> wrote:
> 
> > On Tue, 16 Sep 2014 05:29:20 +0200
> > Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > On Mon, Sep 15, 2014 at 03:26:41PM -0700, Dave Hansen wrote:
> > > > 
> > > > I'm getting the spew below when booting with Haswell (Xeon 
> > > > E5-2699) CPUs and the "Cluster-on-Die" (CoD) feature 
> > > > enabled in the BIOS.
> > > 
> > > What is that cluster-on-die thing? I've heard it before but 
> > > never could find anything on it.
> > 
> > Each CPU has 2.5MB of L3 connected together in a ring that 
> > makes it all act like a single shared cache. The HW tries to 
> > place the data so it's closest to the CPU that uses it. On the 
> > larger processors there are two rings with an interconnect 
> > between them that adds latency if a cache fetch has to cross 
> > that. CoD breaks that connection and effectively gives you two 
> > nodes on one die.
> 
> Note that that's not really a 'NUMA node' in the way lots of 
> places in the kernel assume it: permanent placement assymetry 
> (and access cost assymetry) of RAM.

Agreed, that is not NUMA, both groups will have the exact same local
DRAM latency (unlike the AMD thing which has two memory busses on the
single package, and therefore really has two nodes on a single chip).

This also means the CoD thing sets up the NUMA masks incorrectly.

> It's a new topology construct that needs new handling (and 
> probably a new mask): Non Uniform Cache Architecture (NUCA)
> or so.

Its not new, many chips do this, most notable the Core2Quad which was
basically two Core2Duo dies in a single package. So you have 2 cores
sharing cache, and 2x2 cores sharing the memory bus.

Also, the Silvermont 'modules' which do basically the same thing, have
multiple groups of cores that share cache on the same memory bus.

This is not new. And we can represent this just fine, it just looks like
the Intel CoD stuff sets up the NUMA masks wrong.
