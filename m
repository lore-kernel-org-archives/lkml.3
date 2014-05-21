Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbaEUGmY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 02:42:24 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:32391
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751073AbaEUGmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 02:42:22 -0400
Message-ID: <537C4ABD.2070103@freescale.com>
Date: Wed, 21 May 2014 14:42:05 +0800
From: Hongbo Zhang <hongbo.zhang@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>,
        "leo.li@freescale.com" <leo.li@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "scottwood@freescale.com" <scottwood@freescale.com>,
        "vkoul@infradead.org" <vkoul@infradead.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH v4 8/8] DMA: Freescale: add suspend resume functions for
 DMA driver
References: <1397809071-5353-1-git-send-email-hongbo.zhang@freescale.com>
 <1397809071-5353-9-git-send-email-hongbo.zhang@freescale.com>
 <20140502164604.GB32284@intel.com> <536614E7.9050301@freescale.com>
 <1399451493.2677.11.camel@smile.fi.intel.com> <536B53E5.30506@freescale.com>
 <20140521034513.GF21128@intel.com>
In-Reply-To: <20140521034513.GF21128@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(52604005)(24454002)(377424004)(479174003)(377454003)(51704005)(85852003)(83072002)(31966008)(74662001)(92566001)(65816999)(19580405001)(50986999)(99396002)(74502001)(83322001)(92726001)(77096999)(54356999)(87266999)(19580395003)(44976005)(76176999)(47776003)(86362001)(65806001)(65956001)(80022001)(81542001)(102836001)(64706001)(64126003)(20776003)(21056001)(80316001)(23756003)(36756003)(83506001)(81156002)(87936001)(46102001)(81342001)(77982001)(59896001)(68736004)(69596002)(4396001)(50466002)(6806004)(97736001)(76482001)(33656002);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB399;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 0218A015FA
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=hongbo.zhang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 05/21/2014 11:45 AM, Vinod Koul wrote:
> On Thu, May 08, 2014 at 05:52:37PM +0800, Hongbo Zhang wrote:
>> On 05/07/2014 04:31 PM, Shevchenko, Andriy wrote:
>>> On Sun, 2014-05-04 at 18:22 +0800, Hongbo Zhang wrote:
>>>> On 05/03/2014 12:46 AM, Vinod Koul wrote:
>>>>> On Fri, Apr 18, 2014 at 04:17:51PM +0800, hongbo.zhang@freescale.com wrote:
>>>>>> From: Hongbo Zhang <hongbo.zhang@freescale.com>
>>>>>>
>>>>>> This patch adds suspend resume functions for Freescale DMA driver.
>>>>>> .prepare callback is used to stop further descriptors from being added into the
>>>>>> pending queue, and also issue pending queues into execution if there is any.
>>>>>> .suspend callback makes sure all the pending jobs are cleaned up and all the
>>>>>> channels are idle, and save the mode registers.
>>>>>> .resume callback re-initializes the channels by restore the mode registers.
>>>>>>
>>>>>> +
>>>>>> +static const struct dev_pm_ops fsldma_pm_ops = {
>>>>>> +	.prepare	= fsldma_prepare,
>>>>>> +	.suspend	= fsldma_suspend,
>>>>>> +	.resume		= fsldma_resume,
>>>>>> +};
>>>>> I think this is not correct. We discussed this sometime back on list. The
>>>>> DMAengine drivers should use late resume and early suspend to ensure they get
>>>>> suspended after clients (who should use normal ones) and resume before them
>>>>>
>>>> OK, will update it like this:
>>>> use .suspend to take place of current .prepare
>>> Could you remove this at all?
>>>
>>> Answering to your previous statements I could say that.
>>> Device drivers (DMAc users) that don't implement .suspend callback are
>>> on their own with troubles, you have not to care about them in the DMA
>>> driver.
>> Thanks for pointing out this issue.
>> Then how to handle the descriptors in the pending list if there is any?
>> a. let them finished.
>>      but if the DMA user has already suspended prior DMA controller,
>> it is meaningless somehow and may even ask for trouble.
>> b. don't touch them.
>>      after resume these pending descriptors could be executed, it is
>> also meaningless because the resumed DMA user may in different state
>> from before being suspended.
>> c. delete them.
>>      should we do this? is is a bit crude?
>> d. return a non-success value
>>      then the whole suspend process is reversed, e.g. suspend fails.
>> I've looked through some dma drivers, most of them is in case b.
> Yes and that makese sense.
>
> In calssic suspend case we maybe in middle so graceful behaviour would be to for
> client to PAUSE or terminate and then suspend followed by DMA suspend.
> You need to rely on client doing the right thing here
>
OK, will resend this 6/8, 7/8 and 8/8 for another iteration, and will 
let the current 6/8 to be the last one for being reviewed and merged easier.


