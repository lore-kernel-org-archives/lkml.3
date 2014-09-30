Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbaI3UaU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 16:30:20 -0400
Received: from mail-bn1on0141.outbound.protection.outlook.com ([157.56.110.141]:13628
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750981AbaI3UaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 16:30:19 -0400
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
Thread-Index: AQHP3AU6xL0ppKreQk6rqjZx79AU1JwYcGsAgAAIjYD//8zWgIAAfQkAgAERo4D//9SpAA==
Date: Tue, 30 Sep 2014 20:15:24 +0000
Message-ID: <D0505C72.10E3B%jojyv@juniper.net>
In-Reply-To: <20140930155029.GA4724@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [66.129.239.13]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR05MB517;UriScan:;
x-forefront-prvs: 0350D7A55D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(24454002)(189002)(199003)(479174003)(377424004)(377454003)(51704005)(107046002)(66066001)(105586002)(92566001)(20776003)(85306004)(120916001)(64706001)(99396003)(87936001)(86362001)(10300001)(2656002)(92726001)(101416001)(76482002)(50986999)(21056001)(106356001)(19580395003)(31966008)(95666004)(80022003)(85852003)(99286002)(97736003)(19580405001)(36756003)(54356999)(106116001)(4396001)(46102003)(7059020);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR05MB517;H:CO2PR05MB761.namprd05.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="euc-kr"
Content-ID: <BD54F3C027E9664CB9074091CEF0A1AF@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR05MB217;
X-OriginatorOrg: juniper.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8UKUPnK025224



On 9/30/14 8:50 AM, "Guenter Roeck" <linux@roeck-us.net> wrote:

>On Mon, Sep 29, 2014 at 06:31:06PM -0500, Scott Wood wrote:
>> On Mon, 2014-09-29 at 23:03 +0000, Jojy Varghese wrote:
>> > 
>> > On 9/29/14 12:06 PM, "Guenter Roeck" <linux@roeck-us.net> wrote:
>> > 
>> > >On Mon, Sep 29, 2014 at 01:36:06PM -0500, Scott Wood wrote:
>> > >> On Mon, 2014-09-29 at 09:48 -0700, Guenter Roeck wrote:
>> > >> > From: Jojy G Varghese <jojyv@juniper.net>
>> > >> > 
>> > >> > For E500MC and E5500, a machine check exception in pci(e) memory
>>space
>> > >> > crashes the kernel.
>> > >> > 
>> > >> > Testing shows that the MCAR(U) register is zero on a MC
>>exception for
>> > >>the
>> > >> > E5500 core. At the same time, DEAR register has been found to
>>have the
>> > >> > address of the faulty load address during an MC exception for
>>this
>> > >>core.
>> > >> > 
>> > >> > This fix changes the current behavior to fixup the result
>>register
>> > >> > and instruction pointers in the case of a load operation on a
>>faulty
>> > >> > PCI address.
>> > >> > 
>> > >> > The changes are:
>> > >> > - Added the hook to pci machine check handing to the e500mc
>>machine
>> > >>check
>> > >> >   exception handler.
>> > >> > - For the E5500 core, load faulting address from SPRN_DEAR
>>register.
>> > >> >   As mentioned above, this is necessary because the E5500 core
>>does
>> > >>not
>> > >> >   report the fault address in the MCAR register.
>> > >> > 
>> > >> > Cc: Scott Wood <scottwood@freescale.com>
>> > >> > Signed-off-by: Jojy G Varghese <jojyv@juniper.net>
>> > >> > [Guenter Roeck: updated description]
>> > >> > Signed-off-by: Guenter Roeck <groeck@juniper.net>
>> > >> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> > >> > ---
>> > >> >  arch/powerpc/kernel/traps.c   | 3 ++-
>> > >> >  arch/powerpc/sysdev/fsl_pci.c | 5 +++++
>> > >> >  2 files changed, 7 insertions(+), 1 deletion(-)
>> > >> > 
>> > >> > diff --git a/arch/powerpc/kernel/traps.c
>>b/arch/powerpc/kernel/traps.c
>> > >> > index 0dc43f9..ecb709b 100644
>> > >> > --- a/arch/powerpc/kernel/traps.c
>> > >> > +++ b/arch/powerpc/kernel/traps.c
>> > >> > @@ -494,7 +494,8 @@ int machine_check_e500mc(struct pt_regs
>>*regs)
>> > >> >  	int recoverable = 1;
>> > >> >  
>> > >> >  	if (reason & MCSR_LD) {
>> > >> > -		recoverable = fsl_rio_mcheck_exception(regs);
>> > >> > +		recoverable = fsl_rio_mcheck_exception(regs) ||
>> > >> > +			fsl_pci_mcheck_exception(regs);
>> > >> >  		if (recoverable == 1)
>> > >> >  			goto silent_out;
>> > >> >  	}
>> > >> > diff --git a/arch/powerpc/sysdev/fsl_pci.c
>> > >>b/arch/powerpc/sysdev/fsl_pci.c
>> > >> > index c507767..bdb956b 100644
>> > >> > --- a/arch/powerpc/sysdev/fsl_pci.c
>> > >> > +++ b/arch/powerpc/sysdev/fsl_pci.c
>> > >> > @@ -1021,6 +1021,11 @@ int fsl_pci_mcheck_exception(struct
>>pt_regs
>> > >>*regs)
>> > >> >  #endif
>> > >> >  	addr += mfspr(SPRN_MCAR);
>> > >> >  
>> > >> > +#ifdef CONFIG_E5500_CPU
>> > >> > +	if (mfspr(SPRN_EPCR) & SPRN_EPCR_ICM)
>> > >> > +		addr = PFN_PHYS(vmalloc_to_pfn((void *)mfspr(SPRN_DEAR)));
>> > >> > +#endif
>> > >> 
>> > >> Kconfig tells you what hardware is supported, not what hardware
>>you're
>> > >> actually running on.
>> 
>> Plus, CONFIG_E5500_CPU may not even be set when running on an e5500, as
>> it is used for selecting GCC optimization settings.  You could have
>> CONFIG_GENERIC_CPU instead.
>> 
>> And the subject says "E500MC / E5500", not just "E5500". :-)
>> 
>> > >Hi Scott,
>> > >
>> > >Good point. Jojy, guess we'll have to check if the CPU is actually an
>> > >E5500.
>> > >Can you look into that ?
>> > 
>> > 
>> > "/proc/cpuinfo" shows the cpu as "e5500". Scott, are you suggesting
>>that
>> > we use a runtime method of determining the cpu type (cpu_spec's
>>cpu_name
>> > for
>> > example).  
>> 
>> Yes, if there's a bug to be worked around, and we don't want to apply
>> the workaround unconditionally, you should use PVR to determine whether
>> you're running on an affected core.
>> 
>> > >> Can we rely on DEAR or is this just a side effect of likely having
>>taken
>> > >> a TLB miss for the address recently?  Perhaps we should use the
>> > >> instruction emulation to determine the effective address instead.
>> > >> 
>> > >> Guenter, is this patch intended to deal with an erratum or are you
>> > >> covering up legitimate errors?
>> > >> 
>> >
>> > >Those are errors related to PCIe hotplug, and are seen with
>>unexpected
>> > >PCIe
>> > >device removals (triggered, for example, by removing power from a
>>PCIe
>> > >adapter).
>> > >The behavior we see on E5500 is quite similar to the same behavior on
>> > >E500:
>> > >If unhandled, the CPU keeps executing the same instruction over and
>>over
>> > >again
>> > >if there is an error on a PCIe access and thus stalls. I don't know
>>if
>> > >this
>> > >is considered an erratum or expected behavior, but it is one we have
>>to
>> > >address
>> > >since we have to be able to handle that condition.
>> 
>> The reason I ask is that the handling for e500 was described as an
>> erratum workaround.  If it is an erratum it would be nice to know the
>> erratum number and the full list of affected chips.
>> 
>My understanding, which may be wrong, was that this is expected behavior,
>at least for E5500. I actually thought I had seen it somewhere in the
>specification (response to PCIe errors), but I don't recall where exactly.
>
>At least for my part I am not aware of an erratum.
>
>> > >Ultimately, we'll want
>> > >to
>> > >implement PCIe error handlers for the affected drivers, but that
>>will be
>> > >a next
>> > >step.
>> 
>> For now can we at least print a ratelimited error message?  I don't like
>> the idea of silently ignoring these errors.  I suppose it's a separate
>> issue from extending the workaround to cover e500mc, though.
>> 
>I don't really like the idea of printing an error message pretty much
>each time
>when an unexpected hotplug event occurs.
>
>> > According to the spec, we MCAR is supposed to hold the faulty data
>>address
>> > but for 5500 core, we found that MCAR is zero.
>> 
>> Which specific chip and revision did you see this on?  What is the value
>> in MCSR?
>> 
>Jojy can answer that, at least for P5020. We have seen it on P5040 as
>well,
>though, so it is not just limited to one chip/revision.

The specifics are:
PVR: 0x80240012
Instruction that causes the MC exception: lwbrx
	The faulty load address is also present in RB. So we could change the
logic to use that 
instead of DEAR. What I don¡¯t know is of there are other cases also which
escapes the current logic.

					
				
			
		
	

>
>Guenter
>
>> > You are right that DEAR entry could
>> > be a resultOf a TLB miss but that©ös the register we could rely on.
>> 
>> If it's the result of a previous TLB miss then we can't rely on it.  The
>> translation might have been loaded into the TLB before the hotplug
>> event, or there might have been an interrupt between loading the
>> translation into the TLB and using the translation.
>> 
>> > What do you mean by "instruction emulation"?
>> 
>> mcheck_handle_load()
>> 
>> > Are you suggesting that we
>> > examine the RD, RS
>> > registers for the instruction?
>> 
>> Yes, if we don't have a simpler reliable source of the address.
>> 
>> -Scott
>> 
>> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
