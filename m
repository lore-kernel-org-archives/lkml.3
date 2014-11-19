Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219AbaKSXN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 18:13:26 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:48903 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932658AbaKSXNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 18:13:24 -0500
Date: Thu, 20 Nov 2014 00:13:21 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141119231319.GD11386@lerouge>
References: <20141118215540.GD35311@redhat.com>
 <20141119021902.GA14216@redhat.com>
 <CA+55aFw13opSu6ETXgVo1tjrP+1PLkbsiKewEqRgdBKyBKALWA@mail.gmail.com>
 <20141119145902.GA13387@redhat.com>
 <CA+55aFxBb+aH6GdhbWECkh+wDwsHv43O1ryy4u20O8Bk-oDz+g@mail.gmail.com>
 <CA+55aFym2UfWnXZw0NjA70Q575eybiAOUkx==3Ci+V43u1-ZNQ@mail.gmail.com>
 <20141119190215.GA10796@lerouge>
 <CALCETrVOW1U8uDKZhChP_PgG40jsJE4F0Jeyfj1BT=qJSFY6yw@mail.gmail.com>
 <20141119230051.GB11386@lerouge>
 <CALCETrVrUNgHnT4ON12oZZbt=dXXaaSBSHHYLtUTvDqDo87hYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVrUNgHnT4ON12oZZbt=dXXaaSBSHHYLtUTvDqDo87hYg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 03:07:17PM -0800, Andy Lutomirski wrote:
> On Wed, Nov 19, 2014 at 3:00 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > Note that's non-sleeping faults. So probably most places are fine except
> > a few of them that really don't want exception to mess up some state. I
> > can imagine some entry code that really don't want that.
> 
> Any non-IST fault at all on the kernel_stack reference in system_call
> is instant root on non-SMAP systems and instant double-fault or more
> challenging root on SMAP systems.  The issue is that rsp is
> user-controlled, so the CPU cannot deliver a non-IST fault safely.

Heh.

> >
> > Is kernel stack allocated by vmalloc or alloc_percpu()?
> 
> DEFINE_PER_CPU(unsigned long, kernel_stack)
> 
> Note that I'm talking about kernel_stack, not the kernel stack itself.

Ah. Note, static allocation like DEFINE_PER_CPU() is probably fine. The
issue is on dynamic allocations: alloc_percpu().

> The actual stack is regular linearly-mapped memory, although I plan on
> trying to change that, complete with all kinds of care to avoid double
> faults.

If you do so, you must really ensure that the resulting memory will never
fault.
