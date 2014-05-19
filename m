Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbaESKOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:14:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753204AbaESKOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:14:44 -0400
Date: Mon, 19 May 2014 12:14:39 +0200
From: Miroslav Lichvar <mlichvar@redhat.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH 0/3] timekeeping: Improved NOHZ frequency steering (v2)
Message-ID: <20140519101439.GE4060@localhost>
References: <1400288204-414-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400288204-414-1-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 05:56:41PM -0700, John Stultz wrote:
> This version of the patch set corrects a few issues Miroslav pointed
> out, as well as adapts his approach almost completely for the last
> patch. This pulls the results in to be very close to his original
> patch.

Ok, so it seems to be almost identical to my patch now. The only two
differences seem to be the removal of the ntp_error correction to
change the effective clock frequency at the current time instead of
aligning it to the start of the tick and the flag to handle the xtime
underflow.

Can we get them in too?

I think both are necessary to avoid having large steps in ntp_error
which take long time to correct. You can see this in the nohz off
freq100 result from the simulator, for example.

> I'm not 100% sure we need the last patch in this series, as
> it has additional computational cost and testing on real
> hardware has shown NOHZ=y performance matching NOHZ=n with a
> earlier version of just the first patch:
> 	https://lkml.org/lkml/2014/1/13/501
> (though admittedly, the patch has changed since Richard's testing,
> so the results are a bit stale).

If I could get a sufficiently low update rate on real HW or a more
accurate reference clock, I think I would be able to show you a
difference. But even if we can't at this time, the removal of the
complex feedback loop, which as you saw is difficult to keep working
well in all cases (and we have tested only a very small number of
them), is probably worth the extra computational cost.

Thanks,

> Below are some of the simulator results comparing this patchset
> to vanilla and Miroslav's original patch.

> Miroslav's original patch:
> --------------------------
> 
> $ ./test1.sh 
> 		freq10          freq100         dev             max
> nohz on		0.00601         0.00028         74.0            279.4
> nohz off	0.05867         0.00204         0.2             0.6

> This patchset:
> --------------
> 
> $ ./test1.sh 
> 		freq10          freq100         dev             max
> nohz on		0.00582         0.00033         74.1            279.9
> nohz off	0.06275         0.06440         0.4             1.4

-- 
Miroslav Lichvar
