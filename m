Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405Ab3FGXCP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 19:02:15 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:41061 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab3FGXCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 19:02:12 -0400
MIME-Version: 1.0
In-Reply-To: <CA+8MBb+NAHvTCc-NMz4+HqkDc=VUWJ8gDz7ji=HtFiDbcpWo4Q@mail.gmail.com>
References: <3863425.93Oeg2bhJF@vostro.rjw.lan>
	<CA+8MBb+NAHvTCc-NMz4+HqkDc=VUWJ8gDz7ji=HtFiDbcpWo4Q@mail.gmail.com>
Date: Fri, 7 Jun 2013 16:02:11 -0700
Message-ID: <CA+8MBbJC9hKCjcZVK1tvpjr9DAwY_wAPmarqCWa7X-cq7Bph0A@mail.gmail.com>
Subject: Re: [GIT PULL] Power management and ACPI fixes for v3.10-rc5
From: Tony Luck <tony.luck@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Aaron Lu <aaron.lu@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 7, 2013 at 3:23 PM, Tony Luck <tony.luck@gmail.com> wrote:
> So please don't pull.

Bother. I see I was a few hours late finding this, and commit 9f29ab11ddb
is already in Linus' tree.

That's what happens when I get busy and skip a couple of days testing
linux-next :-(

So my problem comes from
arch/ia64/hp/common/sba_iommu.c

where the code in sba_init() says:

        acpi_bus_register_driver(&acpi_sba_ioc_driver);
        if (!ioc_list) {

but because of this change we never managed to call ioc_init()
so ioc_list doesn't get set up, and we die.
Before this commit, the call chain looked like this:

 [<a0000001011c3710>] ioc_init+0x40/0xd00
 [<a0000001011c4560>] acpi_sba_ioc_add+0x190/0x1c0
 [<a0000001005b3b40>] acpi_device_probe+0xa0/0x280
 [<a000000100850060>] really_probe+0xe0/0x520
 [<a0000001008504d0>] driver_probe_device+0x30/0x60
 [<a000000100850610>] __driver_attach+0x110/0x160
 [<a00000010084c550>] bus_for_each_dev+0x110/0x180
 [<a00000010084fcc0>] driver_attach+0x40/0x60
 [<a00000010084da90>] bus_add_driver+0x230/0x580
 [<a000000100851090>] driver_register+0xf0/0x400
 [<a0000001005b8670>] acpi_bus_register_driver+0x50/0x80
 [<a0000001011c45c0>] sba_init+0x30/0x2d0

Is my problem that this driver has (or attaches) a "scan handler"
where it shouldn't ... and I just need to stop it doing that?

-Tony
