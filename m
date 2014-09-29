Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbaI3AiH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 20:38:07 -0400
Received: from mail-bn1on0135.outbound.protection.outlook.com ([157.56.110.135]:11488
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755389AbaI3AiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 20:38:05 -0400
X-Greylist: delayed 4737 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Sep 2014 20:38:05 EDT
From: Jojy Varghese <jojyv@juniper.net>
To: Guenter Roeck <linux@roeck-us.net>, Scott Wood <scottwood@freescale.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Guenter Roeck <groeck@juniper.net>,
        "hongtao.jia@freescale.com" <hongtao.jia@freescale.com>
Subject: Re: [PATCH] powerpc/fsl: Add support for pci(e) machine check
 exception on E500MC / E5500
Thread-Topic: [PATCH] powerpc/fsl: Add support for pci(e) machine check
 exception on E500MC / E5500
Thread-Index: AQHP3AU6xL0ppKreQk6rqjZx79AU1JwYcGsAgAAIjYD//8zWgA==
Date: Mon, 29 Sep 2014 23:03:37 +0000
Message-ID: <D04F3201.10DEB%jojyv@juniper.net>
In-Reply-To: <20140929190643.GA20189@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [66.129.239.13]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR05MB518;
x-forefront-prvs: 034902F5BC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(377454003)(479174003)(51704005)(24454002)(164054003)(377424004)(199003)(189002)(15202345003)(99396003)(120916001)(10300001)(4396001)(66066001)(92566001)(107046002)(86362001)(99286002)(92726001)(80022003)(46102003)(64706001)(31966008)(76482002)(54356999)(50986999)(19580405001)(95666004)(105586002)(106356001)(19580395003)(106116001)(87936001)(97736003)(85306004)(20776003)(21056001)(36756003)(15975445006)(85852003)(2656002)(101416001)(7059020);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR05MB518;H:CO2PR05MB761.namprd05.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="euc-kr"
Content-ID: <6AB96FD972EE894EA66115811162952E@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: juniper.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8U0cB3d018103



On 9/29/14 12:06 PM, "Guenter Roeck" <linux@roeck-us.net> wrote:

>On Mon, Sep 29, 2014 at 01:36:06PM -0500, Scott Wood wrote:
>> On Mon, 2014-09-29 at 09:48 -0700, Guenter Roeck wrote:
>> > From: Jojy G Varghese <jojyv@juniper.net>
>> > 
>> > For E500MC and E5500, a machine check exception in pci(e) memory space
>> > crashes the kernel.
>> > 
>> > Testing shows that the MCAR(U) register is zero on a MC exception for
>>the
>> > E5500 core. At the same time, DEAR register has been found to have the
>> > address of the faulty load address during an MC exception for this
>>core.
>> > 
>> > This fix changes the current behavior to fixup the result register
>> > and instruction pointers in the case of a load operation on a faulty
>> > PCI address.
>> > 
>> > The changes are:
>> > - Added the hook to pci machine check handing to the e500mc machine
>>check
>> >   exception handler.
>> > - For the E5500 core, load faulting address from SPRN_DEAR register.
>> >   As mentioned above, this is necessary because the E5500 core does
>>not
>> >   report the fault address in the MCAR register.
>> > 
>> > Cc: Scott Wood <scottwood@freescale.com>
>> > Signed-off-by: Jojy G Varghese <jojyv@juniper.net>
>> > [Guenter Roeck: updated description]
>> > Signed-off-by: Guenter Roeck <groeck@juniper.net>
>> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> > ---
>> >  arch/powerpc/kernel/traps.c   | 3 ++-
>> >  arch/powerpc/sysdev/fsl_pci.c | 5 +++++
>> >  2 files changed, 7 insertions(+), 1 deletion(-)
>> > 
>> > diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
>> > index 0dc43f9..ecb709b 100644
>> > --- a/arch/powerpc/kernel/traps.c
>> > +++ b/arch/powerpc/kernel/traps.c
>> > @@ -494,7 +494,8 @@ int machine_check_e500mc(struct pt_regs *regs)
>> >  	int recoverable = 1;
>> >  
>> >  	if (reason & MCSR_LD) {
>> > -		recoverable = fsl_rio_mcheck_exception(regs);
>> > +		recoverable = fsl_rio_mcheck_exception(regs) ||
>> > +			fsl_pci_mcheck_exception(regs);
>> >  		if (recoverable == 1)
>> >  			goto silent_out;
>> >  	}
>> > diff --git a/arch/powerpc/sysdev/fsl_pci.c
>>b/arch/powerpc/sysdev/fsl_pci.c
>> > index c507767..bdb956b 100644
>> > --- a/arch/powerpc/sysdev/fsl_pci.c
>> > +++ b/arch/powerpc/sysdev/fsl_pci.c
>> > @@ -1021,6 +1021,11 @@ int fsl_pci_mcheck_exception(struct pt_regs
>>*regs)
>> >  #endif
>> >  	addr += mfspr(SPRN_MCAR);
>> >  
>> > +#ifdef CONFIG_E5500_CPU
>> > +	if (mfspr(SPRN_EPCR) & SPRN_EPCR_ICM)
>> > +		addr = PFN_PHYS(vmalloc_to_pfn((void *)mfspr(SPRN_DEAR)));
>> > +#endif
>> 
>> Kconfig tells you what hardware is supported, not what hardware you're
>> actually running on.
>> 
>Hi Scott,
>
>Good point. Jojy, guess we'll have to check if the CPU is actually an
>E5500.
>Can you look into that ?


"/proc/cpuinfo" shows the cpu as "e5500". Scott, are you suggesting that
we use a runtime method of determining the cpu type (cpu_spec's cpu_name
for
example).  


>
>> Jia Hongtao, do you know anything about this issue?  Is there an
>> erratum?  What chips are affected by the the erratum covered by
>> <http://patchwork.ozlabs.org/patch/240239/>?
>> 
>We already have and use the above patch(es) in our kernel. It works fine
>for E500 (P2020), but does not address E5500 (P5020/P5040).
>
>> Can we rely on DEAR or is this just a side effect of likely having taken
>> a TLB miss for the address recently?  Perhaps we should use the
>> instruction emulation to determine the effective address instead.
>> 
>> Guenter, is this patch intended to deal with an erratum or are you
>> covering up legitimate errors?
>> 
>Those are errors related to PCIe hotplug, and are seen with unexpected
>PCIe
>device removals (triggered, for example, by removing power from a PCIe
>adapter).
>The behavior we see on E5500 is quite similar to the same behavior on
>E500:
>If unhandled, the CPU keeps executing the same instruction over and over
>again
>if there is an error on a PCIe access and thus stalls. I don't know if
>this
>is considered an erratum or expected behavior, but it is one we have to
>address
>since we have to be able to handle that condition. Ultimately, we'll want
>to
>implement PCIe error handlers for the affected drivers, but that will be
>a next
>step.

According to the spec, we MCAR is supposed to hold the faulty data address
but for 5500 core, we found that MCAR is zero. You are right that DEAR
entry could
be a resultOf a TLB miss but that©ös the register we could rely on.

What do you mean by "instruction emulation"? Are you suggesting that we
examine the RD, RS 
registers for the instruction?



>
>Please let me know if you have a better solution to address this problem.
>
>Thanks,
>Guenter


Thanks
Jojy

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
