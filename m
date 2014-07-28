Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462AbaG1It1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:49:27 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:50955 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbaG1ItZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:49:25 -0400
Message-ID: <53D60E8F.6080208@suse.cz>
Date: Mon, 28 Jul 2014 10:49:19 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: "xinhui.pan" <xinhuix.pan@intel.com>, Greg KH <gregkh@linuxfoundation.org>
CC: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
        Peter Hurley <peter@hurleysoftware.com>, mnipxh <mnipxh@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty/n_gsm.c: fix a memory leak in gsmld_open
References: <53D6067C.4000702@intel.com>
In-Reply-To: <53D6067C.4000702@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2014 10:14 AM, xinhui.pan wrote:
> If gsmld_attach_gsm fails, the gsm is not used anymore.
> tty core will not call gsmld_close to do the cleanup work.
> tty core just restore to the tty old ldisc.
> That always causes memory leak.

Nice catch!

> --- a/drivers/tty/n_gsm.c
> +++ b/drivers/tty/n_gsm.c
> @@ -2382,7 +2383,13 @@ static int gsmld_open(struct tty_struct *tty)
>  
>  	/* Attach the initial passive connection */
>  	gsm->encoding = 1;
> -	return gsmld_attach_gsm(tty, gsm);
> +
> +	ret = gsmld_attach_gsm(tty, gsm);
> +	if (ret != 0) {
> +		gsm_cleanup_mux(gsm);
> +		mux_put(gsm);

It is quite illogical to put the mux here. It should be in gsmld_open.
I.e. gsm_cleanup_mux here, mux_put there.

thanks,
-- 
js
suse labs
