Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758542Ab3DXJtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 05:49:15 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37738 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756130Ab3DXJtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 05:49:13 -0400
Date: Wed, 24 Apr 2013 10:48:53 +0100
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
Message-ID: <20130424094853.GB21850@mudshark.cambridge.arm.com>
References: <1366703825-19373-1-git-send-email-jacob.shin@amd.com>
 <1366703825-19373-2-git-send-email-jacob.shin@amd.com>
 <20130423095437.GD17593@mudshark.cambridge.arm.com>
 <20130423143423.GB17021@jshin-Toonie>
 <20130423144057.GA19644@jshin-Toonie>
 <20130423150240.GD18616@mudshark.cambridge.arm.com>
 <20130423151846.GA22052@jshin-Toonie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130423151846.GA22052@jshin-Toonie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 04:18:46PM +0100, Jacob Shin wrote:
> On Tue, Apr 23, 2013 at 04:02:40PM +0100, Will Deacon wrote:
> > On Tue, Apr 23, 2013 at 03:40:57PM +0100, Jacob Shin wrote:
> > > >   perf stat -e mem:0x1000/0xf:w a.out
> > 
> > Are you saying that this command would count any write to:
> > 
> > 	0x1000
> > 	0x1001
> > 	...
> > 	0x100e
> > 	0x100f
> > 
> > ?
> > 
> > If so, that differs from the ARM debug architecture in that the mask is called
> > `byte-address-select', so a mask of 0b1001 would count accesses at +0 bytes
> > and +3 bytes from the base address. Is that possible to describe with your
> > masking scheme and a single watchpoint?
> > 
> > A mask of 0xf, would count +0, +1, +2 and +3 (essentially bp_len == 4).
> > 
> > Unfortunately, that means I can't just invert the mask like I originally
> > thought.
> 
> Ah, .. that is different .
> 
> Our hardware matches on the breakpoint if:
> 
>   (physical_address & ~bp_addr_mask) == (bp_addr & ~bp_addr_mask)
> 
> In other words, the mask says which of the bp_addr bits hardware should
> ignore when matching.
> 
> .. it would be great if we can come up with userland interface that works
> for both archs. I'm coming up empty at the moment ..

After a bit of thought, I *think* the ARM mechanism is more expressive, and
you could describe your masking in terms of byte-address-select. The
downside is that we'd end up with much larger masks, which could be argued
as counter-intuitive from a user's point of view.

Will
