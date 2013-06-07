Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab3FGXpw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 19:45:52 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:59727 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746Ab3FGXpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 19:45:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tony Luck <tony.luck@gmail.com>
Cc: Aaron Lu <aaron.lu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: acpi_sba_ioc_driver breakage (was: Re: [GIT PULL] Power management and ACPI fixes for v3.10-rc5)
Date: Sat, 08 Jun 2013 01:54:56 +0200
Message-ID: <1951427.655ut1iKp4@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CA+8MBbJC9hKCjcZVK1tvpjr9DAwY_wAPmarqCWa7X-cq7Bph0A@mail.gmail.com>
References: <3863425.93Oeg2bhJF@vostro.rjw.lan> <CA+8MBb+NAHvTCc-NMz4+HqkDc=VUWJ8gDz7ji=HtFiDbcpWo4Q@mail.gmail.com> <CA+8MBbJC9hKCjcZVK1tvpjr9DAwY_wAPmarqCWa7X-cq7Bph0A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 07, 2013 04:02:11 PM Tony Luck wrote:
> On Fri, Jun 7, 2013 at 3:23 PM, Tony Luck <tony.luck@gmail.com> wrote:
> > So please don't pull.
> 
> Bother. I see I was a few hours late finding this, and commit 9f29ab11ddb
> is already in Linus' tree.
> 
> That's what happens when I get busy and skip a couple of days testing
> linux-next :-(
> 
> So my problem comes from
> arch/ia64/hp/common/sba_iommu.c
> 
> where the code in sba_init() says:
> 
>         acpi_bus_register_driver(&acpi_sba_ioc_driver);
>         if (!ioc_list) {
> 
> but because of this change we never managed to call ioc_init()
> so ioc_list doesn't get set up, and we die.
> Before this commit, the call chain looked like this:
> 
>  [<a0000001011c3710>] ioc_init+0x40/0xd00
>  [<a0000001011c4560>] acpi_sba_ioc_add+0x190/0x1c0
>  [<a0000001005b3b40>] acpi_device_probe+0xa0/0x280
>  [<a000000100850060>] really_probe+0xe0/0x520
>  [<a0000001008504d0>] driver_probe_device+0x30/0x60
>  [<a000000100850610>] __driver_attach+0x110/0x160
>  [<a00000010084c550>] bus_for_each_dev+0x110/0x180
>  [<a00000010084fcc0>] driver_attach+0x40/0x60
>  [<a00000010084da90>] bus_add_driver+0x230/0x580
>  [<a000000100851090>] driver_register+0xf0/0x400
>  [<a0000001005b8670>] acpi_bus_register_driver+0x50/0x80
>  [<a0000001011c45c0>] sba_init+0x30/0x2d0
> 
> Is my problem that this driver has (or attaches) a "scan handler"
> where it shouldn't ... and I just need to stop it doing that?

The driver doesn't, but the device it attempts to bind to does.
It looks like that device object has multiple device IDs and one of them
matches one of the existing ACPI scan handlers, but I need a confirmation.

Can you please send me the output of

$ find /sys/devices/LNXSYSTM\:00/ -name modalias -print -exec cat {} \;

from the affected system?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
