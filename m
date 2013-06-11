Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab3FKRKQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 13:10:16 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52250 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755349Ab3FKRKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 13:10:11 -0400
Message-ID: <51B759C7.7080806@ti.com>
Date: Tue, 11 Jun 2013 20:09:27 +0300
From: Illia Smyrnov <x0194613@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Illia Smyrnov <illia.smyrnov@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Daniel Mack <zonque@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <spi-devel-general@lists.sourceforge.net>
Subject: Re: [PATCH 2/2] spi: omap2-mcspi: Add FIFO buffer support
References: <1370432398-7796-1-git-send-email-illia.smyrnov@ti.com> <1370432398-7796-3-git-send-email-illia.smyrnov@ti.com> <20130605120346.GZ31367@sirena.org.uk> <51B05FB8.6050903@ti.com> <20130606103032.GR31367@sirena.org.uk>
In-Reply-To: <20130606103032.GR31367@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.193]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2013 01:30 PM, Mark Brown wrote:
> On Thu, Jun 06, 2013 at 01:08:56PM +0300, Illia Smyrnov wrote:
>> On 06/05/2013 03:03 PM, Mark Brown wrote:
>
>>> Why is this defined for slaves?  Surely the size of the FIFO in the
>>> controller is a property of the controller not the slave?
>
>> According to OMAP TRM [1] the FIFO buffer can be used by only one
>> channel at a time. If several channels are selected and several FIFO
>> enable bit fields are set to 1, the controller forces the buffer not
>> to be used.
>
> The controller ought to be able to figure this out for itself.  As a
> first pass just grabbing the FIFO on a first come first served basis
> will probably work well most of the time, the device would have to be
> very active for it to constantly be doing transfers on all channels.
>
> If there's more contention than that we probably ought to be looking at
> how we handle this in general, it seems like we'd have more problems
> than just the FIFO to worry about.
>
>> If there are several slaves on the controller we must select which
>> of slaves will use the FIFO for SPI transfers. Also, optimal FIFO
>
> A single controller is only going to be able to talk to one slave at
> once, everything on the bus except chip select is shared.
>
>> size is heavily dependent of the SPI transfers length specific for
>> certain slave.
>
> The transfer length doesn't seem like something that we want to be
> encoding in DT, particularly not indirectly - it is obviously readily
> available at runtime, variable during runtime (eg, firmware download may
> do large transfers on a device that only does small transfers most of
> the time) and is something that updates to the drivers could change.

I sent patches for v2 of the MCSPI FIFO support implementation. In this 
version driver will calculate the largest possible FIFO buffer size for 
each SPI transfer.
Also FIFO could be enabled by setting up parameter in the MCSPI 
controller (master) DT node.
