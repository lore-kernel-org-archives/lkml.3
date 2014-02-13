Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995AbaBMShz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 13:37:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34245 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbaBMShy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 13:37:54 -0500
Date: Thu, 13 Feb 2014 10:39:12 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Adam Borowski <kilobyte@angband.pl>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vt: detect and ignore OSC codes.
Message-ID: <20140213183912.GA18522@kroah.com>
References: <1389766864-22673-1-git-send-email-kilobyte@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389766864-22673-1-git-send-email-kilobyte@angband.pl>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 07:21:04AM +0100, Adam Borowski wrote:
> These can be used to send commands consisting of an arbitrary string to the
> terminal, most often used to set a terminal's window title or to redefine
> the colour palette.  Our console doesn't use OSC, unlike everything else,
> which can lead to junk being displayed if a process sends such a code
> unconditionally.
> 
> Not following Ecma-48, this commit recognizes 7-bit forms (ESC ] ... 0x07,
> ESC ] .. ESC \) but not 8-bit (0x9D ... 0x9C).
> 
> Signed-off-by: Adam Borowski <kilobyte@angband.pl>

Where is this documented?


> ---
>  drivers/tty/vt/vt.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
> index 61b1137..0377c52 100644
> --- a/drivers/tty/vt/vt.c
> +++ b/drivers/tty/vt/vt.c
> @@ -1590,7 +1590,7 @@ static void restore_cur(struct vc_data *vc)
>  
>  enum { ESnormal, ESesc, ESsquare, ESgetpars, ESgotpars, ESfunckey,
>  	EShash, ESsetG0, ESsetG1, ESpercent, ESignore, ESnonstd,
> -	ESpalette };
> +	ESpalette, ESosc };
>  
>  /* console_lock is held (except via vc_init()) */
>  static void reset_terminal(struct vc_data *vc, int do_clear)
> @@ -1650,11 +1650,15 @@ static void do_con_trol(struct tty_struct *tty, struct vc_data *vc, int c)
>  	 *  Control characters can be used in the _middle_
>  	 *  of an escape sequence.
>  	 */
> +	if (vc->vc_state == ESosc && c>=8 && c<=13) /* ... except for OSC */
> +		return;
>  	switch (c) {
>  	case 0:
>  		return;
>  	case 7:
> -		if (vc->vc_bell_duration)
> +		if (vc->vc_state == ESosc)
> +			vc->vc_state = ESnormal;
> +		else if (vc->vc_bell_duration)
>  			kd_mksound(vc->vc_bell_pitch, vc->vc_bell_duration);
>  		return;
>  	case 8:
> @@ -1765,7 +1769,9 @@ static void do_con_trol(struct tty_struct *tty, struct vc_data *vc, int c)
>  		} else if (c=='R') {   /* reset palette */
>  			reset_palette(vc);
>  			vc->vc_state = ESnormal;
> -		} else
> +		} else if (c>='0' && c<='9')
> +			vc->vc_state = ESosc;
> +		else
>  			vc->vc_state = ESnormal;
>  		return;
>  	case ESpalette:
> @@ -2023,6 +2029,8 @@ static void do_con_trol(struct tty_struct *tty, struct vc_data *vc, int c)
>  		return;
>  	default:
>  		vc->vc_state = ESnormal;
> +	case ESosc:
> +		return;

Why below the default: case?

thanks,

greg k-h
