Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbaBTSmn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 13:42:43 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:45480 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403AbaBTSmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 13:42:39 -0500
MIME-Version: 1.0
In-Reply-To: <5306413F.3010106@hp.com>
References: <1392669684-4807-1-git-send-email-Waiman.Long@hp.com>
	<53029167.4060109@zytor.com>
	<20140218073111.GW27965@twins.programming.kicks-ass.net>
	<5303B4C4.2040907@hp.com>
	<20140218212827.GR14089@laptop.programming.kicks-ass.net>
	<5303FDEC.9060001@hp.com>
	<20140219085107.GG27965@twins.programming.kicks-ass.net>
	<53050501.3070101@hp.com>
	<CA+55aFwyVgLJq2OgKZBK7g+T5-_M4o+dnEAr+qtYxA5t_=HSvA@mail.gmail.com>
	<5306413F.3010106@hp.com>
Date: Thu, 20 Feb 2014 10:42:38 -0800
X-Google-Sender-Auth: ODlncNSJeFGneYjilULcB2tW2jI
Message-ID: <CA+55aFyJTOwnSJxc_qeHxKGoZ71xo3UWc4DrAJ5=OAtOvG7_CA@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] qspinlock: Introducing a 4-byte queue spinlock
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Daniel J Blueman <daniel@numascale.com>,
        Alexander Fyodorov <halcy@yandex.ru>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 9:54 AM, Waiman Long <waiman.long@hp.com> wrote:
>
> I think we could implement 2 versions of _raw_spin_lock.

Yup. Or rather,  I'd suggest implement just one version of
arch_spin_lock(), but at the top of it you do something like

   #if CONFIG_PARAVIRT_SPINLOCK
        if (static_key_false(&unfair_spinlocks)) {
           .. do paravirt unfair lock version ..
        }
   #endif

which should basically generate almost-perfect code:  it's one extra
no-op for the native case if CONFIG_PARAVIRT_SPINLOCK is on, which
turns into a branch for the unfair version for paravirtualization.

Or something like that.

              Linus
