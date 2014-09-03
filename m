Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642AbaICNbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 09:31:25 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:47697 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388AbaICNbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 09:31:24 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-3c-54071828138a
Message-id: <54071778.8050204@samsung.com>
Date: Wed, 03 Sep 2014 16:28:24 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@gmail.com
Subject: Re: [PATCH 7/8] ima: remove usage of filename parameter
References: <cover.1409728712.git.d.kasatkin@samsung.com>
 <33e79df19a7c5347be058864339d7698b0bd167a.1409728712.git.d.kasatkin@samsung.com>
 <1409750203.21827.71.camel@dhcp-9-2-203-236.watson.ibm.com>
In-reply-to: <1409750203.21827.71.camel@dhcp-9-2-203-236.watson.ibm.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t/xa7oaEuwhBl8fsVh8WVpn8XLGPHaL
	y7vmsFl86HnEZvFpxSRmB1aPnbPusns8OLSZxWP3gs9MHp83yQWwRHHZpKTmZJalFunbJXBl
	NF7ewVjwUbniwOEvjA2MLbJdjJwcEgImEqv+/WSFsMUkLtxbz9bFyMUhJLCUUeL57tfMEE4j
	k8Tt9fehnFmMEicubGcCaeEV0JI4+vEzO4jNIqAq8X79d0YQm01AT2JD8w+wuKhAmMSzXweh
	6gUlfky+xwJiiwhoShxr/cgIMpRZoJdRon9dH9AGDg5hAQeJvhvSEMtOMUq8f7gArJlTwEPi
	zIXlTCA1zALqElOm5IKEmQXkJTavecsMYgsB3dC9di0bxDuKEqcnn2OewCg8C8nqWQjds5B0
	L2BkXsUomlqaXFCclJ5rpFecmFtcmpeul5yfu4kREg9fdzAuPWZ1iFGAg1GJhzdCkC1EiDWx
	rLgy9xCjBAezkgivJjN7iBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbGBbvSPXNDrcXjOT+a9TC/
	XXbl2kqle1O2pu5Jv7Mqbu3tq9NDqk+UL/Ssnp92adXzxWmaG+4cUphYW3rH5N/C0n758rz6
	aZL88hliMkK7098tvqF0dNGZaSVmajdqdms5601dNkvU8kq0oMVd7ZeHX3IETeeI6V0hqfSa
	Tezmyjp29eh37XdUlFiKMxINtZiLihMB2piy7GUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/14 16:16, Mimi Zohar wrote:
> On Wed, 2014-09-03 at 10:20 +0300, Dmitry Kasatkin wrote: 
>> In all cases except ima_bprm_check() filename was not defined and
>> ima_d_path() was used to find full path.
>>
>> ima_bprm_check() used to select between bprm->interp and bprm->filename.
>> Following dump demonstrates differences between using filename and interp.
>>
>> bprm->filename
>>  filename: ./foo.sh, pathname: /root/bin/foo.sh
>>  filename: ./foo.sh, pathname: /bin/dash
>>
>> bprm->interp
>>  filename: ./foo.sh, pathname: /root/bin/foo.sh
>>  filename: /bin/sh, pathname: /bin/dash
>>
>> In both cases pathnames are the same.
>> This patch removes usage of filename and interp in favor of d_path.
>>
>> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> Thanks, this has been on my list to do.  My only concern is whether we
> should be using d_path() or one of the other variants (eg.
> dentry_path(), d_absolute_path()).  For namespaces, we would want to be
> able to differentiate the files.
>
> Please include in this patch description why d_path(), if it is the
> case, the best option.
>
> thanks,

Hi,

Actually as we discussed, we can also in this patch change ima_d_path to
use d_absolute_path().
It will work for "chroot" cases and will show real path...

Should I switch to 'd_absolute_path'?

In the case of namespaces, neither d_path nor d_absolute_path works....
Usage of dentry_path() would eliminate mount tree and requires device
prefix.
But it will 'break' clients, reading process measurement list.
That would require essentially more agreement.

- Dmitry


> Mimi
>
>> ---
>>  security/integrity/ima/ima_main.c | 19 ++++++++-----------
>>  1 file changed, 8 insertions(+), 11 deletions(-)
>>
>> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
>> index aaf5552..673a37e 100644
>> --- a/security/integrity/ima/ima_main.c
>> +++ b/security/integrity/ima/ima_main.c
>> @@ -156,8 +156,8 @@ void ima_file_free(struct file *file)
>>  	ima_check_last_writer(iint, inode, file);
>>  }
>>
>> -static int process_measurement(struct file *file, const char *filename,
>> -			       int mask, int function, int opened)
>> +static int process_measurement(struct file *file, int mask, int function,
>> +			       int opened)
>>  {
>>  	struct inode *inode = file_inode(file);
>>  	struct integrity_iint_cache *iint;
>> @@ -218,7 +218,7 @@ static int process_measurement(struct file *file, const char *filename,
>>  		goto out_digsig;
>>  	}
>>
>> -	pathname = filename ?: ima_d_path(&file->f_path, &pathbuf);
>> +	pathname = ima_d_path(&file->f_path, &pathbuf);
>>
>>  	if (action & IMA_MEASURE)
>>  		ima_store_measurement(iint, file, pathname,
>> @@ -254,7 +254,7 @@ out:
>>  int ima_file_mmap(struct file *file, unsigned long prot)
>>  {
>>  	if (file && (prot & PROT_EXEC))
>> -		return process_measurement(file, NULL, MAY_EXEC, MMAP_CHECK, 0);
>> +		return process_measurement(file, MAY_EXEC, MMAP_CHECK, 0);
>>  	return 0;
>>  }
>>
>> @@ -273,10 +273,7 @@ int ima_file_mmap(struct file *file, unsigned long prot)
>>   */
>>  int ima_bprm_check(struct linux_binprm *bprm)
>>  {
>> -	return process_measurement(bprm->file,
>> -				   (strcmp(bprm->filename, bprm->interp) == 0) ?
>> -				   bprm->filename : bprm->interp,
>> -				   MAY_EXEC, BPRM_CHECK, 0);
>> +	return process_measurement(bprm->file, MAY_EXEC, BPRM_CHECK, 0);
>>  }
>>
>>  /**
>> @@ -292,7 +289,7 @@ int ima_bprm_check(struct linux_binprm *bprm)
>>  int ima_file_check(struct file *file, int mask, int opened)
>>  {
>>  	ima_rdwr_violation_check(file);
>> -	return process_measurement(file, NULL,
>> +	return process_measurement(file,
>>  				   mask & (MAY_READ | MAY_WRITE | MAY_EXEC),
>>  				   FILE_CHECK, opened);
>>  }
>> @@ -317,7 +314,7 @@ int ima_module_check(struct file *file)
>>  #endif
>>  		return 0;	/* We rely on module signature checking */
>>  	}
>> -	return process_measurement(file, NULL, MAY_EXEC, MODULE_CHECK, 0);
>> +	return process_measurement(file, MAY_EXEC, MODULE_CHECK, 0);
>>  }
>>
>>  int ima_fw_from_file(struct file *file, char *buf, size_t size)
>> @@ -328,7 +325,7 @@ int ima_fw_from_file(struct file *file, char *buf, size_t size)
>>  			return -EACCES;	/* INTEGRITY_UNKNOWN */
>>  		return 0;
>>  	}
>> -	return process_measurement(file, NULL, MAY_EXEC, FIRMWARE_CHECK, 0);
>> +	return process_measurement(file, MAY_EXEC, FIRMWARE_CHECK, 0);
>>  }
>>
>>  static int __init init_ima(void)
>
>

