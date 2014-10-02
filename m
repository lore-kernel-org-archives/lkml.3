Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292AbaJBLhG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 07:37:06 -0400
Received: from mail-bn1on0099.outbound.protection.outlook.com ([157.56.110.99]:26016
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750987AbaJBLhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 07:37:04 -0400
Message-ID: <542D38D6.4030209@opensource.altera.com>
Date: Thu, 2 Oct 2014 06:36:54 -0500
From: Dinh Nguyen <dinguyen@opensource.altera.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Pavel Machek <pavel@denx.de>
CC: atull <atull@opensource.altera.com>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <delicious.quinoa@gmail.com>, <yvanderv@opensource.altera.com>
Subject: Re: [PATCH 1/2] socfpga: hotplug: put cpu1 in wfi
References: <1411590449-9794-1-git-send-email-atull@opensource.altera.com> <1411590449-9794-2-git-send-email-atull@opensource.altera.com> <20141001133527.GA12750@amd> <alpine.DEB.2.10.1410010915440.2332@shineypoop> <20141001150418.GA14609@amd> <542C26B6.7010302@opensource.altera.com> <20141001231646.GB1529@amd>
In-Reply-To: <20141001231646.GB1529@amd>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [99.103.66.154]
X-ClientProxiedBy: BY1PR00CA0003.namprd00.prod.outlook.com (25.160.102.13) To
 CY1PR0301MB1195.namprd03.prod.outlook.com (25.160.165.26)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1195;
X-Forefront-PRVS: 03524FBD26
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(24454002)(51704005)(51884002)(479174003)(189002)(377454003)(377424004)(92726001)(92566001)(101416001)(47776003)(80022003)(93886004)(59896002)(85306004)(64706001)(4396001)(23756003)(99396003)(76482002)(120916001)(46102003)(50466002)(10300001)(21056001)(107046002)(87976001)(65816999)(106356001)(86362001)(65956001)(102836001)(54356999)(76176999)(110136001)(31966008)(85852003)(95666004)(66066001)(20776003)(87266999)(33656002)(65806001)(83506001)(105586002)(77096002)(80316001)(64126003)(42186005)(97736003)(50986999);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR0301MB1195;H:Dinhs-MacBook-Pro.local;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/1/14, 6:16 PM, Pavel Machek wrote:
> On Wed 2014-10-01 11:07:18, Dinh Nguyen wrote:
>>
>>
>> On 10/1/14, 10:04 AM, Pavel Machek wrote:
>>> Hi!
>>>
>>>>>> +		__raw_writel(RSTMGR_MPUMODRST_CPU1,
>>>>>> +			     rst_manager_base_addr + 0x10);
>>>>>
>>>>> Would it be possible to copy reset manager description struct from
>>>>> u-boot and use it here, instead of raw offset?
>>>>
>>>> I will replace this 0x10 with a macro that reflects how the register is 
>>>> named in the register map.
>>>
>>> That would be better than 0x10, but even better would be just copying
>>>
>>> struct socfpga_reset_manager {
>>>         u32     status;
>>>         u32     ctrl;
>>>         u32     counts;
>>>         u32     padding1;
>>>         u32     mpu_mod_reset;
>>>         u32     per_mod_reset;
>>>         u32     per2_mod_reset;
>>>         u32     brg_mod_reset;
>>> };
>>>
>>> from u-boot. Unlike macros, structs have advantages that typos lead to
>>> easier-to-see failure modes... (And they are easier to read/parse,
>>> too).
>>>
>>
>> Copying from uboot sounds good, but I already know that the CPU reset
>> offset is different for our next SOC, Arria 10. The Arria 10 SOC should
>> still be able to use the same MSL as Cyclone5 and Arria5, but with a few
>> differences. One of them being, the CPU1 reset offset is at 0x20 instead
>> of 0x10. So I think having a macro for this one register is a bit
>> cleaner than having to define a whole new struct for Arria10.
> 
> I don't think "whole new struct" is a problem. At least it will be
> plain to see what changed (which will get easily lost in ifdefs.
> 
> struct cyclone5_reset_manager {
> 	struct socfpga_reset_manager common;
> 	u32 brg_mod_reset;
> }
> 
> struct aria10_reset_manager {
> 	struct socfpga_reset_manager common;
> 	char filler[0x10];
> 	u32 brg_mod_reset;
> }
> 
> if (of_machine_is_compatible("altr,socfpga-arria10"))
> 	__raw_writel(0, (struct cyclone5_reset_manager *) rst_manager_base_addr->brg_mod_reset));
> else
> 	__raw_writel(0, (struct aria10_reset_manager *) rst_manager_base_addr->brg_mod_reset));
> 
> ...does not sound that bad. (And you'll need some nice solution for
> u-boot, anyway...)
> 

That's fine.

Dinh
