Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088AbaLAN6j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 08:58:39 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:40590 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538AbaLAN6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 08:58:38 -0500
Date: Mon, 1 Dec 2014 14:58:30 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [RFC PATCH 06/30] s390: Introduce cputime64_to_nsecs()
Message-ID: <20141201145830.24d3e43e@mschwide>
In-Reply-To: <20141201122452.GE4074@osiris>
References: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
	<1417199040-21044-7-git-send-email-fweisbec@gmail.com>
	<20141201122452.GE4074@osiris>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120113-0029-0000-0000-000001F5B70C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2014 13:24:52 +0100
Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> On Fri, Nov 28, 2014 at 07:23:36PM +0100, Frederic Weisbecker wrote:
> > This will be needed for the conversion of kernel stat to nsecs.
> > 
> > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > Cc: Oleg Nesterov <oleg@redhat.com>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Rik van Riel <riel@redhat.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Tony Luck <tony.luck@intel.com>
> > Cc: Wu Fengguang <fengguang.wu@intel.com>
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > ---
> >  arch/s390/include/asm/cputime.h | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/arch/s390/include/asm/cputime.h b/arch/s390/include/asm/cputime.h
> > index 820b38a..75ba96f 100644
> > --- a/arch/s390/include/asm/cputime.h
> > +++ b/arch/s390/include/asm/cputime.h
> > @@ -59,6 +59,11 @@ static inline cputime64_t jiffies64_to_cputime64(const u64 jif)
> >  	return (__force cputime64_t)(jif * (CPUTIME_PER_SEC / HZ));
> >  }
> > 
> > +static inline u64 cputime64_to_nsecs(cputime64_t cputime)
> > +{
> > +	return (__force u64)cputime * CPUTIME_PER_USEC * NSEC_PER_USEC;
> > +}
> > +
> 
> This is incorrect. You probably wanted to write something like
> 
> 	return (__force u64)cputime / CPUTIME_PER_USEC * NSEC_PER_USEC; ?
> 
> However we would still lose a lot of precision.
> The correct algorithm to convert from cputime to nanoseconds can be found in
> tod_to_ns() - see arch/s390/include/asm/timex.h
> 
> And if you see that rather complex algorithm, I doubt we want to have the
> changes you propose. We need to have that calculation three times for each
> irq (user, system and steal time) and would still have worse precision than
> we have right now. Not talking about the additional wasted cpu cycles...
> 
> But I guess Martin wanted to comment on your patches anyway ;)

The function that gets called most often is the accounting code for irq_enter
and irq_exit. Both are mapped to vtime_account_irq_enter, with the correct
implementation for the cputime_to_nsec the function gets 15 instructions
longer. The relevant code sequence

Upstream code:
  10592e:       e3 10 02 e8 00 04       lg      %r1,744
  105934:       b2 09 f0 a0             stpt    160(%r15)
  105938:       e3 30 f0 a0 00 04       lg      %r3,160(%r15)
  10593e:       e3 10 02 d8 00 08       ag      %r1,728
  105944:       e3 30 02 e8 00 24       stg     %r3,744
  10594a:       b9 09 00 13             sgr     %r1,%r3
  10594e:       e3 10 02 d8 00 24       stg     %r1,728
  105954:       b9 04 00 41             lgr     %r4,%r1
  105958:       e3 40 c0 68 00 09       sg      %r4,104(%r12)
  10595e:       e3 30 02 e0 00 04       lg      %r3,736
  105964:       b9 09 00 34             sgr     %r3,%r4
  105968:       b9 04 00 54             lgr     %r5,%r4
  10596c:       e3 30 02 e0 00 24       stg     %r3,736
  105972:       a7 39 00 00             lghi    %r3,0
  105976:       e3 10 c0 68 00 24       stg     %r1,104(%r12)
  10597c:       b9 04 00 b4             lgr     %r11,%r4
  105980:       c0 e5 00 03 78 4c       brasl   %r14,174a18 <account_system_time

Patched code:
  105a3e:       e3 50 02 e8 00 04       lg      %r5,744
  105a44:       b2 09 f0 a0             stpt    160(%r15)
  105a48:       b9 04 00 15             lgr     %r1,%r5
  105a4c:       e3 50 f0 a0 00 04       lg      %r5,160(%r15)
  105a52:       e3 50 02 e8 00 24       stg     %r5,744
  105a58:       e3 10 02 d8 00 08       ag      %r1,728
  105a5e:       b9 e9 50 51             sgrk    %r5,%r1,%r5
  105a62:       e3 00 02 e0 00 04       lg      %r0,736
  105a68:       e3 50 02 d8 00 24       stg     %r5,728
  105a6e:       b9 04 00 15             lgr     %r1,%r5
  105a72:       e3 10 a0 68 00 09       sg      %r1,104(%r10)
  105a78:       b9 04 00 e1             lgr     %r14,%r1
  105a7c:       b9 04 00 81             lgr     %r8,%r1
  105a80:       eb 11 00 20 00 0c       srlg    %r1,%r1,32
  105a86:       ec 3e 20 bf 00 55       risbg   %r3,%r14,32,191,0
  105a8c:       eb 91 00 02 00 0d       sllg    %r9,%r1,2
  105a92:       eb c3 00 07 00 0d       sllg    %r12,%r3,7
  105a98:       eb b1 00 07 00 0d       sllg    %r11,%r1,7
  105a9e:       eb 43 00 02 00 0d       sllg    %r4,%r3,2
  105aa4:       b9 09 00 b9             sgr     %r11,%r9
  105aa8:       b9 e9 40 4c             sgrk    %r4,%r12,%r4
  105aac:       b9 08 00 43             agr     %r4,%r3
  105ab0:       b9 08 00 1b             agr     %r1,%r11
  105ab4:       b9 e9 e0 30             sgrk    %r3,%r0,%r14
  105ab8:       eb 11 00 17 00 0d       sllg    %r1,%r1,23
  105abe:       e3 30 02 e0 00 24       stg     %r3,736
  105ac4:       eb 44 00 09 00 0c       srlg    %r4,%r4,9
  105aca:       e3 50 a0 68 00 24       stg     %r5,104(%r10)
  105ad0:       b9 08 00 41             agr     %r4,%r1
  105ad4:       b9 04 00 54             lgr     %r5,%r4
  105ad8:       a7 39 00 00             lghi    %r3,0
  105adc:       c0 e5 00 03 78 02       brasl   %r14,174ae0 <account_system_time

The function is called two times for each interrupt and accounts
the system time only, that makes 2 * 15 instructions more for each
interrupt, while loosing a small amount of precision. Imho not good.

The idea of cputime_t was to allow an architecture to define its preferred
format, for s390 this is a pure CPU timer delta. We do not loose *any*
precision as long as the CPU timer works correctly. From my point of view
this is a change for the worse.

On the positive side, there are some nice improvements in the patch
series. We will definitely pick up some of the patches.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

