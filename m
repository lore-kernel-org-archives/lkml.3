Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563Ab3AWQzO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 11:55:14 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:63098 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756437Ab3AWQzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 11:55:12 -0500
Message-ID: <51001447.3030600@inktank.com>
Date: Wed, 23 Jan 2013 10:48:07 -0600
From: Alex Elder <elder@inktank.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Cong Ding <dinggnu@gmail.com>
CC: Sage Weil <sage@inktank.com>, "David S. Miller" <davem@davemloft.net>,
        ceph-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/ceph/osdmap.c: fix undefined behavior when using
 snprintf()
References: <1358882429-19066-1-git-send-email-dinggnu@gmail.com>
In-Reply-To: <1358882429-19066-1-git-send-email-dinggnu@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2013 01:20 PM, Cong Ding wrote:
> The variable "str" is used as both the source and destination in function
> snprintf(), which is undefined behavior based on C11. The original description
> in C11 is:
> 	"If copying takes place between objects that
> 	overlap, the behavior is undefined."

Yes, this was an ill-advised thing to do in this function.

In fact, the only place this function is used (in osdmap_show()),
the non-static buffer was not initialized before the call.  (It
might happen to work because the same stack space was getting
reused each time through the loop.  Eeeeew!)

This is just an awful couple of functions.

> And, the function of ceph_osdmap_state_str() is to return the osdmap state, so
> it should return "doesn't exist" when all the conditions are not satisfied. I
> fix it in this patch.
> 
> Based on C11, snprintf() does nothing if n==0:
> 	"If n is zero, nothing is written, and s may be a
> 	null pointer. Otherwise, output characters beyond
> 	the n-1st are discarded rather than being written to
> 	the array, and a null character is written at the
> 	end of the characters actually written into the
> 	array."
> so I remove the unnecessary check of len (because it is not a busy path and
> saves a few lines of code).

True.  But since you know it's not going to do anything why
not only make the call if len is non-zero?  I.e.:

	else if (len)
		snprintf(str, len, "doesn't exist");

With your permission I'll make this change and will commit
this for you.  OK?

> Signed-off-by: Cong Ding <dinggnu@gmail.com>

Reviewed-by: Alex Elder <elder@inktank.com>

> ---
>  net/ceph/osdmap.c |   27 ++++++++-------------------
>  1 file changed, 8 insertions(+), 19 deletions(-)
> 
> diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
> index de73214..3131a99d3 100644
> --- a/net/ceph/osdmap.c
> +++ b/net/ceph/osdmap.c
> @@ -13,26 +13,15 @@
>  
>  char *ceph_osdmap_state_str(char *str, int len, int state)
>  {
> -	int flag = 0;
> -
> -	if (!len)
> -		goto done;
> -
> -	*str = '\0';
> -	if (state) {
> -		if (state & CEPH_OSD_EXISTS) {
> -			snprintf(str, len, "exists");
> -			flag = 1;
> -		}
> -		if (state & CEPH_OSD_UP) {
> -			snprintf(str, len, "%s%s%s", str, (flag ? ", " : ""),
> -				 "up");
> -			flag = 1;
> -		}
> -	} else {
> +	if ((state & CEPH_OSD_EXISTS) && (state & CEPH_OSD_UP))
> +		snprintf(str, len, "exists, up");
> +	else if (state & CEPH_OSD_EXISTS)
> +		snprintf(str, len, "exists");
> +	else if (state & CEPH_OSD_UP)
> +		snprintf(str, len, "up");
> +	else
>  		snprintf(str, len, "doesn't exist");
> -	}
> -done:
> +
>  	return str;
>  }
>  
> 

