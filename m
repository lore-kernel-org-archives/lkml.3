Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935704Ab3DPTfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 15:35:45 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:53514 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935301Ab3DPTfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 15:35:44 -0400
MIME-Version: 1.0
In-Reply-To: <2c9001ce3429$e5989a50$b0c9cef0$%kim@samsung.com>
References: <1364890840-20052-1-git-send-email-tushar.behera@linaro.org>
	<20130404213331.8665.7028@quantum>
	<2c9001ce3429$e5989a50$b0c9cef0$%kim@samsung.com>
Date: Tue, 16 Apr 2013 12:35:40 -0700
X-Google-Sender-Auth: _28VCbrVnwCIlJMT5HJ_o-jzwbA
Message-ID: <CAD=FV=UUg9Apb0o+zLdidDUmkLZt1phgo80bxug=o6JmANCPfw@mail.gmail.com>
Subject: Re: [PATCH] clk: exynos5250: Fix divider values for sclk_mmc{0,1,2,3}
From: Doug Anderson <dianders@chromium.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Tushar Behera <tushar.behera@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Patch Tracking <patches@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Olof Johansson <olofj@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Apr 8, 2013 at 12:22 AM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> Mike Turquette wrote:
>>
>> Quoting Tushar Behera (2013-04-02 01:20:40)
>> > In legacy setup, sclk_mmc{0,1,2,3} used PRE_RATIO bit-field (8-bit wide)
>> > instead of RATIO bit-field (4-bit wide) for dividing clock rate.
>> >
>> > With current common clock setup, we are using RATIO bit-field which
>> > is creating FIFO read errors while accessing eMMC. Changing over to
>> > use PRE_RATIO bit-field fixes this issue.
>> >
>> > dwmmc_exynos 12200000.dwmmc0: data FIFO error (status=00008020)
>> > mmcblk0: error -5 transferring data, sector 1, nr 7, cmd response 0x900,
>> card status 0x0
>> > end_request: I/O error, dev mmcblk0, sector 1
>> >
>> > Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
>> > CC: Thomas Abraham <thomas.abraham@linaro.org>
>>
>> I guess this will be applied through the samsung tree, so:
>>
>> Acked-by: Mike Turquette <mturquette@linaro.org>
>>
> Thanks, applied.

I haven't yet had time to dig / track down why, but this patch totally
messes up access to the eMMC on the ARM Chromebook (exynos5250-snow).
I suddenly start getting FIFO errors like you show above.  When I
revert your change then I'm all happy.

Perhaps I need a device tree setting change as well?  I always forget
how the "samsung,dw-mshc-ciu-div" / "samsung,dw-mshc-sdr-timing"
properties work...

For the short term I'm going to revert locally since I've got a few
other things to do over the next few days.  If nobody else gets around
to it then I'll try to find time to dig further.

---

Log messages at boot before your change applied:

localhost ~ # dmesg | grep mmc[a-z]*0
[    1.460000] dwmmc_exynos 12200000.dwmmc0: Using internal DMA controller.
[    1.465000] dwmmc_exynos 12200000.dwmmc0: Version ID is 241a
[    1.475000] dwmmc_exynos 12200000.dwmmc0: DW MMC controller at irq
107, 32 bit host data width, 128 deep fifo
[    1.485000] mmc0: no vmmc regulator found
[    1.510000] mmc_host mmc0: Bus speed (slot 0) = 100000000Hz (slot
req 400000Hz, actual 400000HZ div = 125)
[    1.530000] dwmmc_exynos 12200000.dwmmc0: 1 slots initialized
[    1.750000] mmc0: BKOPS_EN bit is not set
[    1.750000] mmc_host mmc0: Bus speed (slot 0) = 100000000Hz (slot
req 52000000Hz, actual 50000000HZ div = 1)
[    1.755000] mmc0: new high speed DDR MMC card at address 0001
[    1.755000] mmcblk0: mmc0:0001 SEM16G 14.6 GiB
[    1.780000] mmcblk0boot0: mmc0:0001 SEM16G partition 1 2.00 MiB
[    1.785000] mmcblk0boot1: mmc0:0001 SEM16G partition 2 2.00 MiB
[    1.790000] mmcblk0rpmb: mmc0:0001 SEM16G partition 3 128 KiB
[    1.800000]  mmcblk0: p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11 p12
[    1.825000]  mmcblk0boot1: unknown partition table
[    1.835000]  mmcblk0boot0: unknown partition table


Log messages at boot after your change (note that the bus speed is
reported as different which is what lead me to your change):

localhost ~ # dmesg | grep mmc[a-z]*0
[    1.440000] dwmmc_exynos 12200000.dwmmc0: Using internal DMA controller.
[    1.445000] dwmmc_exynos 12200000.dwmmc0: Version ID is 241a
[    1.455000] dwmmc_exynos 12200000.dwmmc0: DW MMC controller at irq
107, 32 bit host data width, 128 deep fifo
[    1.465000] mmc0: no vmmc regulator found
[    1.490000] mmc_host mmc0: Bus speed (slot 0) = 200000000Hz (slot
req 400000Hz, actual 400000HZ div = 250)
[    1.510000] dwmmc_exynos 12200000.dwmmc0: 1 slots initialized
[    1.760000] mmc0: BKOPS_EN bit is not set
[    1.770000] mmc_host mmc0: Bus speed (slot 0) = 200000000Hz (slot
req 52000000Hz, actual 50000000HZ div = 2)
[    1.770000] mmc0: new high speed DDR MMC card at address 0001
[    1.785000] mmcblk0: mmc0:0001 SEM16G 14.6 GiB
[    1.855000] mmcblk0boot0: mmc0:0001 SEM16G partition 1 2.00 MiB
[    1.860000] mmcblk0boot1: mmc0:0001 SEM16G partition 2 2.00 MiB
[    1.950000] mmcblk0rpmb: mmc0:0001 SEM16G partition 3 128 KiB
[    1.955000] mmcblk0: error -84 transferring data, sector 0, nr 8,
cmd response 0x900, card status 0xb00
[    1.965000] mmcblk0: retrying using single block read
[    1.970000] mmcblk0: error -84 transferring data, sector 0, nr 8,
cmd response 0x900, card status 0x0
[    1.980000] end_request: I/O error, dev mmcblk0, sector 0
[    1.985000] mmcblk0: error -84 transferring data, sector 1, nr 7,
cmd response 0x900, card status 0x0
[    1.995000] end_request: I/O error, dev mmcblk0, sector 1
[    2.000000] mmcblk0: error -84 transferring data, sector 2, nr 6,
cmd response 0x900, card status 0x0
[    2.010000] end_request: I/O error, dev mmcblk0, sector 2
[    2.015000] mmcblk0: error -84 transferring data, sector 3, nr 5,
cmd response 0x900, card status 0x0
[    2.025000] end_request: I/O error, dev mmcblk0, sector 3
[    2.030000] mmcblk0: error -84 transferring data, sector 4, nr 4,
cmd response 0x900, card status 0x0
[    2.040000] end_request: I/O error, dev mmcblk0, sector 4
[    2.045000] dwmmc_exynos 12200000.dwmmc0: data FIFO error (status=00008008)
[    2.050000] mmcblk0: error -5 transferring data, sector 5, nr 3,
cmd response 0x900, card status 0x0
[    2.060000] end_request: I/O error, dev mmcblk0, sector 5
...
...
...
...

-Doug
