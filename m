Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbaBTQxP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 11:53:15 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:45783 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518AbaBTQxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 11:53:13 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1402201102290.4468@ionos.tec.linutronix.de>
References: <20140220071145.21609.89019.stgit@viggo.jf.intel.com>
	<alpine.DEB.2.02.1402201102290.4468@ionos.tec.linutronix.de>
Date: Thu, 20 Feb 2014 08:53:12 -0800
Message-ID: <CAPcyv4h0iHXt5jioOt=WMmrobJ-6Si2SALxGZoibJphB2=+XkQ@mail.gmail.com>
Subject: Re: [PATCH] ioat: fix tasklet tear down
From: Dan Williams <dan.j.williams@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Mike Galbraith <bitbucket@online.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, stable@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 2:30 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> B1;3202;0cOn Wed, 19 Feb 2014, Dan Williams wrote:
>
>> Since commit 77873803363c "net_dma: mark broken" we no longer pin dma
>> engines active for the network-receive-offload use case.  As a result
>> the ->free_chan_resources() that occurs after the driver self-test no
>> longer has a NET_DMA induced ->alloc_chan_resources() to back it up.  A
>> late firing irq can lead to ksoftirqd spinning indefinitely due to the
>> tasklet_disable() performed by ->free_chan_resources().  Only
>> ->alloc_chan_resources() can clear this condition in affected kernels.
>>
>> This problem has been present since commit 3e037454bcfa "I/OAT: Add
>> support for MSI and MSI-X" in 2.6.24, but is now exposed. Given the
>> NET_DMA use case is deprecated we can revisit moving the driver to use
>> threaded irqs.  For now, just tear down the irq and tasklet properly by:
>
> Right, moving to threaded irqs would get rid of the whole tasklet
> mess.
>
>> 1/ Disable the irq from triggering the tasklet
>>
>> 2/ Disable the irq from re-arming
>>
>> 3/ Flush inflight interrupts
>>
>> 4/ Flush the timer
>>
>> 5/ Flush inflight tasklets
>>
>> References:
>> https://lkml.org/lkml/2014/1/27/282
>> https://lkml.org/lkml/2014/2/19/672
>>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@elte.hu>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: <stable@vger.kernel.org>
>> Reported-by: Mike Galbraith <bitbucket@online.de>
>> Reported-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
>
> As Mike pointed out tsi721_free_chan_resources() has the same issue.
>
> I did a quick scan of all tasklet_disable() sites. The teardown or
> similar wreckage is available in:
>
> drivers/atm/he.c
> drivers/dma/at_hdmac.c
> drivers/dma/pch_dma.c
> drivers/input/keyboard/omap-keypad.c
> drivers/isdn/gigaset/interface.c
> drivers/media/pci/mantis/mantis_dvb.c
> drivers/mmc/host/s3cmci.c
> drivers/net/ethernet/jme.c
> drivers/net/ethernet/silan/sc92031.c
> drivers/net/usb/r8152.c
> drivers/net/wireless/mwl8k.c
> drivers/ntb/ntb_hw.c
> drivers/rapidio/devices/tsi721_dma.c
> drivers/s390/crypto/ap_bus.c
> drivers/spi/spi-pl022.c
> drivers/staging/cxt1e1/linux.c
> drivers/staging/ozwpan/ozhcd.c
> drivers/usb/gadget/fsl_qe_udc.c
>
> That's 18 of 30 usage sites. Impressive....
>
> We need to poke the relevant maintainers to get this solved.
>

Maybe also rename tasklet_disable() to tasklet_pause() to make it
clearer "this isn't the tasklet cleanup routine you're looking for"?
