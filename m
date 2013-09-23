Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab3IWWKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 18:10:47 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:42534 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab3IWWKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 18:10:45 -0400
Message-ID: <5240BC62.9040102@converseincode.com>
Date: Mon, 23 Sep 2013 18:10:42 -0400
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: balbi@ti.com
CC: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Charlebois <charlebm@gmail.com>
Subject: Re: [PATCH] USB: Removing the use of VLAIS from the gadget driver
References: <1375407344-30120-1-git-send-email-behanw@converseincode.com> <20130923202428.GG309@radagast>
In-Reply-To: <20130923202428.GG309@radagast>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/13 16:24, Felipe Balbi wrote:
> Hi,
>
> On Thu, Aug 01, 2013 at 09:35:44PM -0400, behanw@converseincode.com wrote:
>> From: Behan Webster <behanw@converseincode.com>
>>
>> The use of variable length arrays in structs (VLAIS) in the Linux Kernel code
>> precludes the use of compilers which don't implement VLAIS (for instance the
>> Clang compiler). This patch removes the use of VLAIS in the gadget driver.
>>
>> Signed-off-by: Mark Charlebois <charlebm@gmail.com>
>> Signed-off-by: Behan Webster <behanw@converseincode.com>
>> ---
>>   drivers/usb/gadget/f_fs.c | 128 +++++++++++++++++++++++++++-------------------
>>   1 file changed, 76 insertions(+), 52 deletions(-)
>>
>> diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
>> index f394f29..4b872c4 100644
>> --- a/drivers/usb/gadget/f_fs.c
>> +++ b/drivers/usb/gadget/f_fs.c
>> @@ -30,7 +30,6 @@
>>   
>>   #define FUNCTIONFS_MAGIC	0xa647361 /* Chosen by a honest dice roll ;) */
>>   
>> -
>>   /* Debugging ****************************************************************/
>>   
>>   #ifdef VERBOSE_DEBUG
>> @@ -214,6 +213,8 @@ struct ffs_data {
>>   	/* ids in stringtabs are set in functionfs_bind() */
>>   	const void			*raw_strings;
>>   	struct usb_gadget_strings	**stringtabs;
>> +	struct usb_gadget_strings	*stringtab;
>> +	struct usb_string		*strings;
>>   
>>   	/*
>>   	 * File system's super block, write once when file system is
>> @@ -263,7 +264,10 @@ struct ffs_function {
>>   
>>   	struct ffs_ep			*eps;
>>   	u8				eps_revmap[16];
>> +	struct usb_descriptor_header	**fs_descs;
>> +	struct usb_descriptor_header	**hs_descs;
>>   	short				*interfaces_nums;
>> +	char				*raw_descs;
>>   
>>   	struct usb_function		function;
>>   };
>> @@ -1345,6 +1349,8 @@ static void ffs_data_clear(struct ffs_data *ffs)
>>   	kfree(ffs->raw_descs);
>>   	kfree(ffs->raw_strings);
>>   	kfree(ffs->stringtabs);
>> +	kfree(ffs->stringtab);
>> +	kfree(ffs->strings);
>>   }
>>   
>>   static void ffs_data_reset(struct ffs_data *ffs)
>> @@ -1357,6 +1363,8 @@ static void ffs_data_reset(struct ffs_data *ffs)
>>   	ffs->raw_descs = NULL;
>>   	ffs->raw_strings = NULL;
>>   	ffs->stringtabs = NULL;
>> +	ffs->stringtab = NULL;
>> +	ffs->strings = NULL;
>>   
>>   	ffs->raw_descs_length = 0;
>>   	ffs->raw_fs_descs_length = 0;
>> @@ -1528,12 +1536,10 @@ static void ffs_func_free(struct ffs_function *func)
>>   	ffs_data_put(func->ffs);
>>   
>>   	kfree(func->eps);
>> -	/*
>> -	 * eps and interfaces_nums are allocated in the same chunk so
>> -	 * only one free is required.  Descriptors are also allocated
>> -	 * in the same chunk.
>> -	 */
>> -
>> +	kfree(func->fs_descs);
>> +	kfree(func->hs_descs);
>> +	kfree(func->interfaces_nums);
>> +	kfree(func->raw_descs);
>>   	kfree(func);
>>   }
>>   
>> @@ -1907,33 +1913,35 @@ static int __ffs_data_got_strings(struct ffs_data *ffs,
>>   		return 0;
>>   	}
>>   
>> -	/* Allocate everything in one chunk so there's less maintenance. */
>>   	{
>> -		struct {
>> -			struct usb_gadget_strings *stringtabs[lang_count + 1];
>> -			struct usb_gadget_strings stringtab[lang_count];
>> -			struct usb_string strings[lang_count*(needed_count+1)];
>> -		} *d;
>>   		unsigned i = 0;
>> -
>> -		d = kmalloc(sizeof *d, GFP_KERNEL);
>> -		if (unlikely(!d)) {
>> +		usb_gadget_strings **stringtabs = NULL;
>> +		usb_gadget_strings *stringtab = NULL;
>> +		usb_string *strings = NULL;
> did you compile this patch ?
>
Appologies. The patch as posted has a bug which was fixed after sending 
it to the list.

Andrzej Pietrasiewicz <andrzej.p@samsung.com> has the fixed one. Will 
send the fixed one to the list too.

Behan

-- 
Behan Webster
behanw@converseincode.com

