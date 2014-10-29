Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131AbaJ2Jh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 05:37:56 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:49977 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756210AbaJ2Jhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 05:37:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Heena Sirwani <heenasirwani@gmail.com>, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org
Subject: Re: [PATCH v7] timekeeping: Added a function to return tv_sec portion of ktime_get_ts64()
Date: Wed, 29 Oct 2014 10:37:42 +0100
Message-ID: <3371590.dCyFlG7rJg@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.11.1410291020140.5308@nanos>
References: <20141029091317.GA1138@heena-HP-Compaq-8200-Elite-MT-PC> <alpine.DEB.2.11.1410291020140.5308@nanos>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:V/N8Nt2K3VE5Jag3E8ZwmAk3EgClGwNY9OwVWwxZVdd
 HegdLcb/k03Zohp8QsoXbR9kvuakzLPDQ2d5jZ7aTYAS0VyHzM
 acg78QILK/CQTwR26XteOTlqWWuqSQ9yjBmpCDiGI7IsMUqnHD
 SI2eo6NJNCpEKLGrZFNGnWLu94BZTEjgdDQFFRYcayKLhNndEl
 R9vcY4lZa3bxFLOl3M1wHoDrCDzJTK6kezlKq6VP4wl3MKmme7
 Br1LNaXR/uVnnQ3hiyHioi4S5E2CsujgxEmTm6evsGNChbE05s
 1LfNbvOV9ZVneQvrL2WRjYNItH3d6vzoAZJgJkVgZV1g4p2SYk
 QtcsYgRNckgMwXlJeNBw=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 October 2014 10:21:18 Thomas Gleixner wrote:
> On Wed, 29 Oct 2014, Heena Sirwani wrote:
> > +time64_t ktime_get_seconds(void)
> > +{
> > +     time64_t seconds;
> > +     struct timekeeper *tk = &tk_core.timekeeper;
> > +     unsigned int seq;
> > +
> > +     WARN_ON(timekeeping_suspended);
> 
> You want to have the same 64bit logic as you did for
> ktime_get_real_seconds. So on 64bit it boils down to return
> tk->ktime_sec.
> 
> > +
> > +     do {
> > +             seq = read_seqcount_begin(&tk_core.seq);
> > +             seconds = tk->ktime_sec;
> > +
> > +     } while (read_seqcount_retry(&tk_core.seq, seq));
> 

I wonder if we should just make tk->ktime_sec 'unsigned long' and
avoid the lock for 32-bit as well. Are there any theoretical
cases where the monotonic time could overflow a 32-bit integer?

As a minor optimization 's64 nsec_offset' could also be 'long',
since that only stores a number that is known to be less than
1000000000.

	Arnd
