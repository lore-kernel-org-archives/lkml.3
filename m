Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbaL2Vvy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 16:51:54 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:50861 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbaL2Vvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 16:51:52 -0500
Date: Mon, 29 Dec 2014 21:57:07 +0000
From: "Carlos R. Mafra" <crmafra@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Bisected regression from 3.17 still present in 3.19-rc1
Message-ID: <20141229215707.GA2667@linux-g29b.site>
References: <20141228185409.GA2015@linux-g29b.site>
 <2053111.OpHlk1cZNM@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2053111.OpHlk1cZNM@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Dec 2014 at 22:49:37 +0100, Rafael J. Wysocki wrote:
> On Sunday, December 28, 2014 06:54:09 PM Carlos R. Mafra wrote:
> > 
> > The laptop is a 2-year-old macbook Pro with retina display.
> > 
> > I use a dockapp called wmlaptop2 (http://repo.or.cz/w/wmlaptop2.git)
> > which, among other things, displays battery information (% of charge
> > remaining etc).
> > 
> > With the kernel v3.17 the battery information stopped working and it
> > still does not work in the latest v3.19-rc1.

Correction: v3.18 is when it stopped working, not v3.17.

> > Looking at what wmlaptop2 does I noticed that one entry inside
> > /sys/class/power_supply is not present in a bad kernel.
> > 
> > In a good kernel:
> > 
> > [mafra@linux-g29b:~]$ ls /sys/class/power_supply/
> > ADP1@  BAT0@
> > 
> > but in v3.17 onwards there's no BAT0@ entry:
> > 
> > [mafra@linux-g29b:~]$ ls /sys/class/power_supply/
> > ADP1@
> > 
> > I bisected the problem to this commit:
> 
> Does it help if you revert this commit from 3.19-rc1 (or -rc2)?

Yes, I just did that now (it reverts cleanly) and reverting the
commit makes it work again.


> > commit 7bc5a2bad0b8d9d1ac9f7b8b33150e4ddf197334
> > Author: Matthew Garrett <matthew.garrett@nebula.com>
> > Date:   Sat Sep 20 13:19:47 2014 +0200
> > 
> >     ACPI: Support _OSI("Darwin") correctly
> >     
> > 
> > Is there anything else I can do to help fixing this?
> > 
> > PS: the bisect log:
> > 
> > git bisect start
> > # bad: [f114040e3ea6e07372334ade75d1ee0775c355e1] Linux 3.18-rc1
> > git bisect bad f114040e3ea6e07372334ade75d1ee0775c355e1
> > # good: [bfe01a5ba2490f299e1d2d5508cbbbadd897bbe9] Linux 3.17
> > git bisect good bfe01a5ba2490f299e1d2d5508cbbbadd897bbe9
> > # good: [35a9ad8af0bb0fa3525e6d0d20e32551d226f38e] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next
> > git bisect good 35a9ad8af0bb0fa3525e6d0d20e32551d226f38e
> > # bad: [d6dd50e07c5bec00db2005969b1a01f8ca3d25ef] Merge branch 'core-rcu-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> > git bisect bad d6dd50e07c5bec00db2005969b1a01f8ca3d25ef
> > # bad: [bf65dea87e87c53ba4f97c6432761498bc977efd] Merge tag 'edac/v3.18-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac
> > git bisect bad bf65dea87e87c53ba4f97c6432761498bc977efd
> > # bad: [b211e9d7c861bdb37b86d6384da9edfb80949ceb] Merge branch 'for-3.18' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup
> > git bisect bad b211e9d7c861bdb37b86d6384da9edfb80949ceb
> > # good: [80213c03c4151d900cf293ef0fc51f8d88495e14] Merge tag 'pci-v3.18-changes' of git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci
> > git bisect good 80213c03c4151d900cf293ef0fc51f8d88495e14
> > # good: [7f8998c7aef3ac9c5f3f2943e083dfa6302e90d0] nosave: consolidate __nosave_{begin,end} in <asm/sections.h>
> > git bisect good 7f8998c7aef3ac9c5f3f2943e083dfa6302e90d0
> > # bad: [49a09c9ab012017c4673b86dbb28c616cf8f2381] Merge branch 'pm-domains'
> > git bisect bad 49a09c9ab012017c4673b86dbb28c616cf8f2381
> > # bad: [88b42a4883a7783972c8fc607e60bd3f027e24de] Merge branch 'pm-genirq'
> > git bisect bad 88b42a4883a7783972c8fc607e60bd3f027e24de
> > # bad: [a13f453140d542f9d5a0ee15601531c72e5401d7] Merge branch 'acpi-lpss'
> > git bisect bad a13f453140d542f9d5a0ee15601531c72e5401d7
> > # bad: [939558f2a4b7851c11ce8d08387730914a1e1f5f] Merge branch 'acpi-apple'
> > git bisect bad 939558f2a4b7851c11ce8d08387730914a1e1f5f
> > # good: [5a0b8deeeb19906b24a48d0078aa6b64dc0b4dab] ACPICA: Clear all non-wakeup GPEs in acpi_hw_enable_wakeup_gpe_block()
> > git bisect good 5a0b8deeeb19906b24a48d0078aa6b64dc0b4dab
> > # bad: [7bc5a2bad0b8d9d1ac9f7b8b33150e4ddf197334] ACPI: Support _OSI("Darwin") correctly
> > git bisect bad 7bc5a2bad0b8d9d1ac9f7b8b33150e4ddf197334
> > # good: [9faf6136ff4647452580b019f4b16f8c5082e589] ACPI / SBS: Disable smart battery manager on Apple
> > git bisect good 9faf6136ff4647452580b019f4b16f8c5082e589
> > # first bad commit: [7bc5a2bad0b8d9d1ac9f7b8b33150e4ddf197334] ACPI: Support _OSI("Darwin") correctly
> > [mafra@linux-g29b:linux-2.6]$
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> -- 
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
