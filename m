Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965875Ab3DQR1H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 13:27:07 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35318 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965493Ab3DQR1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 13:27:04 -0400
Date: Wed, 17 Apr 2013 13:27:02 -0400 (EDT)
Message-Id: <20130417.132702.1585825670796781999.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: tomi.valkeinen@ti.com, linux-kernel@vger.kernel.org, clemens@ladisch.de,
        arnd@arndb.de, tiwai@suse.de, mchehab@redhat.com, ralf@linux-mips.org
Subject: Re: Device driver memory 'mmap()' function helper cleanup
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+55aFw2f3cnJOSr2Xz78sRACk1k6xLog-3HpqtCsgNtA4=Fdw@mail.gmail.com>
References: <CA+55aFwt82h7hk1YiCeoG2-GGpgLvyW8t_hZRHxyhDQw=_Luzw@mail.gmail.com>
	<20130417.131156.13653463501819067.davem@davemloft.net>
	<CA+55aFw2f3cnJOSr2Xz78sRACk1k6xLog-3HpqtCsgNtA4=Fdw@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Wed, 17 Apr 2013 10:27:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 17 Apr 2013 10:20:43 -0700

> On Wed, Apr 17, 2013 at 10:11 AM, David Miller <davem@davemloft.net> wrote:
>>
>> Yeah, the only thing special we do on sparc is interpret the PFN
>> specially.  We munge it into the real physical address and then
>> pass it all down to remap_pfn_range() to do the real work.
> 
> So the main thing I want to check is that *if* it's given a regular
> RAM physical address, it still works?
> 
> Some drivers basically allocate DMA memory and then pass on the
> resulting physical address to this. Others pass in the PCI BAR
> addresses etc. And some try to use "remap_pfn_range()", and others try
> to use "io_remap_pfn_range()", and quite frankly, from what I can tell
> we can just always use the "io_" version because it ends up being a
> proper superset.
> 
> I'm pretty sure it works fine the way I read it, but I'm just verifying..

All we do is take the top 4 bits and shift them down into the
resulting physical address.

For normal RAM these bits will be clear, so it should all work out.

Passing PCI BARs into these routines is illegal, we have proper
abstractions for mmap()'ing PCI resources via pci_mmap_page_range()
et al.

So, any code doing that needs to be fixed.
