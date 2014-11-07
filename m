Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbaKGSkP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 13:40:15 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:38701 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752490AbaKGSkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 13:40:12 -0500
X-Sasl-enc: kFZeywjB4/PETv1gcEIip9qbZltrAO/Hjrfum8NUb58m 1415385611
Date: Fri, 7 Nov 2014 16:40:00 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 6/8] x86, microcode, intel: use cpuid explicitly instead
 of sync_core
Message-ID: <20141107184000.GB18128@khazad-dum.debian.net>
References: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
 <1410197875-19252-7-git-send-email-hmh@hmh.eng.br>
 <20141107175645.GC5180@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107175645.GC5180@pd.tnic>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Nov 2014, Borislav Petkov wrote:
> On Mon, Sep 08, 2014 at 02:37:52PM -0300, Henrique de Moraes Holschuh wrote:
> > The protocol to safely read MSR 8BH, described in the Intel SDM vol 3A,
> > section 9.11.7.1, explicitly determines that cpuid with EAX=1 must be
> > used between the wrmsr(0x8B, 0); and the rdmsr(0x8B).
> > 
> > The microcode driver was abusing sync_core() to do this, probably
> > because it predates by nearly a decade the current "asm volatile
> > (:::"memory")" implementation of native_cpuid(), which is required for
> > the Intel MSR 8BH access protocol.
> 
> Huh, what? Have you taken a look at sync_core() first?

Yes, I did.

> > sync_core() semanthics are that of being a speculative execution
> > barrier, and not "run cpuid with EAX=1".
> 
> Again, what?

sync_core() is a speculative execution barrier.  That's what it is
documented to do.  That's the reason _every_ caller other than the microcode
drivers call it.

In i486, sync_core() does a jmp.

In i586 and above, and x86-64, sync_core() does a cpuid(1).

sync_core() doesn't expect that its callers really want a cpuid(1).  If we
ever get a reason to use some other way to insert a speculative execution
barrier, sync_core() is likely to switch to it.

> What is the problem again?

No real problem, other than the fact that the microcode drivers call
sync_core() for what might as well be considered an internal implementation
detail of sync_core().

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
