Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbbASO2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 09:28:31 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:38064 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbbASO23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 09:28:29 -0500
Date: Mon, 19 Jan 2015 14:28:06 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Aleksey Makarov <aleksey.makarov@auriga.com>
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Daney <david.daney@cavium.com>,
        Leonid Rosenboim <lrosenboim@caviumnetworks.com>,
        Aaron Williams <aaron.williams@cavium.com>,
        Chandrakala Chavva <cchavva@caviumnetworks.com>,
        Peter Swain <pswain@cavium.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH] mmc: OCTEON: Add host driver for OCTEON MMC controller
Message-ID: <20150119142805.GE21553@leverpostej>
References: <1421675198-30213-1-git-send-email-aleksey.makarov@auriga.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421675198-30213-1-git-send-email-aleksey.makarov@auriga.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jan 19, 2015 at 01:46:36PM +0000, Aleksey Makarov wrote:
> The OCTEON MMC controller is currently found on cn61XX and cnf71XX
> devices.  Device parameters are configured from device tree data.
> 
> Currenly supported are eMMC, MMC and SD devices.

Does that mean there are other devices that this could support in
future, or that this supports everything it possibly can already?

[...]

> diff --git a/Documentation/devicetree/bindings/mmc/octeon-mmc.txt b/Documentation/devicetree/bindings/mmc/octeon-mmc.txt
> new file mode 100644
> index 0000000..ce373cf
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mmc/octeon-mmc.txt
> @@ -0,0 +1,51 @@
> +* OCTEON SD/MMC Host Controller
> +
> +This controller is present on some members of the Cavium OCTEON SoC
> +family, provide an interface for eMMC, MMC and SD devices.  There is a
> +single controller that may have several "slots" connected.  These
> +slots appear as children of the main controller node.
> +
> +Required properties:
> +- compatible : Should be "cavium,octeon-6130-mmc" or "cavium,octeon-7890-mmc"
> +- reg : Two entries:
> +       1) The base address of the MMC controller register bank.
> +       2) The base address of the MMC DMA engine register bank.
> +- interrupts : Two entries:
> +       1) The MMC controller interrupt line.
> +       2) The MMC DMA engine interrupt line.

Is the DMA engine part of the MMC controller block, or is it a
separate/generic component that happens to be used in combination with
the MMC controller?

> +- #address-cells : Must be <1>
> +- #size-cells : Must be <0>
> +
> +Required properties of child nodes:
> +- compatible : Should be "cavium,octeon-6130-mmc-slot".
> +- reg : The slot number.
> +- cavium,bus-max-width : The number of data lines present in the slot.
> +- spi-max-frequency : The maximum operating frequency of the slot.
> +
> +Optional properties of child nodes:
> +- cd-gpios : Specify GPIOs for card detection
> +- wp-gpios : Specify GPIOs for write protection
> +- power-gpios : Specify GPIOs for power control

No clocks in the DT?

> +
> +Example:
> +       mmc@1180000002000 {
> +               compatible = "cavium,octeon-6130-mmc";
> +               reg = <0x11800 0x00002000 0x0 0x100>,
> +                     <0x11800 0x00000168 0x0 0x20>;
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +               /* EMM irq, DMA irq */
> +               interrupts = <1 19>, <0 63>;
> +
> +               /* The board only has a single MMC slot */
> +               mmc-slot@0 {
> +                       compatible = "cavium,octeon-6130-mmc-slot";
> +                       reg = <0>;
> +                       spi-max-frequency = <20000000>;
> +                       /* bus width can be 1, 4 or 8 */
> +                       cavium,bus-max-width = <8>;
> +                       cd-gpios = <&gpio 9 0>;
> +                       wp-gpios = <&gpio 10 0>;
> +                       power-gpios = <&gpio 8 0>;
> +               };
> +       };

[...]

