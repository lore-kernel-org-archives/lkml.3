Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbaLHQWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 11:22:50 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:13263 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbaLHQWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 11:22:49 -0500
X-IronPort-AV: E=Sophos;i="5.07,539,1413270000"; 
   d="dts'?dtsi'?bz2'66?scan'66,208,49,66";a="52694296"
Message-ID: <5485D054.7090109@broadcom.com>
Date: Mon, 8 Dec 2014 17:22:44 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>,
        Hante Meuleman <meuleman@broadcom.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list <brcm80211-dev-list@broadcom.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>, <hauke@hauke-m.de>
Subject: Re: using DMA-API on ARM
References: <5481794E.4050406@broadcom.com> <F51492713EF10846800D8C0ED37A7DCE01901765@SJEXCHMB15.corp.ad.broadcom.com> <F51492713EF10846800D8C0ED37A7DCE01902076@SJEXCHMB15.corp.ad.broadcom.com> <2863746.4sUSEYqahB@wuerfel>
In-Reply-To: <2863746.4sUSEYqahB@wuerfel>
Content-Type: multipart/mixed;
	boundary="------------050708010200090209040603"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------050708010200090209040603
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

On 12/08/14 16:01, Arnd Bergmann wrote:
> On Monday 08 December 2014 13:47:38 Hante Meuleman wrote:
>> Still using outlook, but will limit the line length, I hope that works for the
>> moment. Attached is a log with the requested information, it is a little
>> bit non-standard though. The dump code from the mm was copied in
>> the driver and called from there, mapping the prints back to our local
>> printf, but it should produce the same. I did this because I didn't realize
>> the table is static.
>>
>> Some background on the test setup: I'm using a Broadcom reference
>> design AP platform with an BRCM 4708 host SOC.
>
> I think you are using the wrong dtb file, the log says this is
> a "Buffalo WZR-1750DHP", not the reference design.

That router is close enough to the reference design.

>> For the AP router
>> platform the opensource packet OpenWRT was used. Some small
>> modifications were made to get it to work on our HW. Only one core
>> is enabled for the moment (no time to figure out how to enable the
>> other one). Openwrt was configured to use kernel 3.18-rc2 and
>> the brcmfmac of the compat-wireless code was updated with our
>> latest code (minor patches, which have been submitted already).
>> The device used is 43602 pcie device. Some modifications to the build
>> system were made to enable PCIE. The test is to connect with a
>> client to the AP and run iperf (TCP). The test can run for many hours
>> without a problem, but sometimes fails very quickly.
>
> The bcm4708 platform is maintained by Hauke Mehrtens, adding him to Cc.

Thanks. While going through the DTS files I intended to add him as well ;-)

> In your log, I see this message:
>
> [    0.000000] PL310 OF: cache setting yield illegal associativity
> [    0.000000] PL310 OF: -1069781724 calculated, only 8 and 16 legal
> [    0.000000] L2C-310 enabling early BRESP for Cortex-A9
> [    0.000000] L2C-310 full line of zeros enabled for Cortex-A9
> [    0.000000] L2C-310 dynamic clock gating enabled, standby mode enabled
> [    0.000000] L2C-310 cache controller enabled, 16 ways, 256 kB
> [    0.000000] L2C-310: CACHE_ID 0x410000c8, AUX_CTRL 0x4e130001
>
> Evidently the cache controller information in DT is incorrect and
> the setup may be wrong as a consequence, which may explain cache
> coherency problems.

While staring at the DTS files I suspect there are some parts still 
missing. I have attached them for reference. Catalin pointed us to a 
patch in the l2 cache [1]. We have not tried that yet.

> Can you verify that the AUX_CTRL value is the same one you see
> in a working kernel?
>
>> The log: first the ring allocation info is printed. Starting at
>> 16.124847, ring 2, 3 and 4 are rings used for device to host. In this
>> log the failure is on a read of ring 3. Ring 3 is 1024 entries of each
>> 16 bytes. The next thing printed is the kernel page tables. Then some
>> OpenWRT info and the logging of part of the connection setup. Then at
>> 1780.130752 the logging of the failure starts. The sequence number is
>> modulo 253 with ring size of 1024 matches an "old" entry (read 40,
>> expected 52). Then the different pointers are printed followed by
>> the kernel page table. The code does then a cache invalidate on the
>> dma_handle and the next read the sequence number is correct.
>
> How do you invalidate the cache? A dma_handle is of type dma_addr_t
> and we don't define an operation for that, nor does it make sense
> on an allocation from dma_alloc_coherent(). What happens if you
> take out the invalidate?

dma_sync_single_for_cpu(, DMA_FROM_DEVICE) which ends up invalidating 
the cache (or that is our suspicion).

> Can you post the patch that you use (both platform and driver) relative
> to the snapshot of the the mainline kernel you are basing on?
>
> 	Arnd
>

Regards,
Arend

[1] http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=6529/1

--------------050708010200090209040603
Content-Type: application/x-bzip2; name="bcm-dt-files.tar.bz2"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="bcm-dt-files.tar.bz2"

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
--------------050708010200090209040603--
