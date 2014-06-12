Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377AbaFLXvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 19:51:07 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:47375 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbaFLXvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 19:51:05 -0400
MIME-Version: 1.0
In-Reply-To: <CALAqxLWAXU0hS8si-CmkOObBOHGv_skMVfPnUsdmLcZzkdUsWA@mail.gmail.com>
References: <CALAqxLWAXU0hS8si-CmkOObBOHGv_skMVfPnUsdmLcZzkdUsWA@mail.gmail.com>
Date: Thu, 12 Jun 2014 16:51:04 -0700
Message-ID: <CALAqxLUoc45535haDAuoNXSSmNqTZF1uiOMF8PyaDp_A+_dnWA@mail.gmail.com>
Subject: Re: [Regression] 3.15 mmc related ext4 corruption with qemu-system-arm
From: John Stultz <john.stultz@linaro.org>
To: Ulf Hansson <ulf.hansson@linaro.org>, Chris Ball <chris@printf.net>,
        Peter Maydell <peter.maydell@linaro.org>
Cc: Johan Rudholm <jrudholm@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 10:35 PM, John Stultz <john.stultz@linaro.org> wrote:
> Bisecting this points to: e7f3d22289e4307b3071cc18b1d8ecc6598c0be4
> (mmc: mmci: Handle CMD irq before DATA irq). Which I guess shouldn't
> be surprising, as I saw problems with that patch earlier in the
> 3.15-rc cycle:
>     https://lkml.org/lkml/2014/4/14/824
>
[...]
>
> Unfortunately reverting the change (manually, as it doesn't revert
> cleanly anymore) doesn't seem to completely avoid the issue, so the
> bisection may have gone slightly astray (though it is interesting it
> landed on the same commit I earlier had trouble with). So I'll
> back-track and double check some of the last few "good" results to
> validate I didn't just luck into 3 good boots accidentally. I'll also
> review my revert in case I missed something subtle in doing it
> manually.

So I'm getting some baffling results. I started going back over the
git bisect logs to see if I had mis-marked a revision as good due to
the issue just not reproducing.

However, despite many many reboots the last good commit in my branch
- bb5cba40dc7f079ea7ee3ae760b7c388b6eb5fc3 (mmc: block: Fixup busy
detection while...) doesn't ever show the issue. While the immediately
following commit which bisect found -
e7f3d22289e4307b3071cc18b1d8ecc6598c0be4 (mmc: mmci: Handle CMD irq
before DATA irq) always does.

The immensely frustrating part is while backing that single change off
from its commit sha always makes the issue go away, reverting that
change from on top of v3.15 doesn't. The issue persists. Since it
doesn't revert cleanly, I also reverted a following patch that it
interacted with 8d94b54d99ea968a9d188ca0e68793ebed601220 (mmc: mmci:
Enable support for busy detection....) to make sure I didn't miss some
dependency and the issue *still* crops up. In fact, doing a git diff
bb5cba40dc7f079ea7ee3ae760b7c388b6eb5fc3..v3.15 drivers/mmc/  doesn't
seem to resolve the issue.

So I'm really at a bit of a loss on what to do next. While it seems
that the "mmci: Handle CMD irq before DATA..." commit is problematic,
there also seems to be some other commit in v3.15 which results in the
same problematic behavior.  I may try to bisect again between the
first bad commit and v3.15, reverting the bad commit each time to see
if I can chase it down, but if anyone has better debugging tools here,
I'd greatly appreciate it.

Again, I'm happy to help interested folks get this reproducing on
their own machine for debugging.

thanks
-john
