Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab3BRPY4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 10:24:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724Ab3BRPYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 10:24:54 -0500
Date: Mon, 18 Feb 2013 12:24:29 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-acpi@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH EDAC 07/13] edac: add support for raw error reports
Message-ID: <20130218122429.239584aa@redhat.com>
In-Reply-To: <20130218135251.GC16622@pd.tnic>
References: <cover.1360931635.git.mchehab@redhat.com>
	<e08f797b129a50b4e1b39e8c31bff82904aea65d.1360931635.git.mchehab@redhat.com>
	<20130215141330.GF14387@pd.tnic>
	<20130215132530.4f3b7dab@redhat.com>
	<20130215154123.GH14387@pd.tnic>
	<20130215134929.3909cfa2@redhat.com>
	<20130215160257.GK14387@pd.tnic>
	<20130215162029.3bcbf50a@redhat.com>
	<20130216165748.GC27207@pd.tnic>
	<20130217074404.05786692@redhat.com>
	<20130218135251.GC16622@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 18 Feb 2013 14:52:51 +0100
Borislav Petkov <bp@alien8.de> escreveu:

> On Sun, Feb 17, 2013 at 07:44:04AM -0300, Mauro Carvalho Chehab wrote:
> > We could do it for the location. The space for label, however, depends on
> > how many DIMMs are in the system, as multiple dimm's may be present, and
> > the core will point to all possible affected DIMMs.
> > 
> > Ok, perhaps we could just allocate one big area for it (like one page), 
> > as this would very likely be enough for it, and change the logic to take
> > the buffer size into account when filling it.
> 
> Or, in the case where ->label is all dimms on the mci, you simply put
> "All DIMMs on MCI%d" in there and done. Simple.

The core does this already when it has no glue at all about where is the
error.

The core is prepared to the case where the location is only half-filled,
as this is a common scenario on the drivers, and important enough on
some memory controllers.

As already discussed, on most memory controllers nowadays, the memory
controller can't point to a single DIMM, as the error correction code
takes 128 bits (2 DIMMs). It is impossible for the error correction
code to determine on what DIMM an uncorrected error happened[1].

With Nehalem memory controllers, depending on the memory configuration,
the minimal DIMM granularity for an uncorrected error can be even worse: 
4 DIMMs, if 128-bits error correction code and mirror mode are both enabled.

There are some border cases where the driver can simply not discover on
what channel or on what dimm(or csrow) inside a channel the error
happened. The error could be associated with some failure at the logic
or at the bus that communicated with the Advanced Memory Buffers on an
FB-DIMM memory controller, for example.

So, the real core's worse case scenario would be if the driver can't
determine on what DIMM inside a channel the error happened. As a channel
can have a large number of DIMMs[2] the allocated area for the label
should be conservative.


 (16? Not sure what's the worse case),

[1] such error can even not be fatal, if that particular address is
unused.

[2] Currently, up to 8, according with:
	$for i in $(git grep "layers.*size\s*=" drivers/edac|perl -ne 'print "$1 " if (m/\=\s*([A-Z][^\s]+);/);'); do echo $i; git grep $i drivers/edac; done|grep define|perl -ne 'print "$1 " if (m/define\s+[^\s]+\s(\d+)/)'
	8 8 2 2 4 2 3 3 3 8 4 4 3 3 1 1 4 

and
	$ git grep "layers.*size\s*=" drivers/edac|perl -ne 'print "$1 " if (m/\=\s*(\d+);/);'
	1 1 1 1 2 2 8 4 1 1 1 1 

Nothing prevents that a driver would have more than 8 DIMMs per layer
in the future.

-- 

Cheers,
Mauro
