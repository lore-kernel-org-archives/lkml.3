Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab3LPRjL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 12:39:11 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:37681 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab3LPRjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 12:39:09 -0500
Date: Mon, 16 Dec 2013 09:39:07 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Rajat Jain <rajatjain@juniper.net>, Yinghai Lu <yinghai@kernel.org>,
        Rajat Jain <rajatjain.linux@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Paul Bolle <pebolle@tiscali.nl>,
        Rajat Jain <rajatxjain@gmail.com>, Guenter Roeck <groeck@juniper.net>
Subject: Re: [PATCH v2 2/4] pciehp: Use link change notifications for
 hot-plug and removal
Message-ID: <20131216173907.GC1811@roeck-us.net>
References: <529E5C0E.80903@gmail.com>
 <20131212224407.GL4699@google.com>
 <CAE9FiQX8XXkwbhhuNhCF-pHdc_3or_dMEH-VN5NBSEV_eXE-Pg@mail.gmail.com>
 <CAErSpo5BsaLNrny3T1sYknz3wo4hN0SKJk0_u6eNyEd6qq5o=g@mail.gmail.com>
 <428d664592c2466c9e5e6b393df9d690@DM2PR05MB671.namprd05.prod.outlook.com>
 <CAErSpo5NjOCqkao03Ea=98gunVEaUUitq8mGLarpKW_DQoDF8g@mail.gmail.com>
 <CAE9FiQX-ZP0R-weuPoOJ6GkPxOLp5jk9thnjfPQ+Q5tCHugD4w@mail.gmail.com>
 <20131214033911.GA25115@roeck-us.net>
 <241775f7fb71476aa84bbb19fde4602f@DM2PR05MB671.namprd05.prod.outlook.com>
 <CAErSpo4grMgCBetm7DMmizWQS_peM5yYBwFS99K8jbXaEWGmEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo4grMgCBetm7DMmizWQS_peM5yYBwFS99K8jbXaEWGmEg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 15, 2013 at 05:18:26PM -0700, Bjorn Helgaas wrote:
> On Sun, Dec 15, 2013 at 4:24 PM, Rajat Jain <rajatjain@juniper.net> wrote:
> >> > >
> >> > >> Once again: the way I interpret this is: * Always enable Link events.
> >> > >> * Disable presence events if attention button is present.
> >> > >
> >> > > That sounds like a good plan to me.
> >> >
> >> > How about Diag_Reset from MPT2SAS and others?  link could up and down
> >> >
> >
> > I am assuming you are referring to
> >
> > static int _base_diag_reset(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
> >
> > Which as far as I could understand would cause link to go down and come up
> > again without the kernel knowing anything about it?  ...
> 
> > In general, I guess the question is when a link goes down and back up,
> > whether or not we want to treat it as a hot unplug followed by a hotplug. I
> > think there may be cases such as AER (or the one Yinghai mentions) where we
> > don't want to treat it as a hotplug (see note below). And there may be cases
> > that we definitely want to treat it as hotplug (need link events!).
> > Situation gets more complex since there may be pciehp slots downstream of a
> > link getting reset.
> >
> > It seems to me that we are saying that a mechanism is needed so that a
> > voluntary Link flap is NOT treated like a hotplug temporarily?  ...
> 
> > Notes: * it may not OK, if the kernel thinks the device is accessible when
> > it is really not.  What if during this downtime, someone tries to access the
> > device (say userspace)?  * How do we know after the link up, that the device
> > is really the same.  If during this reset, the device changed its
> > "character", say a different class?  I think a rescan should be mandated
> > after every such event.  * Do we need to unload and reload the driver after
> > the link reset, since it can be a different device?
> 
> I am quite dubious about the idea of a voluntary link flap.  If the link goes
> down and comes back up, I don't see how we can make any assumptions about what
> device is there.
> 
> I let Alex talk me into pciehp_reset_slot(), which disables presence detect
> interrupts while resetting a device, so we already have a bit of precedent for
> the idea.  But even in that case, the device could easily come out of reset as
> a different device, e.g., if the reset caused it to load updated firmware.
> 
> I would feel much better if we treated link down as a remove and did a rescan
> on the link up.
> 
Agreed. Question is if we might need some means for a driver to tell the PCIe
core about an upcoming "planned" link flap. pciehp_reset_slot() doesn't seem
to address the condition where a driver resets a connected chip by other means
than by calling pciehp_reset_slot(). Still not sure what happens when the
mpt2sas driver issues its diagnostic reset, to take Yinghai's example (or if
there would be a cleaner way to implement such a reset).

Guenter
