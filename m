Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbbAZMaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:30:06 -0500
Received: from mta-out1.inet.fi ([62.71.2.195]:60722 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838AbbAZMaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:30:03 -0500
Date: Mon, 26 Jan 2015 14:29:44 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-next@vger.kernel.org, sfr@canb.auug.org.au, mhocko@suse.cz,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: mmotm 2015-01-22-15-04: qemu failures due to 'mm: account pmd
 page tables to the process'
Message-ID: <20150126122944.GE25833@node.dhcp.inet.fi>
References: <54c1822d.RtdGfWPekQVAw8Ly%akpm@linux-foundation.org>
 <20150123050445.GA22751@roeck-us.net>
 <20150123111304.GA5975@node.dhcp.inet.fi>
 <54C263CC.1060904@roeck-us.net>
 <20150123135519.9f1061caf875f41f89298d59@linux-foundation.org>
 <20150124055207.GA8926@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150124055207.GA8926@roeck-us.net>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 09:52:07PM -0800, Guenter Roeck wrote:
> On Fri, Jan 23, 2015 at 01:55:19PM -0800, Andrew Morton wrote:
> > On Fri, 23 Jan 2015 07:07:56 -0800 Guenter Roeck <linux@roeck-us.net> wrote:
> > 
> > > >>
> > > >> qemu:microblaze generates warnings to the console.
> > > >>
> > > >> WARNING: CPU: 0 PID: 32 at mm/mmap.c:2858 exit_mmap+0x184/0x1a4()
> > > >>
> > > >> with various call stacks. See
> > > >> http://server.roeck-us.net:8010/builders/qemu-microblaze-mmotm/builds/15/steps/qemubuildcommand/logs/stdio
> > > >> for details.
> > > >
> > > > Could you try patch below? Completely untested.
> > > >
> > > >>From b584bb8d493794f67484c0b57c161d61c02599bc Mon Sep 17 00:00:00 2001
> > > > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> > > > Date: Fri, 23 Jan 2015 13:08:26 +0200
> > > > Subject: [PATCH] microblaze: define __PAGETABLE_PMD_FOLDED
> > > >
> > > > Microblaze uses custom implementation of PMD folding, but doesn't define
> > > > __PAGETABLE_PMD_FOLDED, which generic code expects to see. Let's fix it.
> > > >
> > > > Defining __PAGETABLE_PMD_FOLDED will drop out unused __pmd_alloc().
> > > > It also fixes problems with recently-introduced pmd accounting.
> > > >
> > > > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > > > Reported-by: Guenter Roeck <linux@roeck-us.net>
> > > 
> > > Tested working.
> > > 
> > > Tested-by: Guenter Roeck <linux@roeck-us.net>
> > > 
> > > Any idea how to fix the sh problem ?
> > 
> > Can you tell us more about it?  All I'm seeing is "qemu:sh fails to
> > shut down", which isn't very clear.
> 
> Turns out that the include file defining __PAGETABLE_PMD_FOLDED
> was not always included where used, resulting in a messed up mm_struct.

What means "messed up" here? It should only affect size of mm_struct.
 
> The patch below fixes the problem for the sh architecture.
> No idea if the patch is correct/acceptable for other architectures.

That's pain. Some archs includes <linux/mm_types.h> from <asm/pgtable.h>.
I don't see obvious way to fix this. Urghh.

-- 
 Kirill A. Shutemov
