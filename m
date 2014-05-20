Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbaETKK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 06:10:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48520 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045AbaETKK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 06:10:28 -0400
Message-ID: <537B2A0F.1030706@suse.de>
Date: Tue, 20 May 2014 12:10:23 +0200
From: Alexander Graf <agraf@suse.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Michael Mueller <mimu@linux.vnet.ibm.com>
CC: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Gleb Natapov <gleb@kernel.org>, qemu-devel@nongnu.org,
        linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "Jason J. Herne" <jjherne@linux.vnet.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andreas Faerber <afaerber@suse.de>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [Qemu-devel] [PATCH v1 RFC 6/6] KVM: s390: add cpu model support
References: <1399993114-15333-1-git-send-email-mimu@linux.vnet.ibm.com> <1399993114-15333-7-git-send-email-mimu@linux.vnet.ibm.com> <5375FFB8.90504@suse.de> <20140516173907.3b1c4efa@bee> <53767590.2090605@suse.de> <20140519125339.09840b9e@bee> <5379EF78.9040209@suse.de> <20140519161811.5a17bc66@bee> <537A19F8.4060209@suse.de> <20140519190318.6f92c1bd@bee> <537A6608.8000608@suse.de> <20140520120218.38eb7181@bee>
In-Reply-To: <20140520120218.38eb7181@bee>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 20.05.14 12:02, Michael Mueller wrote:
> On Mon, 19 May 2014 22:14:00 +0200
> Alexander Graf <agraf@suse.de> wrote:
>
>> On 19.05.14 19:03, Michael Mueller wrote:
>>> On Mon, 19 May 2014 16:49:28 +0200
>>> Alexander Graf <agraf@suse.de> wrote:
>>>

[...]

