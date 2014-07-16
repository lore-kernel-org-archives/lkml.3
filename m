Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528AbaGPKSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 06:18:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbaGPKSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 06:18:42 -0400
Message-ID: <53C6517D.9090600@redhat.com>
Date: Wed, 16 Jul 2014 12:18:37 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Igor Mammedov <imammedo@redhat.com>, linux-kernel@vger.kernel.org
CC: kvm@vger.kernel.org, x86@kernel.org, mtosatti@redhat.com
Subject: Re: [PATCH] ensure guest's kvmclock never goes backwards when TSC
 jumps backward
References: <1405504368-5581-1-git-send-email-imammedo@redhat.com>
In-Reply-To: <1405504368-5581-1-git-send-email-imammedo@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 16/07/2014 11:52, Igor Mammedov ha scritto:
> There are buggy hosts in the wild that advertise invariant
> TSC and as result host uses TSC as clocksource, but TSC on
> such host sometimes sporadically jumps backwards.
>
> This causes kvmclock to go backwards if host advertises
> PVCLOCK_TSC_STABLE_BIT, which turns off aggregated clock
> accumulator and returns:
>   pvclock_vcpu_time_info.system_timestamp + offset
> where 'offset' is calculated using TSC.
> Since TSC is not virtualized in KVM, it makes guest see
> TSC jumped backwards and leads to kvmclock going backwards
> as well.
>
> This is defensive patch that keeps per CPU last clock value
> and ensures that clock will never go backwards even with
> using PVCLOCK_TSC_STABLE_BIT enabled path.

I'm not sure that a per-CPU value is enough; your patch can make the 
problem much less frequent of course, but I'm not sure neither detection 
nor correction are 100% reliable.  Your addition is basically a faster 
but less reliable version of the last_value logic.

If may be okay to have detection that is faster but not 100% reliable. 
However, once you find that the host is buggy I think the correct thing 
to do is to write last_value and kill PVCLOCK_TSC_STABLE_BIT from 
valid_flags.

Did you check that the affected host has the latest microcode? 
Alternatively, could we simply blacklist some CPU steppings?  I'm not 
sure who we could ask at AMD :( but perhaps there is an erratum.

Paolo
