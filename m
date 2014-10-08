Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbaJHXMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 19:12:23 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:60708 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979AbaJHXMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 19:12:22 -0400
Date: Wed, 8 Oct 2014 16:12:08 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Josh Boyer <jwboyer@fedoraproject.org>, torvalds@linuxfoundation.org
Cc: Josh Cartwright <joshc@codeaurora.org>,
        Pramod Gurav <pramod.gurav@smartplayin.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: pinctrl-msm build error on Linus' tree
Message-ID: <20141008231208.GB25134@roeck-us.net>
References: <CA+5PVA4mO+BiTGvrRb7-MLZRV1iQKsmvaDifFLQiqZN1-b88RQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA4mO+BiTGvrRb7-MLZRV1iQKsmvaDifFLQiqZN1-b88RQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020204.5435C4D6.000A,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 7
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 06:42:55PM -0400, Josh Boyer wrote:
> We're hitting a build error on ARM with Linus' tree as of Linux
> v3.17-2860-gef0625b70dac :
> 
> drivers/pinctrl/qcom/pinctrl-msm.c: In function 'msm_pinctrl_setup_pm_reset':
> drivers/pinctrl/qcom/pinctrl-msm.c:875:4: error: implicit declaration
> of function 'register_restart_handler'
> [-Werror=implicit-function-declaration]
>     if (register_restart_handler(&pctrl->restart_nb))
>     ^
> drivers/pinctrl/qcom/pinctrl-msm.c: In function 'msm_pinctrl_remove':
> drivers/pinctrl/qcom/pinctrl-msm.c:949:2: error: implicit declaration
> of function 'unregister_restart_handler'
> [-Werror=implicit-function-declaration]
>   unregister_restart_handler(&pctrl->restart_nb);
>   ^
> cc1: some warnings being treated as errors
> 
> Looking at the git logs it seems this was added via:
> 
> commit cf1fc187628913070c3e418ce0e205732435aa2f
> Author: Josh Cartwright <joshc@codeaurora.org>
> Date:   Tue Sep 23 15:59:53 2014 -0500
> 
>     pinctrl: qcom: use restart_notifier mechanism for ps_hold
> 
> 
> However, there is literally nothing else in the tree that calls or
> provides those functions:
> 
> [jwboyer@vader linux]$ git grep unregister_restart_handler
> drivers/pinctrl/qcom/pinctrl-msm.c:     unregister_restart_handler(&pctrl->resta
> [jwboyer@vader linux]$
> 
> 
> I'm rather confused.  How was this commit built and tested?
> 

Looks like the pinctrl tree did not include the merge with the immutable
branch with the necessary infrastructure in its pull request to Linus :-(.
As for how it was tested in the pinctrl tree, no idea. Maybe pinctrl-msm has
some dependency which was missing in the pinctrl tree and came in through
a different pull request.

For this to build, you'll need to merge

git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git restart-handler-for-v3.18

which was supposed to be merged by all trees using it, to avoid exactly
this problem (clk, power/restart, and watchdog are the other trees I am
aware of).

Best solution might be for Linus to pull the above tag directly, after
screaming at me appropriately. Sorry, I thought we had this well covered.

Guenter
