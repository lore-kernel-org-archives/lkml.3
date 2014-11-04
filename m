Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbaKDVmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 16:42:16 -0500
Received: from mail-1.atlantis.sk ([80.94.52.57]:46858 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbaKDVmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 16:42:15 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v2] [RESEND] mmc: add Toshiba PCI SD controller driver
Date: Tue, 4 Nov 2014 22:41:44 +0100
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: "linux-mmc" <linux-mmc@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
References: <1414965074-4784-1-git-send-email-linux@rainbow-software.org> <CAPDyKFrf+kHbyzyr1O906NRcPh2jr0TGkeoAxpd1aSK8a0bqRA@mail.gmail.com>
In-Reply-To: <CAPDyKFrf+kHbyzyr1O906NRcPh2jr0TGkeoAxpd1aSK8a0bqRA@mail.gmail.com>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201411042241.45125.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 November 2014 12:09:44 Ulf Hansson wrote:
> On 2 November 2014 22:51, Ondrej Zary <linux@rainbow-software.org> wrote:
> > This patch resurrects an old never-finished driver for Toshiba PCI SD
> > controllers found in some older Toshiba laptops (such as Portege R100):
> >
> > 02:0d.0 System peripheral [0880]: Toshiba America Info Systems SD TypA Controller [1179:0805] (rev 05)
> >
> > The code is fixed, cleaned up and successfully tested with SD, SDHC, SDXC and
> > MMC cards on Portege R100. (MMC cards don't even work in Windows!)
> > SDIO probably does not work (don't have any SDIO card).
> >
> > The hardware is slow (around 2 MB/s - same in Windows) because it does not
> > support bus mastering (busmaster enable bit cannot be set in PCI control reg).
> > Also the card clock is limited to 16MHz (33MHz PCI clock divided by 2).
> >
> > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> 
> Hi Ondrej,
> 
> Sorry for a very very late reply.
> 

...

> > +static void toshsd_init(struct toshsd_host *host);
> > +static void toshsd_set_ios_unlocked(struct mmc_host *mmc, struct mmc_ios *ios);
> 
> I would implement these functions at the proper place instead of
> having them defined here.
> 
> Moreover I think toshsd_set_ios_unlocked() could be renamed to
> "__toshsd_set_ios()".

OK, will do.
 
> > +
> > +static inline u16 toshsd_readw(struct toshsd_host *host, u16 reg)
> > +{
> > +       return ioread16(host->ioaddr + reg);
> > +}
> > +
> > +static inline u32 toshsd_readl(struct toshsd_host *host, u16 reg)
> > +{
> > +       return ioread32(host->ioaddr + reg);
> > +}
> > +
> > +static inline void toshsd_writew(struct toshsd_host *host, u16 reg, u16 val)
> > +{
> > +       iowrite16(val, host->ioaddr + reg);
> > +}
> > +
> > +static inline void toshsd_writel(struct toshsd_host *host, u16 reg, u32 val)
> > +{
> > +       iowrite32(val, host->ioaddr + reg);
> > +}
> > +
> > +static inline void toshsd_readl_rep(struct toshsd_host *host, u16 reg,
> > +                                   void *dst, unsigned long count)
> > +{
> > +       ioread32_rep(host->ioaddr + reg, dst, count);
> > +}
> > +
> > +static inline void toshsd_writel_rep(struct toshsd_host *host, u16 reg,
> > +                                    const void *src, unsigned long count)
> > +{
> > +       iowrite32_rep(host->ioaddr + reg, src, count);
> > +}
> 
> To me, all these wrapper functions seems a bit ugly. How about
> invoking io* functions directly instead?

It's a matter of preference, some drivers use wrappers, some don't.
I can remove them if they're not recommended in mmc subsystem.
 
...

> > +               tasklet_schedule(&host->data_read_tasklet);
> 
> Instead of using a tasklet, I would advise to use a threaded IRQ.
 
Haven't used threaded IRQ yet, will try.

...

> > +#ifdef CONFIG_PM
> 
> This should be CONFIG_PM_SLEEP.
> 
> > +
> > +static int toshsd_suspend(struct pci_dev *pdev, pm_message_t state)
> 
> This is the legacy version of system PM callbacks. You need to convert
> to the modern ones instead.
> 
> > +{
> > +       struct toshsd_host *host = pci_get_drvdata(pdev);
> > +
> > +       toshsd_powerdown(host);
> > +
> > +       pci_save_state(pdev);
> > +       pci_enable_wake(pdev, pci_choose_state(pdev, state), 0);
> > +       pci_disable_device(pdev);
> > +       pci_set_power_state(pdev, pci_choose_state(pdev, state));
> > +
> > +       return 0;
> > +}
> > +
> > +static int toshsd_resume(struct pci_dev *pdev)
> 
> This is the legacy version of system PM callbacks. You need to convert
> to the modern ones instead.

I just converted them and found that suspend does not work on current kernels
when a SD card is inserted (even with unmodified toshsd driver):
[  188.960862] dpm_run_callback(): mmc_bus_suspend+0x0/0x2c [mmc_core] returns -110
[  188.960867] PM: Device mmc0:b368 failed to suspend: error -110
[  188.960869] PM: Some devices failed to suspend, or early wake event detected

Is it a kernel bug or the driver is missing something?

-- 
Ondrej Zary
