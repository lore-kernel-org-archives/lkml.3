Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933657Ab3LIN11 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 08:27:27 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:59142 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933351Ab3LIN1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 08:27:25 -0500
Message-ID: <52A5C53B.1030003@hurleysoftware.com>
Date: Mon, 09 Dec 2013 08:27:23 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH tty-next 5/5] tty: Halve flip buffer GFP_ATOMIC memory
 consumption
References: <1385140198-5822-1-git-send-email-peter@hurleysoftware.com> <1385140198-5822-6-git-send-email-peter@hurleysoftware.com> <20131209010112.GA31052@kroah.com>
In-Reply-To: <20131209010112.GA31052@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2013 08:01 PM, Greg Kroah-Hartman wrote:
> On Fri, Nov 22, 2013 at 12:09:58PM -0500, Peter Hurley wrote:
>> tty flip buffers use GFP_ATOMIC allocations for received data
>> which is to be processed by the line discipline. For each byte
>> received, an extra byte is used to indicate the error status of
>> that byte.
>>
>> Instead, if the received data is error-free, encode the entire
>> buffer without status bytes.
>>
>> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
>> ---
>>   drivers/tty/tty_buffer.c | 45 +++++++++++++++++++++++++++++++++++----------
>>   include/linux/tty.h      |  4 ++++
>>   include/linux/tty_flip.h |  8 ++++++--
>>   3 files changed, 45 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
>> index 6a3620e..c4fe20e 100644
>> --- a/drivers/tty/tty_buffer.c
>> +++ b/drivers/tty/tty_buffer.c
>> @@ -100,6 +100,7 @@ static void tty_buffer_reset(struct tty_buffer *p, size_t size)
>>   	p->next = NULL;
>>   	p->commit = 0;
>>   	p->read = 0;
>> +	p->flags = 0;
>>   }
>>
>>   /**
>> @@ -230,31 +231,49 @@ void tty_buffer_flush(struct tty_struct *tty)
>>    *	tty_buffer_request_room		-	grow tty buffer if needed
>>    *	@tty: tty structure
>>    *	@size: size desired
>> + *	@flags: buffer flags if new buffer allocated (default = 0)
>>    *
>>    *	Make at least size bytes of linear space available for the tty
>>    *	buffer. If we fail return the size we managed to find.
>> + *
>> + *	Will change over to a new buffer if the current buffer is encoded as
>> + *	TTY_NORMAL (so has no flags buffer) and the new buffer requires
>> + *	a flags buffer.
>>    */
>> -int tty_buffer_request_room(struct tty_port *port, size_t size)
>> +int __tty_buffer_request_room(struct tty_port *port, size_t size, int flags)
>>   {
>>   	struct tty_bufhead *buf = &port->buf;
>>   	struct tty_buffer *b, *n;
>> -	int left;
>> +	int left, change;
>>
>>   	b = buf->tail;
>> -	left = b->size - b->used;
>> +	if (b->flags & TTYB_NORMAL)
>> +		left = 2 * b->size - b->used;
>> +	else
>> +		left = b->size - b->used;
>>
>> -	if (left < size) {
>> +	change = (b->flags & TTYB_NORMAL) && (~flags & TTYB_NORMAL);
>> +	if (change || left < size) {
>>   		/* This is the slow path - looking for new buffers to use */
>>   		if ((n = tty_buffer_alloc(port, size)) != NULL) {
>> +			n->flags = flags;
>>   			buf->tail = n;
>>   			b->commit = b->used;
>>   			smp_mb();
>>   			b->next = n;
>> -		} else
>> +		} else if (change)
>> +			size = 0;
>> +		else
>>   			size = left;
>>   	}
>>   	return size;
>>   }
>> +EXPORT_SYMBOL_GPL(__tty_buffer_request_room);
>
> Why are you exporting this?  There is no function prototype anywhere, so
> no one can even try to call it, it should just be static, right?

Yes, sorry. Thanks for catching this.

> I've applied the first 4 patches in this series, care to fix this one
> up?

Patch coming.
