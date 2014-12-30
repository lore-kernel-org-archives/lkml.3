Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683AbaL3S2r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 13:28:47 -0500
Received: from hofr.at ([212.69.189.236]:35804 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531AbaL3S2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 13:28:46 -0500
Date: Tue, 30 Dec 2014 19:28:43 +0100
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        Michal Kazior <michal.kazior@tieto.com>,
        Ben Greear <greearb@candelatech.com>,
        Chun-Yeow Yeoh <yeohchunyeow@gmail.com>,
        Yanbo Li <yanbol@qti.qualcomm.com>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] ath10k: a few incorrect return handling fix-up
Message-ID: <20141230182842.GA18361@opentech.at>
References: <1419942046-17985-1-git-send-email-der.herr@hofr.at> <54A2DE7C.1050602@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54A2DE7C.1050602@cogentembedded.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Dec 2014, Sergei Shtylyov wrote:

> Hello.
>
> On 12/30/2014 03:20 PM, Nicholas Mc Guire wrote:
>
>> wait_for_completion_timeout does not return negative values so the tests
>> for <= 0 are not needed and the case differentiation in the error handling
>> path unnecessary.
>
>    I decided to verify your statement and I saw that it seems wrong.  
> do_wait_for_common() can return -ERESTARTSYS and the return value gets  
> returned by its callers unchanged.

the -ERESTARTSYS only can be returned if state matches but
wait_for_completion_timemout passes TASK_UNINTERRUPTIBLE
so signal_pending_state will return 0 and never negativ

my understanding of the callchain is:
wait_for_completion_timemout with TASK_UNINTERRUPTIBLE
  -> wait_for_common(...TASK_UNINTERRUPTIBLE)
    -> __wait_for_common(...TASK_UNINTERRUPTIBLE)
      -> do_wait_for_common(...TASK_UNINTERRUPTIBLE)
        -> signal_pending_state(TASK_UNINTERRUPTIBLE...)

static inline int signal_pending_state(long state, struct task_struct *p)
{
        if (!(state & (TASK_INTERRUPTIBLE | TASK_WAKEKILL)))
                return 0;

so wait_for_completion_timemout should return 0 or 1 only

>
>> patch was only compile tested x86_64_defconfig + CONFIG_ATH_CARDS=m
>> CONFIG_ATH10K=m
>
>> patch is against linux-next 3.19.0-rc1 -next-20141226
>
>    Rather patches. It would have been better to send one patch instead of 
> 4 patches with the same name.
>
sorry for that - I had split it into separate patches as it was
in different files - giving them the same name of course was a bit
brain-dead.

please do give it one more look - if the above argument is invalid
I apologize for the noise.


thx!
hofrat
