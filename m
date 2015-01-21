Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbbAULK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 06:10:26 -0500
Received: from mail-bn1on0136.outbound.protection.outlook.com ([157.56.110.136]:5600
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752692AbbAULKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 06:10:19 -0500
Message-ID: <54BF72D1.3000302@freescale.com>
Date: Wed, 21 Jan 2015 11:35:13 +0200
From: Purcareata Bogdan <b43198@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: <benh@kernel.crashing.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] powerpc/mpic: Add DT option to skip readback after EOI
References: <1421236622-29366-1-git-send-email-bogdan.purcareata@freescale.com> <1421258312.4961.133.camel@freescale.com>
In-Reply-To: <1421258312.4961.133.camel@freescale.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.88.166.1]
X-ClientProxiedBy: DB3PR05CA0027.eurprd05.prod.outlook.com (25.160.41.155) To
 BL2PR03MB180.namprd03.prod.outlook.com (10.255.230.156)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=B43198@freescale.com; 
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BL2PR03MB180;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BL2PR03MB180;
X-Forefront-PRVS: 04631F8F77
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(6049001)(24454002)(51704005)(199003)(189002)(243025005)(377424004)(59896002)(92566002)(106356001)(97736003)(101416001)(65816999)(54356999)(50986999)(87266999)(76176999)(46102003)(110136001)(105586002)(64126003)(23676002)(50466002)(36756003)(65956001)(65806001)(47776003)(33656002)(64706001)(66066001)(77156002)(62966003)(87976001)(86362001)(19580395003)(80316001)(19580405001)(83506001)(42186005)(40100003)(122386002)(15975445007)(2950100001)(77096005)(68736005)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB180;H:[10.171.74.27];FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB180;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2015 09:35:29.2450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL2PR03MB180
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.01.2015 19:58, Scott Wood wrote:
> On Wed, 2015-01-14 at 11:57 +0000, Bogdan Purcareata wrote:
>> The readback is necessary in order to handle PCI posted
>> writes,
>
> That is unclear.

I'm going to try an venture a different explanation here.

I found a good explanation in Writing PCI Drivers [1] as to why it's 
necessary that a read is performed before returning from an EOI write:

"A good example of such a case is when a driver’s Interrupt Service 
Routine (ISR) is dealing with the Interrupt Request Register (IRR) on a 
card. Clearing a bit in the register indicates that the interrupt has 
been serviced. This is done by posting a write to the register. If the 
driver posts this write and exits its ISR, it could get interrupted 
again immediately because the write hadn’t yet reached the bit in the 
IRR to tell it to stop trying to interrupt. One solution to this 
potential problem is to make sure to read back the value in the IRR 
before exiting from the ISR. Most drivers do this anyway so they can 
handle multiple interrupts in the same ISR visit."

This is designed to work for legacy line interrupts. I understand MSI 
has its way to order writes on the bus, and also it won't send another 
MSI, signaling a new interrupt, unless there's a state change in the IRR 
on the card. When using line interrupts, the line stays asserted as long 
as IRR is set, so the MPIC could trigger an additional interrupt if the 
EOI write is posted and the ISR bit is cleared.

>
>>   or when the MPIC is handling interrupts in a loop
>> (ppc_md.get_irq).
>
> I'm questioning this one as well -- if reading WHOAMI is sufficient to
> sync with the EOI, why wouldn't reading INTACK work as well?

I think I'm going to drop this part of the description. However, I don't 
think reading INTACK is good, since it has some additional side effects 
- interrupt pending register is cleared for edge-sensitive interrupts, 
the in-service register is updated, and the int output signal from the 
MPIC is negated. This is available for Freescale SoCs. This also 
signifies entering the processing cycle of a new interrupt.

Normally, the readback should be done on the EOI register - this is 
stated in the OpenPIC specification and actually was the initial 
implementation of the driver. However, this can't be done since, at 
least for Freescale SoCs, the EOI register is write only.

However, in the light of the above explanation related to PCI posted 
writes, I don't see how performing a readback on the WHOAMI register, 
which is specific to the MPIC, would have any effect in synchronizing 
with the PCI device registers. I guess it's related to the bus 
interconnect on the SoC.

>>   Newer MPIC versions don't require this readback. Leave the option
>> configurable using a device tree entry.
>>
>> This saves a MMIO trap per interrupt.
>>
>> Signed-off-by: Scott Wood <scottwood@freescale.com>
>> Signed-off-by: Bogdan Purcareata <bogdan.purcareata@freescale.com>
>
> You should note changes (e.g. with a [] note between signoffs) if it
> differs from the original...

Will do, sorry for omitting this.

>
> -Scott

[1] http://h21007.www2.hp.com/portal/download/files/unprot/ddk/ddg/chap8.pdf

Best regards,
Bogdan P.