>>>>> What user and thus also user space wants depends on other factors:
>>>>>
>>>>> 1. reliability
>>>>> 2. performance
>>>>> 3. availability
>>>>>
>>>>> It's not features, that's what programmers want.
>>>>>
>>>>> That's why I have designed the model and migration capability around the hardware
>>>>> and not around the software features and don't allow them to be enabled currently
>>>>> together.
>>>>>
>>>>> A software feature is a nice add on that is helpful for evaluation or development
>>>>> purpose. There is few space for it on productions systems.
>>>>>
>>>>> One option that I currently see to make software implemented facility migration
>>>>> capable is to calculate some kind of hash value derived from the full set of
>>>>> active software facilities. That value can be compared with pre-calculated
>>>>> values also stored in the supported model table of qemu. This value could be
>>>>> seen like a virtual model extension that has to match like the model name.
>>>>>
>>>>> But I have said it elsewhere already, a soft facility should be an exception and
>>>>> not the rule.
>>>>>
>>>>>>>> So all we need is a list of "features the guest sees available" which is
>>>>>>>> the same as "features user space wants the guest to see" which then gets
>>>>>>>> masked through "features the host can do in hardware".
>>>>>>>>
>>>>>>>> For emulation we can just check on the global feature availability on
>>>>>>>> whether we should emulate them or not.
>>>>>>>>
>>>>>>>>>> Also, if user space wants to make sure that its feature list is actually
>>>>>>>>>> workable on the host kernel, it needs to set and get the features again
>>>>>>>>>> and then compare that with the ones it set? That's different from x86's
>>>>>>>>>> cpuid implementation but probably workable.
>>>>>>>>> User space will probe what facilities are available and match them with the predefined
>>>>>>>>> cpu model set. Only those models which use a partial or full subset of the hard/host
>>>>>>>>> facility list are selectable.
>>>>>>>> Why?
>>>>>>> If a host does not offer the features required for a model it is not able to
>>>>>>> run efficiently.
>>>>>>>
>>>>>>>> Please take a look at how x86 does cpuid masking :).
>>>>>>>>
>>>>>>>> In fact, I'm not 100% convinced that it's a good idea to link cpuid /
>>>>>>>> feature list exposure to the guest and actual feature implementation
>>>>>>>> inside the guest together. On POWER there is a patch set pending that
>>>>>>>> implements these two things separately - admittedly mostly because
>>>>>>>> hardware sucks and we can't change the PVR.
>>>>>>> That is maybe the big difference with s390. The cpuid in the S390 case is not
>>>>>>> directly comparable with the processor version register of POWER.
>>>>>>>
>>>>>>> In the S390 world we have a well defined CPU model room spanned by the machine
>>>>>>> type and its GA count. Thus we can define a bijective mapping between
>>>>>>> (type, ga) <-> (cpuid, ibc, facility set). From type and ga we form the model
>>>>>>> name which BTW is meaningful also for a human user.
>>>>>> Same thing as POWER.
>>>>>>
>>>>>>> By means of this name, a management interface (libvirt) will draw decisions if
>>>>>>> migration to a remote hypervisor is a good idea or not. For that it just needs
>>>>>>> to compare if the current model of the guest on the source hypervisor
>>>>>>> ("query-cpu-model"), is contained in the supported model list of the target
>>>>>>> hypervisor ("query-cpu-definitions").
>>>>>> I don't think this works, since QEMU should always return all the cpu
>>>>>> definitions it's aware of on query-cpu-definitions, not just the ones
>>>>>> that it thinks may be compatible with the host at a random point in time.
>>>>> It does not return model names that it thinks they are compatible at some point
>>>>> in time. In s390 mode, it returns all definitions (CPU models) that a given host
>>>>> system is capable to run. Together with the CPU model run by the guest, some upper
>>>>> management interface knows if the hypervisor supports the required CPU model and
>>>>> uses a guest definition with the same CPU model on the target hypervisor.
>>>>>
>>>>> The information for that is taken from the model table which QEMU builds up during
>>>>> startup time. This list limits the command line selectable CPU models as well.
>>>> This makes s390 derive from the way x86 handles things. NAK.
>>> One second, that goes a little fast here :-). x86 returns a list they support which happens to
>>> be the full list they define and s390 does logically the same because we know that certain
>>> models are not supported due to probing. BTW that happens only if you run Qemu on back
>>> level hardware and that is perfectly correct.
>> It's not what other architectures do and I'd hate to see s390 deviate
>> just because.
> Only these four architectures implement the query and they all differ a little...
>
> target-arm/helper.c:CpuDefinitionInfoList *arch_query_cpu_definitions(Error **errp)
> target-i386/cpu.c:CpuDefinitionInfoList *arch_query_cpu_definitions(Error **errp)
> target-ppc/translate_init.c:CpuDefinitionInfoList *arch_query_cpu_definitions(Error **errp)
> target-s390x/cpu.c:CpuDefinitionInfoList *arch_query_cpu_definitions(Error **errp)
>
> arm walks through a list of all ARM CPU types
> list = object_class_get_list(TYPE_ARM_CPU, false);
> and returns the CpuDefinitionInfoList derived from that one to one
>
> i386 loops over the static builtin_x86_defs[] array to retrieve the model names,
> they don't even use the CPU class model as source
>
> ppc walks through a list of all POWER CPU types
> list = object_class_get_list(TYPE_POWERPC_CPU, false);
> and then extends the produced list by all defined aliases
>
> and s390x finally also walks through the defined S390 CPU types
> list = object_class_get_list(TYPE_S390_CPU, false);
> but drops those which are not usable (!is_active)
> Just consider them as not defined. I actually would undefine
> them if I knew how.
>
> Also the commands comment says "list of supported virtual CPU definitions" and the s390
> list contains all supported models, that's no contradiction.

So IMHO we can either

   a) change the definition of query_cpu_definitions to only return CPUs 
that are executable with KVM on a given machine (probably a bad idea) or
   b) return not only the CPU type, but also a hint whether it's 
available with KVM or
   c) add a parameter to query_cpu_definitions to say "only return KVM 
runnable CPUs" or
   d) introduce a new query_kvm_cpu_definitions qmp command

>
> ##
> # @query-cpu-definitions:
> #
> # Return a list of supported virtual CPU definitions
> #
> # Returns: a list of CpuDefInfo
>
>>> The migration compatibility test is pretty much ARCH dependent. I looked into the
>>> libvirt implementation and as one can see every architecture has its own implementation
>>> there (libvirt/src/cpu/cpu_<arch>.c).
>> So here's my question again. How does x86 evaluate whether a target
>> machine is compatible with a source machine?
> Will again look into that during the afternoon...

Yes, please. Someone else must have solved this before :).


Alex

