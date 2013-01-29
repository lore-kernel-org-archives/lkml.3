Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab3A2Jrq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 04:47:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46713 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181Ab3A2Jro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 04:47:44 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 2/2] x86 e820: Introduce memmap=resetusablemap for kdump usage
Date: Tue, 29 Jan 2013 10:47:34 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-24-desktop; KDE/4.6.0; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        vgoyal@redhat.com, horms@verge.net.au
References: <1358868049-19884-1-git-send-email-trenn@suse.de> <510721C6.6080705@zytor.com> <CAE9FiQWDcFR+6L-GiR6rk60TC0zH=xewyH_h1Rx_QB+8PTiU3Q@mail.gmail.com>
In-Reply-To: <CAE9FiQWDcFR+6L-GiR6rk60TC0zH=xewyH_h1Rx_QB+8PTiU3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301291047.34957.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 29, 2013 03:10:38 AM Yinghai Lu wrote:
> On Mon, Jan 28, 2013 at 5:11 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> >> So I guess the final patch should be:
> >>    - Add a new e820 type:
> >>         E820_KDUMP_RESERVED /* Originally usable memory where the crashed
> >>                                                     kernel kernel resided in */
> >>   - Use Yinghai's last posted patch, but instead of:
> >> +                     e820_update_range(0, ULLONG_MAX, E820_RAM,
> >> +                                       E820_RESERVED);
> >> ...
> >> +                     e820_remove_range(start_at, mem_size, E820_RESERVED, 0);
> >> do:
> >> +                     e820_update_range(0, ULLONG_MAX, E820_RAM,
> >> +                                       E820_KDUMP_RESERVED);
> >> ...
> >> +                     e820_remove_range(start_at, mem_size, E820_KDUMP_RESERVED, 0);
> >>
> >>   - Come up with another memmap=kdump_reserve_ram memmap option name
> >>     or however it should get named...
> >>
> >> If this proposal gets accepted, I can send a tested patch...
> >>
> >
> > Yes, this is much saner.  There really shouldn't need to be an option,
> > even; since the tools need to be modified anyway, just modify the actual
> > memory map data structure itself.
> 
> yes,
> 
> kexec-tools will change that to E820_KDUMP_RESERVED (or other good name).
> 
> We only need to update kernel to get old max_pfn by
> checking E820_KDUMP_RESERVED.

Wait, above proposal does not include kexec-tools mangling of the
e820 table, for several reasons:

- Keep the boot interface clean and pass the original table
- Only one possible error source on e820 table modifications
- While hpa proposed kexec-tools to pass a modified e820 table to
  make things easier, exactly the opposite is the case:
  If kexec-tools and the kernel modify the table, things are more
  complex and hard to understand in case of debugging where things
  went wrong
- It's really easy to do that in the kernel. As shown above it should
  simply be this line to change usable areas into E820_KDUMP_RESERVED
  ones:
  e820_update_range(0, ULLONG_MAX, E820_RAM, E820_KDUMP_RESERVED);
  and possibly slight adjusting when the memmap=X#Y memory
  the kdump kernel uses is added (has to override E820_KDUMP_RESERVED
  areas with usable memory again)

My previously posted kexec-tools patches should simply work,
it's just that the memmap option name changes to:
memmap=kdump_reserve_ram

This is what I proposed and is IMO the best and less complex
way to go. I guess I still wait another day for comments and
will send something if you agree.

   Thomas
