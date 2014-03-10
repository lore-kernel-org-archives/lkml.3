Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbaCJQmG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 12:42:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48851 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832AbaCJQmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 12:42:04 -0400
Message-ID: <531DEB11.2070709@zytor.com>
Date: Mon, 10 Mar 2014 09:40:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, linux-kernel@vger.kernel.org
CC: x86@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, xen-devel@lists.xen.org,
        Sarah Newman <srn@prgmr.com>
Subject: Re: [PATCHv1] x86: don't schedule when handling #NM exception
References: <1394468273-13676-1-git-send-email-david.vrabel@citrix.com>
In-Reply-To: <1394468273-13676-1-git-send-email-david.vrabel@citrix.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2014 09:17 AM, David Vrabel wrote:
> math_state_restore() is called from the #NM exception handler.  It may
> do a GFP_KERNEL allocation (in init_fpu()) which may schedule.
> 
> Change this allocation to GFP_ATOMIC, but leave all the other callers
> of init_fpu() or fpu_alloc() using GFP_KERNEL.

And what the [Finnish] do you do if GFP_ATOMIC fails?

> do_group_exit() will also call schedule() so replace the call with
> force_sig(SIGKILL, tsk) instead.
> 
> Scheduling in math_state_restore() is particularly bad in Xen PV
> guests since the Xen clears CR0.TS before raising #NM exception (in
> the expectation that the #NM handler always clears TS).  If task A is
> descheduled and task B is scheduled.  Task B may end up with CR0.TS
> unexpectedly clear and any FPU instructions will not raise #NM and
> will corrupt task A's FPU state instead.

Yes, we know Xen is completely broken in this respect.

Anyway, I have a patchset from Sarah Newman which I have been reviewing
privately so far (which looks good and should be posted publicly -- the
holdup has not been Sarah's code but a combination of my bandwidth and
trying to get some preexisting bugs in the eagerfpu code dealt with,
which Suresh Siddha fortunately stepped up to do and which we now have a
solution for.)

Sarah's patchset switches Xen PV to use eagerfpu unconditionally, which
removes the dependency on #NM and is the right thing to do.

Sarah, could you post the latest patchset to LKML so it can be publicly
reviewed?  I'm sorry for the slow response time on my end.

	-hpa

