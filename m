Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab3LMVAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 16:00:21 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:36251 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751872Ab3LMVAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 16:00:20 -0500
X-Sasl-enc: wVEj5fndSIlMGVyWiKG0J3a3ttzzAjA2gSaUceaoBoPC 1386968418
Date: Fri, 13 Dec 2013 19:00:15 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86, microcode: Add option to allow downgrading of
 microcode
Message-ID: <20131213210015.GA26925@khazad-dum.debian.net>
References: <1386363843-32530-1-git-send-email-andi@firstfloor.org>
 <1386363843-32530-2-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386363843-32530-2-git-send-email-andi@firstfloor.org>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Dec 2013, Andi Kleen wrote:
> For testing purposes it can be useful to downgrade microcode.
> Normally the driver only allows upgrading.

...

>  int
>  update_match_revision(struct microcode_header_intel *mc_header, int rev)
>  {
> +	if (allow_downgrade)
> +		return 1;
>  	return ((int)mc_header->rev <= rev) ? 0 : 1;
>  }

Two points maybe worth some thinking about:

1. We might want to forbid downgrading to version 0 of a microcode.  Version
zero is supposed to mean "running factory-provided microcode" and there is
absolutely no way an attempt to downgrade to version 0 is not an attack of
some sort.

And we know for a fact that is a very unwise idea to let strange microcode
get past the kernel driver and into the microcode update microcode itself.

2. This change has unintended side-effects that ought to be at least
documented:

In "allow downgrade" mode, should you send a microcode pack with several
microcodes to the kernel, and more than one of them might apply to the
running processor (when the pf_flags of two or more of the microcodes are
not disjoint), either the first or the last (I didn't check) will be the
one chosen.

I've seen in the wild microcodes where both rev X and Y (when Y > X) could
be applied to a specific processor, but rev X was intended to more
processors (more bits set in pf_mask) than rev. Y.  I don't think they were
in the same Intel microcode update datafile, but it can happen.  In normal
upgrade-only mode this works correctly, while in your proposed downgrade
mode, it won't.

The upgrade/downgrade rules for negative release microcodes are different,
it might be a good idea to ask someone at Intel to clarify these rules
(including whether release X or Y should be installed when X < Y < 0).  So
far, I've only heard of negative release numbers in the microcodes shipped
inside the BIOS/EFI images of some server boards and embedded products, and
I was told they're reserved for "internal Intel development microcode" or
something like that.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
