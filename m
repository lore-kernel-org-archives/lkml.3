Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab3JaFXL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 01:23:11 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:5146 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab3JaFXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 01:23:09 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 30 Oct 2013 22:18:07 -0700
Message-ID: <5271E939.2070309@nvidia.com>
Date: Thu, 31 Oct 2013 14:23:05 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>, Mark Brown <broonie@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: Any news on Runtime Interpreted Power Sequences
References: <20131025112224.6e5265e6@notabene.brown>	<526A0E71.100@nvidia.com>	<20131025183345.2b963e13@notabene.brown>	<526E3605.9080002@nvidia.com>	<20131028221004.3294c1ea@notabene.brown>	<20131028235344.GB16686@sirena.org.uk>	<20131029111037.6e59499d@notabene.brown>	<20131029161816.GE16686@sirena.org.uk> <20131031155946.1890db5a@notabene.brown>
In-Reply-To: <20131031155946.1890db5a@notabene.brown>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2013 01:59 PM, NeilBrown wrote:
> * PGP Signed by an unknown key
>
> On Tue, 29 Oct 2013 09:18:16 -0700 Mark Brown <broonie@kernel.org> wrote:
>
>> On Tue, Oct 29, 2013 at 11:10:37AM +1100, NeilBrown wrote:
>>
>>> Yes, the device is soldered down and has a reset line that needs to be pulsed
>>> low at about the same time that the MMC port enables the regulator.
>>
>>> How do you propose that I describe this?  Which driver should know about the
>>> reset GPIO, how to I tell it about the GPIO, and which function should do the
>>> pulsing?
>>
>> I'd expect the driver for the device to know about this, obviously
>> depending on what this actually does it might want to use this at
>> runtime (for example, putting the device into reset to minimise power
>> while it's idle).  We really need a generic way for devices such as this
>> on enumerable buses to run before the current probe() in order to allow
>> them to manage their power up sequences in embedded systems, this is
>> *far* from a unique situation.
>
> I agree.
> To me, this sounds a lot like saying "We need a way for enumerable buses to
> be given a power-on-sequence to power on the attached device".  That is what
> I hopped RIPS would provide.

There are a few ad-hoc solutions that provide such a mechanism using 
platform data. Take for instance 
include/linux/platform_data/brcmfmac-sdio.h. It allows you to register a 
platform device which sole purpose is to control the power sequence of a 
SDIO network device. When the platform device is registered, it powers 
the network device which can then be probed by the bus. The network 
driver also calls the platform power on/off functions when appropriate.

This works quite well in the case of board files where you can write 
power sequencing code freely, but the question is how to translate it to 
device tree. You need to translate several, board-specific (and not 
device-specific) functions. Here I have to admit this seems like a good 
fit for in-DT power sequences.

> Maybe various devices could allow other devices to register for call-backs
> when the first device activates or deactivates a port  (whether an MMC port or
> USB or Serial or whatever).
> Then a driver that needs to control the power-on sequence would register as a
> platform-device which registers a call-back with the appropriate parent and
> performs the required power-on/off.
>
> Does that sound like the right sort of thing?

I think it does, but you are still left with the problem of how and 
where to define that board-specific power sequence. If things were 
always as simple as turning a regulator on, this would be easy, but 
apparently we also face more complex cases.

Alex.

