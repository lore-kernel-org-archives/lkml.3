Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbaF3N31 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 09:29:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbaF3N3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 09:29:25 -0400
Message-ID: <53B16621.50505@redhat.com>
Date: Mon, 30 Jun 2014 09:29:05 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: RFC: /proc/cpuinfo confusion with AMD processors
References: <53B15D27.9010306@redhat.com> <20140630131309.GA5199@pd.tnic>
In-Reply-To: <20140630131309.GA5199@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/30/2014 09:13 AM, Borislav Petkov wrote:
> On Mon, Jun 30, 2014 at 08:50:47AM -0400, Prarit Bhargava wrote:
>> AMD defines a "Package" as the hardware processor itself.  Each Package contains
>> multiple Nodes, and each Node has multiple Compute Units.  Each Compute Unit can
>> have up to 2 cores that [with the 62xx and 63xx] do not have multiple Threads.
>>
>> That is, to determine the number of CPUs that Linux sees, multiply
>>
>>      Package * Nodes * Compute Units * Cores
>>
>> Note that Nodes and Compute Units are not indicated in /proc/cpuinfo directly
>> (although it could be argued that they should be).
>>
>> The output of /proc/cpuinfo is confusing at this point as ...
>>
>>
>> processor       : 31
>> vendor_id       : AuthenticAMD
>> cpu family      : 21
>> model           : 2
>> model name      : AMD Opteron(tm) Processor 6386 SE
>> stepping        : 0
>> microcode       : 0x6000822
>> cpu MHz         : 2800.000
>> cache size      : 2048 KB
>> physical id     : 1
>> siblings        : 16  <<< this is number of threads per package
>> core id         : 7   <<< this is the core id of this thread relative to node
>> cpu cores       : 8   <<< this is the number of cores per node
> 
> siblings / cpu cores = threads per compute unit.

Yes, I get that. But this doesn't uniquely identify *which* processor it is.

> 
>> which makes deciphering the system topology quite difficult as values are
>> relative to both nodes and the entire package.  It is not possible using this
>> information to uniquely identify a processor.
> 
> To do what with that information? What is the task you're trying to
> accomplish?

Admins load systems relative to nodes, and look at /proc/cpuinfo as a "known"
place to get that info.  At the end of the day I'd like to be able to human-read
/proc/cpuinfo and get the correct data out of it without jumping through hoops
to get processor location information.  I can, in theory, use the initial apicid
and the apicid to map everything out ... but I shouldn't have to.  /proc/cpuinfo
provides an easy look up for this data for Intel; why not for AMD?

Additionally the turbostat utility, for example, is broken because of this lack
of info.  It assumes that /sys/../cpu/cpuX/topology/core_id is *per package*
when on AMD systems it is reported as per node.

> 
>> Thoughts/concerns?
> 
> BIOS does all kinds of hacks and renumbering to accomodate the
> brainf*cked design of other OSes so this info you're trying to put in
> cpuinfo might turn to be completely misleading utterly useless in some
> cases.

I read that exact same thing somewhere else.  The argument you're making is that
it might be broken for some other reason.  It already is completely misleading
and utterly useless in the above case.  A simple test patch to
arch/x86/kernel/cpu/proc.c shows that including the information above is
trivial.  Adding it /sys/.../cpu/cpuX/topology is a little bit more difficult.

P.
> 
