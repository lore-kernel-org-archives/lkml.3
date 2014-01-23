Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbaAWVpO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 16:45:14 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:55345 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbaAWVpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 16:45:12 -0500
Date: Fri, 24 Jan 2014 01:45:05 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@parallels.com>, Mel Gorman <mgorman@suse.de>,
        gnome@rvzt.net, grawoc@darkrefraction.com, alan@lxorguk.ukuu.org.uk,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        bugzilla-daemon@bugzilla.kernel.org
Subject: Re: [PATCH] mm: Ignore VM_SOFTDIRTY on VMA merging, v2
Message-ID: <20140123214505.GA1992@moon>
References: <20140122190816.GB4963@suse.de>
 <20140122191928.GQ1574@moon>
 <20140122223325.GA30637@moon>
 <20140123095541.GD4963@suse.de>
 <20140123103606.GU1574@moon>
 <20140123121555.GV1574@moon>
 <20140123125543.GW1574@moon>
 <20140123151445.GX1574@moon>
 <20140123130235.61e2eca44d92b37936955ff1@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140123130235.61e2eca44d92b37936955ff1@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 01:02:35PM -0800, Andrew Morton wrote:
> On Thu, 23 Jan 2014 19:14:45 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> 
> > VM_SOFTDIRTY bit affects vma merge routine: if two VMAs has all
> > bits in vm_flags matched except dirty bit the kernel can't longer
> > merge them and this forces the kernel to generate new VMAs instead.
> 
> Do you intend to alter the brk() and binprm code to set VM_SOFTDIRTY?

brk() will be "dirtified" now with this merge fix.
brk
  do_brk
    out:
	...
	vma->vm_flags |= VM_SOFTDIRTY;

this will work even if vma get merged, the problem was that earlier
we tried to merge without VM_SOFTDIRTY flag. And matcher failed.

do_brk
  flags = VM_DATA_DEFAULT_FLAGS | VM_ACCOUNT | mm->def_flags;
	vma = vma_merge(mm, prev, addr, addr + len, flags,
					NULL, NULL, pgoff, NULL);
	if (vma)
		goto out;
...
out:
	...
	vma->vm_flags |= VM_SOFTDIRTY;

That said I'm not really sure now if I should alert @flags in code above.
Should I add VM_SOFTDIRTY into @flags for clarity?

Same for binprm -- the vma allocated for bprm->vma is dirtified
__bprm_mm_init
  vma->vm_flags = VM_SOFTDIRTY | VM_STACK_FLAGS | VM_STACK_INCOMPLETE_SETUP;

then setup_arg_pages calls mprotect_fixup with @vm_flags having dirty bit
set thus it'll be propagated to vma

mprotect_fixup
  ...
  vma->vm_flags = newflags;

the @newflags will have dirty bit set from caller code.

Or you mean something else which I'm missing?
