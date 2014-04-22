Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499AbaDVKCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 06:02:24 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:48005 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517AbaDVKCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 06:02:21 -0400
Date: Tue, 22 Apr 2014 13:01:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Bastien Armand <armand.bastien@laposte.net>
Cc: Willy Tarreau <willy@meta-x.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jake Champlin <jake.champlin.27@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] staging: panel: fix sparse warnings in lcd_write
Message-ID: <20140422100144.GE26890@mwanda>
References: <20140418161057.GC1258@plop.dartybox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140418161057.GC1258@plop.dartybox.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Out of curiosity, have you tested this patch?

On Fri, Apr 18, 2014 at 06:10:57PM +0200, Bastien Armand wrote:
> This patch fixes two sparse warnings related to lcd_write :
> warning: incorrect type in argument 1 (different address spaces)
> warning: incorrect type in initializer (incompatible argument 2 
> (different address spaces))
> 
> lcd_write can be used from kernel space (in panel_lcd_print) or from user
> space. So we introduce the lcd_write_char function that will write a char to
> the device. We modify lcd_write and panel_lcd_print to use it. Finally we add
> __user annotation missing in lcd_write.
> 
> 
> Signed-off-by: Bastien Armand <armand.bastien@laposte.net>
> ---
>  drivers/staging/panel/panel.c |  205 ++++++++++++++++++++++-------------------
>  1 file changed, 109 insertions(+), 96 deletions(-)
> 
> diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
> index 1569e26..dc34254 100644
> --- a/drivers/staging/panel/panel.c
> +++ b/drivers/staging/panel/panel.c
> @@ -1217,111 +1217,113 @@ static inline int handle_lcd_special_code(void)
>  	return processed;
>  }
> 
> +static void lcd_write_char(char c)
> +{
> +	/* first, we'll test if we're in escape mode */
> +	if ((c != '\n') && lcd_escape_len >= 0) {
> +		/* yes, let's add this char to the buffer */
> +		lcd_escape[lcd_escape_len++] = c;
> +		lcd_escape[lcd_escape_len] = 0;
> +	} else {
> +		/* aborts any previous escape sequence */
> +		lcd_escape_len = -1;
> +
> +		switch (c) {
> +		case LCD_ESCAPE_CHAR:
> +			/* start of an escape sequence */
> +			lcd_escape_len = 0;
> +			lcd_escape[lcd_escape_len] = 0;
> +			break;
> +		case '\b':
> +			/* go back one char and clear it */
> +			if (lcd_addr_x > 0) {
> +				/* check if we're not at the
> +				   end of the line */
> +				if (lcd_addr_x < lcd_bwidth)
> +					/* back one char */
> +					lcd_write_cmd(0x10);
> +				lcd_addr_x--;
> +			}
> +			/* replace with a space */
> +			lcd_write_data(' ');
> +			/* back one char again */
> +			lcd_write_cmd(0x10);
> +			break;
> +		case '\014':
> +			/* quickly clear the display */
> +			lcd_clear_fast();
> +			break;
> +		case '\n':
> +			/* flush the remainder of the current line and
> +			   go to the beginning of the next line */
> +			for (; lcd_addr_x < lcd_bwidth; lcd_addr_x++)
> +				lcd_write_data(' ');
> +			lcd_addr_x = 0;
> +			lcd_addr_y = (lcd_addr_y + 1) % lcd_height;
> +			lcd_gotoxy();
> +			break;
> +		case '\r':
> +			/* go to the beginning of the same line */
> +			lcd_addr_x = 0;
> +			lcd_gotoxy();
> +			break;
> +		case '\t':
> +			/* print a space instead of the tab */
> +			lcd_print(' ');
> +			break;
> +		default:
> +			/* simply print this char */
> +			lcd_print(c);
> +			break;
> +		}
> +	}
> +
> +	/* now we'll see if we're in an escape mode and if the current
> +	   escape sequence can be understood. */
> +	if (lcd_escape_len >= 2) {
> +		int processed = 0;
> +
> +		if (!strcmp(lcd_escape, "[2J")) {
> +			/* clear the display */
> +			lcd_clear_fast();
> +			processed = 1;
> +		} else if (!strcmp(lcd_escape, "[H")) {
> +			/* cursor to home */
> +			lcd_addr_x = lcd_addr_y = 0;
> +			lcd_gotoxy();
> +			processed = 1;
> +		}
> +		/* codes starting with ^[[L */
> +		else if ((lcd_escape_len >= 3) &&
> +			 (lcd_escape[0] == '[') &&
> +			 (lcd_escape[1] == 'L')) {
> +			processed = handle_lcd_special_code();
> +		}
> +
> +		/* LCD special escape codes */
> +		/* flush the escape sequence if it's been processed
> +		   or if it is getting too long. */
> +		if (processed || (lcd_escape_len >= LCD_ESCAPE_LEN))
> +			lcd_escape_len = -1;
> +	} /* escape codes */
> +}
> +
>  static ssize_t lcd_write(struct file *file,
> -			 const char *buf, size_t count, loff_t *ppos)
> +	const char __user *buf, size_t count, loff_t *ppos)
>  {
> -	const char *tmp = buf;
> +	const char __user *tmp = buf;
>  	char c;
> 
> -	for (; count-- > 0; (ppos ? (*ppos)++ : 0), ++tmp) {
> +	for (; count-- > 0; (*ppos)++, tmp++) {
>  		if (!in_interrupt() && (((count + 1) & 0x1f) == 0))
>  			/* let's be a little nice with other processes
>  			   that need some CPU */
>  			schedule();
> 
> -		if (ppos == NULL && file == NULL)
> -			/* let's not use get_user() from the kernel ! */
> -			c = *tmp;
> -		else if (get_user(c, tmp))
> +		if (get_user(c, buf))
>  			return -EFAULT;

This is buggy.  You are getting the first character over and over.  You
should be doing:

		if (get_user(c, tmp))
			return -EFAULT;

Btw, this whole function is terrible.  It should be reading larger
chunks at once instead of get_user() for each character.


> 
> -		/* first, we'll test if we're in escape mode */
> -		if ((c != '\n') && lcd_escape_len >= 0) {
> -			/* yes, let's add this char to the buffer */
> -			lcd_escape[lcd_escape_len++] = c;
> -			lcd_escape[lcd_escape_len] = 0;
> -		} else {
> -			/* aborts any previous escape sequence */
> -			lcd_escape_len = -1;
> -
> -			switch (c) {
> -			case LCD_ESCAPE_CHAR:
> -				/* start of an escape sequence */
> -				lcd_escape_len = 0;
> -				lcd_escape[lcd_escape_len] = 0;
> -				break;
> -			case '\b':
> -				/* go back one char and clear it */
> -				if (lcd_addr_x > 0) {
> -					/* check if we're not at the
> -					   end of the line */
> -					if (lcd_addr_x < lcd_bwidth)
> -						/* back one char */
> -						lcd_write_cmd(0x10);
> -					lcd_addr_x--;
> -				}
> -				/* replace with a space */
> -				lcd_write_data(' ');
> -				/* back one char again */
> -				lcd_write_cmd(0x10);
> -				break;
> -			case '\014':
> -				/* quickly clear the display */
> -				lcd_clear_fast();
> -				break;
> -			case '\n':
> -				/* flush the remainder of the current line and
> -				   go to the beginning of the next line */
> -				for (; lcd_addr_x < lcd_bwidth; lcd_addr_x++)
> -					lcd_write_data(' ');
> -				lcd_addr_x = 0;
> -				lcd_addr_y = (lcd_addr_y + 1) % lcd_height;
> -				lcd_gotoxy();
> -				break;
> -			case '\r':
> -				/* go to the beginning of the same line */
> -				lcd_addr_x = 0;
> -				lcd_gotoxy();
> -				break;
> -			case '\t':
> -				/* print a space instead of the tab */
> -				lcd_print(' ');
> -				break;
> -			default:
> -				/* simply print this char */
> -				lcd_print(c);
> -				break;
> -			}
> -		}
> -
> -		/* now we'll see if we're in an escape mode and if the current
> -		   escape sequence can be understood. */
> -		if (lcd_escape_len >= 2) {
> -			int processed = 0;
> -
> -			if (!strcmp(lcd_escape, "[2J")) {
> -				/* clear the display */
> -				lcd_clear_fast();
> -				processed = 1;
> -			} else if (!strcmp(lcd_escape, "[H")) {
> -				/* cursor to home */
> -				lcd_addr_x = lcd_addr_y = 0;
> -				lcd_gotoxy();
> -				processed = 1;
> -			}
> -			/* codes starting with ^[[L */
> -			else if ((lcd_escape_len >= 3) &&
> -				 (lcd_escape[0] == '[') &&
> -				 (lcd_escape[1] == 'L')) {
> -				processed = handle_lcd_special_code();
> -			}
> -
> -			/* LCD special escape codes */
> -			/* flush the escape sequence if it's been processed
> -			   or if it is getting too long. */
> -			if (processed || (lcd_escape_len >= LCD_ESCAPE_LEN))
> -				lcd_escape_len = -1;
> -		} /* escape codes */
> +		lcd_write_char(c);
>  	}
> 
>  	return tmp - buf;
> @@ -1365,8 +1367,19 @@ static struct miscdevice lcd_dev = {
>  /* public function usable from the kernel for any purpose */
>  static void panel_lcd_print(const char *s)
>  {
> -	if (lcd_enabled && lcd_initialized)
> -		lcd_write(NULL, s, strlen(s), NULL);
> +	const char *tmp = s;
> +	int count = strlen(s);
> +
> +	if (lcd_enabled && lcd_initialized) {
> +		for (; count-- > 0; tmp++) {
> +			if (!in_interrupt() && (((count + 1) & 0x1f) == 0))
> +				/* let's be a little nice with other processes
> +				   that need some CPU */
> +				schedule();

This schedule() isn't needed.  It just prints a line or two at start up
and some other debug output or something.  Small small.

regards,
dan carpenter

> +
> +			lcd_write_char(*tmp);
> +		}
> +	}
>  }
> 
>  /* initialize the LCD driver */
> --
> 1.7.10.4
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
