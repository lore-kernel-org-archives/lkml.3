Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab3IFQxx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 12:53:53 -0400
Received: from usindpps05.hds.com ([207.126.252.18]:49158 "EHLO
	usindpps05.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab3IFQxv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 12:53:51 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@elte.hu" <mingo@elte.hu>, "bp@alien8.de" <bp@alien8.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "fdeslaur@gmail.com" <fdeslaur@gmail.com>,
        "raphael.beamonte@gmail.com" <raphael.beamonte@gmail.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Tomoki Sekiyama <tomoki.sekiyama@hds.com>
Subject: RE: [PATCH v2] Introduce page fault tracepoint
Thread-Topic: [PATCH v2] Introduce page fault tracepoint
Thread-Index: AQHOoBcWpWROXdr1ikWlDNj02w1Pt5m5RQKA//+9qwA=
Date: Fri, 6 Sep 2013 16:53:03 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D443EA18A6@USINDEM103.corp.hds.com>
References: <521781C7.3050906@hds.com>
 <20130906124935.3b4aa870@gandalf.local.home>
In-Reply-To: <20130906124935.3b4aa870@gandalf.local.home>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-09-06_06:2013-09-06,2013-09-06,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1309060101
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Steven Rostedt [mailto:rostedt@goodmis.org]
> Sent: Friday, September 06, 2013 12:50 PM
> To: Seiji Aguchi
> Cc: linux-kernel@vger.kernel.org; x86@kernel.org; hpa@zytor.com; mingo@elte.hu; bp@alien8.de; tglx@linutronix.de;
> fdeslaur@gmail.com; raphael.beamonte@gmail.com; dle-develop@lists.sourceforge.net; Tomoki Sekiyama
> Subject: Re: [PATCH v2] Introduce page fault tracepoint
> 
> On Fri, 23 Aug 2013 11:37:43 -0400
> Seiji Aguchi <seiji.aguchi@hds.com> wrote:
> 
> 
> > +#if !defined(_TRACE_PAGE_FAULT_H) || defined(TRACE_HEADER_MULTI_READ)
> > +#define _TRACE_PAGE_FAULT_H
> > +
> > +#include <linux/tracepoint.h>
> > +
> > +extern void trace_irq_vector_regfunc(void);
> > +extern void trace_irq_vector_unregfunc(void);
> > +
> > +DECLARE_EVENT_CLASS(x86_exceptions,
> > +
> > +	TP_PROTO(unsigned long address, struct pt_regs *regs,
> > +		 unsigned long error_code),
> > +
> > +	TP_ARGS(address, regs, error_code),
> > +
> > +	TP_STRUCT__entry(
> > +		__field(		unsigned long, address	)
> > +		__field(		struct pt_regs *, regs	)
> > +		__field(		unsigned long, error_code )
> > +	),
> > +
> > +	TP_fast_assign(
> > +		__entry->address = address;
> > +		__entry->regs = regs;
> > +		__entry->error_code = error_code;
> > +	),
> > +
> > +	TP_printk("address=0x%lx ip=0x%lx error_code=0x%lx",
> > +		  __entry->address, __entry->regs->ip, __entry->error_code) );
> 
> This is sure to crash the kernel.
> 
> You just saved the address of a pointer to some task's stack in the
> ring buffer. And then on output (which can happen a long time from when
> it was recorded), you are dereferencing that same address!
> 
> That __entry->regs->ip *will* crash the kernel!
> 
> What you want is to save ip in the fast_assign:
> 
> 	__entry->ip = regs->ip
> 
> And then print that. Never dereference a pointer directly from the ring
> buffer unless it's a constant value (like a global string).

I see..
Thank you for reviewing.

I will fix it.

Seiji
