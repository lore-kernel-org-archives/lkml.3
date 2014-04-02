Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256AbaDBIwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 04:52:16 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:51663 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758036AbaDBIwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 04:52:10 -0400
MIME-Version: 1.0
In-Reply-To: <tip-27f6c573e0f77f7d1cc907c1494c99a61e48b7d8@git.kernel.org>
References: <tip-27f6c573e0f77f7d1cc907c1494c99a61e48b7d8@git.kernel.org>
From: William Dauchy <wdauchy@gmail.com>
Date: Wed, 2 Apr 2014 10:51:49 +0200
Message-ID: <CAJ75kXZbvs2mGRQod0df5Xs_AcodsQ=n+030tYawQDrFW01Y2Q@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86, CMCI: Add proper detection of end of CMCI storms
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, hpa@zytor.com,
        William Dauchy <wdauchy@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>, Tony <tony.luck@intel.com>,
        Gong <gong.chen@linux.intel.com>
Cc: linux-tip-commits@vger.kernel.org, William Dauchy <william@gandi.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 2, 2014 at 9:55 AM, tip-bot for Chen, Gong <tipbot@zytor.com> wrote:
> Commit-ID:  27f6c573e0f77f7d1cc907c1494c99a61e48b7d8
> Gitweb:     http://git.kernel.org/tip/27f6c573e0f77f7d1cc907c1494c99a61e48b7d8
> Author:     Chen, Gong <gong.chen@linux.intel.com>
> AuthorDate: Thu, 27 Mar 2014 21:24:36 -0400
> Committer:  Tony Luck <tony.luck@intel.com>
> CommitDate: Fri, 28 Mar 2014 13:40:16 -0700
>
> x86, CMCI: Add proper detection of end of CMCI storms
>
> When CMCI storm persists for a long time(at least beyond predefined
> threshold. It's 30 seconds for now), we can watch CMCI storm is
> detected immediately after it subsides.
>
> ...
> Dec 10 22:04:29 kernel: CMCI storm detected: switching to poll mode
> Dec 10 22:04:59 kernel: CMCI storm subsided: switching to interrupt mode
> Dec 10 22:04:59 kernel: CMCI storm detected: switching to poll mode
> Dec 10 22:05:29 kernel: CMCI storm subsided: switching to interrupt mode
> ...
>
> The problem is that our logic that determines that the storm has
> ended is incorrect. We announce the end, re-enable interrupts and
> realize that the storm is still going on, so we switch back to
> polling mode. Rinse, repeat.
>
> When a storm happens we disable signaling of errors via CMCI and begin
> polling machine check banks instead. If we find any logged errors,
> then we need to set a per-cpu flag so that our per-cpu tests that
> check whether the storm is ongoing will see that errors are still
> being logged independently of whether mce_notify_irq() says that the
> error has been fully processed.
>
> cmci_clear() is not the right tool to disable a bank. It disables the
> interrupt for the bank as desired, but it also clears the bit for
> this bank in "mce_banks_owned" so we will skip the bank when polling
> (so we fail to see that the storm continues because we stop looking).
> New cmci_storm_disable_banks() just disables the interrupt while
> allowing polling to continue.
>
> Reported-by: William Dauchy <wdauchy@gmail.com>

Could you use the following address instead?
Reported-by: William Dauchy <william@gandi.net>

Thanks,

> Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>

-- 
William
