Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab3FFUwI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 16:52:08 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:55416 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab3FFUwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 16:52:05 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>, "bp@alien8.de" <bp@alien8.de>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Tomoki Sekiyama <tomoki.sekiyama@hds.com>
Subject: RE: [PATCH v14 2/3] trace,x86: Introduce entering/exiting_irq()
Thread-Topic: [PATCH v14 2/3] trace,x86: Introduce entering/exiting_irq()
Thread-Index: AQHOYsn+LDhxMdDsxE6L7lVj2VTv4pkpRCCA///lM8A=
Date: Thu, 6 Jun 2013 20:51:07 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D41B03197A@USINDEM103.corp.hds.com>
References: <51B0A90F.7030309@hds.com> <51B0A965.3070806@hds.com>
 <1370543173.9844.37.camel@gandalf.local.home>
In-Reply-To: <1370543173.9844.37.camel@gandalf.local.home>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8626,1.0.431,0.0.0000
 definitions=2013-06-06_08:2013-06-06,2013-06-06,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 ipscore=0
 suspectscore=0 phishscore=0 bulkscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1306060196
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r56KqFnb014378



> -----Original Message-----
> From: Steven Rostedt [mailto:rostedt@goodmis.org]
> Sent: Thursday, June 06, 2013 2:26 PM
> To: Seiji Aguchi
> Cc: linux-kernel@vger.kernel.org; hpa@zytor.com; tglx@linutronix.de; mingo@elte.hu; bp@alien8.de; linux-edac@vger.kernel.org;
> tony.luck@intel.com; dle-develop@lists.sourceforge.net; Tomoki Sekiyama
> Subject: Re: [PATCH v14 2/3] trace,x86: Introduce entering/exiting_irq()
> 
> On Thu, 2013-06-06 at 11:23 -0400, Seiji Aguchi wrote:
> > ---
> >  arch/x86/include/asm/apic.h |   27 +++++++++++++++++++++++++++
> >  1 files changed, 27 insertions(+), 0 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
> > index 3388034..f8119b5 100644
> > --- a/arch/x86/include/asm/apic.h
> > +++ b/arch/x86/include/asm/apic.h
> > @@ -12,6 +12,7 @@
> >  #include <asm/fixmap.h>
> >  #include <asm/mpspec.h>
> >  #include <asm/msr.h>
> > +#include <asm/idle.h>
> >
> >  #define ARCH_APICTIMER_STOPS_ON_C3	1
> >
> > @@ -687,5 +688,31 @@ extern int default_check_phys_apicid_present(int phys_apicid);
> >  #endif
> >
> >  #endif /* CONFIG_X86_LOCAL_APIC */
> > +extern void irq_enter(void);
> > +extern void irq_exit(void);
> > +
> > +static inline void entering_irq(void)
> > +{
> > +	irq_enter();
> > +	exit_idle();
> > +}
> > +
> > +static inline void entering_ack_irq(void)
> > +{
> > +	ack_APIC_irq();
> > +	entering_irq();
> > +}
> > +
> > +static inline void exiting_irq(void)
> > +{
> > +	irq_exit();
> > +}
> > +
> > +static inline void exiting_ack_irq(void)
> > +{
> > +	irq_exit();
> > +	/* Ack only at the end to avoid potential reentry */
> > +	ack_APIC_irq();
> > +}
> >
> >  #endif /* _ASM_X86_APIC_H */
> 
> I think it also makes sense to use these in this patch as well. That is,
> go ahead and make the changes likes this:
> 
> @@ -919,17 +919,14 @@ void __irq_entry smp_apic_timer_interrupt(struct pt_regs *regs)
>  	/*
>  	 * NOTE! We'd better ACK the irq immediately,
>  	 * because timer handling can be slow.
> -	 */
> -	ack_APIC_irq();
> -	/*
> +	 *
>  	 * update_process_times() expects us to have done irq_enter().
>  	 * Besides, if we don't timer interrupts ignore the global
>  	 * interrupt lock, which is the WrongThing (tm) to do.
>  	 */
> -	irq_enter();
> -	exit_idle();
> +	entering_ack_irq();
>  	local_apic_timer_interrupt();
> -	irq_exit();
> +	exiting_irq();
> 
>  	set_irq_regs(old_regs);
>  }
> 
> And do that with all the interrupts.

OK. Will do.

Seiji

> 
> I think this is getting close for adding to 3.11 queue.
> 
> -- Steve
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
