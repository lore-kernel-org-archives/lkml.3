Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbaCQDSl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 23:18:41 -0400
Received: from mail.xen.prgmr.com ([71.19.149.6]:57042 "EHLO
	mail.xen.prgmr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011AbaCQDSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 23:18:40 -0400
X-Greylist: delayed 328 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Mar 2014 23:18:40 EDT
Message-ID: <53266841.6090308@prgmr.com>
Date: Sun, 16 Mar 2014 20:13:05 -0700
From: Sarah Newman <srn@prgmr.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, xen-devel@lists.xen.org
Subject: Re: [PATCHv1] x86: don't schedule when handling #NM exception
References: <1394468273-13676-1-git-send-email-david.vrabel@citrix.com> <531DEB11.2070709@zytor.com> <531DF319.6010800@citrix.com>
In-Reply-To: <531DF319.6010800@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2014 10:15 AM, David Vrabel wrote:
> On 10/03/14 16:40, H. Peter Anvin wrote:
>> On 03/10/2014 09:17 AM, David Vrabel wrote:
>>> math_state_restore() is called from the #NM exception handler.  It may
>>> do a GFP_KERNEL allocation (in init_fpu()) which may schedule.
>>>
>>> Change this allocation to GFP_ATOMIC, but leave all the other callers
>>> of init_fpu() or fpu_alloc() using GFP_KERNEL.
>>
>> And what the [Finnish] do you do if GFP_ATOMIC fails?
> 
> The same thing it used to do -- kill the task with SIGKILL.  I haven't
> changed this behaviour.
> 
>> Sarah's patchset switches Xen PV to use eagerfpu unconditionally, which
>> removes the dependency on #NM and is the right thing to do.
> 
> Ok. I'll wait for this series and not pursue this patch any further.

Sorry, this got swallowed by my mail filter.

I did some more testing and I think eagerfpu is going to noticeably slow things down. When I ran
"time sysbench --num-threads=64 --test=threads run" I saw on the order of 15% more time spent in
system mode and this seemed consistent over different runs.

As for GFP_ATOMIC, unfortunately I don't know a sanctioned test here so I rolled my own. This test
sequentially allocated math-using processes in the background until it could not any more.  On a
64MB instance, I saw 10% fewer processes allocated with GFP_ATOMIC compared to GFP_KERNEL when I
continually allocated new processes up to OOM conditions (256 vs 228.)  A similar test on a
different RFS and a kernel using GFP_NOWAIT showed pretty much no difference in how many processes I
could allocate. This doesn't seem too bad unless there is some kind of fragmentation over time which
would cause worse performance.

Since performance degradation applies at all times and not just under extreme conditions, I think
the lesser evil will actually be GFP_ATOMIC.  But it's not necessary to always use GFP_ATOMIC, only
under certain conditions - IE when the xen PVABI forces us to.

Patches will be supplied shortly.
