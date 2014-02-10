Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbaBJRwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:52:55 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:53280 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751970AbaBJRwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:52:51 -0500
Date: Mon, 10 Feb 2014 17:52:46 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Madper Xie <cxie@redhat.com>
Cc: Matt Fleming <matt.fleming@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Adam Williamson <awilliam@redhat.com>
Subject: Re: [BUG] can't boot up: unable to handle kernel paging request at
 ffffffffff340003
Message-ID: <20140210175246.GB2887@console-pimps.org>
References: <8738jr5t3e.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8738jr5t3e.fsf@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Feb, at 03:23:33PM, Madper Xie wrote:
> Howdy,
> 
> With old kernel (from 3.10 to 3.14-rc1), my hp box shows following
> outputs:
> ~~~
> [    0.009166] Freeing SMP alternatives memory: 20K (ffffffff82234000 - ffffffff82239000)
> [    0.010302] ioremap: invalid physical address 1376e01800000001
> [    0.010303] ------------[ cut here ]------------
> [    0.010308] WARNING: CPU: 0 PID: 0 at arch/x86/mm/ioremap.c:83 __ioremap_caller+0x357/0x380()

OK, this looks like a bogus BGRT address, that's a 64-bit physical
address. I suspect the BGRT address is actually 0x1376e018, but that's
just a guess. This looks like a BIOS bug.

> ~~~
> However the box can boot up and works well.
> After I update kernel to 3.14-rc2, it panic when booting. Here is
> console output:
> ~~~
> [    0.010366] BUG: unable to handle kernel paging request at ffffffffff340003
> [    0.017376] IP: [<ffffffff81d85ba4>] efi_bgrt_init+0x9d/0x133
> [    0.023153] PGD 159eb067 PUD 159ed067 PMD 16240067 PTE 9376e01800000163
> [    0.029842] Oops: 0009 [#1] SMP 

Well, nuts. I think this is my bad. Does reverting commit 081cd62a010f
("x86/efi: Allow mapping BGRT on x86-32") make things work? Or at least,
work as well as they did prior to -rc2?

I wonder if we're calling early_memremap() when the fixmap slots are no
longer valid. Could you try building the 'urgent' branch at,

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git

-- 
Matt Fleming, Intel Open Source Technology Center
