Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab3CTVDx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 17:03:53 -0400
Received: from canardo.mork.no ([148.122.252.1]:47018 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242Ab3CTVDw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 17:03:52 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Shawn Starr <shawn.starr@rogers.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Intel][RNG] PCI IDs commented out for 82801I (ICH9 Mobile and non-mobile)?
Organization: m
References: <1597390.RUFC41Uyje@segfault.sh0n.net>
Date: Wed, 20 Mar 2013 22:03:46 +0100
In-Reply-To: <1597390.RUFC41Uyje@segfault.sh0n.net> (Shawn Starr's message of
	"Wed, 20 Mar 2013 16:42:22 -0400")
Message-ID: <8738vppyvh.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shawn Starr <shawn.starr@rogers.com> writes:

> Hello folks,
>
> I was looking at why I can't load the Intel RNG driver (or why it doesn't load automatically) and 
> it just so happens I have both the mobile and non-mobile ICH9 chipset. Looking at the driver I noticed:
>
>  /* BAM, CAM, DBM, FBM, GxM
>        { PCI_DEVICE(0x8086, 0x2448) }, */
>  
>  /* BA, CA, DB, Ex, 6300, Fx, 631x/632x, Gx
>        { PCI_DEVICE(0x8086, 0x244e) }, */
>
> IDs from both machines:
>  
> 00:1e.0 PCI bridge [0604]: Intel Corporation 82801 Mobile PCI Bridge [8086:2448] (rev 93)
> 00:1e.0 PCI bridge [0604]: Intel Corporation 82801 PCI Bridge [8086:244e] (rev 92)
>  
> I saw a thread from 2006 explaining the 50% chance there's no RNG (but these days all modern chipsets should have an RNG) and I know 
> this chipset I have does have an RNG so I'd like to use the HW random generator vs software.
>
> Do we need to revisit this? Even if I try to force it to load it still fails:
>
> # modprobe intel_rng no_fwh_detect=-1 or =1 
> modprobe: ERROR: could not insert 'intel_rng': No such device

The module verifies that you have one of the PCI devices in that table,
so you need to modify it to get the driver to load:

static int __init mod_init(void)
{
        int err = -ENODEV;
        int i;
        struct pci_dev *dev = NULL;
        void __iomem *mem = mem;
        u8 hw_status;
        struct intel_rng_hw *intel_rng_hw;

        for (i = 0; !dev && pci_tbl[i].vendor; ++i)
                dev = pci_get_device(pci_tbl[i].vendor, pci_tbl[i].device,
                                     NULL);

        if (!dev)
                goto out; /* Device not found. */



Bjørn
