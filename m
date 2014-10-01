Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaJAQHb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 12:07:31 -0400
Received: from mail-by2on0089.outbound.protection.outlook.com ([207.46.100.89]:6784
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751535AbaJAQH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 12:07:29 -0400
Message-ID: <542C26B6.7010302@opensource.altera.com>
Date: Wed, 1 Oct 2014 11:07:18 -0500
From: Dinh Nguyen <dinguyen@opensource.altera.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Pavel Machek <pavel@denx.de>, atull <atull@opensource.altera.com>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <delicious.quinoa@gmail.com>,
        <yvanderv@opensource.altera.com>
Subject: Re: [PATCH 1/2] socfpga: hotplug: put cpu1 in wfi
References: <1411590449-9794-1-git-send-email-atull@opensource.altera.com> <1411590449-9794-2-git-send-email-atull@opensource.altera.com> <20141001133527.GA12750@amd> <alpine.DEB.2.10.1410010915440.2332@shineypoop> <20141001150418.GA14609@amd>
In-Reply-To: <20141001150418.GA14609@amd>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [99.103.66.154]
X-ClientProxiedBy: BY1PR00CA0026.namprd00.prod.outlook.com (25.160.102.36) To
 CY1PR0301MB1194.namprd03.prod.outlook.com (25.160.165.25)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1194;
X-Forefront-PRVS: 0351D213B3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(24454002)(51884002)(189002)(51704005)(199003)(479174003)(377454003)(64126003)(83506001)(65956001)(66066001)(59896002)(4396001)(31966008)(33656002)(23756003)(99396003)(76482002)(101416001)(10300001)(120916001)(97736003)(86362001)(92726001)(20776003)(87976001)(21056001)(64706001)(65806001)(50986999)(50466002)(85852003)(42186005)(93886004)(65816999)(54356999)(76176999)(87266999)(107046002)(105586002)(85306004)(46102003)(102836001)(77096002)(95666004)(47776003)(80022003)(106356001)(92566001)(80316001);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR0301MB1194;H:Dinhs-MacBook-Pro.local;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/1/14, 10:04 AM, Pavel Machek wrote:
> Hi!
> 
>>>> +		__raw_writel(RSTMGR_MPUMODRST_CPU1,
>>>> +			     rst_manager_base_addr + 0x10);
>>>
>>> Would it be possible to copy reset manager description struct from
>>> u-boot and use it here, instead of raw offset?
>>
>> I will replace this 0x10 with a macro that reflects how the register is 
>> named in the register map.
> 
> That would be better than 0x10, but even better would be just copying
> 
> struct socfpga_reset_manager {
>         u32     status;
>         u32     ctrl;
>         u32     counts;
>         u32     padding1;
>         u32     mpu_mod_reset;
>         u32     per_mod_reset;
>         u32     per2_mod_reset;
>         u32     brg_mod_reset;
> };
> 
> from u-boot. Unlike macros, structs have advantages that typos lead to
> easier-to-see failure modes... (And they are easier to read/parse,
> too).
> 

Copying from uboot sounds good, but I already know that the CPU reset
offset is different for our next SOC, Arria 10. The Arria 10 SOC should
still be able to use the same MSL as Cyclone5 and Arria5, but with a few
differences. One of them being, the CPU1 reset offset is at 0x20 instead
of 0x10. So I think having a macro for this one register is a bit
cleaner than having to define a whole new struct for Arria10.

if (of_machine_is_compatible("altr,socfpga-arria10"))
	__raw_writel(0, rst_manager_base_addr + 0x20);
else
	__raw_writel(0, rst_manager_base_addr + 0x10);

Dinh
