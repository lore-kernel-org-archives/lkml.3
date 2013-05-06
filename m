Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758464Ab3EFUxe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 16:53:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52140 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932066Ab3EFUxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 16:53:32 -0400
Date: Mon, 6 May 2013 21:53:30 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Matt Turner <mattst88@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH] alpha: spinlock: don't perform memory access in locked
 critical section
Message-ID: <20130506205329.GO25399@ZenIV.linux.org.uk>
References: <1367870465-23948-1-git-send-email-will.deacon@arm.com>
 <CAEdQ38HnWbUB=ZNCZeYz8GZH3U4bv_Uag8WL2zT0D=GMcoT+2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEdQ38HnWbUB=ZNCZeYz8GZH3U4bv_Uag8WL2zT0D=GMcoT+2A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 01:19:51PM -0700, Matt Turner wrote:

> I'm not sure of the interpretation that LDA counts as a memory access.
> 
> The manual says it's Ra <- Rbv + SEXT(disp).
> 
> It's not touching memory that I can see.

More to the point, the same manual gives explicit list of instructions
that shouldn't occur between LDx_L and STx_C, and LDA does not belong to any
of those.  I suspect that Will has misparsed the notations in there - LDx is
present in the list, but it's _not_ "all instructions with mnemonics starting
with LD", just the 4 "load integer from memory" ones.  FWIW, instructions
with that encoding (x01xxx<a:5><b:5><offs:16>) are grouped so:
	LDAx - LDA, LDAH; load address
	LDx -  LDL, LDQ, LDBU, LDWU; load memory data into integer register
	LDQ_U; load unaligned
	LDx_L - LDL_L, LDQ_L; load locked
	STx_C - STL_C, STQ_C; store conditional
	STx - STL, STQ, STB, STW; store
	STQ_U; store unaligned
They all have the same encoding, naturally enough (operation/register/address
representation), but that's it...  See section 4.2 in reference manual for
details; relevant note follows discussion of LDx_L and it spells the list
out.  LDx is present, LDAx isn't (and neither is LDA by itself).
