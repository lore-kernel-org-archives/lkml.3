Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab3JXJfL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 05:35:11 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:47104 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab3JXJfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 05:35:09 -0400
Message-ID: <5268E73C.7030302@linux.vnet.ibm.com>
Date: Thu, 24 Oct 2013 17:24:12 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 13/15] KVM: MMU: locklessly write-protect the page
References: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1382534973-13197-14-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20131024091732.GA5289@redhat.com>
In-Reply-To: <20131024091732.GA5289@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102409-0260-0000-0000-000003D8CAAF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2013 05:17 PM, Gleb Natapov wrote:

>>  
>> -/**
>> - * kvm_mmu_write_protect_pt_masked - write protect selected PT level pages
>> +static void __rmap_write_protect_lockless(u64 *sptep)
>> +{
>> +	u64 spte;
>> +
>> +retry:
>> +	/*
>> +	 * Note we may partly read the sptep on 32bit host, however, we
>> +	 * allow this case because:
>> +	 * - we do not access the page got from the sptep.
>> +	 * - cmpxchg64 can detect that case and avoid setting a wrong value
>> +	 *   to the sptep.
>> +	 */
>> +	spte = *rcu_dereference(sptep);
>> +	if (unlikely(!is_last_spte(spte) || !is_writable_pte(spte)))
> is_last_spte gets two parameters.

In patch [PATCH v3 12/15] KVM: MMU: check last spte with unawareness of mapping level,
we have removed the 'level' from the parameter list.

