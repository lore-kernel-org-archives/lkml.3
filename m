Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296AbbAWTAi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 14:00:38 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:64776 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbbAWTAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 14:00:35 -0500
Message-ID: <54C29A51.1050904@acm.org>
Date: Fri, 23 Jan 2015 13:00:33 -0600
From: Corey Minyard <minyard@acm.org>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: nick <xerofoify@gmail.com>
CC: openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] char:ipmi: Free ipmi_recv_msg messages from the linked
 list,recv_msgs for the function,ipmi_release in the file,ipmi_devintf.c
References: <1422036143-27808-1-git-send-email-xerofoify@gmail.com> <54C292A7.9090000@gmail.com>
In-Reply-To: <54C292A7.9090000@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2015 12:27 PM, nick wrote:
> Corney,
> Hope this patch fixes the issue. Sorry about missing that kfree
> being required. :(

Well, the kfree needs to be after the free of the messages.    You can't
use an item after you free it.

-corey

> Nick
>
>
> On 2015-01-23 01:02 PM, Nicholas Krause wrote:
>> This adds a loop through the elements in the linked list, recv_msgs using
>> list_for_entry_safe in order to free messages in this list.  In addition
>> we are using the safe version of this marco in order to prevent use after
>> bugs related to deleting the element we are on currently by holding a
>> pointer to the next element after the current one we are on and freeing
>> with the function, ipmi_free_recv_msg internally in this loop.
>>
>> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>> ---
>>  drivers/char/ipmi/ipmi_devintf.c | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/char/ipmi/ipmi_devintf.c b/drivers/char/ipmi/ipmi_devintf.c
>> index ec318bf..a625510 100644
>> --- a/drivers/char/ipmi/ipmi_devintf.c
>> +++ b/drivers/char/ipmi/ipmi_devintf.c
>> @@ -157,14 +157,19 @@ static int ipmi_release(struct inode *inode, struct file *file)
>>  {
>>  	struct ipmi_file_private *priv = file->private_data;
>>  	int                      rv;
>> +	struct  ipmi_recv_msg *msg, *next;
>>  
>>  	rv = ipmi_destroy_user(priv->user);
>>  	if (rv)
>>  		return rv;
>>  
>> -	/* FIXME - free the messages in the list. */
>>  	kfree(priv);
>>  
>> +	list_for_each_entry_safe(msg, next, &priv->recv_msgs, link) {
>> +		ipmi_free_recv_msg(msg);
>> +	}
>> +
>> +
>>  	return 0;
>>  }
>>  
>>

