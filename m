Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbaKYLJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:09:47 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:49265 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875AbaKYLJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 06:09:41 -0500
Message-ID: <54746349.3000306@ti.com>
Date: Tue, 25 Nov 2014 13:08:57 +0200
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Mike Turquette <mturquette@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kevin Hilman <khilman@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Rob Herring" <robh+dt@kernel.org>, <ssantosh@kernel.org>
Subject: Re: [PATCH v4 1/2] ARM: keystone: pm: switch to use generic pm domains
References: <1415631557-22897-1-git-send-email-grygorii.strashko@ti.com> <2997659.fTX2lvxXfH@wuerfel> <20141125064406.12298.57929@quantum> <15074721.IbfeeI3ajE@wuerfel>
In-Reply-To: <15074721.IbfeeI3ajE@wuerfel>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On 11/25/2014 12:33 PM, Arnd Bergmann wrote:
> On Monday 24 November 2014 22:44:06 Mike Turquette wrote:
>> Quoting Arnd Bergmann (2014-11-24 02:50:28)
>>>
>>> Could the driver maybe identify the clocks that it wants to manage itself
>>> to the pm-domain code? If it's safe for a device to have the clock turned
>>> on at the default rate before loading the driver, any device that is connected
>>> to the simple clk-pm-domain code could have all its clocks start out as
>>> owned by the pm-domain, but then claim the clocks it needs to reprogram for
>>> itself and take them out of the pmdomain.
>>
>> I was thinking along similar lines. The functional versus optional stuff
>> is really a property of the consuming device, not the clock signal
>> itself.
>>
>> Instead of adding a new property to the clock binding (e.g. fck-clocks
>> or optional-clocks), could we simply wrap those lists of clocks in
>> another node? E.g:
>>
>> mandatory-clocks {
>>         clocks = <&papllclk>, <&clkcpgmac>;
>>         clock-names = "clk_pa", "clk_cpgmac";
>> }
>>
>> clocks = <&papllclk>, <&clkcpgmac>, <&chipclk12>;

optional-clocks { ?
>>         clocks = <&clkcpgmac>;         

	   clocks = <&chipclk12>; ?

>>         clock-names = "cpsw_cpts_rft_clk";
>> }
>>
>> I'm showing my DT ignorance on this one. I haven't really thought
>> through how these sub-nodes would work with of_clk_* handlers in
>> drivers/clk/clkdev.c.

As I remember, there was nack for sub-nodes approach from Olof :(
"[RFC 0/2] pwrseq: Add subsystem for power sequences"
http://thread.gmane.org/gmane.linux.power-management.general/46635

> 
> I'm not sure I even understand what you intended the example to look
> like, it does't parse ;-)
> 
> My point above was completely different, the suggestion I made was
> to not classify the clocks in DT at all, but to leave it all in
> the client driver.

I slept with this idea :) From one side it sounds good. Pls, Correct me if I'm wrong:
- there still will be "simple-pmdomain" and all devices will be attached to it by
   default (or as specified in DT power-domains = <&simple_pmdomain>;);
- drivers will use smth. like pm_clk_remove() to remove optional clocks from pm_clk;

>From another side:
- drivers will get dependency from pm_clk;
- HW limitations can't be taken into account - it's possible that some clocks should
  not be enabled until it's allowed. And only driver know when it's allowed.
  Otherwise, HW state may become unspecified or wrong output can be generated.

regards,
-grygorii
