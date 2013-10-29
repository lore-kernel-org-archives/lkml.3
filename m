Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625Ab3J2NBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 09:01:08 -0400
Received: from 4.mo6.mail-out.ovh.net ([87.98.184.159]:57964 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755263Ab3J2NBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 09:01:06 -0400
X-Greylist: delayed 8098 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Oct 2013 09:01:06 EDT
Message-ID: <526F8E89.30005@overkiz.com>
Date: Tue, 29 Oct 2013 11:31:37 +0100
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Fabio Porcedda <fabio.porcedda@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Guenter Roeck <groeck7@gmail.com>, Yang Wenyou <wenyou.yang@atmel.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH v5 0/4] watchdog: at91sam9_wdt: handle already configured
 wdt
References: <1380871455-7324-1-git-send-email-b.brezillon@overkiz.com> <20131029075028.GF19704@spo001.leaseweb.com>
In-Reply-To: <20131029075028.GF19704@spo001.leaseweb.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 10260044376695732408
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrgeeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrgeeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wim,

I'm sorry for the inconvenience, but I found some bugs in my patch series:

1) the secs_to_ticks returns an erronous value when 0 is passed as an 
argument
2) the calculated heartbeat is too small for some use cases
     (i.e. kexecing a new kernel might trigger a watchdog reset before 
the new kernel
      is able to load the watchdog driver)
3) when initializing the watchdog driver, the timer should be configured 
with the min_heartbeat value
     instead of the standard heartbeat value, because we don't for how 
long the timer has been running.

I'll send a new patch fixing those issues.
I hope it won't bother you :-(.

Best Regards,

Boris

On 29/10/2013 08:50, Wim Van Sebroeck wrote:
> Hi Boris,
>
>> Hello,
>>
>> This patch series is a porposal to enhance the sam9 watchdog timer support.
>>
>> The at91sam9 watchdog timer can only be configured once, and the current
>> implementation tries to configure it in a static way:
>> - 2 seconds timeout
>> - wdt restart every 500ms
>>
>> If the timer has already been configured with different values, it returns an
>> error and do not create any watchdog device.
>>
>> This is not critical if the watchdog is disabled, but if it has been enabled
>> with different timeout values it will lead to a SoC reset.
>>
>> This patch series tries to address this issue by adapting the heartbeat value
>> according the WDT timer config:
>> - it first tries to configure the timer as requested.
>> - if it fails it fallbacks to the current config, adapting its heartbeat timer
>> to the needs
>>
>> This patch series also move to a dynamically allocated at91wdt device instead
>> of the static instance. I'm not sure this is the best solution, so please tell
>> me if you prefer to keep static instance of watchdog.
>>
>> It adds a new at91 wdt type: software. This new type make use of the at91 wdt
>> interrupt to trigger a software reboot.
>>
>> Finally it adds several properties to the device tree bindings.
>>
>> Best Regards,
>> Boris
>>
>> Changes since v4:
>>   - fix coding style issues
>>   - remove unneeded watchdog_active test
>>
>> Changes since v3:
>>   - fix a bug in heartbeat time computation
>>   - fix a bug in at91_wdt_set_timeout when new timeout is bigger than the old
>>     one
>>   - rename at91_wdt_ping into at91_wdt_start
>>   - remove unneeded ping callback assignment
>>
>> Changes since v2:
>>   - fix documentation
>>   - rework the heartbeat computation to get a more flexible behaviour
>>   - fix xx_to_yy macros
>>   - modify warning and error messages
>>   - remove unneeded parenthesis in arithmetic operations
>>   - use devm functions to map io memory
>>   - remove unneeded devm_kfree calls
>>
>> Change since v1:
>>   - fix typo in documentaion
>>   - fix irq dt definition for sama5d3 SoC
>>
>>
>> Boris BREZILLON (4):
>>    watchdog: at91sam9_wdt: better watchdog support
>>    watchdog: at91sam9_wdt: update device tree doc
>>    ARM: at91/dt: add sam9 watchdog default options to SoCs
>>    ARM: at91/dt: add watchdog properties to kizbox board
>>
>>   .../devicetree/bindings/watchdog/atmel-wdt.txt     |   30 +-
>>   arch/arm/boot/dts/at91sam9260.dtsi                 |    5 +
>>   arch/arm/boot/dts/at91sam9263.dtsi                 |    5 +
>>   arch/arm/boot/dts/at91sam9g45.dtsi                 |    5 +
>>   arch/arm/boot/dts/at91sam9n12.dtsi                 |    5 +
>>   arch/arm/boot/dts/at91sam9x5.dtsi                  |    5 +
>>   arch/arm/boot/dts/kizbox.dts                       |    6 +
>>   arch/arm/boot/dts/sama5d3.dtsi                     |    5 +
>>   drivers/watchdog/at91sam9_wdt.c                    |  309 ++++++++++++++------
>>   9 files changed, 287 insertions(+), 88 deletions(-)
> These 4 patches have been added to linux-watchdog-next.
>
> Kind regards,
> Wim.
>