> +static inline void *phys_to_ptr(u64 address)
> +{
> +       return (void *)(address | (1ull<<63)); /* XKPHYS */
> +}
> +
> +/**
> + * Lock a single line into L2. The line is zeroed before locking
> + * to make sure no dram accesses are made.
> + *
> + * @addr   Physical address to lock
> + */
> +static void l2c_lock_line(u64 addr)
> +{
> +       char *addr_ptr = phys_to_ptr(addr);
> +
> +       asm volatile (
> +               "cache 31, %[line]"     /* Unlock the line */
> +               :: [line] "m" (*addr_ptr));
> +}
> +
> +/**
> + * Locks a memory region in the L2 cache
> + *
> + * @start - start address to begin locking
> + * @len - length in bytes to lock
> + */
> +static void l2c_lock_mem_region(u64 start, u64 len)
> +{
> +       u64 end;
> +
> +       /* Round start/end to cache line boundaries */
> +       end = ALIGN(start + len - 1, CVMX_CACHE_LINE_SIZE);
> +       start = ALIGN(start, CVMX_CACHE_LINE_SIZE);
> +
> +       while (start <= end) {
> +               l2c_lock_line(start);
> +               start += CVMX_CACHE_LINE_SIZE;
> +       }
> +       asm volatile("sync");
> +}
> +
> +/**
> + * Unlock a single line in the L2 cache.
> + *
> + * @addr       Physical address to unlock
> + *
> + * Return Zero on success
> + */
> +static void l2c_unlock_line(u64 addr)
> +{
> +       char *addr_ptr = phys_to_ptr(addr);
> +       asm volatile (
> +               "cache 23, %[line]"     /* Unlock the line */
> +               :: [line] "m" (*addr_ptr));
> +}
> +
> +/**
> + * Unlock a memory region in the L2 cache
> + *
> + * @start - start address to unlock
> + * @len - length to unlock in bytes
> + */
> +static void l2c_unlock_mem_region(u64 start, u64 len)
> +{
> +       u64 end;
> +
> +       /* Round start/end to cache line boundaries */
> +       end = ALIGN(start + len - 1, CVMX_CACHE_LINE_SIZE);
> +       start = ALIGN(start, CVMX_CACHE_LINE_SIZE);
> +
> +       while (start <= end) {
> +               l2c_unlock_line(start);
> +               start += CVMX_CACHE_LINE_SIZE;
> +       }
> +}

Why do you need to mess with the cache in this way within an MMC driver?
To me it seems somewhat surprising that you need to do that, and again
surprising that you have custom functions within the MMC driver.

[...]

