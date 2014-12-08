Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597AbaLHPCo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 10:02:44 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:54637 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbaLHPCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 10:02:43 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Hante Meuleman <meuleman@broadcom.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list <brcm80211-dev-list@broadcom.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arend Van Spriel <arend@broadcom.com>,
        David Miller <davem@davemloft.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>, hauke@hauke-m.de
Subject: Re: using DMA-API on ARM
Date: Mon, 08 Dec 2014 16:01:32 +0100
Message-ID: <2863746.4sUSEYqahB@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <F51492713EF10846800D8C0ED37A7DCE01902076@SJEXCHMB15.corp.ad.broadcom.com>
References: <5481794E.4050406@broadcom.com> <F51492713EF10846800D8C0ED37A7DCE01901765@SJEXCHMB15.corp.ad.broadcom.com> <F51492713EF10846800D8C0ED37A7DCE01902076@SJEXCHMB15.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:MCGCFx0ZCA1W6iRrcpjj9kK7ZTa/y7wiQMv9ARhqnpwle0DJK8H
 E2Yn5u8QCLq4P9IYpq72xcYVGoP64bFw7jMN2IjK/Z7s+ALEKuArF2OTTXO6Wk0wyHCZSwE
 lB73ZIk9t01/B86ER/2VpZWBsqkbiKhJouQC3KUQ9LjY6ouxDKpe7fPZPIuN97nXn3uBIo6
 1uHjcZl8n6JLpRBOgubkw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 December 2014 13:47:38 Hante Meuleman wrote:
> Still using outlook, but will limit the line length, I hope that works for the
> moment. Attached is a log with the requested information, it is a little
> bit non-standard though. The dump code from the mm was copied in
> the driver and called from there, mapping the prints back to our local
> printf, but it should produce the same. I did this because I didn't realize
> the table is static.
> 
> Some background on the test setup: I'm using a Broadcom reference 
> design AP platform with an BRCM 4708 host SOC.

I think you are using the wrong dtb file, the log says this is
a "Buffalo WZR-1750DHP", not the reference design.

> For the AP router 
> platform the opensource packet OpenWRT was used. Some small
> modifications were made to get it to work on our HW. Only one core
> is enabled for the moment (no time to figure out how to enable the
> other one). Openwrt was configured to use kernel 3.18-rc2 and 
> the brcmfmac of the compat-wireless code was updated with our 
> latest code (minor patches, which have been submitted already). 
> The device used is 43602 pcie device. Some modifications to the build
> system were made to enable PCIE. The test is to connect with a 
> client to the AP and run iperf (TCP). The test can run for many hours
> without a problem, but sometimes fails very quickly.

The bcm4708 platform is maintained by Hauke Mehrtens, adding him to Cc.

In your log, I see this message:

[    0.000000] PL310 OF: cache setting yield illegal associativity
[    0.000000] PL310 OF: -1069781724 calculated, only 8 and 16 legal
[    0.000000] L2C-310 enabling early BRESP for Cortex-A9
[    0.000000] L2C-310 full line of zeros enabled for Cortex-A9
[    0.000000] L2C-310 dynamic clock gating enabled, standby mode enabled
[    0.000000] L2C-310 cache controller enabled, 16 ways, 256 kB
[    0.000000] L2C-310: CACHE_ID 0x410000c8, AUX_CTRL 0x4e130001

Evidently the cache controller information in DT is incorrect and
the setup may be wrong as a consequence, which may explain cache
coherency problems.

Can you verify that the AUX_CTRL value is the same one you see
in a working kernel?

> The log: first the ring allocation info is printed. Starting at
> 16.124847, ring 2, 3 and 4 are rings used for device to host. In this
> log the failure is on a read of ring 3. Ring 3 is 1024 entries of each
> 16 bytes. The next thing printed is the kernel page tables. Then some 
> OpenWRT info and the logging of part of the connection setup. Then at 
> 1780.130752 the logging of the failure starts. The sequence number is 
> modulo 253 with ring size of 1024 matches an "old" entry (read 40, 
> expected 52). Then the different pointers are printed followed by 
> the kernel page table. The code does then a cache invalidate on the 
> dma_handle and the next read the sequence number is correct.

How do you invalidate the cache? A dma_handle is of type dma_addr_t
and we don't define an operation for that, nor does it make sense
on an allocation from dma_alloc_coherent(). What happens if you
take out the invalidate?

Can you post the patch that you use (both platform and driver) relative
to the snapshot of the the mainline kernel you are basing on?

	Arnd

