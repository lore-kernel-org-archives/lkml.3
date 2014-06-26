Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096AbaFZAGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 20:06:14 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:32945 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071AbaFZAGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 20:06:11 -0400
MIME-Version: 1.0
In-Reply-To: <53AB4F2D.2060208@wwwdotorg.org>
References: <1403072180-4944-1-git-send-email-abrestic@chromium.org>
	<1403072180-4944-7-git-send-email-abrestic@chromium.org>
	<53AB4F2D.2060208@wwwdotorg.org>
Date: Wed, 25 Jun 2014 17:06:10 -0700
X-Google-Sender-Auth: 4u0ac7pADGsXANZHu9G09BGBL-I
Message-ID: <CAL1qeaFhfYdW06Md10eGVYWBrRR+f1yykVYHNp5+9-t1C9joPQ@mail.gmail.com>
Subject: Re: [PATCH v1 6/9] usb: xhci: Add NVIDIA Tegra XHCI host-controller driver
From: Andrew Bresticker <abrestic@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-usb@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kishon Vijay Abraham I <kishon@ti.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 3:37 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 06/18/2014 12:16 AM, Andrew Bresticker wrote:
>> Add support for the on-chip XHCI host controller present on Tegra SoCs.
>>
>> The driver is currently very basic: it loads the controller with its
>> firmware, starts the controller, and is able to service messages sent
>> by the controller's firmware.  The hardware supports device mode as
>> well as runtime power-gating, but support for these is not yet
>> implemented here.
>>
>> Based on work by:
>>   Ajay Gupta <ajayg@nvidia.com>
>>   Bharath Yadav <byadav@nvidia.com>
>
>> diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
>
>> +config USB_XHCI_TEGRA
>> +     tristate "NVIDIA Tegra XHCI support"
>> +     depends on ARCH_TEGRA
>> +     select PINCTRL_TEGRA_XUSB
>> +     select TEGRA_XUSB_MBOX
>> +     select FW_LOADER
>
> I think at least some of those should be depends. In particular, the
> mbox driver patch said:
>
> +config TEGRA_XUSB_MBOX
> +       bool "NVIDIA Tegra XUSB mailbox support"
>
> which means the option is user-selectable. Either MBOX should be
> invisible and selected here, or it should be visible with USB_XHCI_TEGRA
> depending on it.

Annoyingly, TEGRA_XUSB_MBOX isn't selectable unless MAILBOX is
selected, so I think I will make USB_XHCI_TEGRA depend on
TEGRA_XUSB_MBOX.

>> diff --git a/drivers/usb/host/xhci-tegra.c b/drivers/usb/host/xhci-tegra.c
>
>> +#define TEGRA_XHCI_UTMI_PHYS 3
>> +#define TEGRA_XHCI_HSIC_PHYS 2
>> +#define TEGRA_XHCI_USB3_PHYS 2
>> +#define TEGRA_XHCI_MAX_PHYS (TEGRA_XHCI_UTMI_PHYS + TEGRA_XHCI_HSIC_PHYS + \
>> +                          TEGRA_XHCI_USB3_PHYS)
>
> Do those numbers need to be synchronized with the XUSB padctrl driver at
> all?

Oops, yeah, these probably belong in a header somewhere.

>> +static u32 csb_readl(struct tegra_xhci_hcd *tegra, u32 addr)
>> +{
>> +     u32 page, offset;
>> +
>> +     page = CSB_PAGE_SELECT(addr);
>> +     offset = CSB_PAGE_OFFSET(addr);
>> +     fpci_writel(tegra, page, XUSB_CFG_ARU_C11_CSBRANGE);
>> +     return fpci_readl(tegra, XUSB_CFG_CSB_BASE_ADDR + offset);
>> +}
>
> I assume some higher level has the required locking or single-threading
> so that the keyhole register accesses don't get interleaved?

Yes, we only touch these in the firmware loading path which is single-threaded.

