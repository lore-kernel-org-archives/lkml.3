Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398Ab3BATNk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 14:13:40 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:33383 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756319Ab3BATNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 14:13:38 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1301311002190.1876-100000@iolanthe.rowland.org>
References: <CANK3SE09VqvshdLrV4xp2W8BHZqLmuz-pV9jQVj7tbk1JBX+9g@mail.gmail.com>
 <Pine.LNX.4.44L0.1301311002190.1876-100000@iolanthe.rowland.org>
From: Mark Einon <mark.einon@gmail.com>
Date: Fri, 1 Feb 2013 19:13:23 +0000
Message-ID: <CANK3SE25kcgSu2dwKtQKU6-wvryC4qNQJu_nj3NPJHQTTC0oXw@mail.gmail.com>
Subject: Re: [PATCH] firewire: Fix ohci free_irq() warning
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 January 2013 15:04, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Wed, 30 Jan 2013, Mark Einon wrote:
>
>> >> > >> This patch fixes the kernel warning generated when putting an MSI MS-1727
>> >> > >> GT740 laptop into suspend mode. The call sequence in this case calls
>> >> > >> free_irq() twice, once in pci_remove() and once then in pci_suspend().
>> >> > >
>> >> > > You mean /first/ in pci_suspend() and /then/ in pci_remove() on the
>> >> > > already suspended devices, right?
>> >> >
>> >> > Yes, I did. The call sequence is suspend then resume. My bad.
>> >
>> > Why does the pci_suspend routine call free_irq() at all?  As far as I
>> > know, it's not supposed to do that.  Won't the device continue to use
>> > the same IRQ after it is resumed?
>>
>> This sounds reasonable to me - I think we could probably get rid of
>> the request_irq() call from resume, and use
>> disable_irq()/enable_irq()?
>
> Why mess around with IRQ settings at all?  Just have the suspend
> routine tell the controller to stop generating them.
>
> Alan Stern
>

I looked into doing this; using context_stop() to stop the controller running.

However, removing the enable_irq() from pci_resume() involves not
calling ohci_enable() (as it is also the fw_card_driver.enable
function, and can't easily be modified). As this call involves a lot
of register writes and I have no devices to test, I decided against
it.

I'll send an updated patch for consideration that merely uses a bool
to stop the irq being freed twice - crude, but it works without
changing too much code.

Cheers,

Mark
