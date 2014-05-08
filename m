Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbaEHJw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 05:52:58 -0400
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:56384
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752845AbaEHJwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 05:52:55 -0400
Message-ID: <536B53E5.30506@freescale.com>
Date: Thu, 8 May 2014 17:52:37 +0800
From: Hongbo Zhang <hongbo.zhang@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
CC: "leo.li@freescale.com" <leo.li@freescale.com>,
        "Koul, Vinod" <vinod.koul@intel.com>,
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
 <1399451493.2677.11.camel@smile.fi.intel.com>
In-Reply-To: <1399451493.2677.11.camel@smile.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(51704005)(199002)(189002)(479174003)(377454003)(52604005)(24454002)(377424004)(68736004)(69596002)(76176999)(54356999)(65956001)(4396001)(44976005)(50986999)(77982001)(15975445006)(83506001)(84676001)(2009001)(50466002)(87936001)(99396002)(76482001)(97736001)(46102001)(74502001)(83322001)(6806004)(92566001)(19580405001)(79102001)(19580395003)(81156002)(15202345003)(81342001)(33656001)(64126003)(85852003)(65806001)(21056001)(83072002)(80022001)(77096999)(74662001)(47776003)(31966008)(20776003)(64706001)(92726001)(86362001)(65816999)(23676002)(36756003)(81542001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB395;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 0205EDCD76
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=hongbo.zhang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 05/07/2014 04:31 PM, Shevchenko, Andriy wrote:
> On Sun, 2014-05-04 at 18:22 +0800, Hongbo Zhang wrote:
>> On 05/03/2014 12:46 AM, Vinod Koul wrote:
>>> On Fri, Apr 18, 2014 at 04:17:51PM +0800, hongbo.zhang@freescale.com wrote:
>>>> From: Hongbo Zhang <hongbo.zhang@freescale.com>
>>>>
>>>> This patch adds suspend resume functions for Freescale DMA driver.
>>>> .prepare callback is used to stop further descriptors from being added into the
>>>> pending queue, and also issue pending queues into execution if there is any.
>>>> .suspend callback makes sure all the pending jobs are cleaned up and all the
>>>> channels are idle, and save the mode registers.
>>>> .resume callback re-initializes the channels by restore the mode registers.
>>>>
>>>> +
>>>> +static const struct dev_pm_ops fsldma_pm_ops = {
>>>> +	.prepare	= fsldma_prepare,
>>>> +	.suspend	= fsldma_suspend,
>>>> +	.resume		= fsldma_resume,
>>>> +};
>>> I think this is not correct. We discussed this sometime back on list. The
>>> DMAengine drivers should use late resume and early suspend to ensure they get
>>> suspended after clients (who should use normal ones) and resume before them
>>>
>> OK, will update it like this:
>> use .suspend to take place of current .prepare
> Could you remove this at all?
>
> Answering to your previous statements I could say that.
> Device drivers (DMAc users) that don't implement .suspend callback are
> on their own with troubles, you have not to care about them in the DMA
> driver.

Thanks for pointing out this issue.
Then how to handle the descriptors in the pending list if there is any?
a. let them finished.
     but if the DMA user has already suspended prior DMA controller, it 
is meaningless somehow and may even ask for trouble.
b. don't touch them.
     after resume these pending descriptors could be executed, it is 
also meaningless because the resumed DMA user may in different state 
from before being suspended.
c. delete them.
     should we do this? is is a bit crude?
d. return a non-success value
     then the whole suspend process is reversed, e.g. suspend fails.
I've looked through some dma drivers, most of them is in case b.

>> use .suspend_late to take place of current .suspend
>> use .resume_early to take place of current .resume
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe dmaengine" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


