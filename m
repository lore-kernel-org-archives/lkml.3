Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab3FDPvb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 11:51:31 -0400
Received: from usindpps05.hds.com ([207.126.252.18]:38888 "EHLO
	usindpps05.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab3FDPv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 11:51:29 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>, "bp@alien8.de" <bp@alien8.de>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Tomoki Sekiyama <tomoki.sekiyama@hds.com>
Subject: RE: [PATCH v13 3/3] trace,x86: Add irq vector tracepoints
Thread-Topic: [PATCH v13 3/3] trace,x86: Add irq vector tracepoints
Thread-Index: AQHOYJD5t4s5mkVepkqNMD/e2H+1XZkk7OKAgACn4LA=
Date: Tue, 4 Jun 2013 15:50:17 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D41B010ECC@USINDEM103.corp.hds.com>
References: <51ACEDBB.6040706@hds.com> <51ACEEB4.1010302@hds.com>
 <1370303581.26799.109.camel@gandalf.local.home>
In-Reply-To: <1370303581.26799.109.camel@gandalf.local.home>
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
 definitions=2013-06-04_06:2013-06-04,2013-06-04,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 ipscore=0
 suspectscore=0 phishscore=0 bulkscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1306040135
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r54FpeON018397

> Yeah, I believe this does work. But you probably should add a comment
> like the following:

OK. I will add  some  comment above " extern atomic_long_t current_idt_descr_ptr;".

> 
> /*
>  * The current_idt_descr_ptr can only be set out of interrupt context
>  * to avoid races. 

I will introduce set_current_idt() as follows.

set_current_idt(unsigned long idt)
{
	If (WARN_ON_ONCE(in_interrupt()))
		return;

	atomic_long_set(idt);

}


> * Once set, the load_current_idt() is called by interrupt
>  * context either by NMI, debug, or via a smp_call_function(). That way
>  * the IDT will always be set back to the expected descriptor.
>  */

The important thing is not "called by interrupt context" but "called with interrupt disabled"
to avoid races.
Actually, load_current_idt() is called in process context in irq_vector_{reg/unreg}func().
In next patch, I will rewrite the comment.

> >
> > +extern atomic_long_t current_idt_descr_ptr;
> > +static inline void load_current_idt(void)
> > +{
> > +	if (atomic_long_read(&current_idt_descr_ptr))
> 
> Also, we should probably add here:
> 		unsigned long new_idt = atomic_long_read(&current_idt_descr_ptr);
> 
> 		if (WARN_ON_ONCE(!validate_idt(new_idt))
> 			return;
> 		load_idt((const struct desc_ptr *)new_idt);
> 
> > +		load_idt((const struct desc_ptr *)
> > +			 atomic_long_read(&current_idt_descr_ptr));
> > +	else
> > +		load_idt((const struct desc_ptr *)&idt_descr);
> > +}
> > +
> 
> Then have
> 
> bool validate_idt(unsigned long idt)
> {
> 	switch(idt) {
> 	case (unsigned long)&trace_idt_descr:
> 	case (unsigned long)&idt_descr:
> 		return 0;
> 	}
> 	return -1;
> }
> 
> This way we wont be opening up any easy root holes where if a process
> finds a way to modify some arbitrary kernel memory, we can prevent it
> from modifying the current_idt_descr_ptr and have a nice way to exploit
> the IDT. Sure, one can argue that if they can modify arbitrary kernel
> memory, we may already be lost, but lets not make it easier for them
> than need be.

I will introduce the validate_idt() as above in a next patch.

Thanks.

Seiji

> 
> -- Steve
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
