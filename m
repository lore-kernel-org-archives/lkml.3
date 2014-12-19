Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbaLSL3L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 06:29:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbaLSL3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 06:29:09 -0500
Message-ID: <54940BF0.1020104@redhat.com>
Date: Fri, 19 Dec 2014 12:28:48 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: nick <xerofoify@gmail.com>, gleb@kernel.org
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Question about hrtimer_restart apic_timer_fn in lapic.c
References: <549319DD.1020908@gmail.com>
In-Reply-To: <549319DD.1020908@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 18/12/2014 19:15, nick wrote:
>       /*
>        * There is a race window between reading and incrementing, but we do
>        * not care about potentially losing timer events in the !reinject
>        * case anyway. Note: KVM_REQ_PENDING_TIMER is implicitly checked
>        * in vcpu_enter_guest.
>        */
>        if (!atomic_read(&ktimer->pending)) {
>                 atomic_inc(&ktimer->pending);
>                 /* FIXME: this code should not know anything about vcpus */
>                 kvm_make_request(KVM_REQ_PENDING_TIMER, vcpu);
>        }
> 
>        if (waitqueue_active(q))
>                 wake_up_interruptible(q);
> 
>         if (lapic_is_periodic(apic)) {
>                hrtimer_add_expires_ns(&ktimer->timer, ktimer->period);
>                return HRTIMER_RESTART;
>          } else
>                 return HRTIMER_NORESTART;
> }
> What is point of the comment, clearly we need access to vcpu in the call as it's a pointer to the apic structure's vcpu
> and we need to call on that particular CPU a request of  KVM_REQ_PENDING_TIMER? Please let me known if I am missing any
> important information.

The idea is that there should be a function in x86.c (something like
kvm_vcpu_set_pending_timer) that calls kvm_make_request, instead of
doing it in lapic.c.

Paolo