>> +static void tegra_xhci_cfg(struct tegra_xhci_hcd *tegra)
>> +{
>> +     u32 reg;
>> +
>> +     reg = ipfs_readl(tegra, IPFS_XUSB_HOST_CONFIGURATION_0);
>> +     reg |= IPFS_EN_FPCI;
>> +     ipfs_writel(tegra, reg, IPFS_XUSB_HOST_CONFIGURATION_0);
>> +     udelay(10);
>> +
>> +     /* Program Bar0 Space */
>> +     reg = fpci_readl(tegra, XUSB_CFG_4);
>> +     reg |= tegra->hcd->rsrc_start;
>
> Don't you need to mask out the original value here? I guess whatever is
> being written is probably always the same, but it seems scary to assume
> that a bootloader, or previous version of a module during development,
> didn't write something unexpected there. Perhaps if the HW module's
> reset is pulsed we don't need to worry though.

Hmm, so I left this part mostly identical to what the downstream
kernels do, but the more I look at it the more it looks wrong.  The
TRM says that BASE_ADDRESS is XUSB_CFG_4[31:15] and the rest are flags
(which we avoid over-writing because the base address is 64K aligned),
but we just slam the physical address of the host in there.  I'll get
some clarification on what exactly needs to be programmed into this
register.

>> +static int tegra_xhci_load_firmware(struct tegra_xhci_hcd *tegra)
>> +{
>> +     struct device *dev = tegra->dev;
>> +     struct tegra_xhci_fw_cfgtbl *cfg_tbl;
>> +     u64 fw_base;
>> +     u32 val;
>> +     time_t fw_time;
>> +     struct tm fw_tm;
>> +
>> +     if (csb_readl(tegra, XUSB_CSB_MP_ILOAD_BASE_LO) != 0) {
>> +             dev_info(dev, "Firmware already loaded, Falcon state 0x%x\n",
>> +                      csb_readl(tegra, XUSB_FALC_CPUCTL));
>> +             return 0;
>> +     }
>> +
>> +     cfg_tbl = (struct tegra_xhci_fw_cfgtbl *)tegra->fw_data;
>
> Are there endianness or CPU word size (e.g. ARMv8) issues here; this is
> casting the content of a data file to a CPU data structure.

I don't think there are word-size issues, but I suppose there could be
endianness issues.

>> +static int tegra_xhci_set_ss_clk(struct tegra_xhci_hcd *tegra,
>> +                              unsigned long rate)
>
>> +     switch (rate) {
>> +     case TEGRA_XHCI_SS_CLK_HIGH_SPEED:
>> +             /* Reparent to PLLU_480M. Set div first to avoid overclocking */
>> +             old_parent_rate = clk_get_rate(clk_get_parent(clk));
>> +             new_parent_rate = clk_get_rate(tegra->pll_u_480m);
>> +             div = new_parent_rate / rate;
>> +             ret = clk_set_rate(clk, old_parent_rate / div);
>> +             if (ret)
>> +                     return ret;
>> +             ret = clk_set_parent(clk, tegra->pll_u_480m);
>> +             if (ret)
>> +                     return ret;
>
> Don't you need to call clk_set_rate() again after reparenting, since the
> divisor will be different, and the rounding too.

Nope, the divider we set before remains in-tact after clk_set_parent().

>> +static int tegra_xhci_regulator_enable(struct tegra_xhci_hcd *tegra)
>> +{
>> +     int ret;
>> +
>> +     ret = regulator_enable(tegra->s3p3v_reg);
>> +     if (ret < 0)
>> +             return ret;
>> +     ret = regulator_enable(tegra->s1p8v_reg);
>> +     if (ret < 0)
>> +             goto disable_s3p3v;
>> +     ret = regulator_enable(tegra->s1p05v_reg);
>> +     if (ret < 0)
>> +             goto disable_s1p8v;
>
> Would regulator_bulk_enable() save any code here? Similar in _disable().

Yes, will do.

>> +static const struct tegra_xhci_soc_config tegra124_soc_config = {
>> +     .firmware_file = "tegra12x/tegra_xusb_firmware",
>> +};
>
> I would prefer an "nvidia/" prefix so everything gets namespaced by vendor.
>
> "tegra12x" isn't the name of the chip, but rather "Tegra124".
>
> "tegra_" and "_firmware" seem redundant, since they're implied by parent
> directories.
>
> So, how about "nvidia/tegra124/xusb"? (perhaps with .img or .bin file
> extension)

Sounds good to me.

>> +static int tegra_xhci_probe(struct platform_device *pdev)
>
>> +     tegra->host_clk = devm_clk_get(&pdev->dev, "xusb_host");
>> +     if (IS_ERR(tegra->host_clk)) {
>> +             ret = PTR_ERR(tegra->host_clk);
>> +             goto put_hcd;
>> +     }
>> +     tegra->falc_clk = devm_clk_get(&pdev->dev, "xusb_falcon_src");
>> +     if (IS_ERR(tegra->falc_clk)) {
>> +             ret = PTR_ERR(tegra->falc_clk);
>> +             goto put_hcd;
>> +     }
> ...
>
> Seems like devm_clk_get_bulk() would be useful:-)

Indeed...

>> +     for (i = 0; i < TEGRA_XHCI_UTMI_PHYS; i++) {
>> +             char prop[sizeof("utmi-N")];
>> +
>> +             sprintf(prop, "utmi-%d", i);
>
> Since this loop is cut/paste 3 times just with the string
> "utmi"/"hsic"/"usb3" being different, does it make sense to add an outer
> loop over an array of strings instead of duplicating the loo?

Ok, will do.

>> +     ret = request_firmware_nowait(THIS_MODULE, true,
>> +                                   tegra->soc_config->firmware_file,
>> +                                   tegra->dev, GFP_KERNEL, tegra,
>> +                                   tegra_xhci_probe_finish);
>
> I'm not familiar with that API. I assume the point is this works in allh
> the following situations:
>
> * Driver is built-in, probes before rootfs is available, firmware
> eventually gets loaded a few seconds after rootfs is available.
>
> * Driver is a module and gets loaded from an initrd, firmware is loaded
> from initrd essentially immediately.
>
> * Driver is a module and gets loaded from an initrd, firmware eventually
> gets loaded a few seconds after rootfs is available.
>
> * Driver is a module and gets loaded from rootfs, firmware is loaded
> from rootfs essentially immediately.

Yes, this will handle all those cases.  If the rootfs is not available
at the time request_firmware{_nowait} is called, however, you'll need
to use the userspace firmware loader interface (or have a tool that
does it automatically) once it does become available.  See
Documentation/firmware_class/README for details.

For testing (and in the ChromiumOS tree), we build the firmware into
the kernel image with CONFIG_EXTRA_FIRMWARE.
