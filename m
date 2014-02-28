Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538AbaB1WC4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 17:02:56 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:42121 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbaB1WCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 17:02:54 -0500
MIME-Version: 1.0
In-Reply-To: <20140228215739.GA14992@kroah.com>
References: <1393259343-825-1-git-send-email-mathias.nyman@linux.intel.com>
	<Pine.LNX.4.44L0.1402241243230.1427-100000@iolanthe.rowland.org>
	<20140228203200.GE3405@xanatos>
	<CAPcyv4j4qsuXGqpUEV1rTLDg4jZix_MEQho8fzxYV5eQ9tyusA@mail.gmail.com>
	<20140228215739.GA14992@kroah.com>
Date: Fri, 28 Feb 2014 14:02:53 -0800
Message-ID: <CAPcyv4jjDas8OzjGE3kOr1rfDG17CD5EG0L4Ta85-YQYA1S6Lw@mail.gmail.com>
Subject: Re: [RFC PATCH v2] xhci: Prevent runtime pm from autosuspending
 during initialization
From: Dan Williams <dan.j.williams@intel.com>
To: Greg KH <greg@kroah.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        USB list <linux-usb@vger.kernel.org>, david.a.cohen@linux.intel.com,
        Jianqiang Tang <jianqiang.tang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 1:57 PM, Greg KH <greg@kroah.com> wrote:
> On Fri, Feb 28, 2014 at 12:41:31PM -0800, Dan Williams wrote:
>> On Fri, Feb 28, 2014 at 12:32 PM, Sarah Sharp
>> <sarah.a.sharp@linux.intel.com> wrote:
>> > On Mon, Feb 24, 2014 at 12:44:46PM -0500, Alan Stern wrote:
>> >> On Mon, 24 Feb 2014, Mathias Nyman wrote:
>> >>
>> >> > xHCI driver has its own pci probe function that will call usb_hcd_pci_probe
>> >> > to register its usb-2 bus, and then continue to manually register the
>> >> > usb-3 bus. usb_hcd_pci_probe does a pm_runtime_put_noidle at the end and
>> >> > might thus trigger a runtime suspend before the usb-3 bus is ready.
>> >> >
>> >> > Prevent the runtime suspend by increasing the usage count in the
>> >> > beginning of xhci_pci_probe, and decrease it once the usb-3 bus is
>> >> > ready.
>> >> >
>> >> > xhci-platform driver is not using usb_hcd_pci_probe to set up
>> >> > busses and should not need to have it's usage count increased during probe.
>> >> >
>> >> > Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
>> >> > ---
>> >> >  drivers/usb/host/xhci-pci.c | 11 ++++++++++-
>> >> >  1 file changed, 10 insertions(+), 1 deletion(-)
>> >> >
>> >> > diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
>> >> > index 04f986d..ea7158b 100644
>> >> > --- a/drivers/usb/host/xhci-pci.c
>> >> > +++ b/drivers/usb/host/xhci-pci.c
>> >> > @@ -190,6 +190,10 @@ static int xhci_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
>> >> >     struct usb_hcd *hcd;
>> >> >
>> >> >     driver = (struct hc_driver *)id->driver_data;
>> >> > +
>> >> > +   /* Prevent USB-2 roothub runtime suspend until USB-3 is initialized. */
>> >> > +   pm_runtime_get_noresume(&dev->dev);
>> >>
>> >> Strictly speaking, this prevents the _controller_ from going into
>> >> runtime suspend -- not the root hub.
>> >
>> > Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
>>
>> Pardon the nitpick, but this is an acked-by if Mathias is submitting.
>
> No, it's a "chain of signed-off-by's" and this is allowed just fine (it
> used to be the default-thing before we came up with the "acked-by"
> line...)

Ok. jejb picked on me about it once, but I'm more than willing to drop
this off my list of things to nitpick.
