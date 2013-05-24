Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab3EXN37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 09:29:59 -0400
Received: from usindpps05.hds.com ([207.126.252.18]:59658 "EHLO
	usindpps05.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904Ab3EXN35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 09:29:57 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "Borislav Petkov (bp@alien8.de)" <bp@alien8.de>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Tomoki Sekiyama <tomoki.sekiyama@hds.com>
Subject: RE: [PATCH v12 3/3] trace,x86: code-sharing between non-trace and
 trace irq handlers
Thread-Topic: [PATCH v12 3/3] trace,x86: code-sharing between non-trace and
 trace irq handlers
Thread-Index: Ac4yMsLoDKRDE6+HTHWLu1jFQu+oqQl3ifAAABxp9FA=
Date: Fri, 24 May 2013 13:28:55 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D41B00320D@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D41AF86286@USINDEM103.corp.hds.com>
 <1369338892.6828.214.camel@gandalf.local.home>
In-Reply-To: <1369338892.6828.214.camel@gandalf.local.home>
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
 definitions=2013-05-24_06:2013-05-24,2013-05-24,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 ipscore=0
 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1305240117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4ODU6AW012210



> This as a separate patch actually makes things more confusing to review.
> It should be merged into the previous patch. If you want to break up the
> changes, I would first add the entering_irq(), and exiting_irq() as
> patch 1, and then do the rest of the changes in patch 2.

Thanks. I will update this patchset as above.

Seiji

> -----Original Message-----
> From: Steven Rostedt [mailto:rostedt@goodmis.org]
> Sent: Thursday, May 23, 2013 3:55 PM
> To: Seiji Aguchi
> Cc: linux-kernel@vger.kernel.org; x86@kernel.org; hpa@zytor.com; Thomas Gleixner (tglx@linutronix.de); 'mingo@elte.hu'
> (mingo@elte.hu); Borislav Petkov (bp@alien8.de); linux-edac@vger.kernel.org; Luck, Tony (tony.luck@intel.com); dle-
> develop@lists.sourceforge.net; Tomoki Sekiyama
> Subject: Re: [PATCH v12 3/3] trace,x86: code-sharing between non-trace and trace irq handlers
> 
> On Fri, 2013-04-05 at 19:21 +0000, Seiji Aguchi wrote:
> > [Issue]
> >
> > Currently, irq vector handlers for tracing are just
> > copied non-trace handlers by simply inserting tracepoints.
> >
> > It is difficult to manage the codes.
> >
> > [Solution]
> 
> 
> This as a separate patch actually makes things more confusing to review.
> It should be merged into the previous patch. If you want to break up the
> changes, I would first add the entering_irq(), and exiting_irq() as
> patch 1, and then do the rest of the changes in patch 2.
> 
> -- Steve
> 
> > This patch shares common codes between non-trace and trace handlers
> > as follows to make them manageable and readable.
> >
> > Non-trace irq handler:
> > smp_irq_handler()
> > {
> > 	entering_irq(); /* pre-processing of this handler */
> > 	__smp_irq_handler(); /*
> >                           * common logic between non-trace and trace handlers
> >                           * in a vector.
> >                           */
> > 	exiting_irq(); /* post-processing of this handler */
> >
> > }
> >
> > Trace irq_handler:
> > smp_trace_irq_handler()
> > {
> > 	entering_irq(); /* pre-processing of this handler */
> > 	trace_irq_entry(); /* tracepoint for irq entry */
> > 	__smp_irq_handler(); /*
> >                           * common logic between non-trace and trace handlers
> >                           * in a vector.
> >                           */
> > 	trace_irq_exit(); /* tracepoint for irq exit */
> > 	exiting_irq(); /* post-processing of this handler */
> >
> > }
> >
> > If tracepoints can place outside entering_irq()/exiting_irq() as follows, it looks \
> > cleaner.
> >
> > smp_trace_irq_handler()
> > {
> > 	trace_irq_entry();
> > 	smp_irq_handler();
> > 	trace_irq_exit();
> > }
> >
> > But it doesn't work.
> > The problem is with irq_enter/exit() being called. They must be called before \
> > trace_irq_enter/exit(),  because of the rcu_irq_enter() must be called before any \
> > tracepoints are used, as tracepoints use  rcu to synchronize.
> >
> > As a possible alternative, we may be able to call irq_enter() first as follows if \
> > irq_enter() can nest.
> >
> > smp_trace_irq_hander()
> > {
> > 	irq_entry();
> > 	trace_irq_entry();
> > 	smp_irq_handler();
> > 	trace_irq_exit();
> > 	irq_exit();
> > }
> >
> > But it doesn't work, either.
> > If irq_enter() is nested, it may have a time penalty because it has to check if it \
> > was already called or not. The time penalty is not desired in performance sensitive \
> > paths even if it is tiny.
> >
> > Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
