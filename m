Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266AbaKTWL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 17:11:28 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:33468 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756761AbaKTWL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 17:11:26 -0500
Date: Thu, 20 Nov 2014 17:11:22 -0500
From: Tejun Heo <tj@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141120221122.GA25393@htj.dyndns.org>
References: <20141119145902.GA13387@redhat.com>
 <CA+55aFxBb+aH6GdhbWECkh+wDwsHv43O1ryy4u20O8Bk-oDz+g@mail.gmail.com>
 <CA+55aFym2UfWnXZw0NjA70Q575eybiAOUkx==3Ci+V43u1-ZNQ@mail.gmail.com>
 <20141119190215.GA10796@lerouge>
 <alpine.DEB.2.11.1411192251120.3909@nanos>
 <20141119225615.GA11386@lerouge>
 <alpine.DEB.2.11.1411200002330.3909@nanos>
 <20141119235033.GE11386@lerouge>
 <20141120122339.GA14877@htj.dyndns.org>
 <alpine.DEB.2.11.1411202204030.3950@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1411202204030.3950@nanos>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 10:58:26PM +0100, Thomas Gleixner wrote:
> It's completely undocumented behaviour, whether it has been that way
> for ever or not. And I agree with Fredric, that it is insane. Actuallu
> it's beyond insane, really.

This is exactly the same for any address in the vmalloc space.

..
>    So in the scheduler if the same task gets reselected you check that
>    sequence count and update the PGD if different. If a task switch
>    happens then you also need to check the sequence count and act
>    accordingly.

That isn't enough tho.  What if the percpu allocated pointer gets
passed to another CPU without task switching?  You'd at least need to
send IPIs to all CPUs so that all the active PGDs get updated
synchronously.

> What really frightens me is the potential and well hidden fuckup
> potential which lurks around the corner and the hard to debug once in
> a while fallout which might be caused by this.

Lazy vmalloc population through fault is something we accepted as
reasonable as it works fine for most of the kernel.  If the lazy
loading can be improved so that it doesn't depend on faulting, great.
For the time being, we can make percpu accessors complain when called
from nmi handlers so that the problematic ones can be easily
identified.

Thanks.

-- 
tejun
