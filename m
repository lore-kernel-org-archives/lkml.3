Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961AbbAUUA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 15:00:58 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58938 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbbAUUAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 15:00:49 -0500
Message-ID: <1421870361.3430.12.camel@pengutronix.de>
Subject: Re: [PATCH 3/5] PCI: st: Provide support for the sti PCIe controller
From: Lucas Stach <l.stach@pengutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Gabriel Fernandez <gabriel.fernandez@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>, Mohit Kumar <mohit.kumar@st.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Fabrice Gasnier <fabrice.gasnier@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Thierry Reding <treding@nvidia.com>,
        Minghuan Lian <Minghuan.Lian@freescale.com>,
        Magnus Damm <damm@opensource.se>, Will Deacon <will.deacon@arm.com>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Pratyush Anand <pratyush.anand@st.com>,
        Sachin Kamat <sachin.kamat@samsung.com>, Andrew Lunn <andrew@lunn.ch>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Srikanth Thokala <sthokal@xilinx.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>, linux-pci@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Date: Wed, 21 Jan 2015 20:59:21 +0100
In-Reply-To: <6574269.bTBzFhcnBx@wuerfel>
References: <1418812486-12394-1-git-send-email-gabriel.fernandez@linaro.org>
	 <1682713.ac5OoTJoOr@wuerfel>
	 <CAG374jCRByNZuuYxi5+-mKvV7p5-tCf2G+8mTYfzU4rRV4yfYQ@mail.gmail.com>
	 <6574269.bTBzFhcnBx@wuerfel>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:fa0f:41ff:fe58:4010
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 21.01.2015, 20:35 +0100 schrieb Arnd Bergmann:
> On Wednesday 21 January 2015 16:47:36 Gabriel Fernandez wrote:
> > On 19 January 2015 at 14:49, Arnd Bergmann <arnd@arndb.de> wrote:
> > > On Monday 19 January 2015 13:37:33 Gabriel Fernandez wrote:
> > >> On 17 December 2014 at 23:14, Arnd Bergmann <arnd@arndb.de> wrote:
> > >> > On Wednesday 17 December 2014 11:34:44 Gabriel FERNANDEZ wrote:
> > >> > > +/*
> > >> > > + * On ARM platforms, we actually get a bus error returned when the PCIe
> > >> > IP
> > >> > > + * returns a UR or CRS instead of an OK.
> > >> > > + */
> > >> > > +static int st_pcie_abort_
> > >> >
> > >> > handler(unsigned long addr, unsigned int fsr,
> > >> > > +                              struct pt_regs *regs)
> > >> > > +{
> > >> > > +     return 0;
> > >> > > +}
> > >> >
> > >> > You should check that it's actually PCI that caused the abort. Don't
> > >> > just ignore a hard error condition.
> > >> >
> > >> > Usually there are registers in the PCI core that let you identify what
> > >> > happened.
> > >> >
> > >>
> > >>
> > >> We return 0 because abort handler is not activated during boot.
> > >>
> > >
> > > Can you just remove the handler then? We should never have exception
> > > handlers that unconditionally return 0.
> > >
> > 
> > Ah sorry, we need the handler because we can received aborts from
> > user-land after the boot.
> > 
> > I have 2 solutions, the first to simplify we can only return 0.
> > The second is to manage handler during boot. Then i need for that a
> > new patch from Fabrice
> > https://lkml.org/lkml/2014/2/7/631
> 
> I still don't get it. What is causing the abort? Is that something
> user space does, or is it just a condition that gets stuck the pcie
> device after probing that gets delivered once as soon as the aborts
> are enabled?
> 
The abort is caused by the kernel trying to access a non-existent device
while probing the bus. It isn't delivered to the ARM core, as it is an
imprecise external abort which are masked during boot.
Once pid1 is started and we do the first schedule imprecise aborts get
unmasked and pid1 will be hit by the stale abort.

The above patch does the right thing by unmasking imprecise abort early
during boot, so they can get handled once they are hit.

The abort handling for the DW PCIe core right now is a complete
disaster. Hooking the fault code means we possibly overwrite any other
handler for the same abort. Also as the configuration space is mapped as
device memory the abort actually happens on the *next* instruction after
the read that caused it. Improving this is something I had on my to-do
list for quite some time now. 

Regards,
Lucas


