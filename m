Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab3HUQ4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 12:56:12 -0400
Received: from smtp.citrix.com ([66.165.176.89]:39049 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633Ab3HUQ4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 12:56:11 -0400
X-IronPort-AV: E=Sophos;i="4.89,929,1367971200"; 
   d="scan'208";a="46241093"
Message-ID: <5214F128.1000901@citrix.com>
Date: Wed, 21 Aug 2013 17:56:08 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Jan Beulich <JBeulich@suse.com>, Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        <Xen-devel@lists.xen.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Pavel Emelyanov <xemul@parallels.com>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Regression: x86/mm: new _PTE_SWP_SOFT_DIRTY bit conflicts with
 existing use
References: <5214C524.1050900@citrix.com> <20130821141223.GS18673@moon> <5214F09002000078000ED5C3@nat28.tlf.novell.com> <20130821154238.GV18673@moon> <521500E102000078000ED65C@nat28.tlf.novell.com> <20130821161946.GW18673@moon>
In-Reply-To: <20130821161946.GW18673@moon>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/08/13 17:19, Cyrill Gorcunov wrote:
> On Wed, Aug 21, 2013 at 05:03:13PM +0100, Jan Beulich wrote:
>>>
>>> Only to non-present ptes, as far as I know.
>>
>> That's not really any guarantee. And the accessor functions also
>> don't check that they'd be used on non-present PTEs only.
> 
> Wait. This _PAGE_SWP_SOFT_DIRTY bit (which is in real PSE bit) assigned
> in only one place -- in try_to_unmap_one(). The PTE get non-present then
> and consists of swap entry format. I don't see any accessor to such entry
> without testing if it's swap entry or pte-none. What I'm missing?
> 
>>> orig_pte has pse bit set if page has been soft dirty
>>> when it reached swap.
>>
>> "when it reached swap" to me again implies that it could come
>> from a live page table, with the present bit set. So that
>> explanation attempt of yours confuses me more than it
>> clarifies things for me. (And referring to this bit as PSE bit is
> 
> When page swapped out it become non-present in pte entry.
> 
>> sort of wrong here too - there's no PSE bit for 4k PTEs, that
>> bit is the PAT one, and that's what the whole discussion
>> started from.)
> 
> And I asked David to point me how it happens, because I don't
> understand at which point pse bit get analized when page is
> not present.

As Jan said, we're concerned that the bit was being used on present PTEs
and not just non-present ones.  From a more careful look at this code
this does not appear to be the case.

However, I do find the use of PTE bits in this way somewhat fragile.
What other potential corner cases might still remain that will require
further games with PTE bits?

FWIW, Xen uses a separate dirty log to track which pages have become
dirty since the log was last cleared.  Such a dirty log seems more
efficient than having scan all the PTEs looking for the soft dirty bits
and then having to scan them all again to clear them (particularly if
you need multiple passes because the task is still running and
continuing to dirty pages).

David
