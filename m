Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbaFPLKP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 07:10:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbaFPLKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 07:10:13 -0400
Message-ID: <539ED084.2000906@redhat.com>
Date: Mon, 16 Jun 2014 13:09:56 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Nadav Amit <nadav.amit@gmail.com>, Nadav Amit <namit@cs.technion.ac.il>
CC: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] KVM: x86: check DR6/7 high-bits are clear only on
 long-mode
References: <1402837982-24959-1-git-send-email-namit@cs.technion.ac.il> <1402837982-24959-7-git-send-email-namit@cs.technion.ac.il> <539EC43F.607@redhat.com> <539EC7F7.2000208@gmail.com>
In-Reply-To: <539EC7F7.2000208@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 16/06/2014 12:33, Nadav Amit ha scritto:
>>
>> Do you get this if the input register has bit 31 set?
> No. To be frank, the scenario may be considered a bit synthetic: the
> guest assigns a value to a general-purpose register in 64-bit mode,
> setting the high 32-bits to some non-zero value. Then, later, in 32-bit
> mode, the guest performs MOV DR instruction. In between the two
> assignments, the general purpose register is unmodified, so the high
> 32-bits of the general purpose registers are still set.
>
> Note that this scenario does not occur when MOV DR is emulated, but when
> handle_dr() is called. In this case, the entire 64-bits of the general
> purpose register used for MOV DR are read, regardless to the execution
> mode of the guest.

I wonder if the same bug happens elsewhere.  For example, 
kvm_emulate_hypercall doesn't look at CS.L/CS.DB, which is really a 
corner case but arguably also a bug.  kvm_hv_hypercall instead does it 
right.

Perhaps we need a variant of kvm_register_read that (on 64-bit hosts) 
checks EFER/CS.L/CS.DB and masks the returned value accordingly.  You 
could call it kvm_register_readl.

Paolo
