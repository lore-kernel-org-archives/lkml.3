Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392AbaKFDJ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 22:09:29 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:37336 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbaKFDJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 22:09:24 -0500
Date: Wed, 5 Nov 2014 22:09:16 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Chen Gang <gang.chen.5i5j@gmail.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH next] xen: pcifront: Process failure for
 pcifront_(re)scan_root()
Message-ID: <20141106030916.GA4186@laptop.dumpdata.com>
References: <469h2cuyy0a5y5fn77uh3y1b.1413332405802@email.android.com>
 <20141015210355.GB6579@laptop.dumpdata.com>
 <544AD7CF.5020006@gmail.com>
 <CAErSpo78mX9Q8HDsOFMhzNTjtGqD1aiTTrWH-zwGUEo24EF9CA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo78mX9Q8HDsOFMhzNTjtGqD1aiTTrWH-zwGUEo24EF9CA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 04:31:17PM -0700, Bjorn Helgaas wrote:
> [+cc linux-pci again]
> 
> On Fri, Oct 24, 2014 at 4:50 PM, Chen Gang <gang.chen.5i5j@gmail.com> wrote:
> > On 10/16/14 5:03, Konrad Rzeszutek Wilk wrote:
> >> On Wed, Oct 15, 2014 at 08:20:06AM +0800, Chen Gang wrote:
> >>>
> >>> At least for me, what you said sound OK.
> >>
> >> Let me review it - next week.
> >
> > Please help check this patch, when you have time.
> 
> linux-pci got dropped from the cc list, which makes it harder for me
> to track this in patchwork.
> 
> But I'm waiting for Konrad to either ack this or just take it
> directly.  Here's my ack if you want it:
> 
> Acked-by: Bjorn Helgas <bhelgaas@google.com>

Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Bjorn, if you would like to pick it up that would be good!
> 
> >>> Bjorn Helgaas <bhelgaas@google.com> wrote:
> >>>
> >>>> On Mon, Oct 06, 2014 at 11:04:45AM +0800, Chen Gang wrote:
> >>>>> When pcifront_rescan_root() or pcifront_scan_root() fails, need return
> >>>>> error code, neither set XenbusStateConnected state, just like the other
> >>>>> areas have done.
> >>>>>
> >>>>> For pcifront_rescan_root(), it will return error code ("num_roots = 0;",
> >>>>> skip xenbus_switch_state return value).
> >>>>>
> >>>>> For pcifront_scan_root(), it will return 0 ("num_roots = 0;", set 0 by
> >>>>> the return value of xenbus_switch_state, which always return 0, at
> >>>>> present).
> >>>>
> >>>> The changelog is somewhat confusing because it talks about the patch hunks
> >>>> in reverse order (the pcifront_scan_root() change is first in the patch,
> >>>> but the changelog mentions pcifront_rescan_root() first).  I *think* this
> >>>> means:
> >>>>
> >>>>  When pcifront_try_connect() finds no PCI roots, it falls back to calling
> >>>>  pcifront_scan_root() for 0000:00.  If that fails, it used to switch to
> >>>>  XenbusStateConnected and return success (because xenbus_switch_state()
> >>>>  currently always succeeds).
> >>>>
> >>>>  If pcifront_scan_root() fails, leave the XenbusState unchanged and
> >>>>  return an error code.
> >>>>
> >>>>  Similarly, pcifront_attach_devices() falls back to calling
> >>>>  pcifront_rescan_root() for 0000:00.  If that fails, it used to
> >>>>  switch to XenbusStateConnected and return an error code.
> >>>>
> >>>>  If pcifront_rescan_root() fails, leave the XenbusState unchanged and
> >>>>  return the error code.
> >>>>
> >>>> The "num_roots" part doesn't seem relevant to me.
> >>>>
> >>>>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> >>>>
> >>>> Konrad, if you want to take this, feel free.  Otherwise, if you ack it and
> >>>> you think my changelog understanding makes sense, I can pick it up.
> >>>>
> >>>> It does seem odd that pcifront_attach_devices() ignores the
> >>>> xenbus_switch_state() return value while pcifront_try_connect() does not.
> >>>> But many other callers also ignore the return value, so maybe that's OK.

It is OK. We had an discussion about making the xenbus_switch_state an
void. The reason being that if the state change fails we call xenbus_switch_fatal
(which does not return anything) - which then sets the state to XenbusStateClosing.

But for some drivers it makes sense to know about this failure so that
they can deallocate their resources. So ignoring ret is OK if the driver
is OK handling its deallocation in a different way.

> >>>>
> >>>> Bjorn
> >>>>
> >>>>> ---
> >>>>>  drivers/pci/xen-pcifront.c | 10 ++++++++++
> >>>>>  1 file changed, 10 insertions(+)
> >>>>>
> >>>>> diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
> >>>>> index 53df39a..d78d884 100644
> >>>>> --- a/drivers/pci/xen-pcifront.c
> >>>>> +++ b/drivers/pci/xen-pcifront.c
> >>>>> @@ -866,6 +866,11 @@ static int pcifront_try_connect(struct pcifront_device *pdev)
> >>>>>            xenbus_dev_error(pdev->xdev, err,
> >>>>>                             "No PCI Roots found, trying 0000:00");
> >>>>>            err = pcifront_scan_root(pdev, 0, 0);
> >>>>> +          if (err) {
> >>>>> +                  xenbus_dev_fatal(pdev->xdev, err,
> >>>>> +                                   "Error scanning PCI root 0000:00");
> >>>>> +                  goto out;
> >>>>> +          }
> >>>>>            num_roots = 0;
> >>>>>    } else if (err != 1) {
> >>>>>            if (err == 0)
> >>>>> @@ -947,6 +952,11 @@ static int pcifront_attach_devices(struct pcifront_device *pdev)
> >>>>>            xenbus_dev_error(pdev->xdev, err,
> >>>>>                             "No PCI Roots found, trying 0000:00");
> >>>>>            err = pcifront_rescan_root(pdev, 0, 0);
> >>>>> +          if (err) {
> >>>>> +                  xenbus_dev_fatal(pdev->xdev, err,
> >>>>> +                                   "Error scanning PCI root 0000:00");
> >>>>> +                  goto out;
> >>>>> +          }
> >>>>>            num_roots = 0;
> >>>>>    } else if (err != 1) {
> >>>>>            if (err == 0)
> >>>>> --
> >>>>> 1.9.3
> >
> > --
> > Chen Gang
> >
> > Open, share, and attitude like air, water, and life which God blessed
