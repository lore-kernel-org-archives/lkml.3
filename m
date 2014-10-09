Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbaJIOpY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 10:45:24 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:35658 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755848AbaJIOpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 10:45:20 -0400
Message-ID: <54369F77.5000906@hurleysoftware.com>
Date: Thu, 09 Oct 2014 10:45:11 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Sudhir Sreedharan <ssreedharan@mvista.com>, gregkh@linuxfoundation.org,
        khilman@kernel.org
CC: linux-serial@vger.kernel.org, jslaby@suse.cz, linux-kernel@vger.kernel.org,
        olof@lixom.net, linux-arm-kernel@lists.infradead.org,
        geert@linux-m68k.org
Subject: Re: [PATCH] tty: serial: 8250_core: Do not call set_sleep for console
 port
References: <CAJJ77WtZKtDqxRQv4+zH6DDnBKq9RmsKT7DYe7d+H-ztjKNQ7A@mail.gmail.com> <1412862326-6147-1-git-send-email-ssreedharan@mvista.com>
In-Reply-To: <1412862326-6147-1-git-send-email-ssreedharan@mvista.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sudhir,

On 10/09/2014 09:45 AM, Sudhir Sreedharan wrote:
> In ST16650V2 based serial uarts, while initalizing the PM state,
> LCR registers are being initialized to 0 in serial8250_set_sleep().
> If console port is already initialized and being used, this will
> throws garbage in the console.
> 
> Signed-off-by: Sudhir Sreedharan <ssreedharan@mvista.com>
> ---
>  drivers/tty/serial/8250/8250_core.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
> index ca5cfdc..994aa25 100644
> --- a/drivers/tty/serial/8250/8250_core.c
> +++ b/drivers/tty/serial/8250/8250_core.c
> @@ -2618,6 +2618,9 @@ void serial8250_do_pm(struct uart_port *port, unsigned int state,
>  {
>  	struct uart_8250_port *p = up_to_u8250p(port);
>  
> +	if (port->cons && (port->cons->flags & CON_ENABLED) && (state == 0))
> +		return;
> +
>  	serial8250_set_sleep(p, state != 0);
>  }
>  EXPORT_SYMBOL(serial8250_do_pm);

Please just fix serial8250_set_sleep() register programming to save and restore the
LCR.

You could also fix:
1. preserving the other EFR bits
2. acquiring the port lock around the register programming. Not entirely sure it's
absolutely necessary because the serial core serializes most heavy duty register
programming with port mutex, but it's probably wise anyway.

Regards,
Peter Hurley

