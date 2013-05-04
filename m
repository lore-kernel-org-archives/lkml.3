Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758962Ab3EDMvV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 08:51:21 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35968 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758927Ab3EDMvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 08:51:18 -0400
Date: Sat, 4 May 2013 14:51:16 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: "len.brown@intel.com" <len.brown@intel.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH] PM: Fix dev_pm_put_subsys_data() to not call kfree()
 while holding device power lock
Message-ID: <20130504125116.GA13770@amd.pavel.ucw.cz>
References: <1367614010.8452.2.camel@lorien>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367614010.8452.2.camel@lorien>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> dev_pm_put_subsys_data() calls kfree() while holding device power lock, when
> the reference count is 0. Fix it to call kfree() after releasing the lock.
> 
> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> ---
>  drivers/base/power/common.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
w> diff --git a/drivers/base/power/common.c b/drivers/base/power/common.c
> index 39c3252..da05fe2 100644
> --- a/drivers/base/power/common.c
> +++ b/drivers/base/power/common.c
> @@ -73,13 +73,17 @@ int dev_pm_put_subsys_data(struct device *dev)
>  
>  	if (--psd->refcount == 0) {
>  		dev->power.subsys_data = NULL;
> -		kfree(psd);
>  		ret = 1;
>  	}
>  
>   out:
>  	spin_unlock_irq(&dev->power.lock);
>  
> +	if (ret == 1) {
> +		/* kfree() verifies that its argument is nonzero. */
> +		kfree(psd);
> +	}
> +
>  	return ret;
>  }

Wow, that function is fragile. It returns 0/1/-EINVAL, while being
documented for 0/1...

Patch does not look obviously wrong, but maybe 

@@ -73,13 +73,17 @@ int dev_pm_put_subsys_data(struct device *dev)
 
 	if (--psd->refcount == 0) {
 		dev->power.subsys_data = NULL;
+		spin_unlock_irq(&dev->power.lock);
-		kfree(psd);
- 		ret = 1;
+		return 1;
 	}

Would be cleaner.
									Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
