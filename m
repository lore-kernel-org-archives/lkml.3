Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbbAWEun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 23:50:43 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:46300 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbbAWEuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 23:50:37 -0500
Message-ID: <54C1D30B.8090705@oracle.com>
Date: Thu, 22 Jan 2015 23:50:19 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: minyard@acm.org, Nicholas Krause <xerofoify@gmail.com>
CC: openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] char:ipmi: Free ipmi_recv_msg messages from the
 linked list,recv_msgs for the function,ipmi_release in the file,ipmi_devintf.c
References: <1421723653-19633-1-git-send-email-xerofoify@gmail.com> <54C0F59B.8090709@acm.org>
In-Reply-To: <54C0F59B.8090709@acm.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2015 08:05 AM, Corey Minyard wrote:
> Patch is queued for 3.20.  Thanks.

That patch is horribly broken.


Thanks,
Sasha

> -corey
> 
> On 01/19/2015 09:14 PM, Nicholas Krause wrote:
>> This adds a loop through the elements in the linked list, recv_msgs using
>> list_for_entry_safe in order to free messages in this list.  In addition
>> we are using the safe version of this marco in order to prevent use after
>> bugs related to deleting the element we are on currently by holding a
>> pointer to the next element after the current one we are on and freeing
>> with the function, ipmi_free_recv_msg internally in this loop.
>>
>> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>> ---
>>  drivers/char/ipmi/ipmi_devintf.c | 7 ++++---
>>  1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/char/ipmi/ipmi_devintf.c b/drivers/char/ipmi/ipmi_devintf.c
>> index ec318bf..d2af38a 100644
>> --- a/drivers/char/ipmi/ipmi_devintf.c
>> +++ b/drivers/char/ipmi/ipmi_devintf.c
>> @@ -157,14 +157,15 @@ static int ipmi_release(struct inode *inode, struct file *file)
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
>> -	kfree(priv);
>> -
>> +	list_for_each_entry_safe(msg, next, &priv->recv_msgs, link) {
>> +		ipmi_free_recv_msg(msg);
>> +	}
>>  	return 0;
>>  }
>>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

