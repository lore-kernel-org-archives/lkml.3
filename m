Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056Ab3K0BNn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:13:43 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:42868 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758916Ab3K0BNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 20:13:39 -0500
Message-ID: <52954740.5030801@hurleysoftware.com>
Date: Tue, 26 Nov 2013 20:13:36 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>, gregkh@linuxfoundation.org
CC: jirislaby@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] TTY: tty_buffer, warn on leaks
References: <1384200359-31356-1-git-send-email-jslaby@suse.cz> <528164AA.4070300@hurleysoftware.com>
In-Reply-To: <528164AA.4070300@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2013 06:13 PM, Peter Hurley wrote:
> On 11/11/2013 03:05 PM, Jiri Slaby wrote:
>> When we leak something, warn about that. For that we need to account
>> the memory used also in the free_all method. It is handled elsewhere
>> correctly.
>
> Hi Jiri,
>
> Good idea.
>
>> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
>> ---
>>   drivers/tty/tty_buffer.c | 10 ++++++++--
>>   1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
>> index 5f08c39e76ab..20cb9492dbf8 100644
>> --- a/drivers/tty/tty_buffer.c
>> +++ b/drivers/tty/tty_buffer.c
>> @@ -115,21 +115,27 @@ void tty_buffer_free_all(struct tty_port *port)
>>       struct tty_bufhead *buf = &port->buf;
>>       struct tty_buffer *p, *next;
>>       struct llist_node *llist;
>> +    int zero = 0;
>>
>>       while ((p = buf->head) != NULL) {
>>           buf->head = p->next;
>> +        atomic_sub(p->size, &buf->memory_used);
>
> buf->memory_used doesn't need to be treated atomically here,
> and doing so implies that it's necessary.
>
> Accumulating p->size in a non-atomic local is probably better.
>
>>           if (p->size > 0)
>>               kfree(p);
>>       }
>>       llist = llist_del_all(&buf->free);
>> -    llist_for_each_entry_safe(p, next, llist, free)
>> +    llist_for_each_entry_safe(p, next, llist, free) {
>> +        atomic_sub(p->size, &buf->memory_used);
>
> Same here.

Sorry, I forgot:  the buffers on the free list have already been
accounted for in tty_buffer_free() so don't form part of the
buf->mem_used total.

The buffer memory accounting was like that in 3.7 so I left it in.

static void tty_buffer_free(struct tty_port *port, struct tty_buffer *b)
{
	struct tty_bufhead *buf = &port->buf;

	/* Dumb strategy for now - should keep some stats */
	WARN_ON(atomic_sub_return(b->size, &buf->mem_used) < 0);

	if (b->size > MIN_TTYB_SIZE)
		kfree(b);
	else if (b->size > 0)
		llist_add(&b->free, &buf->free);
}

Regards,
Peter Hurley

