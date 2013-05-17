Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab3EQXlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 19:41:47 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:45073 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551Ab3EQXlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 19:41:46 -0400
Message-ID: <5196C02C.2080707@ahsoftware.de>
Date: Sat, 18 May 2013 01:41:32 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] tty: make sure a BUG is hit if tty_port will be destroyed
 before tty
References: <5195B561.3090503@ahsoftware.de> <1368774728-4817-1-git-send-email-holler@ahsoftware.de> <20130517153136.GC19541@kroah.com> <51965DC0.7030901@ahsoftware.de> <5196718D.30904@hurleysoftware.com> <5196835B.4060100@ahsoftware.de> <5196887A.2010906@ahsoftware.de> <5196B477.8080904@hurleysoftware.com>
In-Reply-To: <5196B477.8080904@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 18.05.2013 00:51, schrieb Peter Hurley:
> On 05/17/2013 03:43 PM, Alexander Holler wrote:
>> Am 17.05.2013 21:22, schrieb Alexander Holler:
>>
>>> The case that the machine didn't die, but just the process, only happens
>>> when my proposed patch is applied, which prevents the memory corruption.
>>
>> In short, the proposed BUG_ON() prevents the memory corruption because
>> it is hit before something bad can happen. The result is that just the
>> process in question will be killed (and a tty is not released), but only
>> that BUG_ON() prevents that something _really_ bad happens.
>>
>> I hope I could describe it now clearly. ;)
>
> Your descriptions have been clear and I understood your meaning. However,
> I think you may have misunderstood my suggestion.
>
> Would you please test the patch below?
>
> --- >% ---
> Subject: [PATCH] tty: Prevent tty_port destruction if tty not released
>
> If the tty driver mistakenly drops the last port reference
> before the tty has been released, issue a diagnostic and
> abort the port destruction.
>
> This will leak memory and may zombify the port, but should
> otherwise keep the machine in runnable state.
>
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>   drivers/tty/tty_port.c | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
> index 6d9e0b2..a4f4fa9 100644
> --- a/drivers/tty/tty_port.c
> +++ b/drivers/tty/tty_port.c
> @@ -140,6 +140,10 @@ EXPORT_SYMBOL(tty_port_destroy);
>   static void tty_port_destructor(struct kref *kref)
>   {
>       struct tty_port *port = container_of(kref, struct tty_port, kref);
> +
> +    /* check if last port ref was dropped before tty release */
> +    if (WARN_ON(port->itty))
> +        return;
>       if (port->xmit_buf)
>           free_page((unsigned long)port->xmit_buf);
>       tty_port_destroy(port);

I don't have to test this, I see what will happen. Sorry, but I'm 
exhausted and need a break dealing with lkml and maintainers.

Regards,

Alexander Holler
