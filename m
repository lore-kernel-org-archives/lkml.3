Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669Ab3BQIlU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 03:41:20 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:49964 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab3BQIlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 03:41:19 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 17 Feb 2013 09:41:00 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Mark Einon <mark.einon@gmail.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, stern@rowland.harvard.edu
Subject: Re: [PATCH v3] firewire: Fix ohci free_irq() warning
Message-ID: <20130217094100.7a5d17e3@stein>
In-Reply-To: <1360061927-3359-1-git-send-email-mark.einon@gmail.com>
References: <1359748245-3674-1-git-send-email-mark.einon@gmail.com>
	<1360061927-3359-1-git-send-email-mark.einon@gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 05 Mark Einon wrote:
> This patch fixes the kernel warning below, generated when putting an
> MSI MS-1727 GT740 laptop into suspend mode. The call sequence in this
> case calls free_irq() twice, once in pci_suspend() and once then in
> pci_remove().
> 
> The fix breaks up the ohci_enable() call into four separate calls -
> ohci_enable_regs(), ohci_create_irq(), ohci_enable_irq() and
> ohci_enable_run(). The original call sequence of ohci_enable() is replaced
> by the four calls, but the ohci_enable() called from pci_resume() is
> replaced by three of the calls, missing out ohci_create_irq().
> 
> Finally, a new call, ohci_disable_irq(), replaces the free_irq() in
> pci_suspend() which sets the irq mask to zero.
[...]

Hi,
I haven't forgotten about this patch; just didn't fully check it yet
because I still wanted to look whether there is a more minimalistic
way.  Perhaps I'll post something in the next days.

> @@ -3766,7 +3811,7 @@ static int pci_suspend(struct pci_dev *dev, pm_message_t state)
>  	int err;
>  
>  	software_reset(ohci);
> -	free_irq(dev->irq, ohci);
> +	ohci_disable_irq(ohci);
>  	pci_disable_msi(dev);
>  	err = pci_save_state(dev);
>  	if (err) {
> @@ -3802,10 +3847,13 @@ static int pci_resume(struct pci_dev *dev)
>  		reg_write(ohci, OHCI1394_GUIDHi, (u32)(ohci->card.guid >> 32));
>  	}
>  
> -	err = ohci_enable(&ohci->card, NULL, 0);
> +	err = ohci_enable_regs(&ohci->card, NULL, 0);
>  	if (err)
>  		return err;
>  
> +	ohci_enable_irq(ohci);
> +	ohci_enable_run(ohci);
> +
>  	ohci_resume_iso_dma(ohci);
>  
>  	return 0;

Looks like pci_{en,dis}able_msi are now unbalanced.  I suppose we better
place them immediately around {request,free}_irq.
-- 
Stefan Richter
-=====-===-= --=- =---=
http://arcgraph.de/sr/
