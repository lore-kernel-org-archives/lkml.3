Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab3JAVky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 17:40:54 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:32908 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751253Ab3JAVkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 17:40:51 -0400
Message-ID: <1380663645.2081.29.camel@dabdike>
Subject: Re: [PATCH] [workqueue] check values of pwq and wq in
 print_worker_info() before use
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Tejun Heo <tj@kernel.org>
Cc: Helge Deller <deller@gmx.de>, Libin <huawei.libin@huawei.com>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org
Date: Tue, 01 Oct 2013 14:40:45 -0700
In-Reply-To: <20131001204352.GA27149@mtj.dyndns.org>
References: <20131001203520.GA8248@p100.box>
	 <20131001204352.GA27149@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-01 at 16:43 -0400, Tejun Heo wrote:
> Hello,
> 
> On Tue, Oct 01, 2013 at 10:35:20PM +0200, Helge Deller wrote:
> > print_worker_info() includes no validity check on the pwq and wq
> > pointers before handing them over to the probe_kernel_read() functions.
> > 
> > It seems that most architectures don't care about that, but at least on
> > the parisc architecture this leads to a kernel crash since accesses to
> > page zero are protected by the kernel for security reasons.
> > 
> > Fix this problem by verifying the contents of pwq and wq before usage.
> > Even if probe_kernel_read() usually prevents such crashes by disabling
> > page faults, clean code should always include such checks. 
> > 
> > Without this fix issuing "echo t > /proc/sysrq-trigger" will immediately
> > crash the Linux kernel on the parisc architecture.
> 
> Hmm... um had similar problem but the root cause here is that the arch
> isn't implementing probe_kernel_read() properly.  We really have no
> idea what the pointer value may be at the dump point and that's why we
> use probe_kernel_read().  If something like the above is necessary for
> the time being, the correct place would be the arch
> probe_kernel_read() implementation.  James, would it be difficult
> implement proper probe_kernel_read() on parisc?

The problem seems to be that some traps bypass our exception table
handling.  Helge, do you have the actual stack trace for this?  That
should show where the exception handling is missing.

Thanks,

James


