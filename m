Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab3DOVkH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 17:40:07 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:33563 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab3DOVkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 17:40:05 -0400
Date: Mon, 15 Apr 2013 23:39:58 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Benjamin Poirier <bpoirier@suse.de>
Cc: Michal Marek <mmarek@suse.cz>, Wang YanQing <udknight@gmail.com>,
        Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] menuconfig: Add "breadcrumbs" navigation aid
Message-ID: <20130415213958.GA12519@free.fr>
References: <1366035231-24370-1-git-send-email-bpoirier@suse.de>
 <1366035231-24370-2-git-send-email-bpoirier@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366035231-24370-2-git-send-email-bpoirier@suse.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin, All,

On Mon, Apr 15, 2013 at 10:13:51AM -0400, Benjamin Poirier wrote:
> Displays a trail of the menu entries used to get to the current menu.

Very good idea, indeed! :-)

> diff --git a/scripts/kconfig/lxdialog/util.c b/scripts/kconfig/lxdialog/util.c
> index 109d531..9a41d78 100644
> --- a/scripts/kconfig/lxdialog/util.c
> +++ b/scripts/kconfig/lxdialog/util.c
> @@ -257,13 +257,54 @@ void dialog_clear(void)
>  	attr_clear(stdscr, LINES, COLS, dlg.screen.atr);
>  	/* Display background title if it exists ... - SLH */
>  	if (dlg.backtitle != NULL) {
> -		int i;
> +		int i, len = 0;
> +		struct subtitle_list *pos;
>  
>  		wattrset(stdscr, dlg.screen.atr);
>  		mvwaddstr(stdscr, 0, 1, (char *)dlg.backtitle);
>  		wmove(stdscr, 1, 1);
>  		for (i = 1; i < COLS - 1; i++)
>  			waddch(stdscr, ACS_HLINE);

This means you'll be re-writing over this line with the following
code... (follow at [*], below)

> +		for (pos = dlg.subtitles; pos != NULL; pos = pos->next) {
> +			/* 3 is for the arrow and spaces */
> +			len += strlen(pos->text) + 3;
> +		}
> +
> +		if (len) {
> +			int skip = 0;
> +
> +			wmove(stdscr, 1, 1);
> +			if (len > COLS - 2) {
> +				const char *ellipsis = "[...] ";
> +				waddstr(stdscr, ellipsis);
> +				skip = len - (COLS - 2 - strlen(ellipsis));
> +			}
> +
> +			for (pos = dlg.subtitles; pos != NULL; pos =
> +			     pos->next) {
> +				if (skip == 0)
> +					waddch(stdscr, ACS_RARROW);
> +				else
> +					skip--;
> +
> +				if (skip == 0)
> +					waddch(stdscr, ' ');
> +				else
> +					skip--;
> +
> +				if (skip < strlen(pos->text)) {
> +					waddstr(stdscr, pos->text + skip);
> +					skip = 0;
> +				} else
> +					skip -= strlen(pos->text);
> +
> +				if (skip == 0)
> +					waddch(stdscr, ' ');
> +				else
> +					skip--;
> +			}
> +		}

[*] ... when you could have drawn only the needed part here:

+		wmove(stdscr, 1, len+1);
+		for (i = len + 1; i < COLS - 1; i++)
+			waddch(stdscr, ACS_HLINE);

[--SNIP--]

Queued (with that change) into:
https://git.gitorious.org/linux-kconfig/linux-kconfig.git yem-kconfig-for-next

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
