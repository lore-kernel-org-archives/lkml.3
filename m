Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757AbaF3OIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 10:08:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbaF3OIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 10:08:15 -0400
Message-ID: <53B16F3D.5020303@redhat.com>
Date: Mon, 30 Jun 2014 10:07:57 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: RFC: /proc/cpuinfo confusion with AMD processors
References: <53B15D27.9010306@redhat.com> <20140630131309.GA5199@pd.tnic> <53B16621.50505@redhat.com> <20140630133803.GE4766@pd.tnic>
In-Reply-To: <20140630133803.GE4766@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/30/2014 09:38 AM, Borislav Petkov wrote:
> On Mon, Jun 30, 2014 at 09:29:05AM -0400, Prarit Bhargava wrote:
>> Yes, I get that. But this doesn't uniquely identify *which* processor
>> it is.
> 
> What do you mean, which processor it is? You want to know which
> processor on the motherboard, physically? When you look at the mobo and
> if all is enumerated regularly and you have a, say, two socket system
> with the processors above, to be able to say that processor 31 is the
> 16th core on the second node on the motherboard? Something like that?

Sorry, yes, exactly that.  Requests have come in where an admin is setting up
system loads relative to specific nodes and cores.  Determining that information
is trivial on Intel and a lot more difficult on AMD. (see below)

>> to get processor location information. I can, in theory, use the
>> initial apicid and the apicid to map everything out ... but I
>> shouldn't have to. /proc/cpuinfo provides an easy look up for this
>> data for Intel; why not for AMD?
> 
> What does it show on Intel that's clear there and that's puzzling you on
> AMD?

Intel does not have the concept of multi-node packages (AFAIK).  So the Intel
existing physical id and core id (both of which are relative to the package) is
good enough to determine which core it is.  For example from an Intel box


processor       : 3
...
physical id     : 3
siblings        : 2
core id         : 1
cpu cores       : 2



tells me that this processor 3 is on socket/package (physical id) 3, core 1 out
of 2, and the cores are not hyperthreaded.  On a system in which an admin would
like to (for example) set cpu affinity for a VM or a particular application
knowing this information is useful.

On an AMD system,

processor       : 31
physical id     : 1
siblings        : 16
core id         : 7
cpu cores       : 8

implies (using the logic above), package/socket 1, core 7/8 cores, and
multi-threading is on ... which is incorrect.  The package in question is 16
thread and 16 core with no multi-threading.

The difference in the result occurs because AMD is (IMO) erroneously reporting
per node information.  Another view of this could be that on AMD systems we
should modify the output to report per package information to make it consistent
with Intel (and other arches ... ppc reports per socket as does s390.  I haven't
checked ARM yet).  AMD is the outlier here.

> 
>> Additionally the turbostat utility, for example, is broken because of
>> this lack of info. It assumes that /sys/../cpu/cpuX/topology/core_id
>> is *per package* when on AMD systems it is reported as per node.
> 
> The turbostat utility might need some testing and fixing on AMD. If you
> can get some resources to do that I think everyone will profit from it.

The problem isn't turbostat though -- it is that core_id implies two different
things for two different x86 processors.  Intel reports that value as per
package, while AMD reports it as per node (and there is no way to determine
which node it is).  The problem is that the values are ambiguous relative to
processor vendor and they shouldn't be.

P.

