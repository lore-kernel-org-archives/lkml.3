Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbaESJP1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 05:15:27 -0400
Received: from mx0.aculab.com ([213.249.233.131]:59942 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752681AbaESJPZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 05:15:25 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Andi Kleen'" <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>
Subject: RE: [PATCH 1/8] ixgbe: Out of line ixgbe_read/write_reg
Thread-Topic: [PATCH 1/8] ixgbe: Out of line ixgbe_read/write_reg
Thread-Index: AQHPcVA/yvdChpZic0OyLRs93tzV1ZtHom5A
Date: Mon, 19 May 2014 09:14:57 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D17248D76@AcuExch.aculab.com>
References: <1400276595-6965-1-git-send-email-andi@firstfloor.org>
 <1400276595-6965-2-git-send-email-andi@firstfloor.org>
In-Reply-To: <1400276595-6965-2-git-send-email-andi@firstfloor.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen
> ixgbe_read_reg and ixgbe_write_reg are frequently called and are very big
> because they have complex error handling code.

Have you measured the performance impact?
I suspect that it might me measurable.

Clearly the calls during initialisation don't need to be inline,
but there will be some in the normal tx and rx paths.

	David

> Moving them out of line saves ~27k text in the ixgbe driver.
> 
>    text	   data	    bss	    dec	    hex	filename
> 14220873	2008072	1507328	17736273	10ea251	vmlinux-before-ixgbe
> 14193673	2003976	1507328	17704977	10e2811	vmlinux-ixgbe
> 
> Cc: netdev@vger.kernel.org
> Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_common.h | 22 ++--------------------
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c   | 22 ++++++++++++++++++++++
>  2 files changed, 24 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.h
> b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.h
> index f12c40f..05f094d 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.h
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.h
> @@ -162,28 +162,10 @@ static inline void writeq(u64 val, void __iomem *addr)
>  }
>  #endif
> 
> -static inline void ixgbe_write_reg64(struct ixgbe_hw *hw, u32 reg, u64 value)
> -{
> -	u8 __iomem *reg_addr = ACCESS_ONCE(hw->hw_addr);
> +void ixgbe_write_reg64(struct ixgbe_hw *hw, u32 reg, u64 value);
> +u32 ixgbe_read_reg(struct ixgbe_hw *hw, u32 reg);
> 
> -	if (ixgbe_removed(reg_addr))
> -		return;
> -	writeq(value, reg_addr + reg);
> -}
>  #define IXGBE_WRITE_REG64(a, reg, value) ixgbe_write_reg64((a), (reg), (value))
> -
> -static inline u32 ixgbe_read_reg(struct ixgbe_hw *hw, u32 reg)
> -{
> -	u8 __iomem *reg_addr = ACCESS_ONCE(hw->hw_addr);
> -	u32 value;
> -
> -	if (ixgbe_removed(reg_addr))
> -		return IXGBE_FAILED_READ_REG;
> -	value = readl(reg_addr + reg);
> -	if (unlikely(value == IXGBE_FAILED_READ_REG))
> -		ixgbe_check_remove(hw, reg);
> -	return value;
> -}
>  #define IXGBE_READ_REG(a, reg) ixgbe_read_reg((a), (reg))
> 
>  #define IXGBE_WRITE_REG_ARRAY(a, reg, offset, value) \
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> index d62e7a2..5f81f62 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> @@ -371,6 +371,28 @@ void ixgbe_write_pci_cfg_word(struct ixgbe_hw *hw, u32 reg, u16 value)
>  	pci_write_config_word(adapter->pdev, reg, value);
>  }
> 
> +void ixgbe_write_reg64(struct ixgbe_hw *hw, u32 reg, u64 value)
> +{
> +	u8 __iomem *reg_addr = ACCESS_ONCE(hw->hw_addr);
> +
> +	if (ixgbe_removed(reg_addr))
> +		return;
> +	writeq(value, reg_addr + reg);
> +}
> +
> +u32 ixgbe_read_reg(struct ixgbe_hw *hw, u32 reg)
> +{
> +	u8 __iomem *reg_addr = ACCESS_ONCE(hw->hw_addr);
> +	u32 value;
> +
> +	if (ixgbe_removed(reg_addr))
> +		return IXGBE_FAILED_READ_REG;
> +	value = readl(reg_addr + reg);
> +	if (unlikely(value == IXGBE_FAILED_READ_REG))
> +		ixgbe_check_remove(hw, reg);
> +	return value;
> +}
> +
>  static void ixgbe_service_event_complete(struct ixgbe_adapter *adapter)
>  {
>  	BUG_ON(!test_bit(__IXGBE_SERVICE_SCHED, &adapter->state));
> --
> 1.9.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


