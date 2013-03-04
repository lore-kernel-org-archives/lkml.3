Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171Ab3CDTTo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 14:19:44 -0500
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:50876 "EHLO
	95-31-19-74.broadband.corbina.ru" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758173Ab3CDTTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 14:19:43 -0500
Message-ID: <5134F3CD.3020805@ilyx.ru>
Date: Mon, 04 Mar 2013 23:19:41 +0400
From: Ilya Zykov <ilya@ilyx.ru>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] tty: Correct tty buffer flush.
References: <50BC76E9.2070703@ilyx.ru>
In-Reply-To: <50BC76E9.2070703@ilyx.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.12.2012 13:54, Ilya Zykov wrote:
>   The root of problem is carelessly zeroing pointer(in function __tty_buffer_flush()),
> when another thread can use it. It can be cause of "NULL pointer dereference".
>   Main idea of the patch, this is never release last (struct tty_buffer) in the active buffer.
> Only flush data for ldisc(tty->buf.head->read = tty->buf.head->commit).
> At that moment driver can collect(write) data in buffer without conflict.
> It is repeat behavior of flush_to_ldisc(), only without feeding data to ldisc.
> Test program and bug report you can see:
> https://lkml.org/lkml/2012/11/29/368
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Ilya Zykov <ilya@ilyx.ru>
> ---
> diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
> index 6c9b7cd..4f02f9c 100644
> --- a/drivers/tty/tty_buffer.c
> +++ b/drivers/tty/tty_buffer.c
> @@ -114,11 +114,14 @@ static void __tty_buffer_flush(struct tty_struct *tty)
>  {
>  	struct tty_buffer *thead;
>  
> -	while ((thead = tty->buf.head) != NULL) {
> -		tty->buf.head = thead->next;
> -		tty_buffer_free(tty, thead);
> +	if (tty->buf.head == NULL)
> +		return;
> +	while ((thead = tty->buf.head->next) != NULL) {
> +		tty_buffer_free(tty, tty->buf.head);
> +		tty->buf.head = thead;
>  	}
> -	tty->buf.tail = NULL;
> +	WARN_ON(tty->buf.head != tty->buf.tail);
> +	tty->buf.head->read = tty->buf.head->commit;
>  }
>  
>  /**
> 

You can include this patch, in 3.2 series , for improve stability,
it would be merged in upstream 3.9-rc1.

Thank you.
Ilya.


https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/tty/tty_buffer.c?id=64325a3be08d364a62ee8f84b2cf86934bc2544a

