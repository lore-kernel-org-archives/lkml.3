Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab3LOAkV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 19:40:21 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:43065 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754178Ab3LOAkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 19:40:20 -0500
X-Sasl-enc: r2T4h+9R4UY5lf7+oma4GBW15eTyp9GlwCcUG4Ae0Z4F 1387068018
Date: Sat, 14 Dec 2013 22:40:16 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86, microcode: Add option to allow downgrading of
 microcode
Message-ID: <20131215004016.GB3049@khazad-dum.debian.net>
References: <1386363843-32530-1-git-send-email-andi@firstfloor.org>
 <1386363843-32530-2-git-send-email-andi@firstfloor.org>
 <20131213210015.GA26925@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131213210015.GA26925@khazad-dum.debian.net>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Dec 2013, Henrique de Moraes Holschuh wrote:
> 2. This change has unintended side-effects that ought to be at least
> documented:
> 
> In "allow downgrade" mode, should you send a microcode pack with several
> microcodes to the kernel, and more than one of them might apply to the
> running processor (when the pf_flags of two or more of the microcodes are
> not disjoint), either the first or the last (I didn't check) will be the
> one chosen.
> 
> I've seen in the wild microcodes where both rev X and Y (when Y > X) could
> be applied to a specific processor, but rev X was intended to more
> processors (more bits set in pf_mask) than rev. Y.  I don't think they were
> in the same Intel microcode update datafile, but it can happen.  In normal
> upgrade-only mode this works correctly, while in your proposed downgrade
> mode, it won't.

Well, tracked it down to:

/lib/firmware/intel-ucode/0f-04-0a
  001: sig 0x00000f4a, pf mask 0x5c, 2005-12-14, rev 0x0004, size 2048
  002: sig 0x00000f4a, pf mask 0x5d, 2005-06-10, rev 0x0002, size 2048

/lib/firmware/intel-ucode/0f-04-08
  001: sig 0x00000f48, pf mask 0x5f, 2005-06-30, rev 0x0007, size 3072
  002: sig 0x00000f48, pf mask 0x01, 2006-05-08, rev 0x000c, size 3072
  003: sig 0x00000f48, pf mask 0x02, 2008-01-15, rev 0x000e, size 3072

And these are microcodes still being distributed in the latest Intel
microcode bundle (2013-09-06).  They're for old processors, but still...  if
it happened once and it is still being distributed like that, it can happen
again.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
