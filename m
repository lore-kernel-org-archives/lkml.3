Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445AbaIRO6H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 10:58:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:36735 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756067AbaIRO6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 10:58:05 -0400
Date: Thu, 18 Sep 2014 16:57:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Hansen <dave@sr71.net>
Cc: mingo@kernel.org, hpa@linux.intel.com, brice.goglin@gmail.com,
        bp@alien8.de, linux-kernel@vger.kernel.org,
        dave.hansen@linux.intel.com
Subject: Re: [RFC][PATCH 2/6] x86: introduce cpumask specifically for the
 package
Message-ID: <20140918145757.GR2840@worktop.localdomain>
References: <20140917223310.026BCC2C@viggo.jf.intel.com>
 <20140917223314.CEE1F258@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140917223314.CEE1F258@viggo.jf.intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 03:33:14PM -0700, Dave Hansen wrote:
> 
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> As noted by multiple reports:
> 
> 	https://lkml.org/lkml/2014/9/15/1240
> 	https://lkml.org/lkml/2014/7/28/442
> 
> the sched domains code has some assumptions that break on newer
> AMD and Intel CPUs.  Namely, the code assumes that NUMA node
> boundaries always lie outside of a CPU package.  That assumption
> is no longer true with Intel's Cluster-on-Die found in Haswell
> CPUs (with a special BIOS config knob) and AMD's DCM feature.
> 
> Essentially, the 'cpu_core_map' is no longer suitable for
> enumerating all the CPUs in a physical package.
> 
> This patch introduces a new map which is specifically built by
> consulting the the physical package ids instead of inferring the
> information from NUMA nodes.
> 
> This still leaves us with a broken 'core_siblings_list' in sysfs,
> but a later patch will fix that up too.

If we do dynamic topology layout we don't need a second mask I think.
The machines that have multiple packages per node will simply present a
different sched_domain_topology than the machines that have multiple
nodes per package.

Specifically, in the former we include the package_mask as DIE level, in
the other case we leave it out entirely and rely on the SLIT table to
build the right domain topology.
