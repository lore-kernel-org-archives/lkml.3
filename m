Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaIIUPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 16:15:53 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:47909 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbaIIUPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 16:15:52 -0400
Date: Tue, 9 Sep 2014 14:15:43 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Rostislav Lisovy <lisovy@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Yijing Wang <wangyijing@huawei.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH RESEND] ARM: PCI: Use PCI_CLASS_* defines for PCI class
Message-ID: <20140909201543.GC14765@obsidianresearch.com>
References: <1410163532-31057-1-git-send-email-lisovy@gmail.com>
 <CAErSpo7sOc72V3g5tOov8Yj4nKiuJupaUTKEEecHMcqEUrzh_g@mail.gmail.com>
 <20140908180357.GA6159@obsidianresearch.com>
 <CAErSpo7QQMRFKSk4vQCkDeEQQXX87Gq5YAKR+P4bxxcqMSJeDw@mail.gmail.com>
 <20140908200422.GA6204@obsidianresearch.com>
 <CAErSpo56jB1Bf2JtYCGKXZBZqRF1jXFxGmeewPX_e6vSXueGyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo56jB1Bf2JtYCGKXZBZqRF1jXFxGmeewPX_e6vSXueGyA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 01:31:46PM -0600, Bjorn Helgaas wrote:
> On Mon, Sep 8, 2014 at 2:04 PM, Jason Gunthorpe
> <jgunthorpe@obsidianresearch.com> wrote:
> > On Mon, Sep 08, 2014 at 01:39:40PM -0600, Bjorn Helgaas wrote:
> >
> >> > Essentially for that case the mvebu HW is a repurposed end port core,
> >> > so when working as a root port it presents an end port config space
> >> > (not a root port bridge config space). The BAR in that config space is
> >> > not relevant, so the old mvebu used code like this to hide it from the
> >> > PCI core. Otherwise the core will try to program it from the aperture,
> >> > and the default BAR size is really big, so it runs out of space.
> 
> This is a bit of a tangent, but an endpoint has a type 0 config
> header, while a root port is a bridge and has a type 1 config header.
> I don't understand how the PCI core can operate a root port correctly
> if that port has a type 0 config header.

Well, it cannot operate 'correctly' but something gets bodged
together enough to pass basic scenarios..

Everything gets flattened down to bus 0, so the end port config space
gets to be device 0x10, and then config access to other device numbers
are forwarded out as TLPs to whatever is connected, so typically the
connected device shows up as device 0x0.

> It sounds like when these devices are configured as root ports, they
> have BARs visible to the host, which is how dev->resource[] would get
> filled in to begin with.  We manage normal BARs so the CPU can perform
> MMIO accesses to the device.  In this case, it sounds like the BARs
> are more for the benefit of devices below the bridge that want to
> perform DMA.  The PCI core certainly wouldn't know what to do about
> something like that, so I agree the best thing to do is to clear out
> the resource completely and pretend it doesn't exist.  I guess a new
> (not repurposed) design would probably put stuff like this in
> device-specific config space, not in architected BARs.

Yes to all of this.

Jason
