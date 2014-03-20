Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbaCTGQL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 02:16:11 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:22738 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750917AbaCTGQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 02:16:09 -0400
Message-ID: <532A8794.40103@marvell.com>
Date: Thu, 20 Mar 2014 14:15:48 +0800
From: Jane Li <jiel@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, <joe@perches.com>,
        <tj@kernel.org>, <fweisbec@gmail.com>, <davem@davemloft.net>,
        <keescook@chromium.org>, <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "jiel@marvell.com" <"Jane Li"@mx0b-0016f401.pphosted.com>
Subject: Re: [PATCH] printk: fix one circular lockdep warning about console_lock
References: <23E65EE4544D484CBE73B588E192C6D620B93AC9EB@sc-vexch3.marvell.com> <532A838D.8040209@marvell.com>
In-Reply-To: <532A838D.8040209@marvell.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-03-20_02:2014-03-19,2014-03-20,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1403190204
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2014 06:00 PM, Jan Kara wrote:

> On Wed 19-03-14 11:08:08, Jane Li wrote:
>> On 02/12/2014 05:19 AM, Andrew Morton wrote:
>>> On Tue, 11 Feb 2014 14:50:00 +0800<jiel@marvell.com>  wrote:
>   Umm, I disagree with the patch. What I proposed in my answer to your patch is something like the patch below. Does it fix your problem?
>
> 								Honza
>
> From 91497a88c403a7f22e78fee2f69d7413c6e8209f Mon Sep 17 00:00:00 2001
> From: Jan Kara <jack@suse.cz>
> Date: Wed, 19 Mar 2014 10:56:12 +0100
> Subject: [PATCH] printk: Fixup lockdep annotation in console_suspend()
>
> Although console_suspend() releases console_sem, it doesn't tell lockdep about it. That results in the lockdep warning about circular locking when doing the following:
>   enter suspend ->  resume ->  plug-out CPUx (echo 0 > cpux/online)
>
> Fix the problem by telling lockdep we actually released the semaphore in
> console_suspend() and acquired it again in console_resume().
>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  kernel/printk/printk.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c index 4dae9cbe9259..e6ada322782b 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -1880,6 +1880,7 @@ void suspend_console(void)
>  	console_lock();
>  	console_suspended = 1;
>  	up(&console_sem);
> +	mutex_release(&console_lock_dep_map, 1, _RET_IP_);
>  }
>  
>  void resume_console(void)
> @@ -1887,6 +1888,7 @@ void resume_console(void)
>  	if (!console_suspend_enabled)
>  		return;
>  	down(&console_sem);
> +	mutex_acquire(&console_lock_dep_map, 0, 0, _RET_IP_);
>  	console_suspended = 0;
>  	console_unlock();
>  }
> --
> 1.8.1.4

Oh, yes, this new solution works well. If run same test, no circular lockdep warning occurs now. I will update patch v2.

Sorry for misunderstanding your answer before.

Thanks!

Best Regards,

Jane


