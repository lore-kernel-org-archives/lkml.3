Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757765Ab3JQQtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 12:49:20 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:54346 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755708Ab3JQQtR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 12:49:17 -0400
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
Date: Thu, 17 Oct 2013 18:48:35 +0200
Subject: Re: [PATCH v5 1/4] i2c: busses: i2c-st: Add ST I2C controller
Thread-Topic: [PATCH v5 1/4] i2c: busses: i2c-st: Add ST I2C controller
Thread-Index: Ac7LWLkWomV1xqBWTF2k06opL/1yxw==
Message-ID: <526014E3.70505@st.com>
References: <1381754813-4679-1-git-send-email-maxime.coquelin@st.com>
 <1381754813-4679-2-git-send-email-maxime.coquelin@st.com>
 <20131016151419.GA14104@ns203013.ovh.net> <525F915D.9020501@st.com>
 <20131017141627.GD14104@ns203013.ovh.net>
In-Reply-To: <20131017141627.GD14104@ns203013.ovh.net>
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


On 10/17/2013 04:16 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 09:27 Thu 17 Oct     , Maxime COQUELIN wrote:
>> Hi Jean-Christophe,
>>
>> On 10/16/2013 05:14 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
>>
>>
>> ...
>>>> +
>>>> +static inline void st_i2c_set_bits(void __iomem *reg, u32 mask)
>>>> +{
>>>> +     writel(readl(reg) | mask, reg);
>>>> +}
>>>> +
>>>> +static inline void st_i2c_clr_bits(void __iomem *reg, u32 mask)
>>>> +{
>>>> +     writel(readl(reg) & ~mask, reg);
>>> use set_bit api and use relaxed version
>> Using the set_bit api here does not match with the purpose of these
>> functions.
>> We want to be able to set/clear multiple bits, and AFAICS the set_bit
>> api does not
>> provide this possibility.
>>
>> I took example on i2c-nomadik for these functions.
>>
> so factorize the code not copy and paste
I won't create a new API for this.
If this is blocking for you, then I will just remove this functions.

>>>> +}
>>>> +
>>>> +/* From I2C Specifications v0.5 */
>>>> +static struct st_i2c_timings i2c_timings[] = {
>>>> use readsl
>> Since the read content is flushed, I prefer keeping it as it is instead
>> of allocating
>> a buffer of the FIFO's size.
> keep point is to speedup the bus
I meant I will use readl_relaxed, not readl.

>>> use relaxed version as much as possible
>> I was not comfortable with the different possibilities (_raw_readl,
>> readl_relaxed, readl...).
>> I found this interresting discussion:
>> _http://comments.gmane.org/gmane.linux.ports.arm.kernel/117626
>>   From what I understood, you are right, I should be able to use
>> readl_relaxed everywhere.
>>
>> Maybe I should perform a readl on the interrupt mask register before
>> returning from the interrupt handler,
>> in order to ensure that the write to the IEN register is effective
>> before the IRQ for the device is re-enabled at GIC level.
>> Maybe this could avoid the few spurious interrupts I face sometimes, I
>> will have a try.
> ok
I failed to reproduce the spurious interrupt without the patch, so I 
can't say
whether performing a readl at this stage helps.
>>>> +}
