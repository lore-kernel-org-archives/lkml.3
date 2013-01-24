Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab3AXRpg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 12:45:36 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:61793 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab3AXRpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 12:45:34 -0500
MIME-Version: 1.0
In-Reply-To: <1356702623-9430-1-git-send-email-js1304@gmail.com>
References: <1356702623-9430-1-git-send-email-js1304@gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 24 Jan 2013 10:45:13 -0700
Message-ID: <CAErSpo5_dgH1Au3QChVrhqBY_Fm54+Aw_ZiwGf2JSsgQaR1dug@mail.gmail.com>
Subject: Re: [PATCH] x86, reboot: skip reboot_fixups in early boot phase
To: Joonsoo Kim <js1304@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 6:50 AM, Joonsoo Kim <js1304@gmail.com> wrote:
> During early boot phase, PCI bus subsystem is not yet initialized.
> If panic is occured in early boot phase and panic_timeout is set,
> code flow go into emergency_restart() and hit mach_reboot_fixups(), then
> encounter another panic. When second panic, we can't hold a panic_lock, so
> code flow go into panic_smp_self_stop() which prevent system to restart.
>
> For avoid second panic, skip reboot_fixups in early boot phase.
> It makes panic_timeout works in early boot phase.
>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Signed-off-by: Joonsoo Kim <js1304@gmail.com>
>
> diff --git a/arch/x86/kernel/reboot_fixups_32.c b/arch/x86/kernel/reboot_fixups_32.c
> index c8e41e9..b9b8ec9 100644
> --- a/arch/x86/kernel/reboot_fixups_32.c
> +++ b/arch/x86/kernel/reboot_fixups_32.c
> @@ -89,6 +89,10 @@ void mach_reboot_fixups(void)
>         if (in_interrupt())
>                 return;
>
> +       /* During early boot phase, PCI is not yet initialized */
> +       if (system_state == SYSTEM_BOOTING)
> +               return;
> +
>         for (i=0; i < ARRAY_SIZE(fixups_table); i++) {
>                 cur = &(fixups_table[i]);
>                 dev = pci_get_device(cur->vendor, cur->device, NULL);

I guess you're saying that if we call pci_get_device() too early, it
panics?  Did you figure out why that happens?

If we call pci_get_device() before PCI has been initialized, it would
be good if it just returned NULL, indicating that we didn't find any
matching device.  I looked briefly, and I thought that's what would
happen, but apparently I'm missing something.

Bjorn
