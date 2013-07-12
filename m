Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507Ab3GLJrn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 05:47:43 -0400
Received: from smtp208.alice.it ([82.57.200.104]:37909 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757350Ab3GLJrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 05:47:42 -0400
Date: Fri, 12 Jul 2013 11:47:33 +0200
From: Gianluca Anzolin <gianluca@sottospazio.it>
To: jslaby@suse.cz
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix refcount leak in tty_port.c
Message-ID: <20130712094733.GA28317@debian.seek.priv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130709083535.GA30227>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm sorry to bother you again, I'm just pinging to see if you received the
patch or if it got lost in the noise. It fixes a regression introduced in git
commit aa27a094e2c2e

I have another patch for rfcomm tty waiting for this fix to get applied.

Thank you,

Gianluca

On Tue, Jul 09, 2013 at 10:35:35AM +0200, Gianluca Anzolin wrote:
> Hello,
> 
> In linux 3.10 in the file drivers/tty/tty_port.c the function
> tty_port_tty_hangup may leak a tty reference:
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
> Fix by nesting two if statements.
> 
> Signed-off-by: Gianluca Anzolin <gianluca@sottospazio.it>

> diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
> index 121aeb9..2198f7d 100644
> --- a/drivers/tty/tty_port.c
> +++ b/drivers/tty/tty_port.c
> @@ -256,8 +256,9 @@ void tty_port_tty_hangup(struct tty_port *port, bool check_clocal)
>  {
>  	struct tty_struct *tty = tty_port_tty_get(port);
>  
> -	if (tty && (!check_clocal || !C_CLOCAL(tty))) {
> -		tty_hangup(tty);
> +	if (tty) {
> +		if (!check_clocal || !C_CLOCAL(tty))
> +			tty_hangup(tty);
>  		tty_kref_put(tty);
>  	}
>  }

