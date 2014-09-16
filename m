Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbaIPQ7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 12:59:49 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:29942 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754539AbaIPQ7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 12:59:48 -0400
X-IronPort-AV: E=Sophos;i="5.04,535,1406584800"; 
   d="scan'208";a="96122097"
Message-ID: <54186C82.2040404@gmail.com>
Date: Tue, 16 Sep 2014 18:59:46 +0200
From: Brice Goglin <brice.goglin@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Dave Hansen <dave@sr71.net>
CC: linux-kernel@vger.kernel.org, borislav.petkov@amd.com,
        andreas.herrmann3@amd.com, mingo@kernel.org, hpa@linux.intel.com,
        ak@linux.intel.com
Subject: Re: [PATCH] x86: Consider multiple nodes in a single socket to be
 "sane"
References: <20140915222641.D640BD8A@viggo.jf.intel.com> <20140916032920.GH2840@worktop.localdomain>
In-Reply-To: <20140916032920.GH2840@worktop.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 16/09/2014 05:29, Peter Zijlstra a écrit :
>
>> This also fixes sysfs because CPUs with the same 'physical_package_id'
>> in /sys/devices/system/cpu/cpu*/topology/ are not listed together
>> in the same 'core_siblings_list'.  This violates a statement from
>> Documentation/ABI/testing/sysfs-devices-system-cpu:
>>
>> 	core_siblings: internal kernel map of cpu#'s hardware threads
>> 	within the same physical_package_id.
>>
>> 	core_siblings_list: human-readable list of the logical CPU
>> 	numbers within the same physical_package_id as cpu#.
> No that statement is wrong; it assumes physical_package_id is a good
> identifier for nodes. Clearly this is no longer true.
>
> The idea is that core_siblings (or rather cpu_core_mask) is a mask of
> all cores on a node.

or rather node_core_mask since it's not clear whether a CPU is a package
or a die or a node or whatever?

Aside from the bad naming, I fail to see why core_siblings couldn't be
package-wide.

Node-wide masks are already in /sys/devices/system/node/node*/cpumap

>> The sysfs effects here cause an issue with the hwloc tool where
>> it gets confused and thinks there are more sockets than are
>> physically present.
> Meh, so then we need another mask.

Note that AMD tried to add a "cpu_node" mask back in 2009 for the same
reason for their 6xxx CPUs but it was rejected :/
https://lkml.org/lkml/2009/6/3/244

>> diff -puN arch/x86/kernel/smpboot.c~hsw-cod-is-sane arch/x86/kernel/smpboot.c
>> --- a/arch/x86/kernel/smpboot.c~hsw-cod-is-sane	2014-09-15 14:56:20.012314468 -0700
>> +++ b/arch/x86/kernel/smpboot.c	2014-09-15 14:58:58.837506644 -0700
>> @@ -344,10 +344,13 @@ static bool match_llc(struct cpuinfo_x86
>>  static bool match_mc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
>>  {
>>  	if (c->phys_proc_id == o->phys_proc_id) {
>> -		if (cpu_has(c, X86_FEATURE_AMD_DCM))
>> -			return true;
>> -
>> -		return topology_sane(c, o, "mc");
>> +		/*
>> +		 * We used to enforce that 'c' and 'o' be on the
>> +		 * same node, but AMD's DCM and Intel's Cluster-
>> +		 * on-Die (CoD) support both have physical
>> +		 * processors that span NUMA nodes.
>> +		 */
>> +		return true;
>>  	}
>>  	return false;
>>  }
> This is wrong (and I suppose the AMD case was already wrong). That
> function is supposed to match a multi-core group which is very much
> supposed to be smaller-or-equal to a node, not spanning nodes.

Well, even if it's wrong, it matches what the sysfs doc says. We have
been using this ABI in userspace tools for years and it always properly
detected AMD CPUs. So if you want to break things, please remove
core_siblings entirely and add new well-defined package-wide and
node-wide masks :/

Brice

