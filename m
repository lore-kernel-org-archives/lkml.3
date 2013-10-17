Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869Ab3JQH2q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 03:28:46 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:48418 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750892Ab3JQH2n convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 03:28:43 -0400
From: Maxime COQUELIN <maxime.coquelin@st.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Stuart MENEFY <stuart.menefy@st.com>, Lee Jones <lee.jones@linaro.org>,
        Stephen GALLIMORE <stephen.gallimore@st.com>,
        Gabriel FERNANDEZ <gabriel.fernandez@st.com>
Date: Thu, 17 Oct 2013 09:27:25 +0200
Subject: Re: [PATCH v5 1/4] i2c: busses: i2c-st: Add ST I2C controller
Thread-Topic: [PATCH v5 1/4] i2c: busses: i2c-st: Add ST I2C controller
Thread-Index: Ac7LClSqleas+eOoTgimFBRbgRDrDQ==
Message-ID: <525F915D.9020501@st.com>
References: <1381754813-4679-1-git-send-email-maxime.coquelin@st.com>
 <1381754813-4679-2-git-send-email-maxime.coquelin@st.com>
 <20131016151419.GA14104@ns203013.ovh.net>
In-Reply-To: <20131016151419.GA14104@ns203013.ovh.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.0
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean-Christophe,

On 10/16/2013 05:14 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:


...
>> +
>> +static inline void st_i2c_set_bits(void __iomem *reg, u32 mask)
>> +{
>> +     writel(readl(reg) | mask, reg);
>> +}
>> +
>> +static inline void st_i2c_clr_bits(void __iomem *reg, u32 mask)
>> +{
>> +     writel(readl(reg) & ~mask, reg);
> use set_bit api and use relaxed version
Using the set_bit api here does not match with the purpose of these 
functions.
We want to be able to set/clear multiple bits, and AFAICS the set_bit 
api does not
provide this possibility.

I took example on i2c-nomadik for these functions.

>> +}
>> +
>> +/* From I2C Specifications v0.5 */
>> +static struct st_i2c_timings i2c_timings[] = {
>> +     [I2C_MODE_STANDARD] = {
>> +             .rate                   = 100000,
>> +             .rep_start_hold         = 4000,
>> +             .rep_start_setup        = 4700,
>> +             .start_hold             = 4000,
>> +             .data_setup_time        = 250,
>> +             .stop_setup_time        = 4000,
>> +             .bus_free_time          = 4700,
>> +     },
>> +     [I2C_MODE_FAST] = {
>> +             .rate                   = 400000,
>> +             .rep_start_hold         = 600,
>> +             .rep_start_setup        = 600,
>> +             .start_hold             = 600,
>> +             .data_setup_time        = 100,
>> +             .stop_setup_time        = 600,
>> +             .bus_free_time          = 1300,
>> +     },
>> +};
> so how do you plane to support other rate that 100k and 400k?
The SSC IP only supports Standard and Fast modes.
There are no plans to support faster modes.
>> +
>> +static void st_i2c_flush_rx_fifo(struct st_i2c_dev *i2c_dev)
>> +{
>> +     int count, i;
>> +
>> +     /*
>> +      * Counter only counts up to 7 but fifo size is 8...
>> +      * When fifo is full, counter is 0 and RIR bit of status register is
>> +      * set
>> +      */
>> +     if (readl(i2c_dev->base + SSC_STA) & SSC_STA_RIR)
>> +             count = SSC_RXFIFO_SIZE;
>> +     else
>> +             count = readl(i2c_dev->base + SSC_RX_FSTAT) &
>> +                     SSC_RX_FSTAT_STATUS;
>> +
>> +     for (i = 0; i < count; i++)
>> +             readl(i2c_dev->base + SSC_RBUF);
> use readsl
Since the read content is flushed, I prefer keeping it as it is instead 
of allocating
a buffer of the FIFO's size.
>
> use relaxed version as much as possible
I was not comfortable with the different possibilities (_raw_readl, 
readl_relaxed, readl...).
I found this interresting discussion: 
_http://comments.gmane.org/gmane.linux.ports.arm.kernel/117626
 From what I understood, you are right, I should be able to use 
readl_relaxed everywhere.

Maybe I should perform a readl on the interrupt mask register before 
returning from the interrupt handler,
in order to ensure that the write to the IEN register is effective 
before the IRQ for the device is re-enabled at GIC level.
Maybe this could avoid the few spurious interrupts I face sometimes, I 
will have a try.

>> +}
>> +
...
>> +
>> +static int st_i2c_wait_free_bus(struct st_i2c_dev *i2c_dev)
>> +{
>> +     u32 sta;
>> +     int i;
>> +
>> +     for (i = 0; i < 10; i++) {
>> +             sta = readl(i2c_dev->base + SSC_STA);
>> +             if (!(sta & SSC_STA_BUSY))
>> +                     return 0;
>> +
>> +             usleep_range(2000, 4000);
> can not use interrupt?
Sadly, no.
There is no interrupt linked to the busy bit.
>> +     }
>> +
...
>> +
>> +static struct of_device_id st_i2c_match[] = {
>> +     { .compatible = "st,comms-ssc-i2c", },
> the rules is to put the first soc that use the ip in the compatible
> as st,sti7100-scc-i2c
Ok. There are no plans to upstream the SH4 platforms, it will only 
remains in stlinux.com.
Maybe I can set the first ARM platform (STiH415)?
That would give st,stih415-ssc-i2c.

Thanks for the review,
Maxime

>
> Best Regards,
> J.
