Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab3HVG4c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 02:56:32 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:55557 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798Ab3HVG4b convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:9:1>);
	Thu, 22 Aug 2013 02:56:31 -0400
Message-Id: <5215D23A02000078000ED7FC@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Thu, 22 Aug 2013 07:56:26 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Cc: "Andy Lutomirski" <luto@amacapital.net>,
        "David Vrabel" <david.vrabel@citrix.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        <Xen-devel@lists.xen.org>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "Pavel Emelyanov" <xemul@parallels.com>,
        "Ingo Molnar" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Regression: x86/mm: new _PTE_SWP_SOFT_DIRTY bit conflicts
 with existing use
References: <5214C524.1050900@citrix.com> <20130821141223.GS18673@moon>
 <5214F09002000078000ED5C3@nat28.tlf.novell.com>
 <20130821154238.GV18673@moon>
 <521500E102000078000ED65C@nat28.tlf.novell.com>
 <20130821161946.GW18673@moon>
In-Reply-To: <20130821161946.GW18673@moon>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 21.08.13 at 18:19, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Wed, Aug 21, 2013 at 05:03:13PM +0100, Jan Beulich wrote:
>> > 
>> > Only to non-present ptes, as far as I know.
>> 
>> That's not really any guarantee. And the accessor functions also
>> don't check that they'd be used on non-present PTEs only.
> 
> Wait. This _PAGE_SWP_SOFT_DIRTY bit (which is in real PSE bit) assigned
> in only one place -- in try_to_unmap_one(). The PTE get non-present then
> and consists of swap entry format. I don't see any accessor to such entry
> without testing if it's swap entry or pte-none. What I'm missing?

Fact is that this

static inline pte_t pte_swp_mksoft_dirty(pte_t pte)
{
	return pte_set_flags(pte, _PAGE_SWP_SOFT_DIRTY);
}

has no checking whatsoever that the PTE being modified is a
non-present one, not even in any of the debugging modes. It
would be a different thing if the above acted on a swp_entry_t.

The fact that there currently may be just a single call site (where
the caller guarantees the non-present state) is no guarantee that
in the future another one won't appear, and then result in very
hard to debug problems.

Jan

