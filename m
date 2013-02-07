Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab3BGKcW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 05:32:22 -0500
Received: from multi.imgtec.com ([194.200.65.239]:36626 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755803Ab3BGKcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 05:32:17 -0500
Message-ID: <511382AD.7030804@imgtec.com>
Date: Thu, 7 Feb 2013 10:32:13 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-next <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Heads up on a device tree change
References: <CACxGe6sCBCGfLDAGVRgP3cnmE+oyXBDdPeVXVCqrsvCh13yPiw@mail.gmail.com> <51125B56.9050407@imgtec.com> <CACxGe6vuZ2H-G7xamS6SAiX_aCbjpO+vKavqCK77ek8tTdOmdA@mail.gmail.com>
In-Reply-To: <CACxGe6vuZ2H-G7xamS6SAiX_aCbjpO+vKavqCK77ek8tTdOmdA@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_02_07_10_32_14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/13 14:28, Grant Likely wrote:
> On Wed, Feb 6, 2013 at 1:32 PM, James Hogan <james.hogan@imgtec.com> wrote:
>> On 06/02/13 13:11, Grant Likely wrote:
>>> - Resources on platform_devices get registered so they appear in
>>> /proc/iomem and /proc/ioports and so that device drivers get the added
>>> protection of request_region. This will cause breakage on device trees
>>> nodes with partially overlapping memory regions. (ie. 0x100..0x1ff and
>>> 0x180..0x27f). I also have a workaround for this, but I doubt that it
>>> will be necessary.
>>
>> Hi Grant,
>>
>> If I understand you correctly, the non-overlapping memory regions thing
>> could be a problem for me. We have a Meta based SoC that has various SoC
>> registers grouped together for doing GPIOs and Pin control things. I'm
>> still in the process of converting it to device tree, but the way I've
>> been handling it is to provide overlapping registers to both the gpio
>> and pinctl DT nodes. Each GPIO bank's registers are also interleaved
>> with the others, so I've been providing overlapping register ranges
>> (offset by 4 for each bank) to the DT node for each gpio bank too, so
>> each bank can function independently and the driver doesn't have to
>> worry about multiple banks. Does that sound like a reasonable use case?
>>
>> I guess I could cheat with the length, or specify each register in it's
>> own memory resource, but it seems like overkill.
> 
> Note that overlapping regions are fine /provided/ that they are the
> same size or one fits nicely inside another. It's partial overlap that
> is a problem

It still feels a bit artificial to impose that limitation on something
that is supposed to be implementation independent. Having said that it
doesn't particularly bother me having to work around it.

> 
> I've been thinking about your exact problem though and I think the
> best way to handle it is for the gpio driver to understand multiple
> banks.

Something like this works quite nicely for me and keeps the driver code
nice and simple (iterates over children a bit like I2C, no need for
gpio-cells=3). I'd welcome comments:

		gpios: gpios@02005800 {
			#address-cells = <1>;
			#size-cells = <0>;
			compatible = "img,tz1090-gpio";
			reg = <0x02005800 0x90>;

			gpios0: bank@0 {
				#gpio-cells = <2>;
				#interrupt-cells = <2>;
				reg = <0>;
				interrupts = <13 4 /* level */>;
				gpio-controller;
				gpio-ranges = <&pinctrl 0 30>;
				interrupt-controller;
			};
			gpios1: bank@1 {
				#gpio-cells = <2>;
				#interrupt-cells = <2>;
				reg = <1>;
				interrupts = <14 4 /* level */>;
				gpio-controller;
				gpio-ranges = <&pinctrl 30 30>;
				interrupt-controller;
			};
			gpios2: bank@2 {
				#gpio-cells = <2>;
				#interrupt-cells = <2>;
				reg = <2>;
				interrupts = <15 4 /* level */>;
				gpio-controller;
				gpio-ranges = <&pinctrl 60 30>;
				interrupt-controller;
			};
		};

Cheers
James

