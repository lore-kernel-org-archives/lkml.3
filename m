Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbaDCJON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 05:14:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:18593 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422AbaDCJOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 05:14:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,785,1389772800"; 
   d="scan'208";a="506035093"
Message-ID: <533D262A.2040602@intel.com>
Date: Thu, 03 Apr 2014 17:13:14 +0800
From: Jet Chen <jet.chen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>, "Wu, Fengguang" <fengguang.wu@intel.com>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [mtd/sbc_gxx] kernel BUG at include/linux/mtd/map.h:148!
References: <20140327140140.GA9083@localhost> <CAErSpo7b+OJUoRcMY0edZPgEKG6DbwdLcq5M0-9B6JKALpm+QQ@mail.gmail.com> <20140331113412.GA13548@localhost> <20140331143543.GA9764@sepie.suse.cz>
In-Reply-To: <20140331143543.GA9764@sepie.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

Your patch fixes the problem.

Tested-by: Jet Chen <jet.chen@intel.com>

Thanks,
-Jet

On 03/31/2014 10:35 PM, Michal Marek wrote:
> On Mon, Mar 31, 2014 at 07:34:12PM +0800, Fengguang Wu wrote:
>> CC Michal and kbuild list.
>>
>> On Thu, Mar 27, 2014 at 04:51:53PM -0600, Bjorn Helgaas wrote:
>>> [+cc David, Brian]
>>>
>>> On Thu, Mar 27, 2014 at 8:01 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
>>>> FYI, here is a very old warning, too old to be bisected.
>>>>
>>>> [    5.282127] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
>>>> [    5.286079] SBC-GXx flash: IO:0x258-0x259 MEM:0xdc000-0xdffff
>>>> [    5.288723] ------------[ cut here ]------------
>>>> [    5.289649] kernel BUG at include/linux/mtd/map.h:148!
>>>
>>> I think the problem is that your randconfig happens to have none of
>>> CONFIG_MTD_MAP_BANK_WIDTH_* set (you should have played the lottery
>>> today!), and the default implementation of map_bankwidth() in that
>>> case is just "BUG()":
>>>
>>>    $ grep MTD_MAP config-3.14.0-rc8-wl-03045-gdf16ea4
>>>    # CONFIG_MTD_MAP_BANK_WIDTH_1 is not set
>>>    # CONFIG_MTD_MAP_BANK_WIDTH_2 is not set
>>>    # CONFIG_MTD_MAP_BANK_WIDTH_4 is not set
>>>    # CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
>>>    # CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
>>>    # CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
>>>
>>> I don't know enough Kconfig or MTD to fix this.
>>
>> Michal, the problem we run into is, how to select one of the above
>> CONFIG_MTD_MAP_BANK_WIDTH_xx in "make randconfig".
>
> You can't enforce this in Kconfig. What you can do is to make the logic
> more fool-proof and fall back to some sensible default if none of the
> CONFIG_MTD_MAP_BANK_WIDTH_* options is enabled. Like this
>
>
>  From 76e66ceea7e2ffbb1d39c01af2eaf6f2b66c2be3 Mon Sep 17 00:00:00 2001
> From: Michal Marek <mmarek@suse.cz>
> Date: Mon, 31 Mar 2014 16:25:32 +0200
> Subject: [PATCH] mtd: Fall back to MTD_MAP_BANK_WIDTH_1 if none is specified
>
> This is mainly to fix make randconfig errors.
>
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>   drivers/mtd/chips/Kconfig | 8 ++++++++
>   include/linux/mtd/map.h   | 4 ++--
>   2 files changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mtd/chips/Kconfig b/drivers/mtd/chips/Kconfig
> index e4696b3..219de49 100644
> --- a/drivers/mtd/chips/Kconfig
> +++ b/drivers/mtd/chips/Kconfig
> @@ -115,6 +115,14 @@ config MTD_MAP_BANK_WIDTH_32
>   	  If you wish to support CFI devices on a physical bus which is
>   	  256 bits wide, say 'Y'.
>
> +config HAVE_MTD_MAP_BANK_WIDTH_1
> +	bool
> +	default MTD_MAP_BANK_WIDTH_1 || (!MTD_MAP_BANK_WIDTH_2 && !MTD_MAP_BANK_WIDTH_4 && !MTD_MAP_BANK_WIDTH_8 && !MTD_MAP_BANK_WIDTH_16 && !MTD_MAP_BANK_WIDTH_32)
> +
> +if HAVE_MTD_MAP_BANK_WIDTH_1 && !MTD_MAP_BANK_WIDTH_1
> +comment "no buswidth selected, using 8-bit as a fallback "
> +endif
> +
>   config MTD_CFI_I1
>   	bool "Support 1-chip flash interleave" if MTD_CFI_GEOMETRY
>   	default y
> diff --git a/include/linux/mtd/map.h b/include/linux/mtd/map.h
> index 5f487d7..d4f4f49 100644
> --- a/include/linux/mtd/map.h
> +++ b/include/linux/mtd/map.h
> @@ -32,7 +32,7 @@
>   #include <asm/io.h>
>   #include <asm/barrier.h>
>
> -#ifdef CONFIG_MTD_MAP_BANK_WIDTH_1
> +#ifdef CONFIG_HAVE_MTD_MAP_BANK_WIDTH_1
>   #define map_bankwidth(map) 1
>   #define map_bankwidth_is_1(map) (map_bankwidth(map) == 1)
>   #define map_bankwidth_is_large(map) (0)
> @@ -156,7 +156,7 @@ static inline int map_bankwidth(void *map)
>   static inline int map_bankwidth_supported(int w)
>   {
>   	switch (w) {
> -#ifdef CONFIG_MTD_MAP_BANK_WIDTH_1
> +#ifdef CONFIG_HAVE_MTD_MAP_BANK_WIDTH_1
>   	case 1:
>   #endif
>   #ifdef CONFIG_MTD_MAP_BANK_WIDTH_2
>
