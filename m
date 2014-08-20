Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415AbaHTQDl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 12:03:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbaHTQDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 12:03:39 -0400
Message-ID: <53F4C6D2.9050209@redhat.com>
Date: Wed, 20 Aug 2014 18:03:30 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi <hui-zhi.zhao@hp.com>
Subject: Re: [PATCH 9/9] KVM: VMX: automatic PLE window maximum
References: <1408480536-8240-1-git-send-email-rkrcmar@redhat.com> <1408480536-8240-10-git-send-email-rkrcmar@redhat.com> <53F44B40.6060806@redhat.com> <20140820124112.GC28873@potion.brq.redhat.com> <53F49F80.1090408@redhat.com> <20140820153115.GA20453@potion.brq.redhat.com> <53F4BFF3.3060606@redhat.com> <20140820160137.GB20453@potion.brq.redhat.com>
In-Reply-To: <20140820160137.GB20453@potion.brq.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 20/08/2014 18:01, Radim Krčmář ha scritto:
> 2014-08-20 17:34+0200, Paolo Bonzini:
>> Il 20/08/2014 17:31, Radim Krčmář ha scritto:
>>> Btw. without extra code, we are still going to overflow on races when
>>> changing PW_grow, should they be covered as well?
>>
>> You mean because there is no spinlock or similar protecting the changes?
>>  I guess you could use a seqlock.
> 
> Yes, for example between a modification of ple_window
>   new = min(old, PW_actual_max) * PW_grow
> which gets compiled into something like this:
>   1) tmp = min(old, PW_actual_max)
>   2) new = tmp * PW_grow
> and a write to increase PW_grow
>   3) PW_actual_max = min(PW_max / new_PW_grow, PW_actual_max)
>   4) PW_grow = new_PW_grow
>   5) PW_actual_max = PW_max / new_PW_grow
> 
> 3 and 4 can exectute between 1 and 2, which could overflow.
> 
> I don't think they are important enough to warrant a significant
> performance hit of locking.

A seqlock just costs two memory accesses to the same (shared) cache line
as the PW data, and a non-taken branch.  I don't like code that is
unsafe by design...

Paolo

> Or even more checks that would prevent it in a lockless way.
> 
> (I'd just see that the result is set to something legal and also drop
>  line 3, because it does not help things that much.)
> 

