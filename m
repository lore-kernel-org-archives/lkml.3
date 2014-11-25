Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751269AbaKYTL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 14:11:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbaKYTL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 14:11:28 -0500
Message-ID: <5474D39F.4010206@redhat.com>
Date: Tue, 25 Nov 2014 14:08:15 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org
CC: Luiz Capitulino <lcapitulino@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org
Subject: Re: [patch -rt 1/2] KVM: use simple waitqueue for vcpu->wq
References: <20141125172108.992070524@redhat.com> <20141125172329.435080075@redhat.com> <5474D121.4070905@redhat.com>
In-Reply-To: <5474D121.4070905@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2014 01:57 PM, Rik van Riel wrote:
> On 11/25/2014 12:21 PM, Marcelo Tosatti wrote:
>> The problem:
>>
>> On -RT, an emulated LAPIC timer instances has the following path:
>>
>> 1) hard interrupt
>> 2) ksoftirqd is scheduled
>> 3) ksoftirqd wakes up vcpu thread
>> 4) vcpu thread is scheduled
>>
>> This extra context switch introduces unnecessary latency in the 
>> LAPIC path for a KVM guest.
>>
>> The solution:
>>
>> Allow waking up vcpu thread from hardirq context,
>> thus avoiding the need for ksoftirqd to be scheduled.
>>
>> Normal waitqueues make use of spinlocks, which on -RT 
>> are sleepable locks. Therefore, waking up a waitqueue 
>> waiter involves locking a sleeping lock, which 
>> is not allowed from hard interrupt context.
>>
> 
> What are the consequences for the realtime kernel of
> making waitqueue traversal non-preemptible?
> 
> Is waitqueue traversal something that ever takes so
> long we need to care about it being non-preemptible?

I answered my own question.

This patch only changes the kvm vcpu waitqueue,
which should only ever have the vcpu thread itself
waiting on it. In other words, it is a wait "queue"
of just one entry long, and the latency of traversing
it will be absolutely minimal.

Unless someone can think of a better way to implement
this patch, it gets my:

Acked-by: Rik van Riel <riel@redhat.com>

