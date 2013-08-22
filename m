Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab3HVHDJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 03:03:09 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:40725 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab3HVHDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 03:03:08 -0400
Date: Thu, 22 Aug 2013 11:03:05 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Xen-devel@lists.xen.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Pavel Emelyanov <xemul@parallels.com>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Regression: x86/mm: new _PTE_SWP_SOFT_DIRTY bit conflicts with
 existing use
Message-ID: <20130822070305.GH18673@moon>
References: <5214C524.1050900@citrix.com>
 <20130821141223.GS18673@moon>
 <5214F09002000078000ED5C3@nat28.tlf.novell.com>
 <20130821154238.GV18673@moon>
 <521500E102000078000ED65C@nat28.tlf.novell.com>
 <20130821161946.GW18673@moon>
 <5215D23A02000078000ED7FC@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5215D23A02000078000ED7FC@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 07:56:26AM +0100, Jan Beulich wrote:
> >>> On 21.08.13 at 18:19, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> > On Wed, Aug 21, 2013 at 05:03:13PM +0100, Jan Beulich wrote:
> >> > 
> >> > Only to non-present ptes, as far as I know.
> >> 
> >> That's not really any guarantee. And the accessor functions also
> >> don't check that they'd be used on non-present PTEs only.
> > 
> > Wait. This _PAGE_SWP_SOFT_DIRTY bit (which is in real PSE bit) assigned
> > in only one place -- in try_to_unmap_one(). The PTE get non-present then
> > and consists of swap entry format. I don't see any accessor to such entry
> > without testing if it's swap entry or pte-none. What I'm missing?
> 
> Fact is that this
> 
> static inline pte_t pte_swp_mksoft_dirty(pte_t pte)
> {
> 	return pte_set_flags(pte, _PAGE_SWP_SOFT_DIRTY);
> }
> 
> has no checking whatsoever that the PTE being modified is a
> non-present one, not even in any of the debugging modes. It
> would be a different thing if the above acted on a swp_entry_t.
> 
> The fact that there currently may be just a single call site (where
> the caller guarantees the non-present state) is no guarantee that
> in the future another one won't appear, and then result in very
> hard to debug problems.

Ok, how about this?

static inline pte_t pte_swp_mksoft_dirty(pte_t pte)
{
	BUG_ON(pte_present(pte));
	return pte_set_flags(pte, _PAGE_SWP_SOFT_DIRTY);
}
