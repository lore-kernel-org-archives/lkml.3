Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab3GYG0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 02:26:51 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:40785 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032Ab3GYG0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 02:26:50 -0400
Message-ID: <51F0C525.8080506@suse.cz>
Date: Thu, 25 Jul 2013 08:26:45 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Gianluca Anzolin <gianluca@sottospazio.it>, gregkh@linuxfoundation.org
CC: gustavo@padovan.org, peter@hurleysoftware.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty_port: Fix refcounting leak in tty_port_tty_hangup()
References: <1374729977-7164-1-git-send-email-gianluca@sottospazio.it>
In-Reply-To: <1374729977-7164-1-git-send-email-gianluca@sottospazio.it>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2013 07:26 AM, Gianluca Anzolin wrote:
> The function tty_port_tty_hangup() could leak a reference to the tty_struct:
> 
>         struct tty_struct *tty = tty_port_tty_get(port);
> 
>         if (tty && (!check_clocal || !C_CLOCAL(tty))) {
>                 tty_hangup(tty);
>                 tty_kref_put(tty);
>         }
> 
> If tty != NULL and the second condition is false we never call tty_kref_put and
> the reference is leaked.
> 
> Fix by always calling tty_kref_put() which accepts a NULL argument.
> 
> The patch fixes a regression introduced by commit aa27a094.
> 
> Acked-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
> Signed-off-by: Gianluca Anzolin <gianluca@sottospazio.it>

Acked-by: Jiri Slaby <jslaby@suse.cz>

Thanks for the fix.

> ---
>  drivers/tty/tty_port.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
> index 121aeb9..f597e88 100644
> --- a/drivers/tty/tty_port.c
> +++ b/drivers/tty/tty_port.c
> @@ -256,10 +256,9 @@ void tty_port_tty_hangup(struct tty_port *port, bool check_clocal)
>  {
>  	struct tty_struct *tty = tty_port_tty_get(port);
>  
> -	if (tty && (!check_clocal || !C_CLOCAL(tty))) {
> +	if (tty && (!check_clocal || !C_CLOCAL(tty)))
>  		tty_hangup(tty);
> -		tty_kref_put(tty);
> -	}
> +	tty_kref_put(tty);
>  }
>  EXPORT_SYMBOL_GPL(tty_port_tty_hangup);
>  
> 


-- 
js
suse labs
