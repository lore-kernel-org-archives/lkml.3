Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495Ab3I3WKA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 18:10:00 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:48018 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756014Ab3I3WJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 18:09:59 -0400
Message-ID: <5249F6AF.7050608@linux.vnet.ibm.com>
Date: Mon, 30 Sep 2013 17:09:51 -0500
From: Joel Schopp <jschopp@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Daniel De Graaf <dgdegra@tycho.nsa.gov>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Rajiv Andrade <mail@srajiv.net>, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Sirrix AG <tpmdd@sirrix.com>,
        Richard Maciel Costa <richardm@br.ibm.com>,
        "trousers-tech@lists.sourceforge.net" 
	<trousers-tech@lists.sourceforge.net>
Subject: Re: [tpmdd-devel] [PATCH 09/13] tpm: Pull everything related to sysfs
 into tpm-sysfs.c
References: <1379960083-8942-1-git-send-email-jgunthorpe@obsidianresearch.com> <1379960083-8942-10-git-send-email-jgunthorpe@obsidianresearch.com> <52408E5D.4020904@tycho.nsa.gov>	<20130923193633.GA9194@obsidianresearch.com> <5240A2A3.4040102@tycho.nsa.gov> <20130923204232.GB16345@obsidianresearch.com> <5240BA0E.3000304@tycho.nsa.gov>	<20130923222324.GA9533@obsidianresearch.com> <5241A199.1080505@tycho.nsa.gov> <20130930181005.GG28898@obsidianresearch.com> <5249E0CB.2070106@tycho.nsa.gov>
In-Reply-To: <5249E0CB.2070106@tycho.nsa.gov>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13093022-5806-0000-0000-000022E80787
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<snip>

> There is also the fact that the driver may not be able to tell if a
> locality is available without doing some kind of test command. The Xen
> TPM interface doesn't expose what localities are available, for example,
> and the TIS interface may need to test to see if locality 3 and 4 are
> actually blocked by the chipset - at least 3 might be available on some
> systems (the spec leaves this "implementation dependent").
> 
>>> Perhaps:
>>> 	default_locality - default to CONFIG_USER_DEFAULT_LOCALITY
>>> 		sysfs node permissions 0644
>>> 	kernel_locality - default to #CONFIG_KERNEL_DEFAULT_LOCALITY
>>> 		0444 if CONFIG_KERNEL_ONLY_LOCALITY=y
>>> 		0644 if CONFIG_KERNEL_ONLY_LOCALITY=n
>>> 	ioctl TPM_{GET,SET}_LOCALITY on an open /dev/tpmX
>>>
>>> If CONFIG_KERNEL_ONLY_LOCALITY=y, the userspace locality is not
>>> permitted to be equal to kernel_locality (but may take any other valid
>>> value).  Drivers may reject locality values that they consider invalid
>>> (the default should be to only allow 0-4, which is all that is defined
>>> in the spec) or may fail on attempted use of the TPM by passing down an
>>> error from the hardware - I would expect the latter to be the case on
>>> attempts to use locality 4 in the tpm_tis driver.
>>
>> Seems resonable, CONFIG_KERNEL_ONLY_LOCALITY could be
>> CONFIG_TPM_ONE_TIME_LOCALITY (eg you get to set kernel_locality only
>> once)
> 
> Hmm, how much trouble would it be to make this a menu selection? Even
> with the one-time-set option, you still need a default set either in
> the code or by CONFIG_ so that the TPM is not unavailable before the
> sysfs write. The options would be:
> 
>   - CONFIG_TPM_KERNEL_DEFAULT_LOCALITY = [int]
>   - CONFIG_TPM_KERNEL_LOCALITY_FIXED - no changes from userspace
>   - CONFIG_TPM_KERNEL_LOCALITY_ONESHOT - only one change possible
>   - CONFIG_TPM_KERNEL_LOCALITY_ANY - may be changed freely
> 
> The userspace locality is not allowed to use the kernel locality if
> the mode is either FIXED or ONESHOT, but may share locality if ANY
> is used.
> 
> Or, for more flexibility (I actually like this one better):
> 
>   - CONFIG_TPM_KERNEL_DEFAULT_LOCALITY = [int]
>   - CONFIG_TPM_KERNEL_LOCALITY_FIXED = [bool]

This seems best of the options discussed to me.

> 
> And sysfs contains:
>   - kernel_locality [0644, int; 0444 if FIXED=y or when locked(?)]
>   - lock_kernel_locality [write-once; only exists if FIXED=n]
> 
> Where kernel_locality may be changed until a write is made to
> local_kernel_locality, at which time the value of kernel_locality
> becomes read-only and no longer available via /dev/tpmX.
> 
>>> The only one I see immediately is seal/unseal (security/keys/trusted.c).
>>> The invocation of the seal command would need to be changed to seal the
>>> trusted keys to the kernel-only locality in order to take advantage of
>>> the increased protection provided by a kernel-only locality.
>>
>> Right
> 
> Actually, only the invocation needs to be changed - the PCR selection
> is passed in from userspace, which will just need to use PCR_INFO_LONG
> with the proper locality mask.
> 
>>>> Do you know anyone on the userspace SW side who could look at this?
>>
>>> I should be able to find someone.
>>
>> Okay, let me know. I'd like to get a few more clean ups done before
>> mucking with the sysfs, but the way forward for locality looks pretty
>> clear..
>>
>> Thanks,
>> Jason
> 
> So far, nobody I have talked to has offered any strong opinions on
> what locality should be used or how it should be set. I think finding
> a developer of trousers may be the most useful to talk about how the
> ioctl portion of this would need to be set up - if someone is actually
> needed.
> 

I am a TrouSerS developer and am ccing Richard, another TrouSerS
developer, and ccing the trousers-tech list.  It would be good if you
could elaborate on the question and context for those not following the
entire thread, myself included.

