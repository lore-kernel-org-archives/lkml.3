Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186AbaGPUfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 16:35:52 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:31897 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbaGPUft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 16:35:49 -0400
Message-ID: <53C6E214.3030902@oracle.com>
Date: Wed, 16 Jul 2014 14:35:32 -0600
From: Khalid Aziz <khalid.aziz@oracle.com>
Organization: Oracle Corp
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: davem@davemloft.net, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc: Add support for seek and shorter read to /dev/mdesc
References: <1405519323-3092-1-git-send-email-khalid.aziz@oracle.com> <20140716190414.GA6028@ravnborg.org>
In-Reply-To: <20140716190414.GA6028@ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

Thanks for the feedback.

On 07/16/2014 01:04 PM, Sam Ravnborg wrote:
> Hi Kahlid.
>
> On Wed, Jul 16, 2014 at 08:02:03AM -0600, Khalid Aziz wrote:
>> /dev/mdesc on Linux does not support reading arbitrary number
>> of bytes and seeking while /dev/mdesc on Solaris does. This
>> causes tools that work on Solaris to break on Linux. This patch
>> adds these two capabilities to /dev/mdesc.
>>
>> Signed-off-by: Khalid Aziz <khalid.aziz@oracle.com>
>> ---
>>   arch/sparc/kernel/mdesc.c | 77 ++++++++++++++++++++++++++++++++++++++++-------
>>   1 file changed, 66 insertions(+), 11 deletions(-)
>>
>> +/* mdesc_open() - Grab a reference to mdesc_handle when /dev/mdesc is
>> + *	opened. Hold this reference until /dev/mdesc is closed to ensure
>> + *	mdesc data structure is not released underneath us. Store the
>> + *	pointer to mdesc structure in private_data for read and seek to use
>> + */
>> +static int mdesc_open(struct inode *inode, struct file *file)
>>   {
>>   	struct mdesc_handle *hp = mdesc_grab();
>>
>>   	if (!hp)
>>   		return -ENODEV;
>>
>> +	file->private_data = hp;
>> +	return 0;
>> +}
>
> Do we know the open/close always come in pairs?
> I assume so - but there is no check fo this (at least on this level).

Most likely yes, but I wouldn't assume that to be guaranteed. Is that a 
concern? Isn't "struct file" unique for each instance of open?

>
>> +
>> +static ssize_t mdesc_read(struct file *file, char __user *buf,
>> +			  size_t len, loff_t *offp)
>> +{
>> +	struct mdesc_handle *hp = file->private_data;
>> +	unsigned char *mdesc;
>> +	int err, bytes_left;
>> +
>> +	if (*offp >= hp->handle_size)
>> +		return 0;
>> +	err = len;
>> +	bytes_left = hp->handle_size - *offp;
>> +	if (len > bytes_left)
>> +		err = bytes_left;
>> +	mdesc = (unsigned char *)&hp->mdesc;
>> +	mdesc += *offp;
>> +	if (copy_to_user(buf, mdesc, err))
>>   		err = -EFAULT;
>> -	mdesc_release(hp);
>> +	else
>> +		*offp += err;
>> +
>> +	return err;
>> +}
>
> When reading your code it is confusing to read that err is set to len,
> and then maybe later set to an error value or a new len.
>
> See the following refactoring of mdesc_read() that avoids the err local
> variable resulting in more readable code.
>
> static ssize_t mdesc_read(struct file *file, char __user *buf,
>                         size_t len, loff_t *offp)
> {
>       struct mdesc_handle *hp = file->private_data;
>       unsigned char *mdesc;
>       int bytes_left;
>
>       if (*offp >= hp->handle_size)
>               return 0;
>
>       bytes_left = hp->handle_size - *offp;
>       if (len > bytes_left)
>               len = bytes_left;
>
>       mdesc = (unsigned char *)&hp->mdesc;
>       mdesc += *offp;
>       if (!copy_to_user(buf, mdesc, len)) {
>               *offp += len;
> 	     return len;
>       } else {
>               return -EFAULT;
>       }
> }
>
> The above is IMO more readable.

I was simply following how err was used in the original code, but I 
agree this is more readable. I can redo the patch.

>>
>> +static loff_t mdesc_llseek(struct file *file, loff_t offset, int whence)
>> +{
>> +	struct mdesc_handle *hp;
>> +	int err;
>> +
>> +	switch (whence) {
>> +	case SEEK_CUR:
>> +		offset += file->f_pos;
>> +		break;
>> +	case SEEK_SET:
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	err = offset;
>> +	hp = file->private_data;
>> +	if (offset > hp->handle_size)
>> +		err = -EINVAL;
>> +	else
>> +		file->f_pos = offset;
>>   	return err;
>>   }
> Same story here with err.
>
>
> 	Sam
> --
> To unsubscribe from this list: send the line "unsubscribe sparclinux" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
Khalid

