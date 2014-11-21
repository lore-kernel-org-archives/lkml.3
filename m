Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758914AbaKUQZP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 11:25:15 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:49211 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758890AbaKUQZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 11:25:12 -0500
Date: Fri, 21 Nov 2014 11:25:06 -0500
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141121162506.GA15461@htj.dyndns.org>
References: <20141119225615.GA11386@lerouge>
 <alpine.DEB.2.11.1411200002330.3909@nanos>
 <20141119235033.GE11386@lerouge>
 <20141120122339.GA14877@htj.dyndns.org>
 <alpine.DEB.2.11.1411202204030.3950@nanos>
 <20141120221122.GA25393@htj.dyndns.org>
 <alpine.DEB.2.11.1411202315230.3950@nanos>
 <20141120230514.GB25393@htj.dyndns.org>
 <alpine.DEB.2.11.1411210109460.6439@nanos>
 <20141121141332.GA8808@lerouge>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141121141332.GA8808@lerouge>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Frederic.

On Fri, Nov 21, 2014 at 03:13:35PM +0100, Frederic Weisbecker wrote:
...
> So when the issue arised 4 years ago, it was a problem only for NMIs.
> Like Linus says: "what happens in NMI stays in NMI". Ok no that's not quite
> what he says :-)  But NMIs happen to be a corner case for about everything
> and it's sometimes better to fix things from NMI itself, or have an NMI
> special case rather than grow the whole infrastructure in complexity to
> support this very corner case.

I'm not familiar with the innards of fault handling, so can you please
help me understand what may actually break?  Here are what I currently
understand.

* Static percpu areas wouldn't trigger fault lazily.  Note that this
  is not necessarily because the first percpu chunk which contains the
  static area is embedded inside the kernel linear mapping.  Depending
  on the memory layout and boot param, percpu allocator may choose to
  map the first chunk in vmalloc space too; however, this still works
  out fine because at that point there are no other page tables and
  the PUD entries covering the first chunk is faulted in before other
  pages tables are copied from the kernel one.

* NMI used to be a problem because vmalloc fault handler couldn't
  safely nest inside NMI handler but this has been fixed since and it
  should work fine from NMI handlers now.

* Function tracers are problematic because they may end up nesting
  inside themselves through triggering a vmalloc fault while accessing
  dynamic percpu memory area.  This may lead to recursive locking and
  other surprises.

Are there other cases where the lazy vmalloc faults can break things?

Thanks.

-- 
tejun
