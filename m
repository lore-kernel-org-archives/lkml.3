Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841AbaHHVk2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:40:28 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:62077 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758819AbaHHVkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 17:40:22 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:28a4:d7e2:1da8:e877]
In-Reply-To: <53E0736E.7030901@samsung.com>
References: <20140805130926.4e8c8fe5@canb.auug.org.au>
	<53E0736E.7030901@samsung.com>
Date: Fri, 8 Aug 2014 14:40:21 -0700
Message-ID: <CAOesGMjjLHOaBJZwFENaWW41KFsNZ3pUqiYk0jtet=8NFvce3g@mail.gmail.com>
Subject: Re: linux-next: build failures after merge of the drm tree
From: Olof Johansson <olof@lixom.net>
To: YoungJun Cho <yj44.cho@samsung.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Dave Airlie <airlied@linux.ie>,
        Kukjin Kim <kgene.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Wood <thomas.wood@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Inki Dae <daeinki@gmail.com>, Rahul Sharma <rahul.sharma@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 4, 2014 at 11:02 PM, YoungJun Cho <yj44.cho@samsung.com> wrote:
> Hi Stephen and Dave,
>
>
> On 08/05/2014 12:09 PM, Stephen Rothwell wrote:
>>
>> Hi Dave,
>>
>> After merging the drm tree, today's linux-next build (x86_64
>> allmodconfig) failed like this:
>>
>> ERROR: "drm_sysfs_connector_remove" [drivers/gpu/drm/i2c/tda998x.ko]
>> undefined!
>> ERROR: "drm_sysfs_connector_add" [drivers/gpu/drm/i2c/tda998x.ko]
>> undefined!
>>
>> Caused by commit c707c3619ca8 ("drm/i2c: tda998x: add component
>> support") interacting with commit 34ea3d386347 ("drm: add register and
>> unregister functions for connectors").  Maybe it should have been fixed
>> up in the merge commit 920f946428b7 ("Merge branch 'tda998x-devel' of
>> git://ftp.arm.linux.org.uk/~rmk/linux-cubox into drm-next")?
>>
>> I reverted commit c707c3619ca8 for today.
>>
>> But then the arm multi_v7_defconfig build produced these errors:
>>
>> ERROR (phandle_references): Reference to non-existent node or label
>> "disp_pd"
>>
>> ERROR: Input tree has errors, aborting (use -f to force output)
>> make[2]: *** [arch/arm/boot/dts/exynos5420-arndale-octa.dtb] Error 2
>> make[2]: *** Waiting for unfinished jobs....
>> ERROR (phandle_references): Reference to non-existent node or label
>> "disp_pd"
>>
>> ERROR: Input tree has errors, aborting (use -f to force output)
>> make[2]: *** [arch/arm/boot/dts/exynos5420-smdk5420.dtb] Error 2
>> ERROR (phandle_references): Reference to non-existent node or label
>> "disp_pd"
>>
>> ERROR: Input tree has errors, aborting (use -f to force output)
>> ERROR (phandle_references): Reference to non-existent node or label
>> "disp_pd"
>>
>> make[2]: *** [arch/arm/boot/dts/exynos5800-peach-pi.dtb] Error 2
>> ERROR: Input tree has errors, aborting (use -f to force output)
>>
>> Caused by commit 5a8da524049c ("ARM: dts: exynos5420: add dsi node")
>> interacting with commit d51cad7df871 ("ARM: dts: remove display power
>> domain for exynos5420") from the arm-soc tree.
>>
>
> I missed the patch "ARM: dts: remove display power domain for exynos5420" in
> linux-samsung-soc mail thread.
>
> In my test without power domain property, the exynos5420 dsi master driver
> works well.
>
>
>> I applied this merge fix patch:
>>
>> From: Stephen Rothwell <sfr@canb.auug.org.au>
>> Date: Tue, 5 Aug 2014 13:03:01 +1000
>> Subject: [PATCH] ARM: dts: exynos5420: remove disp_pd
>>
>> per comit d51cad7df871 ("ARM: dts: remove display power
>> domain for exynos5420").
>>
>> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
>> ---
>>   arch/arm/boot/dts/exynos5420.dtsi | 1 -
>>   1 file changed, 1 deletion(-)
>>
>> diff --git a/arch/arm/boot/dts/exynos5420.dtsi
>> b/arch/arm/boot/dts/exynos5420.dtsi
>> index 95ec37dff3e8..bfe056d9148c 100644
>> --- a/arch/arm/boot/dts/exynos5420.dtsi
>> +++ b/arch/arm/boot/dts/exynos5420.dtsi
>> @@ -525,7 +525,6 @@
>>                 compatible = "samsung,exynos5410-mipi-dsi";
>>                 reg = <0x14500000 0x10000>;
>>                 interrupts = <0 82 0>;
>> -               samsung,power-domain = <&disp_pd>;
>>                 phys = <&mipi_phy 1>;
>>                 phy-names = "dsim";
>>                 clocks = <&clock CLK_DSIM1>, <&clock CLK_SCLK_MIPI1>;
>>
>
> Tested-by: YoungJun Cho <yj44.cho@samsung.com>

Sigh, now Linus' tree is broken because of this because nobody picked it up.

Dave, can you revert the original change, please? (5a8da524049c).

DTS changes like these shouldn't go through driver trees in the first place. :(


-Olof