> +static int octeon_mmc_probe(struct platform_device *pdev)
> +{
> +       union cvmx_mio_emm_cfg emm_cfg;
> +       struct octeon_mmc_host *host;
> +       struct resource *res;
> +       void __iomem *base;
> +       int mmc_irq[9];
> +       int i;
> +       int ret = 0;
> +       struct device_node *node = pdev->dev.of_node;
> +       int found = 0;
> +       bool cn78xx_style;
> +       u64 t;
> +       enum of_gpio_flags f;
> +
> +       host = devm_kzalloc(&pdev->dev, sizeof(*host), GFP_KERNEL);
> +       if (!host)
> +               return -ENOMEM;
> +
> +       spin_lock_init(&host->irq_handler_lock);
> +       sema_init(&host->mmc_serializer, 1);
> +
> +       cn78xx_style = of_device_is_compatible(node, "cavium,octeon-7890-mmc");
> +       if (cn78xx_style) {
> +               host->need_bootbus_lock = false;
> +               host->big_dma_addr = true;
> +               host->need_irq_handler_lock = true;
> +               /*
> +                * First seven are the EMM_INT bits 0..6, then two for
> +                * the EMM_DMA_INT bits
> +                */
> +               for (i = 0; i < 9; i++) {
> +                       mmc_irq[i] = platform_get_irq(pdev, i);
> +                       if (mmc_irq[i] < 0)
> +                               return mmc_irq[i];

The documentation describes two interrupts, yet here you try to acquire
nine. Please document which interrupts you expect (i.e. in what order
and what the logical function of each is), and when you expect them.

If some interrupts might not always be present, use interrupt-names.

> +               }
> +       } else {
> +               host->need_bootbus_lock = true;
> +               host->big_dma_addr = false;
> +               host->need_irq_handler_lock = false;
> +               /* First one is EMM second NDF_DMA */
> +               for (i = 0; i < 2; i++) {
> +                       mmc_irq[i] = platform_get_irq(pdev, i);
> +                       if (mmc_irq[i] < 0)
> +                               return mmc_irq[i];
> +               }
> +       }
> +       host->last_slot = -1;
> +
> +       if (bb_size < 512 || bb_size >= (1 << 24))
> +               bb_size = 1 << 18;
> +       host->linear_buf_size = bb_size;
> +       host->linear_buf = devm_kzalloc(&pdev->dev, host->linear_buf_size,
> +                                       GFP_KERNEL);
> +
> +       if (!host->linear_buf) {
> +               dev_err(&pdev->dev, "devm_kzalloc failed\n");
> +               return -ENOMEM;
> +       }
> +
> +       host->pdev = pdev;
> +
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       if (!res) {
> +               dev_err(&pdev->dev, "Platform resource[0] is missing\n");
> +               return -ENXIO;
> +       }
> +       base = devm_ioremap_resource(&pdev->dev, res);
> +       if (IS_ERR(base))
> +               return PTR_ERR(base);
> +       host->base = (u64)base;

I take it this can only be used on a 64-bit platform?

> +
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +       if (!res) {
> +               dev_err(&pdev->dev, "Platform resource[1] is missing\n");
> +               ret = -EINVAL;
> +               goto err;
> +       }
> +       base = devm_ioremap_resource(&pdev->dev, res);
> +       if (IS_ERR(base)) {
> +               ret = PTR_ERR(base);
> +               goto err;
> +       }
> +       host->ndf_base = (u64)base;
> +       /*
> +        * Clear out any pending interrupts that may be left over from
> +        * bootloader.
> +        */
> +       t = cvmx_read_csr(host->base + OCT_MIO_EMM_INT);
> +       cvmx_write_csr(host->base + OCT_MIO_EMM_INT, t);
> +       if (cn78xx_style) {
> +               /* Only CMD_DONE, DMA_DONE, CMD_ERR, DMA_ERR */
> +               for (i = 1; i <= 4; i++) {
> +                       ret = devm_request_irq(&pdev->dev, mmc_irq[i],
> +                                              octeon_mmc_interrupt,
> +                                              0, DRV_NAME, host);
> +                       if (ret < 0) {
> +                               dev_err(&pdev->dev, "Error: devm_request_irq %d\n",
> +                                       mmc_irq[i]);
> +                               goto err;
> +                       }
> +               }
> +       } else {
> +               ret = devm_request_irq(&pdev->dev, mmc_irq[0],
> +                                      octeon_mmc_interrupt, 0, DRV_NAME, host);
> +               if (ret < 0) {
> +                       dev_err(&pdev->dev, "Error: devm_request_irq %d\n",
> +                               mmc_irq[0]);
> +                       goto err;
> +               }
> +       }
> +
> +       ret = of_get_named_gpio_flags(node, "power-gpios", 0, &f);
> +       if (ret == -EPROBE_DEFER)
> +               goto err;
> +
> +       host->global_pwr_gpio = ret;
> +       host->global_pwr_gpio_low =
> +               (host->global_pwr_gpio >= 0 && f == OF_GPIO_ACTIVE_LOW);
> +
> +       if (host->global_pwr_gpio >= 0) {
> +               ret = gpio_request(host->global_pwr_gpio, "mmc global power");
> +               if (ret) {
> +                       dev_err(&pdev->dev,
> +                               "Could not request mmc global power gpio %d\n",
> +                               host->global_pwr_gpio);
> +                       goto err;
> +               }
> +               dev_dbg(&pdev->dev, "Global power on\n");
> +               gpio_direction_output(host->global_pwr_gpio,
> +                                     !host->global_pwr_gpio_low);
> +       }
> +
> +       platform_set_drvdata(pdev, host);
> +
> +       node = of_get_next_child(pdev->dev.of_node, NULL);
> +       while (node) {

You should use for_each_child_of_node here.

Also, you'll want to skip nodes that aren't compatible with
"cavium,octeon-6130-mmc-slot", and you'll probably want to log a warning
in that case.

> +               int r;
> +               u32 slot;
> +
> +               found = 0;
> +
> +               r = of_property_read_u32(node, "reg", &slot);
> +               if (!r) {

If you use for_each_child_of_node, you can just skip ahead in this case,
rather than having 90% of this block conditional.

e.g.

for_each_child_of_node(pdev->dev.of_node, node) {
	
	if (!of_device_is_compatible(node, "cavium,octeon-6130-mmc-slot") {
		pr_warn("sub node isn't slot: %s\n", of_node_full_name(node));
		continue;
	}

	if (of_property_read_u32(node, "reg", &slot) != 0) {
		pr_warn("Missing or invalid reg property on %s\n",
			of_node_full_name(node));
		continue;
	}

	other_stuff();
	not_indented();

}

> +                       int ro_gpio, cd_gpio, pwr_gpio;
> +                       bool ro_low, cd_low, pwr_low;
> +                       u32 bus_width, max_freq, cmd_skew, dat_skew;
> +
> +                       r = of_property_read_u32(node, "cavium,bus-max-width",
> +                                                &bus_width);
> +                       if (r) {
> +                               pr_info("Bus width not found for slot %d\n",
> +                                       slot);
> +                               bus_width = 8;

If the default assumption is 8 lanes, document that in the binding.
Otherwise, make this mandatory and skip the slot if this is missing from
the DT.

> +                       } else {
> +                               switch (bus_width) {
> +                               case 1:
> +                               case 4:
> +                               case 8:
> +                                       break;
> +                               default:
> +                                       bus_width = 8;
> +                                       break;
> +                               }
> +                       }

Silently modifying this value is not a good idea. If you get an invalid
value, warn and skip the node. If the DT was wrong then you have no
chance of guessing better anyway.

> +
> +                       r = of_property_read_u32(node, "cavium,cmd-clk-skew",
> +                                                &cmd_skew);
> +                       if (r)
> +                               cmd_skew = 0;
> +
> +                       r = of_property_read_u32(node, "cavium,dat-clk-skew",
> +                                                &dat_skew);
> +                       if (r)
> +                               dat_skew = 0;
> +

These weren't in the binding. They need to be documented.


> +                       r = of_property_read_u32(node, "spi-max-frequency",
> +                                                &max_freq);
> +                       if (r) {
> +                               max_freq = 52000000;
> +                               pr_info("no spi-max-frequency for slot %d, defautling to %d\n",

s/defautling/defaulting/

> +                                       slot, max_freq);
> +                       }
> +
> +                       ro_gpio = of_get_named_gpio_flags(node, "wp-gpios",
> +                                                         0, &f);
> +                       ro_low = (ro_gpio >= 0 && f == OF_GPIO_ACTIVE_LOW);
> +                       cd_gpio = of_get_named_gpio_flags(node, "cd-gpios",
> +                                                         0, &f);
> +                       cd_low = (cd_gpio >= 0 && f == OF_GPIO_ACTIVE_LOW);
> +                       pwr_gpio = of_get_named_gpio_flags(node, "power-gpios",
> +                                                          0, &f);
> +                       pwr_low = (pwr_gpio >= 0 && f == OF_GPIO_ACTIVE_LOW);
> +
> +                       ret = octeon_init_slot(host, slot, bus_width, max_freq,
> +                                              ro_gpio, cd_gpio, pwr_gpio,
> +                                              ro_low, cd_low, pwr_low,
> +                                              cmd_skew, dat_skew);
> +                       octeon_mmc_dbg("init slot %d, ret = %d\n", slot, ret);
> +                       if (ret)
> +                               goto err;
> +               }
> +               node = of_get_next_child(pdev->dev.of_node, node);
> +       }
> +
> +       return ret;
> +
> +err:
> +       /* Disable MMC controller */
> +       emm_cfg.s.bus_ena = 0;
> +       cvmx_write_csr(host->base + OCT_MIO_EMM_CFG, emm_cfg.u64);
> +
> +       if (host->global_pwr_gpio >= 0) {
> +               dev_dbg(&pdev->dev, "Global power off\n");
> +               gpio_set_value_cansleep(host->global_pwr_gpio,
> +                                       host->global_pwr_gpio_low);
> +               gpio_free(host->global_pwr_gpio);
> +       }
> +
> +       return ret;
> +}

It's probably worth having some logging in this error path.

Thanks,
Mark.
