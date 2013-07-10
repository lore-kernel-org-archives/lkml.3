Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab3GJTJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 15:09:20 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57687 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537Ab3GJTJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 15:09:16 -0400
Message-ID: <51DDB159.2080003@wwwdotorg.org>
Date: Wed, 10 Jul 2013 13:09:13 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Simon Horman <horms@verge.net.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Warren <swarren@nvidia.com>, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        ARM kernel mailing list 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] kexec: return error of machine_kexec() fails
References: <1373421296-6112-1-git-send-email-horms@verge.net.au> <87obaaiiry.fsf@xmission.com>
In-Reply-To: <87obaaiiry.fsf@xmission.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 08:36 AM, Eric W. Biederman wrote:
> Simon Horman <horms@verge.net.au> writes:
> 
>> From: Stephen Warren <swarren@nvidia.com>
>>
>> Prior to commit 3ab8352 "kexec jump", if machine_kexec() returned,
>> sys_reboot() would return -EINVAL. This patch restores this behaviour
>> for the non-KEXEC_JUMP case, where machine_kexec() is not expected to
>> return.
>>
>> This situation can occur on ARM, where kexec requires disabling all but
>> one CPU using CPU hotplug. However, if hotplug isn't supported by the
>> particular HW the kernel is running on, then kexec cannot succeed.
> 
> Ugh. This reasoning is nonsense.  Prior to the kexec jump work
> machine_kexec could never return and so could never return -EINVAL.

Well, any function /can/ return. Perhaps there was some undocumented
requirement that machine_kexec() was not allowed to return? I did test
it, and everything appears to work fine if it does return, aside from
the error code.

> It is not ok to have an image loaded that we can not kexec.  kexec_load
> should fail not machine_shutdown or machine_kexec.

Hmm. I suppose one option is to enhance ARM's machine_kexec_prepare(),
which is called from kexec_load(), and have that fail unless either the
current HW is non-SMP, or full CPU HW/driver hotplug/PM support is
available, so that it's guaranteed that machine_shutdown() will be able
to fully disable all but one CPU.

Would that be acceptable?

Other alternatives would be:

a) Force the user to disable (hot unplug) the CPUs themselves before
calling kexec_load(). This seems rather onerous, and could be defeated
by replugging them between kexec_load() and kernel_kexec().

b) Actually modifying kexec_load() to disable the CPUs, at the point
where it's legal for it to fail. However, I suspect some use-cases call
kexec_load() a long time before kernel_kexec(), so this would end up
disabling SMP way too early.

> ARM needs to get it's act together and stop modifying the generic code
> to deal with it's broken multi-cpu architecture.

A standardized in-CPU mechanism for disabling CPUs as part of the ARM
architecture would be nice. However, even if that appears today, it's
not going to help all the already extant systems that don't have it.
