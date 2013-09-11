Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab3IKPrM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 11:47:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17521 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab3IKPrK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 11:47:10 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=cpn0iEa-oVMA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=uXgjhyO7DfoA:10 a=yPCof4ZbAAAA:8 a=Unp3Hef_tPO2zRRPd_cA:9 a=CjuIK1q_8ugA:10 a=7DSvI1NPTFQA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Wed, 11 Sep 2013 11:47:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Jason Baron <jbaron@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com
Subject: Re: Regression :-) Re: [GIT PULL RESEND] x86/jumpmplabel changes
 for v3.12-rc1
Message-ID: <20130911114708.1b42aec0@gandalf.local.home>
In-Reply-To: <20130911152149.GA22076@phenom.dumpdata.com>
References: <201309110248.r8B2miI2032449@terminus.zytor.com>
	<20130911134717.GA10925@phenom.dumpdata.com>
	<20130911135745.GB11043@phenom.dumpdata.com>
	<20130911142545.GA11364@phenom.dumpdata.com>
	<20130911105633.1c029147@gandalf.local.home>
	<20130911152149.GA22076@phenom.dumpdata.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Sep 2013 11:21:49 -0400
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > 
> > I'm trying to understand how this will fix it for you. Are you sure you
> > removed 'xen_nopvspin'?
> 
> Yes.
> > 
> > If you are calling static_key_slow_inc() before jump_label_init(), then
> > it should still fail. The static_key_slow_inc() eventually calls
> > arch_jump_label_transform(), which calls __jump_label_transform() with
> > init == 0.
> 
> Perhaps I am misreading the code, but I believe init is set to one.
> That is due to us calling:
> 
> arch_jump_label_transform (.., JUMP_LABEL_ENABLE)
> 
> which calls __jump_label_transform(.., 1)
> ?

>From what I'm looking at, only arch_jump_label_transform_static() calls
__jump_label_transform() with a 1 for init. arch_jump_label_transform()
calls it with 0 for init, which is what eventually gets called by
xen_init_spinlocks().

> 
> Perhaps the 'init' and 'enable' parameters have different meanings?

Yes they do.

-- Steve

> 
> > 
> > The below code looks to me that it would still compare the contents
> > with the ideal_nop, which hasn't been set yet.
> 
> In the !init case - sure. 
> 
> In the init case - just with default_nop.
> 
