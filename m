Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933625AbaDIPjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:39:09 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:59985 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932908AbaDIPjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:39:07 -0400
X-IronPort-AV: E=Sophos;i="4.97,826,1389744000"; 
   d="scan'208";a="118353414"
Message-ID: <5345697D.8000405@citrix.com>
Date: Wed, 9 Apr 2014 16:38:37 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>,
        <konrad@kernel.org>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <linux-kernel@vger.kernel.org>,
        <keir@xen.org>, <jbeulich@suse.com>
Subject: Re: [Xen-devel] [XEN PATCH 1/2] hvm: Support more than 32 VCPUS when
 migrating.
References: <1396859560.22845.4.camel@kazak.uk.xensource.com> <1396977950-8789-1-git-send-email-konrad@kernel.org> <1396977950-8789-2-git-send-email-konrad@kernel.org> <53443D88.6010202@citrix.com> <20140408185346.GA1678@phenom.dumpdata.com> <5344F89D.3020209@citrix.com> <20140409153444.GA6604@phenom.dumpdata.com>
In-Reply-To: <20140409153444.GA6604@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/14 16:34, Konrad Rzeszutek Wilk wrote:
> On Wed, Apr 09, 2014 at 09:37:01AM +0200, Roger Pau Monné wrote:
>> On 08/04/14 20:53, Konrad Rzeszutek Wilk wrote:
>>> On Tue, Apr 08, 2014 at 08:18:48PM +0200, Roger Pau Monné wrote:
>>>> On 08/04/14 19:25, konrad@kernel.org wrote:
>>>>> From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>>>>>
>>>>> When we migrate an HVM guest, by default our shared_info can
>>>>> only hold up to 32 CPUs. As such the hypercall
>>>>> VCPUOP_register_vcpu_info was introduced which allowed us to
>>>>> setup per-page areas for VCPUs. This means we can boot PVHVM
>>>>> guest with more than 32 VCPUs. During migration the per-cpu
>>>>> structure is allocated fresh by the hypervisor (vcpu_info_mfn
>>>>> is set to INVALID_MFN) so that the newly migrated guest
>>>>> can do make the VCPUOP_register_vcpu_info hypercall.
>>>>>
>>>>> Unfortunatly we end up triggering this condition:
>>>>> /* Run this command on yourself or on other offline VCPUS. */
>>>>>  if ( (v != current) && !test_bit(_VPF_down, &v->pause_flags) )
>>>>>
>>>>> which means we are unable to setup the per-cpu VCPU structures
>>>>> for running vCPUS. The Linux PV code paths make this work by
>>>>> iterating over every vCPU with:
>>>>>
>>>>>  1) is target CPU up (VCPUOP_is_up hypercall?)
>>>>>  2) if yes, then VCPUOP_down to pause it.
>>>>>  3) VCPUOP_register_vcpu_info
>>>>>  4) if it was down, then VCPUOP_up to bring it back up
>>>>>
>>>>> But since VCPUOP_down, VCPUOP_is_up, and VCPUOP_up are
>>>>> not allowed on HVM guests we can't do this. This patch
>>>>> enables this.
>>>>
>>>> Hmmm, this looks like a very convoluted approach to something that could
>>>> be solved more easily IMHO. What we do on FreeBSD is put all vCPUs into
>>>> suspension, which means that all vCPUs except vCPU#0 will be in the
>>>> cpususpend_handler, see:
>>>>
>>>> http://svnweb.freebsd.org/base/head/sys/amd64/amd64/mp_machdep.c?revision=263878&view=markup#l1460
>>>
>>> How do you 'suspend' them? If I remember there is a disadvantage of doing
>>> this as you have to bring all the CPUs "offline". That in Linux means using
>>> the stop_machine which is pretty big hammer and increases the latency for migration.
>>
>> In order to suspend them an IPI_SUSPEND is sent to all vCPUs except vCPU#0:
>>
>> http://fxr.watson.org/fxr/source/kern/subr_smp.c#L289
>>
>> Which makes all APs call cpususpend_handler, so we know all APs are
>> stuck in a while loop with interrupts disabled:
>>
>> http://fxr.watson.org/fxr/source/amd64/amd64/mp_machdep.c#L1459
>>
>> Then on resume the APs are taken out of the while loop and the first
>> thing they do before returning from the IPI handler is registering the
>> new per-cpu vcpu_info area. But I'm not sure this is something that can
>> be accomplished easily on Linux.
> 
> That is a bit of what the 'stop_machine' would do. It puts all of the
> CPUs in whatever function you want. But I am not sure of the latency impact - as
> in what if the migration takes longer and all of the CPUs sit there spinning.
> Another variant of that is the 'smp_call_function'.

I tested stop_machine() on all CPUs during suspend once and it was
awful:  100s of ms of additional downtime.

Perhaps a hand-rolled IPI-and-park-in-handler would be quicker the full
stop_machine().

David
