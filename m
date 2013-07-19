Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751256Ab3GSLBv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 07:01:51 -0400
Received: from pequod.mess.org ([46.65.169.142]:52100 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741Ab3GSLBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 07:01:50 -0400
Date: Fri, 19 Jul 2013 12:01:47 +0100
From: Sean Young <sean@mess.org>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: linux-media@vger.kernel.org, alipowski@interia.pl,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-kernel@vger.kernel.org, srinivas.kandagatla@gmail.com
Subject: Re: [PATCH v1 1/2] media: rc: Add user count to rc dev.
Message-ID: <20130719110147.GA1104@pequod.mess.org>
References: <1374223132-4924-1-git-send-email-srinivas.kandagatla@st.com>
 <1374223167-4980-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374223167-4980-1-git-send-email-srinivas.kandagatla@st.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 09:39:27AM +0100, Srinivas KANDAGATLA wrote:
> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> 
> This patch adds user count to rc_dev structure, the reason to add this
> new member is to allow other code like lirc to open rc device directly.
> In the existing code, rc device is only opened by input subsystem which
> works ok if we have any input drivers to match. But in case like lirc
> where there will be no input driver, rc device will be never opened.
> 
> Having this user count variable will be useful to allow rc device to be
> opened from code other than rc-main.
> 
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> ---
>  drivers/media/rc/rc-main.c |   11 +++++++++--
>  include/media/rc-core.h    |    1 +
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index 1cf382a..e800b96 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -702,15 +702,22 @@ EXPORT_SYMBOL_GPL(rc_keydown_notimeout);
>  static int ir_open(struct input_dev *idev)
>  {
>  	struct rc_dev *rdev = input_get_drvdata(idev);
> +	int rval = 0;
>  
> -	return rdev->open(rdev);
> +	if (!rdev->users++)
> +		rval = rdev->open(rdev);
> +
> +	if (rval)
> +		rdev->users--;
> +
> +	return rval;

This looks racey. Some locking is needed, I think rc_dev->lock should work
fine for this. Here and in the lirc code path too.

Sean

>  }
>  
>  static void ir_close(struct input_dev *idev)
>  {
>  	struct rc_dev *rdev = input_get_drvdata(idev);
>  
> -	 if (rdev)
> +	 if (rdev && !--rdev->users)
>  		rdev->close(rdev);
>  }
>  
> diff --git a/include/media/rc-core.h b/include/media/rc-core.h
> index 06a75de..b42016a 100644
> --- a/include/media/rc-core.h
> +++ b/include/media/rc-core.h
> @@ -101,6 +101,7 @@ struct rc_dev {
>  	bool				idle;
>  	u64				allowed_protos;
>  	u64				enabled_protocols;
> +	u32				users;
>  	u32				scanmask;
>  	void				*priv;
>  	spinlock_t			keylock;
> -- 
> 1.7.6.5
