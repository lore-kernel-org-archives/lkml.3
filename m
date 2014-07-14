Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526AbaGNEfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 00:35:45 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:53820 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaGNEff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 00:35:35 -0400
MIME-Version: 1.0
In-Reply-To: <20140711224421.GA5417@google.com>
References: <1404198978-26593-1-git-send-email-vidyas@nvidia.com>
 <20140705185736.GD28871@google.com> <20140705190203.GE28871@google.com>
 <113ACA888B71994BB56E5CF3704953486D8E9DFE3C@BGMAIL02.nvidia.com>
 <CAErSpo5qSy6sEUj-Hu1_ympHUhxLBw6Cf1v_Y6bQ6XqFNmJS8Q@mail.gmail.com>
 <CAN7O0+KymyWPNnd+HDHNPTUwm8uSXa2v2fmUkHK=5NQenWK7xA@mail.gmail.com> <20140711224421.GA5417@google.com>
From: vidya sagar <sagar.tv@gmail.com>
Date: Mon, 14 Jul 2014 10:05:13 +0530
Message-ID: <CAN7O0+LJKCMdXmELP3KTsLyRmGEHKvRcvNi+53AJFJLHUnmhrg@mail.gmail.com>
Subject: Re: [PATCH v1] PCI: enable ASPM configuration in PCIE POWERSAVE mode
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Vidya Sagar <vidyas@nvidia.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        Stephen Warren <swarren@nvidia.com>, Krishna Thota <kthota@nvidia.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "tianyu.lan@intel.com" <tianyu.lan@intel.com>,
        Nagananda Chumbalkar <nchumbalkar@lenovo.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2014 at 4:14 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> [updated Naga's email address]
>
> On Wed, Jul 09, 2014 at 11:50:01PM +0530, vidya sagar wrote:
>> On Tue, Jul 8, 2014 at 2:42 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> > On Mon, Jul 7, 2014 at 12:00 PM, Vidya Sagar <vidyas@nvidia.com> wrote:
>> >>> -----Original Message-----
>> >>> From: Bjorn Helgaas [mailto:bhelgaas@google.com]
>> >>> Sent: Sunday, July 06, 2014 12:32 AM
>> >>> To: Vidya Sagar
>> >>> Cc: nagananda.chumbalkar@hp.com; thierry.reding@gmail.com; Stephen
>> >>> Warren; Krishna Thota; linux-pci@vger.kernel.org; linux-
>> >>> kernel@vger.kernel.org; Matthew Garrett; Rafael J. Wysocki
>> >>> Subject: Re: [PATCH v1] PCI: enable ASPM configuration in PCIE POWERSAVE
>> >>> mode
>> >>>
>> >>> [+cc Rafael]
>> >>>
>> >>> On Sat, Jul 05, 2014 at 12:57:36PM -0600, Bjorn Helgaas wrote:
>> >>> > [+cc Matthew]
>> >>> >
>> >>> > On Tue, Jul 01, 2014 at 12:46:18PM +0530, Vidya Sagar wrote:
>> >>> > > commit 1a680b7c moved pcie_aspm_powersave_config_link() out of
>> >>> > > pci_raw_set_power_state() to pci_set_power_state() which would
>> >>> > > enable ASPM. But, with commit db288c9c, which re-introduced the
>> >>> > > following check
>> >>> > > ./drivers/pci/pci.c: pci_set_power_state()
>> >>> > > +   /* Check if we're already there */
>> >>> > > +   if (dev->current_state == state)
>> >>> > > +       return 0;
>> >>> > > in pci_set_power_state(), call to pcie_aspm_powersave_config_link()
>> >>> > > is never made leaving ASPM broken.
>> >>> > > Fix it by not returning from when the above condition is true,
>> >>> > > rather, jump to ASPM configuration code and exit from there eventually.
>> >>> >
>> >>> > Rafael, Matthew, any comments?  We have vacillated on this before and
>> >>> > the web is already pretty tangled.
>> >>> >
>> >> I've raised a bugzilla bug  https://bugzilla.kernel.org/show_bug.cgi?id=79621 for the same.
>> >> Scenario here is, when the driver of a particular PCIe device is loaded and when CONFIG_PCIEASPM_POWERSAVE=y, ASPM is expected to get configured by the sub system which is not happening as of today.
>> >> The reason for this behavior is the 'if' condition that checks for the device's power state and returns if it is already in D0. Ideally, it shouldn't return from there, rather proceed to configure ASPM.
>> >
>> Please find the attached files (before_aspm_patch.txt &
>> after_aspm_patch.txt) with 'dmesg' and 'lspci -vvv' info.
>> BTW, my understanding is that this issue (enabling ASPM while booting)
>> exists for all the devices which are in D0 state.
>> Please correct my understanding if it's wrong.
>> Though, enabling aspm through writing 'powersave' to
>> '/sys/module/pcie_aspm/parameters' is working fine always.
>
> I think your observation is correct: it looks like if we boot with all
> devices in D0 (which I would expect to be a very common case), we don't
> touch ASPM configuration at all.  That would mean we would just leave
> the BIOS settings alone.
>
> It seems pretty surprising that it could have been this way since
> v3.6, when db288c9c5f9d was merged, and we haven't noticed until now,
> but if most BIOSes configure ASPM themselves, maybe it's possible.
>
> But I wonder if we can untangle ASPM from pci_set_power_state().  I
> don't think they're really related.  There are a zillion .suspend()
> and .resume() methods that call pci_set_power_state().  I doubt that
> we need to do ASPM configuration during suspend, and I'm dubious about
> resume, too.  What about a patch like the following?
>

yes. this looks better. I've tested this and is working fine.
I'll push a new patch with this.

>
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 63a54a340863..75fabd1f72bc 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -839,12 +839,6 @@ int pci_set_power_state(struct pci_dev *dev, pci_power_t state)
>
>         if (!__pci_complete_power_transition(dev, state))
>                 error = 0;
> -       /*
> -        * When aspm_policy is "powersave" this call ensures
> -        * that ASPM is configured.
> -        */
> -       if (!error && dev->bus->self)
> -               pcie_aspm_powersave_config_link(dev->bus->self);
>
>         return error;
>  }
> @@ -1195,12 +1189,18 @@ int __weak pcibios_enable_device(struct pci_dev *dev, int bars)
>  static int do_pci_enable_device(struct pci_dev *dev, int bars)
>  {
>         int err;
> +       struct pci_dev *bridge;
>         u16 cmd;
>         u8 pin;
>
>         err = pci_set_power_state(dev, PCI_D0);
>         if (err < 0 && err != -EIO)
>                 return err;
> +
> +       bridge = pci_upstream_bridge(dev);
> +       if (bridge)
> +               pcie_aspm_powersave_config_link(bridge);
> +
>         err = pcibios_enable_device(dev, bars);
>         if (err < 0)
>                 return err;
