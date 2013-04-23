Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab3DWPDG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 11:03:06 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:53148 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755403Ab3DWPDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 11:03:04 -0400
Date: Tue, 23 Apr 2013 16:02:40 +0100
From: Will Deacon <will.deacon@arm.com>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 1/4] perf: Add hardware breakpoint address mask
Message-ID: <20130423150240.GD18616@mudshark.cambridge.arm.com>
References: <1366703825-19373-1-git-send-email-jacob.shin@amd.com>
 <1366703825-19373-2-git-send-email-jacob.shin@amd.com>
 <20130423095437.GD17593@mudshark.cambridge.arm.com>
 <20130423143423.GB17021@jshin-Toonie>
 <20130423144057.GA19644@jshin-Toonie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130423144057.GA19644@jshin-Toonie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 03:40:57PM +0100, Jacob Shin wrote:
> On Tue, Apr 23, 2013 at 09:34:23AM -0500, Jacob Shin wrote:
> > On Tue, Apr 23, 2013 at 10:54:37AM +0100, Will Deacon wrote:
> > > Can you see a problem if I simply invert the mask?
> > 
> > That's great! No, I don't see a problem at all.

Great! The GDB folks have been asking for this, so I can finally make them
go away now :)

> > I guess now it can be debated if the mask coming in from userland should
> > be include or exclude mask. But I think exclude makes syntax easier:
> > 
> > To count writes to [0x1000 ~ 0x1010)
> > 
> > Include mask (my current patchset):
>   ^^^^^^^
>   Exclude (I mean ..)
> > 
> >   perf stat -e mem:0x1000/0xf:w a.out

Are you saying that this command would count any write to:

	0x1000
	0x1001
	...
	0x100e
	0x100f

?

If so, that differs from the ARM debug architecture in that the mask is called
`byte-address-select', so a mask of 0b1001 would count accesses at +0 bytes
and +3 bytes from the base address. Is that possible to describe with your
masking scheme and a single watchpoint?

A mask of 0xf, would count +0, +1, +2 and +3 (essentially bp_len == 4).

Unfortunately, that means I can't just invert the mask like I originally
thought.

Will
