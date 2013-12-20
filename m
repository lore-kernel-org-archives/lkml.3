Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721Ab3LTAhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 19:37:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47232 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756516Ab3LTAhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 19:37:38 -0500
Date: Thu, 19 Dec 2013 16:37:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: xqx12 <s2exqx@gmail.com>
Cc: giometti@enneenne.com, linux-kernel@vger.kernel.org, chyyuu@gmail.com,
        xuyongjiande@gmail.com, xqx12 <xiaoqixue_1@163.com>
Subject: Re: [PATCH] a multiplication overflow in drivers/pps/pps.c
Message-Id: <20131219163736.56144b5368be511af2df5a73@linux-foundation.org>
In-Reply-To: <1387352171-3811-1-git-send-email-xiaoqixue_1@163.com>
References: <1387352171-3811-1-git-send-email-xiaoqixue_1@163.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Dec 2013 15:36:11 +0800 xqx12 <s2exqx@gmail.com> wrote:

> there is an overflow in the following code :
> 
> ticks = fdata.timeout.sec * HZ;
> 
> while ticks is a signed 64-bit, but the result of fdata.timeout.sec *
> HZ will be converted be 32-bit first. So ticks will be a wrong value
> after multiplication overflow.

When fixing a bug, please always include a full description of the
user-visible effects of that bug.  This helps others decide which
kernel version(s) should be fixed.

> ...
>
> --- a/drivers/pps/pps.c
> +++ b/drivers/pps/pps.c
> @@ -164,7 +164,7 @@ static long pps_cdev_ioctl(struct file *file,
>  			dev_dbg(pps->dev, "timeout %lld.%09d\n",
>  					(long long) fdata.timeout.sec,
>  					fdata.timeout.nsec);
> -			ticks = fdata.timeout.sec * HZ;
> +			ticks = (s64)(fdata.timeout.sec) * HZ;
>  			ticks += fdata.timeout.nsec / (NSEC_PER_SEC / HZ);
>  
>  			if (ticks != 0) {

pps_fdata.timeout.sec has type __s64, so the patch should be a no-op?

Did you really observe a runtime problem from this?  If so, I suspect
your compiler is busted.


