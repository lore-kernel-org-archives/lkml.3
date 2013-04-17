Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965369Ab3DQRL7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 13:11:59 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35118 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965321Ab3DQRL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 13:11:58 -0400
Date: Wed, 17 Apr 2013 13:11:56 -0400 (EDT)
Message-Id: <20130417.131156.13653463501819067.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: tomi.valkeinen@ti.com, linux-kernel@vger.kernel.org, clemens@ladisch.de,
        arnd@arndb.de, tiwai@suse.de, mchehab@redhat.com, ralf@linux-mips.org
Subject: Re: Device driver memory 'mmap()' function helper cleanup
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+55aFwt82h7hk1YiCeoG2-GGpgLvyW8t_hZRHxyhDQw=_Luzw@mail.gmail.com>
References: <CA+55aFyK2EEPuBPrqu3AGRbW+8TdP=kLLz4opvynNRcrSWC2ww@mail.gmail.com>
	<516E88A9.9070200@ti.com>
	<CA+55aFwt82h7hk1YiCeoG2-GGpgLvyW8t_hZRHxyhDQw=_Luzw@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Wed, 17 Apr 2013 10:11:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 17 Apr 2013 07:44:33 -0700

> (*) io_remap_pfn_page() is the "extended" version that takes care of
> some special magical details on a couple of odd architectures, notably
> sparc (but also one special case of MIPS PAE that have some magic bit
> tricks). But even for MIPS and Sparc, it ends up devolving to be the
> same as the "regular" remap_pfn_page() for normal memory. I'm adding
> David and Ralf to the cc just to verify that I read it right, but
> everybody else just defines "io_remap_pfn_range" to be
> "remap_pfn_range".

Yeah, the only thing special we do on sparc is interpret the PFN
specially.  We munge it into the real physical address and then
pass it all down to remap_pfn_range() to do the real work.

We used to have a crazy special version of this entire routine
on sparc64 that tried to create huge TLB mappings, but that got
killed quite some time ago:

commit 3e37fd3153ac95088a74f5e7c569f7567e9f993a
Author: David S. Miller <davem@davemloft.net>
Date:   Thu Nov 17 18:17:59 2011 -0800

    sparc: Kill custom io_remap_pfn_range().
    
    To handle the large physical addresses, just make a simple wrapper
    around remap_pfn_range() like MIPS does.
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

