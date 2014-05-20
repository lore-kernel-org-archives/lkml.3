Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751182AbaETUeo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 16:34:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34551 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaETUem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 16:34:42 -0400
Date: Wed, 21 May 2014 05:34:32 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Takashi Iwai <tiwai@suse.de>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        USB list <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Holger Hans Peter Freyther <holger@moiji-mobile.com>,
        Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH 02/10] xhci: 'noxhci_port_switch' kernel parameter
Message-ID: <20140520203432.GB30178@kroah.com>
References: <1399566363-25837-1-git-send-email-mathias.nyman@linux.intel.com>
 <1399566363-25837-3-git-send-email-mathias.nyman@linux.intel.com>
 <20140520010137.GA8146@kroah.com>
 <537B24B8.9050303@linux.intel.com>
 <s5ha9acbwwo.wl%tiwai@suse.de>
 <CAPcyv4gg164u8Dz0RtV4KjXkDyCMvuC92j6VopqTbA1Shp_3QA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4gg164u8Dz0RtV4KjXkDyCMvuC92j6VopqTbA1Shp_3QA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 11:25:37AM -0700, Dan Williams wrote:
> On Tue, May 20, 2014 at 2:51 AM, Takashi Iwai <tiwai@suse.de> wrote:
> > At Tue, 20 May 2014 12:47:36 +0300,
> > Mathias Nyman wrote:
> >>
> >> On 05/20/2014 04:01 AM, Greg KH wrote:
> >> > On Thu, May 08, 2014 at 07:25:55PM +0300, Mathias Nyman wrote:
> >> >> From: Dan Williams <dan.j.williams@intel.com>
> >> >>
> >> >> Add a command line switch for disabling ehci port switchover.  Useful
> >> >> for working around / debugging xhci incompatibilities where ehci
> >> >> operation is available.
> >> >>
> >> >> Reference: http://marc.info/?l=linux-usb&m=138920063001509&w=2
> >> >>
> >> >> Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
> >> >> Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
> >> >> Cc: Holger Hans Peter Freyther <holger@moiji-mobile.com>
> >> >> Suggested-by: Alan Stern <stern@rowland.harvard.edu>
> >> >> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> >> >> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> >> >> ---
> >> >>  Documentation/kernel-parameters.txt |  3 +++
> >> >>  drivers/usb/host/pci-quirks.c       | 15 +++++++++++++--
> >> >>  2 files changed, 16 insertions(+), 2 deletions(-)
> >> >>
> >> >> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> >> >> index 4384217..fc3403114 100644
> >> >> --- a/Documentation/kernel-parameters.txt
> >> >> +++ b/Documentation/kernel-parameters.txt
> >> >> @@ -2251,6 +2251,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
> >> >>
> >> >>    nox2apic        [X86-64,APIC] Do not enable x2APIC mode.
> >> >>
> >> >> +  noxhci_port_switch
> >> >> +                  [USB] Use EHCI instead of XHCI where available
> >> >> +
> >> >
> >> > Ugh, I really don't like new command line options.
> >> >
> >> > Especially one that isn't very well documented.  Why would someone want
> >> > to enable this?  What problem is it solving?  Can we detect this
> >> > automatically and do it for the user?  Is this just for prototype
> >> > hardware that has not shipped?  What hardware needs this?
> >> >
> >> > I need a whole lot more documentation at the very least before I will
> >> > apply this.
> >> >
> >>
> >> On Intel hardware with both ehci and xhci controllers we can select if a usb2 port
> >> is controlled by ehci or xhci. This capability can be checked from Intel xhci pci
> >> config space. Xhci driver checks this on boot and switches over the supported ports.
> >>
> >> This is a feature in Intel Panther point and later chipsets, in shipped hardware.
> >> Its working quite well in most cases, but sometimes vendors claim they support
> >> switchover, but then forget to connect some wires, and the usb2 port ends up dead
> >> after switching.
> >>
> >> A recently found case is the Sony VAIO T-series. (I'll send you a different patch
> >> for that shortly)
> >> http://marc.info/?l=linux-usb&m=139993106029340&w=2
> >>
> >> This is the extreme case that the usb2 ports appears completely dead.
> >> Other reasons are that some devices might work better under ehci than xhci,
> >> and users want to enforce the ehci opton. For powermanagement developers it's nice
> >> to disable switchover as it turns out some hardware are quirky with port
> >> switchover and suspend/resume. (might need to turn port back to ehci before
> >> suspending).
> >>
> >> I don't think we can detect this automatically.
> >>
> >> Dan, can you add more documentation to this patch?
> >
> > While we're at it: can we implement a bitmask instead?
> >
> > We've seen lots of HP laptops having Webcams or BT devices that don't
> > work XHCI but only with EHCI.  For making them working properly, the
> > specific xhci ports have to be disabled.  But, we don't want to kill
> > the whole XHCI at all.  The single boolean option doesn't work for
> > such a case.
> >
> 
> I'm not sure we want to make this more complex.  Ideally this is just
> a stop-gap measure for users to workaround incompatibilities in xhci
> while the xhci fix is identified.

We can't use a kernel command line option as a "stop-gap", sorry.  Let's
just fix the real problem here.

thanks,

greg k-h
