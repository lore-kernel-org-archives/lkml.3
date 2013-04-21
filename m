Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009Ab3DUVNc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 17:13:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab3DUVNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 17:13:30 -0400
Message-ID: <51745650.9050204@redhat.com>
Date: Sun, 21 Apr 2013 17:12:48 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jiannan Ouyang <ouyang@cs.pitt.edu>
CC: LKML <linux-kernel@vger.kernel.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Avi Kivity <avi.kivity@gmail.com>, Gleb Natapov <gleb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Chegu Vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Andrew Jones <drjones@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Karen Noel <knoel@redhat.com>
Subject: Re: Preemptable Ticket Spinlock
References: <CAJocwccu5QQyuKRvgNyPSFz2K_rzCW419W9-XdSUYOL7+KqQKg@mail.gmail.com>
In-Reply-To: <CAJocwccu5QQyuKRvgNyPSFz2K_rzCW419W9-XdSUYOL7+KqQKg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2013 06:12 PM, Jiannan Ouyang wrote:
> Hello Everyone,
>
> I recently came up with a spinlock algorithm that can adapt to
> preemption, which you may be interested in. The intuition is to
> downgrade a fair lock to an unfair lock automatically upon preemption,
> and preserve the fairness otherwise. It is a guest side optimization,
> and can be used as a complementary technique to host side optimizations
> like co-scheduling and Pause-Loop Exiting.
>
> In my experiments, it improves VM performance by 5:32X on average, when
> running on a non paravirtual VMM, and by 7:91X when running on a VMM
> that supports a paravirtual locking interface (using a pv preemptable
> ticket spinlock), when executing a set of microbenchmarks as well as a
> realistic e-commerce benchmark.
>
> A detailed algorithm description can be found in my VEE 2013 paper,
> Preemptable Ticket Spinlocks: Improving Consolidated Performance in the
> Cloud
> Jiannan Ouyang, John R. Lange
> ouyang,jacklange@cs.pitt.edu <mailto:jacklange@cs.pitt.edu>
> University of Pittsburgh
> http://people.cs.pitt.edu/~ouyang/files/publication/preemptable_lock-ouyang-vee13.pdf

Your algorithm is very clever, and very promising.

However, it does increase the size of the struct spinlock, and adds
an additional atomic operation to spin_unlock, neither of which I
suspect are necessary.

If we always incremented the ticket number by 2 (instead of 1), then
we could use the lower bit of the ticket number as the spinlock.

If we do NOT run virtualized, we simply increment the ticket by 2
in spin_unlock, and the code can remain otherwise the same.

If we do run virtualized, we take that spinlock after acquiring
the ticket (or timing out), just like in your code. In the
virtualized spin_unlock, we can then release the spinlock and
increment the ticket in one operation: by simply increasing the
ticket by 1.

In other words, we should be able to keep the overhead of this
to an absolute minimum, and keep spin_unlock to be always the
same cost it is today.

-- 
All rights reversed
