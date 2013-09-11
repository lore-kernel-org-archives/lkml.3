Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab3IKOZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 10:25:26 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:17722 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805Ab3IKOZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 10:25:20 -0400
Message-ID: <52307DB3.7010909@oracle.com>
Date: Wed, 11 Sep 2013 10:26:59 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: xen-devel@lists.xen.org, linux-kernel@vger.kernel.org, JBeulich@suse.com
Subject: Re: [Xen-devel] [PATCH v1 0/5] xen/PMU: PMU support for Xen PV guests
References: <1378827110-4192-1-git-send-email-boris.ostrovsky@oracle.com> <523038FD.4070100@citrix.com>
In-Reply-To: <523038FD.4070100@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 05:33 AM, David Vrabel wrote:
> On 10/09/13 16:31, Boris Ostrovsky wrote:
>> This is the Linux side of Xen PMU support for PV guests, including dom0. Only
>> kernel changes are here, toolstack patch will be provided separately.
>>
>> Here is description from the hypervisor patch submission that applies to this
>> series as well:
>>
>> This version has following limitations:
>> * For accurate profiling of dom0/Xen dom0 VCPUs should be pinned.
>> * Hypervisor code is only profiled on processors that have running dom0 VCPUs
>> on them.
>> * No backtrace support.
> These are some pretty significant limitations.   Is there a plan for how
> to remove them?

I don't have a specific plan (other than do it after this stage is 
finished) but I do
have a rough idea of what would be needed to address these.

Hypervisor changes for all three should be pretty easy.

Linux-wise, for the first one (pinned VCPU) we will probably need to make a
change in perf_sample_data. There is a reserved filed there so perhaps we
can use it to store PCPU (and maybe domainID). Plus a way to actually write
the data, probably a hook or something.

Backtrace support should also not be too bad: we can pass Xen IP stack in
the shared data area to dom0 and then again have a hook or something to
pass it to perf. (Note that backtracing is not supported for KVM neither 
so both
may benefit here)

The second one is the most difficult: We need to be able somehow to access
MSRs (and APIC, I think) on non-dom0 CPUs. Creating interface for such 
access
is not a big deal but integrating it into perf infrastructure will be a 
challenge. There
are other alternatives but they have problems as well.


-boris
