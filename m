Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751200Ab3BPFTq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 00:19:46 -0500
Received: from usindpps03.hds.com ([207.126.252.16]:34895 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab3BPFTp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 00:19:45 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Steven Rostedt <rostedt@goodmis.org>, "H. Peter Anvin" <hpa@zytor.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "Borislav Petkov (bp@alien8.de)" <bp@alien8.de>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: RE: [PATCH v9 3/3] trace,x86: code-sharing between non-trace and
 trace irq handlers
Thread-Topic: [PATCH v9 3/3] trace,x86: code-sharing between non-trace and
 trace irq handlers
Thread-Index: Ac4DKfj9nhV66AyvSzikmHjqFbN/2gI2mNqAAAJ/aQAAAtk2MA==
Date: Sat, 16 Feb 2013 05:18:53 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D414A9A312@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A64C5B@USINDEM103.corp.hds.com>
	 <511ECF2B.8090202@zytor.com> <1360977902.23152.119.camel@gandalf.local.home>
In-Reply-To: <1360977902.23152.119.camel@gandalf.local.home>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2013-02-16_01:2013-02-15,2013-02-16,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1302150325
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > How important is it that the tracepoint is *inside* the enter/exit
> > handling?  If not, it would be simpler to just do:
> >
> > smp_trace_irq_handler()
> > {
> > 	trace_irq_entry();
> > 	smp_irq_handler();
> > 	trace_irq_exit();
> > }
> >
> > ... which seems a bit cleaner.  If this isn't possible, then this
> > patch is fine, but please add to the patch description why the simple
> > wrapper isn't doable.
> 
> The problem is with irq_enter/exit() being called. They must be called before trace_irq_enter/exit(), because of the rcu_irq_enter()
> must be called before any tracepoints are used, as tracepoints use rcu to synchronize.
>

I tried to place tracepoints outside the enter/exit handling. But it didn't work because of the rcu_irq_enter().

> Now perhaps we could do this and have trace_irq_entry().
> 
> Not only that, the tracepoint callbacks expect irq_enter() to already be called.
> 
> Hmm, if irq_enter() can nest, which I think it can, perhaps we can call
> irq_enter() first. I'm not sure if that will screw up the second
> irq_entry() inside smp_irq_handler().
> 
> smp_trace_irq_hander()
> {
> 	irq_entry();
> 	trace_irq_entry();
> 	smp_irq_handler();
> 	trace_irq_exit();
> 	irq_exit();
> }

If irq_enter() is nested, it may have a time penalty because it has to check if it was already called or not.  
It doesn't satisfy a goal of this patch.
Therefore, I think current coding is reasonable.

I will update the patch description.

Seiji
