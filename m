Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340AbaLPHhZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 02:37:25 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:63183 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaLPHhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 02:37:24 -0500
Date: Tue, 16 Dec 2014 08:37:58 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Imre Deak <imre.deak@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/3] vt: fix locking around vt_bind/vt_unbind
Message-ID: <20141216073758.GH2711@phenom.ffwll.local>
Mail-Followup-To: Imre Deak <imre.deak@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jiri Slaby <jslaby@suse.cz>,
	Peter Hurley <peter@hurleysoftware.com>,
	linux-kernel@vger.kernel.org
References: <1418681761-3709-1-git-send-email-imre.deak@intel.com>
 <1418681761-3709-2-git-send-email-imre.deak@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418681761-3709-2-git-send-email-imre.deak@intel.com>
X-Operating-System: Linux phenom 3.16-2-amd64 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 12:16:00AM +0200, Imre Deak wrote:
> Currently vt_bind and vt_unbind access at least the con_driver object
> and registered_con_driver array without holding the console lock. Fix
> this by locking around the whole function in each case.
> 
> Signed-off-by: Imre Deak <imre.deak@intel.com>
> Reviewed-by: Peter Hurley <peter@hurleysoftware.com>

Well it's not pretty that console_lock is constantly growing and getting
pushed up the lock dep chain the past few years for various reasons, but
this here looks genuine and won't wrap new locks in console_lock.

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

> ---
>  drivers/tty/vt/vt.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
> index 9c046fb..5d36c23 100644
> --- a/drivers/tty/vt/vt.c
> +++ b/drivers/tty/vt/vt.c
> @@ -3318,11 +3318,8 @@ static int vt_bind(struct con_driver *con)
>  		if (first == 0 && last == MAX_NR_CONSOLES -1)
>  			deflt = 1;
>  
> -		if (first != -1) {
> -			console_lock();
> +		if (first != -1)
>  			do_bind_con_driver(csw, first, last, deflt);
> -			console_unlock();
> -		}
>  
>  		first = -1;
>  		last = -1;
> @@ -3362,9 +3359,7 @@ static int vt_unbind(struct con_driver *con)
>  			deflt = 1;
>  
>  		if (first != -1) {
> -			console_lock();
>  			ret = do_unbind_con_driver(csw, first, last, deflt);
> -			console_unlock();
>  			if (ret != 0)
>  				return ret;
>  		}
> @@ -3394,11 +3389,15 @@ static ssize_t store_bind(struct device *dev, struct device_attribute *attr,
>  	struct con_driver *con = dev_get_drvdata(dev);
>  	int bind = simple_strtoul(buf, NULL, 0);
>  
> +	console_lock();
> +
>  	if (bind)
>  		vt_bind(con);
>  	else
>  		vt_unbind(con);
>  
> +	console_unlock();
> +
>  	return count;
>  }
>  
> -- 
> 1.8.4
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
