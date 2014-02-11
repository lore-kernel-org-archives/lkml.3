Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461AbaBKJx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 04:53:57 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:64001 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaBKJxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 04:53:51 -0500
MIME-Version: 1.0
In-Reply-To: <1392001823.3996.21.camel@pasglop>
References: <20140207165801.GC2107@lst.de>
	<1392001823.3996.21.camel@pasglop>
Date: Tue, 11 Feb 2014 15:23:51 +0530
Message-ID: <CAC4Lta2Pssu5QY_QLmy5C3Fm2G3fwpiuc5BNOLBnQTmmRH+W4Q@mail.gmail.com>
Subject: Re: [PATCH v2] powerpc ticket locks
From: Raghavendra KT <raghavendra.kt.linux@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Torsten Duwe <duwe@lst.de>
Cc: Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Scott Wood <scottwood@freescale.com>, Tom Musta <tommusta@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 8:40 AM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Fri, 2014-02-07 at 17:58 +0100, Torsten Duwe wrote:
>>  typedef struct {
>> -       volatile unsigned int slock;
>> -} arch_spinlock_t;
>> +       union {
>> +               __ticketpair_t head_tail;
>> +               struct __raw_tickets {
>> +#ifdef __BIG_ENDIAN__          /* The "tail" part should be in the MSBs */
>> +                       __ticket_t tail, head;
>> +#else
>> +                       __ticket_t head, tail;
>> +#endif
>> +               } tickets;
>> +       };
>> +#if defined(CONFIG_PPC_SPLPAR)
>> +       u32 holder;
>> +#endif
>> +} arch_spinlock_t __aligned(4);
>
> That's still broken with lockref (which we just merged).
>
> We must have the arch_spinlock_t and the ref in the same 64-bit word
> otherwise it will break.
>
> We can make it work in theory since the holder doesn't have to be
> accessed atomically, but the practicals are a complete mess ...
> lockref would essentially have to re-implement the holder handling
> of the spinlocks and use lower level ticket stuff.
>

Probably very basic and stupid question from me.
How much important to have holder information for PPC? From my
previous experiment
on x86, it was lock-waiter preemption which is problematic rather than
lock-holder preemption.
