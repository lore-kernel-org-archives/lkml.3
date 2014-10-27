Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbaJ0UIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 16:08:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59650 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbaJ0UIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 16:08:18 -0400
Date: Mon, 27 Oct 2014 21:08:11 +0100
From: Borislav Petkov <bp@suse.de>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, namit@cs.technion.ac.il,
        stable@vger.kernel.org
Subject: Re: [PATCH] KVM: emulator: fix execution close to the segment limit
Message-ID: <20141027200811.GB5470@pd.tnic>
References: <1414420306-2771-2-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1414420306-2771-2-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 03:31:46PM +0100, Paolo Bonzini wrote:
> Emulation of code that is 14 bytes to the segment limit or closer
> (e.g. RIP = 0xFFFFFFF2 after reset) is broken because we try to read as
> many as 15 bytes from the beginning of the instruction, and __linearize
> fails when the passed (address, size) pair reaches out of the segment.
> 
> To fix this, let __linearize return the maximum accessible size (clamped
> to 2^32-1) for usage in __do_insn_fetch_bytes, and avoid the limit check
> by passing zero for the desired size.
> 
> For expand-down segments, __linearize is performing a redundant check.
> (u32)(addr.ea + size - 1) <= lim can only happen if addr.ea is close
> to 4GB; in this case, addr.ea + size - 1 will also fail the check against
> the upper bound of the segment (which is provided by the D/B bit).
> After eliminating the redundant check, it is simple to compute
> the *max_size for expand-down segments too.
> 
> Now that the limit check is done in __do_insn_fetch_bytes, we want
> to inject a general protection fault there if size < op_size (like
> __linearize would have done), instead of just aborting.
> 
> This fixes booting Tiano Core from emulated flash with EPT disabled.
> 
> Cc: stable@vger.kernel.org
> Fixes: 719d5a9b2487e0562f178f61e323c3dc18a8b200
> Reported-by: Borislav Petkov <bp@suse.de>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Thanks Paolo, the ept=0 case seems to work now. I'll stress it more
later this week.

Tested-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
