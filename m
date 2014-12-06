Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaLFKS4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 05:18:56 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61520 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbaLFKSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 05:18:54 -0500
Date: Sat, 6 Dec 2014 11:18:49 +0100
From: Mariusz Gorski <marius.gorski@gmail.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Willy Tarreau <w@1wt.eu>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: panel: Remove magic numbers in LCD commands
Message-ID: <20141206101849.GA2959@firebird>
References: <1417813843-7589-1-git-send-email-marius.gorski@gmail.com>
 <20141206081652.GA5320@sudip-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141206081652.GA5320@sudip-PC>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 06, 2014 at 01:46:52PM +0530, Sudip Mukherjee wrote:
> On Fri, Dec 05, 2014 at 10:10:43PM +0100, Mariusz Gorski wrote:
> > Get rid of magic numbers in LCD commands and replace them with defined
> > values, so that it's more obvious that the commands are doing.
> > 
> it is not applying to next-20141205. is it based on staging-testing ?

Yes, it's based on yesterday's staging-testing + my previous, not yet
applied patch: https://lkml.org/lkml/2014/12/3/732

Cheers,
Mariusz

> thanks
> sudip
> 
> > Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>
> > ---
> >  drivers/staging/panel/panel.c | 83 +++++++++++++++++++++++++++++--------------
> >  1 file changed, 57 insertions(+), 26 deletions(-)
> > 
> > diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
> > index b68a9c3..fbba46f 100644
> > --- a/drivers/staging/panel/panel.c
> > +++ b/drivers/staging/panel/panel.c
> > @@ -130,6 +130,28 @@
> >  #define LCD_FLAG_N		0x0040	/* 2-rows mode */
> >  #define LCD_FLAG_L		0x0080	/* backlight enabled */
> >  
> > +/* LCD commands */
> > +#define LCD_CMD_DISPLAY_CLEAR	0x01	/* Clear entire display */
> > +
> > +#define LCD_CMD_ENTRY_MODE	0x04	/* Set entry mode */
> > +#define LCD_CMD_CURSOR_INC	0x02	/* Increment cursor */
> > +
> > +#define LCD_CMD_DISPLAY_CTRL	0x08	/* Display control */
> > +#define LCD_CMD_DISPLAY_ON	0x04	/* Set display on */
> > +#define LCD_CMD_CURSOR_ON	0x02	/* Set cursor on */
> > +#define LCD_CMD_BLINK_ON	0x01	/* Set blink on */
> > +
> > +#define LCD_CMD_SHIFT		0x10	/* Shift cursor/display */
> > +#define LCD_CMD_DISPLAY_SHIFT	0x08	/* Shift display instead of cursor */
> > +#define LCD_CMD_SHIFT_RIGHT	0x04	/* Shift display/cursor to the right */
> > +
> > +#define LCD_CMD_FUNCTION_SET	0x20	/* Set function */
> > +#define LCD_CMD_DATA_LEN_8BITS	0x10	/* Set data length to 8 bits */
> > +
> > +#define LCD_CMD_SET_CGRAM_ADDR	0x40	/* Set char generator RAM address */
> > +
> > +#define LCD_CMD_SET_DDRAM_ADDR	0x80	/* Set display data RAM address */
> > +
> >  #define LCD_ESCAPE_LEN		24	/* max chars for LCD escape command */
> >  #define LCD_ESCAPE_CHAR	27	/* use char 27 for escape command */
> >  
> > @@ -883,7 +905,7 @@ static void lcd_write_data_tilcd(int data)
> >  
> >  static void lcd_gotoxy(void)
> >  {
> > -	lcd_write_cmd(0x80	/* set DDRAM address */
> > +	lcd_write_cmd(LCD_CMD_SET_DDRAM_ADDR
> >  		      | (lcd.addr.y ? lcd.hwidth : 0)
> >  		      /* we force the cursor to stay at the end of the
> >  			 line if it wants to go farther */
> > @@ -991,7 +1013,7 @@ static void lcd_clear_fast_tilcd(void)
> >  /* clears the display and resets X/Y */
> >  static void lcd_clear_display(void)
> >  {
> > -	lcd_write_cmd(0x01);	/* clear display */
> > +	lcd_write_cmd(LCD_CMD_DISPLAY_CLEAR);
> >  	lcd.addr.x = 0;
> >  	lcd.addr.y = 0;
> >  	/* we must wait a few milliseconds (15) */
> > @@ -1005,26 +1027,29 @@ static void lcd_init_display(void)
> >  
> >  	long_sleep(20);		/* wait 20 ms after power-up for the paranoid */
> >  
> > -	lcd_write_cmd(0x30);	/* 8bits, 1 line, small fonts */
> > +	/* 8bits, 1 line, small fonts; let's do it 3 times */
> > +	lcd_write_cmd(LCD_CMD_FUNCTION_SET | LCD_CMD_DATA_LEN_8BITS);
> >  	long_sleep(10);
> > -	lcd_write_cmd(0x30);	/* 8bits, 1 line, small fonts */
> > +	lcd_write_cmd(LCD_CMD_FUNCTION_SET | LCD_CMD_DATA_LEN_8BITS);
> >  	long_sleep(10);
> > -	lcd_write_cmd(0x30);	/* 8bits, 1 line, small fonts */
> > +	lcd_write_cmd(LCD_CMD_FUNCTION_SET | LCD_CMD_DATA_LEN_8BITS);
> >  	long_sleep(10);
> >  
> > -	lcd_write_cmd(0x30	/* set font height and lines number */
> > +	/* set font height and lines number */
> > +	lcd_write_cmd(LCD_CMD_FUNCTION_SET | LCD_CMD_DATA_LEN_8BITS
> >  		      | ((lcd.flags & LCD_FLAG_F) ? 4 : 0)
> >  		      | ((lcd.flags & LCD_FLAG_N) ? 8 : 0)
> >  	    );
> >  	long_sleep(10);
> >  
> > -	lcd_write_cmd(0x08);	/* display off, cursor off, blink off */
> > +	/* display off, cursor off, blink off */
> > +	lcd_write_cmd(LCD_CMD_DISPLAY_CTRL);
> >  	long_sleep(10);
> >  
> > -	lcd_write_cmd(0x08	/* set display mode */
> > -		      | ((lcd.flags & LCD_FLAG_D) ? 4 : 0)
> > -		      | ((lcd.flags & LCD_FLAG_C) ? 2 : 0)
> > -		      | ((lcd.flags & LCD_FLAG_B) ? 1 : 0)
> > +	lcd_write_cmd(LCD_CMD_DISPLAY_CTRL	/* set display mode */
> > +		      | ((lcd.flags & LCD_FLAG_D) ? LCD_CMD_DISPLAY_ON : 0)
> > +		      | ((lcd.flags & LCD_FLAG_C) ? LCD_CMD_CURSOR_ON : 0)
> > +		      | ((lcd.flags & LCD_FLAG_B) ? LCD_CMD_BLINK_ON : 0)
> >  	    );
> >  
> >  	lcd_backlight((lcd.flags & LCD_FLAG_L) ? 1 : 0);
> > @@ -1032,7 +1057,7 @@ static void lcd_init_display(void)
> >  	long_sleep(10);
> >  
> >  	/* entry mode set : increment, cursor shifting */
> > -	lcd_write_cmd(0x06);
> > +	lcd_write_cmd(LCD_CMD_ENTRY_MODE | LCD_CMD_CURSOR_INC);
> >  
> >  	lcd_clear_display();
> >  }
> > @@ -1116,7 +1141,7 @@ static inline int handle_lcd_special_code(void)
> >  		if (lcd.addr.x > 0) {
> >  			/* back one char if not at end of line */
> >  			if (lcd.addr.x < lcd.bwidth)
> > -				lcd_write_cmd(0x10);
> > +				lcd_write_cmd(LCD_CMD_SHIFT);
> >  			lcd.addr.x--;
> >  		}
> >  		processed = 1;
> > @@ -1124,19 +1149,20 @@ static inline int handle_lcd_special_code(void)
> >  	case 'r':	/* shift cursor right */
> >  		if (lcd.addr.x < lcd.width) {
> >  			/* allow the cursor to pass the end of the line */
> > -			if (lcd.addr.x <
> > -			    (lcd.bwidth - 1))
> > -				lcd_write_cmd(0x14);
> > +			if (lcd.addr.x < (lcd.bwidth - 1))
> > +				lcd_write_cmd(LCD_CMD_SHIFT |
> > +						LCD_CMD_SHIFT_RIGHT);
> >  			lcd.addr.x++;
> >  		}
> >  		processed = 1;
> >  		break;
> >  	case 'L':	/* shift display left */
> > -		lcd_write_cmd(0x18);
> > +		lcd_write_cmd(LCD_CMD_SHIFT | LCD_CMD_DISPLAY_SHIFT);
> >  		processed = 1;
> >  		break;
> >  	case 'R':	/* shift display right */
> > -		lcd_write_cmd(0x1C);
> > +		lcd_write_cmd(LCD_CMD_SHIFT | LCD_CMD_DISPLAY_SHIFT |
> > +				LCD_CMD_SHIFT_RIGHT);
> >  		processed = 1;
> >  		break;
> >  	case 'k': {	/* kill end of line */
> > @@ -1205,7 +1231,7 @@ static inline int handle_lcd_special_code(void)
> >  			esc++;
> >  		}
> >  
> > -		lcd_write_cmd(0x40 | (cgaddr * 8));
> > +		lcd_write_cmd(LCD_CMD_SET_CGRAM_ADDR | (cgaddr * 8));
> >  		for (addr = 0; addr < cgoffset; addr++)
> >  			lcd_write_data(cgbytes[addr]);
> >  
> > @@ -1244,13 +1270,18 @@ static inline int handle_lcd_special_code(void)
> >  		if ((oldflags ^ lcd.flags) &
> >  		    (LCD_FLAG_B | LCD_FLAG_C | LCD_FLAG_D))
> >  			/* set display mode */
> > -			lcd_write_cmd(0x08
> > -				      | ((lcd.flags & LCD_FLAG_D) ? 4 : 0)
> > -				      | ((lcd.flags & LCD_FLAG_C) ? 2 : 0)
> > -				      | ((lcd.flags & LCD_FLAG_B) ? 1 : 0));
> > +			/* TODO: This indent party here got ugly, clean it! */
> > +			lcd_write_cmd(LCD_CMD_DISPLAY_CTRL
> > +				      | ((lcd.flags & LCD_FLAG_D)
> > +						      ? LCD_CMD_DISPLAY_ON : 0)
> > +				      | ((lcd.flags & LCD_FLAG_C)
> > +						      ? LCD_CMD_CURSOR_ON : 0)
> > +				      | ((lcd.flags & LCD_FLAG_B)
> > +						      ? LCD_CMD_BLINK_ON : 0));
> >  		/* check whether one of F,N flags was changed */
> >  		else if ((oldflags ^ lcd.flags) & (LCD_FLAG_F | LCD_FLAG_N))
> > -			lcd_write_cmd(0x30
> > +			lcd_write_cmd(LCD_CMD_FUNCTION_SET
> > +				      | LCD_CMD_DATA_LEN_8BITS
> >  				      | ((lcd.flags & LCD_FLAG_F) ? 4 : 0)
> >  				      | ((lcd.flags & LCD_FLAG_N) ? 8 : 0));
> >  		/* check whether L flag was changed */
> > @@ -1291,13 +1322,13 @@ static void lcd_write_char(char c)
> >  				   end of the line */
> >  				if (lcd.addr.x < lcd.bwidth)
> >  					/* back one char */
> > -					lcd_write_cmd(0x10);
> > +					lcd_write_cmd(LCD_CMD_SHIFT);
> >  				lcd.addr.x--;
> >  			}
> >  			/* replace with a space */
> >  			lcd_write_data(' ');
> >  			/* back one char again */
> > -			lcd_write_cmd(0x10);
> > +			lcd_write_cmd(LCD_CMD_SHIFT);
> >  			break;
> >  		case '\014':
> >  			/* quickly clear the display */
> > -- 
> > 2.1.3
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
