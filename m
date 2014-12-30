Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbaL3IlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 03:41:00 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:45703 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbaL3Ik7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 03:40:59 -0500
X-Greylist: delayed 506 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Dec 2014 03:40:59 EST
Date: Tue, 30 Dec 2014 09:32:30 +0100
From: Andreas Mohr <andi@lisas.de>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-mm@kvack.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] kstrdup optimization
Message-ID: <20141230083230.GA17639@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54A25135.5030103@samsung.com>
X-Priority: none
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Andrzej Hajda wrote:
> On 12/30/2014 07:45 AM, Andi Kleen wrote:
> > What happens if someone is to kfree() these strings?
> >
> > -Andi
> >
> kstrdup_const must be accompanied by kfree_const, I did not mention it
> in cover letter
> but it is described in the 1st patch commit message.
> Simpler alternative (but I am not sure if better) would be to add
> similar check
> (ie. if pointer is in .rodata) to kfree itself.

Seems like a large potential programmer-side (a)symmetry issue to me
(not unsimilar to the new/delete vs. malloc/free asymmetry PITA
encountered in case of "dirty C++ habits").

This symmetry issue probably could be cleanly avoided only
by having kfree() itself contain such an identifying check, as you suggest
(thereby slowing down kfree() performance).
(OTOH we do have nice helpers such as Coccinelle
to near-sufficiently deal with such issues,
albeit in a less preferrable/elegant/automatic manner).

If we decide to want to avoid this rats nest via clean builtin identification
but in case such a kfree-side .rodata check is unjustifiably expensive,
one could try to have *builtin* (i.e., fully or at least almost *non*-runtime)
branching of their differing handling,
by marking _const-originated "allocations" via a special easily checkable flag -
but since in such kalloc/kfree API cases
we're dealing with simple raw pointer results
rather than more complex structs,
such identification markup probably could only be achieved
via internal mapping overhead (of management structs) -
unless those APIs happen to have internal bookkeeping already
(in which case the only penalty would either be setting/evaluating a flag
of common shared bookkeeping structs,
or full/clean branching into distinctly handled management parts,
which might be able to cause less runtime overhead).

Andreas Mohr

-- 
GNU/Linux. It's not the software that's free, it's you.
