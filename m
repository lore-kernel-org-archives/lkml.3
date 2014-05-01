Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbaEAJJw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 05:09:52 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:38779 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbaEAJJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 05:09:50 -0400
Date: Thu, 1 May 2014 12:09:24 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Christian Engelmayer <cengelma@gmx.at>
Cc: devel@driverdev.osuosl.org, mcgrof@do-not-panic.com,
        gregkh@linuxfoundation.org, oat.elena@gmail.com,
        linux-kernel@vger.kernel.org, Larry.Finger@lwfinger.net
Subject: Re: [PATCH] staging: rtl8188eu: fix potential leak in rtw_set_key()
Message-ID: <20140501090924.GK26890@mwanda>
References: <20140501103811.41992b00@spike>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140501103811.41992b00@spike>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 10:38:11AM +0200, Christian Engelmayer wrote:
> Fix a potential leak in the error path of rtw_set_key(). In case the requested
> algorithm is not supported by the driver, the function returns without
> enqueuing or freeing the already allocated command and parameter structs. Use
> a centralized exit path and make sure that all memory is freed correctly.
> Detected by Coverity - CID 1077716, 1077717.
> 
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
> ---
> Compile tested and applies against branch staging-next of tree
> git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
> ---
>  drivers/staging/rtl8188eu/core/rtw_mlme.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme.c b/drivers/staging/rtl8188eu/core/rtw_mlme.c
> index 769d4dd..275ae7b 100644
> --- a/drivers/staging/rtl8188eu/core/rtw_mlme.c
> +++ b/drivers/staging/rtl8188eu/core/rtw_mlme.c
> @@ -1729,13 +1729,12 @@ int rtw_set_key(struct adapter *adapter, struct security_priv *psecuritypriv, in
>  	pcmd = (struct	cmd_obj *)rtw_zmalloc(sizeof(struct	cmd_obj));
>  	if (pcmd == NULL) {
>  		res = _FAIL;  /* try again */
> -		goto exit;
> +		goto fail_noobj;

Just return here.  The do nothing goto is misleading because you assume
it is a there for a purpose but then when you read all the way to the
end, it doesn't do anything useful.  It doesn't do anything at all.

The label statements should be based on the thing which is labeled and
not the goto locations.  In this case it should be something like
"err_free_cmd" and "err_free_keyparm".  The "fail" label is too generic
so it's not a good name.

regards,
dan carpenter

