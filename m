Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470Ab3DXTXH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 15:23:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57357 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757101Ab3DXTXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 15:23:05 -0400
Subject: RE: memcpy_fromio in dmi_scan.c
From: Jean Delvare <jdelvare@suse.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: DuanZhenzhong <zhenzhong.duan@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F1EA52ED3@ORSMSX104.amr.corp.intel.com>
References: <1366636689.4503.35.camel@chaos.site>
	 <5175FF0F.9050206@oracle.com> <1366702122.4667.11.camel@chaos.site>
	 <3908561D78D1C84285E8C5FCA982C28F1EA52ED3@ORSMSX104.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Wed, 24 Apr 2013 21:22:08 +0200
Message-ID: <1366831328.4618.476.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

Thanks for stepping in.

Le Tuesday 23 April 2013 à 22:00 +0000, Luck, Tony a écrit :
> > I don't have much knowledge about IA64 either. All I see is that while
> > x86 implements memcpy_fromio() with memcpy [1], ia64 implements it with
> > readb [2]. There must be a reason for that, and I can only suppose that
> > memcpy on __iomem pointers doesn't work on IA64. If memcpy doesn't work
> > then I can't see memcmp working.
> 
> On most platforms readb() just ends up doing a regular dereference of the
> address ... so I'd expect that memcmp would work just fine.  The exception
> is the old SGI sn2 which end up calling ___sn_readb() ... which does something
> weird with sn_dma_flush() after doing the dereference of *addr.  I don't
> really understand what is going on here - but I assume that it is for real
> PCI iomapped memory, as opposed to random bits of BIOS reserved memory
> that we used ioremap() to get a virtual handle on.

Ah, OK. I tested on a HP RX8640 server and to my surprised it worked
fine. But now your explanation tells me why. Now I also tested on a
Supermicro I8QBH, and it worked. But on a SGI SN2 I get the following in
dmesg (with kernel 3.0.70, which has the suspicious code changes):

DMI not present or invalid.

> Not sure how to test ... what would I run to exercise this code?

It is executed at boot time, if it works you get something like:

SMBIOS 2.7 present.

or:

DMI present.

in dmesg. If not, you get instead:

DMI not present or invalid.

That being said, "my" SN2 machine was previously running kernel 3.0.34
which has the old dmi_scan code and it also said "DMI not present or
invalid." Plus dmidecode fails on this machine with:

/sys/firmware/efi/systab: SMBIOS entry point missing

So it might as well be that DMI support on SN2 was already broken.
Please let me know your findings on other SN2 machines.

Anyway, either memcpy_fromio is needed and the code should be fixed, or
it isn't and the code should be simplified. The current state makes
little sense.

What is strange is that the call to memcpy_fromio was added a long time
ago, long before dmi_scan was enabled on ia64.

-- 
Jean Delvare
Suse L3

