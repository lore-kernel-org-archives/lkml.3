Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148AbaCPXyR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 19:54:17 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:58704 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932094AbaCPXyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 19:54:12 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Stephane Eranian <eranian@google.com>
Cc: Borislav Petkov <bp@alien8.de>, lkml <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Linux PCI <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Info: mapping multiple BARs. Your kernel is fine.
Date: Mon, 17 Mar 2014 01:09:39 +0100
Message-ID: <1425376.F2qgSAxAbW@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc6+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CABPqkBSmes+ee19iVh0EHvMQ=7TAzN3Fx1BKdOZ-2iuk5L0ugw@mail.gmail.com>
References: <20140224162400.GE16457@pd.tnic> <20140316115546.GA11935@nazgul.tnic> <CABPqkBSmes+ee19iVh0EHvMQ=7TAzN3Fx1BKdOZ-2iuk5L0ugw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, March 16, 2014 02:08:16 PM Stephane Eranian wrote:
> Rafael,
> 
> Thanks for the analysis.
> 
> On Sun, Mar 16, 2014 at 12:55 PM, Borislav Petkov <bp@alien8.de> wrote:
> > On Sat, Mar 15, 2014 at 03:15:04PM +0100, Rafael J. Wysocki wrote:
> >> I've just gone throught this.
> >
> > Thanks.
> >
> >> So the problem is that we have the PNP "system" driver whose only purpose seems
> >> to be to reserve system resources so that the PCI layer doesn't assign them to
> >> new devices on hotplug (disclaimer: I didn't invent it, I only read the code and
> >> comments in there).
> >>
> >> It does that for ACPI device objects having the "PNP0C02" and "PNP0C01" IDs.
> >
> > Right, pnp 00:01 is PNP0C02.
> >
> >> Apparently, snb_uncore_imc_init_box() steps on a range already reserved by that
> >> driver on your box.  And this doesn't seem to be a coincidence, because the ACPI
> >> device object in question probably *does* correspond to the memory controller
> >> that the uncore driver attempts to use.
> >>
> >> I'm not sure how to address that right now to be honest.  Arguably, the PNP
> >> "system" driver should be replaced with something saner, but still the
> >> resources it claims need to be kept out of reach of the PCI's resource
> >> allocation code.
> >
> > Well, I'm only conjecturing here but there should be a way for the
> > uncore code to tell the PNP "system" driver to free this resource
> > because uncore is going to use it now. Or something to that effect.
> >
> I agree. The snb_uncore_imc() is making real (good) use of the device.
> It needs to own it. So we need a way to free the resource from the PNP
> system or  a way to tell PNP need to grab it on systems with the
> snb_uncore_imc() support. Does that kind of API exist?
> 
> Where do I look to prevent PNP from grabbing the IMC?

drivers/pnp/system.c is the driver in question and system_pnp_probe() makes
the reservations via reserve_resources_of_dev(), so you'd need to modify that.

I'm not sure what's the right way to go here, though.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
