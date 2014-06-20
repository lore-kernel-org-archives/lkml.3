Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934692AbaFTH2c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 03:28:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934032AbaFTH2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 03:28:30 -0400
Message-ID: <53A3E256.8090307@redhat.com>
Date: Fri, 20 Jun 2014 09:27:18 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>, Ulf Hansson <ulf.hansson@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        linux-pm@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Alexandre Courbot <gnurou@gmail.com>,
        Arend van Spriel <arend@broadcom.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, Chris Ball <chris@printf.net>,
        Chen-Yu Tsai <wens@csie.org>, Russell King <linux@arm.linux.org.uk>,
        Tomasz Figa <tomasz.figa@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>
Subject: Re: [RFC 1/2] pwrseq: Add subsystem to handle complex power sequences
References: <1403183091-27876-1-git-send-email-ulf.hansson@linaro.org>	<1403183091-27876-2-git-send-email-ulf.hansson@linaro.org> <CAOesGMj6xp_cXZRuqL5HOPX4AeDuCkj69E32xuPVgGk4xABLbQ@mail.gmail.com>
In-Reply-To: <CAOesGMj6xp_cXZRuqL5HOPX4AeDuCkj69E32xuPVgGk4xABLbQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 06/19/2014 07:18 PM, Olof Johansson wrote:
> Hi,
> 
> 
> 
> On Thu, Jun 19, 2014 at 6:04 AM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
>> The pwrseq subsystem handles complex power sequences, typically useful
>> for subsystems that makes use of discoverable buses, like for example
>> MMC and I2C.
>>
>> The pwrseq subsystem is dependant on CONFIG_OF to be able to parse a DT
>> childnode to find out what power sequence method to bind for a device.
>>
>> From the DT childnode, the pwrseq DT parser tries to locate a
>> "power-method" property, which string is matched towards the list of
>> supported pwrseq methods.
>>
>> Each pwrseq method implements it's own power sequence and interfaces
>> the pwrseq core through a few callback functions.
>>
>> To instantiate a pwrseq method, clients shall use the devm_pwrseq_get()
>> API. If needed, clients can explicity drop the references to a pwrseq
>> method using devm_pwrseq_put() API.
>>
>> Besides instantiation, the pwrseq API provides clients opportunity to
>> select a certain power state. In this intial version, PWRSEQ_POWER_ON
>> and PWRSEQ_POWER_OFF are supported. Those are also mandatory for each
>> pwrseq method to support.
>>
>> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
>> ---
>>  .../devicetree/bindings/pwrseq/pwrseq.txt          |   48 ++++++
>>  drivers/Makefile                                   |    2 +-
>>  drivers/pwrseq/Makefile                            |    2 +
>>  drivers/pwrseq/core.c                              |  175 ++++++++++++++++++++
>>  drivers/pwrseq/core.h                              |   37 +++++
>>  drivers/pwrseq/method.c                            |   38 +++++
>>  include/linux/pwrseq.h                             |   50 ++++++
>>  7 files changed, 351 insertions(+), 1 deletion(-)
>>  create mode 100644 Documentation/devicetree/bindings/pwrseq/pwrseq.txt
>>  create mode 100644 drivers/pwrseq/Makefile
>>  create mode 100644 drivers/pwrseq/core.c
>>  create mode 100644 drivers/pwrseq/core.h
>>  create mode 100644 drivers/pwrseq/method.c
>>  create mode 100644 include/linux/pwrseq.h
>>
>> diff --git a/Documentation/devicetree/bindings/pwrseq/pwrseq.txt b/Documentation/devicetree/bindings/pwrseq/pwrseq.txt
>> new file mode 100644
>> index 0000000..80848ae
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/pwrseq/pwrseq.txt
>> @@ -0,0 +1,48 @@
>> +Power sequence DT bindings
>> +
>> +Each power sequence method has a corresponding "power-method" property string.
>> +This property shall be set in a subnode for a device. That subnode should also
>> +describe resourses which are specific to that power method.
>> +
>> +Do note, power sequences as such isn't encoded through DT. Instead those are
>> +implemented by each power method.
>> +
>> +Required subnode properties:
>> +- power-method: should contain the string for the power method to bind.
>> +
>> +       Supported power methods: None.
>> +
>> +Example:
>> +
>> +Note, the "clock" power method in this example isn't actually supported, but
>> +used to visualize how a childnode could be described.
>> +
>> +// WLAN SDIO channel
>> +sdi1_per2@80118000 {
>> +       compatible = "arm,pl18x", "arm,primecell";
>> +       reg = <0x80118000 0x1000>;
>> +       interrupts = <0 50 IRQ_TYPE_LEVEL_HIGH>;
>> +
>> +       dmas = <&dma 32 0 0x2>, /* Logical - DevToMem */
>> +              <&dma 32 0 0x0>; /* Logical - MemToDev */
>> +       dma-names = "rx", "tx";
>> +
>> +       clocks = <&prcc_kclk 2 4>, <&prcc_pclk 2 6>;
>> +       clock-names = "sdi", "apb_pclk";
>> +
>> +       arm,primecell-periphid = <0x10480180>;
>> +       max-frequency = <100000000>;
>> +       bus-width = <4>;
>> +       non-removable;
>> +       pinctrl-names = "default", "sleep";
>> +       pinctrl-0 = <&sdi1_default_mode>;
>> +       pinctrl-1 = <&sdi1_sleep_mode>;
>> +
>> +       status = "okay";
>> +
>> +       pwrseq: pwrseq1 {
>> +               power-method = "clock";
>> +               clocks = <&someclk 1 2>, <&someclk 3 4>;
>> +               clock-names = "pwrseq1", "pwrseq2";
>> +       };
> 
> I am strongly against the subnode approach as a general framework. We
> don't have a subnode for interrupts, nor for clocks or pinctrl. So why
> should we have it for the power sequencing?
> 
> Sure, that fits the linux driver model better, but that's irrelevant
> w.r.t. describing the hardware.

Actually this is about describing the hardware, when you have e.g. an
mmc device which needs pwrseq, there will be 2 sets of certain
resources, ie clocks for the host controller and clocks going directly
to the mmc device. I think putting those both in the same subnode is
a BAD idea, so we really do need a subnode to group the pwrseq resources
together.

Regards,

Hans
