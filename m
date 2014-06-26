Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbaFZNV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 09:21:27 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:56190 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaFZNVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 09:21:23 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-c1-53ac1e503110
Message-id: <53AC1E1E.8040903@samsung.com>
Date: Thu, 26 Jun 2014 16:20:30 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com
Subject: Re: [PATCH 1/1] ima: fix fallback to use new_sync_read()
References: <ffb4808ed8ce0dddbc96c566ccca2c9b39005643.1403616439.git.d.kasatkin@samsung.com>
 <1403786949.2017.66.camel@dhcp-9-2-203-236.watson.ibm.com>
In-reply-to: <1403786949.2017.66.camel@dhcp-9-2-203-236.watson.ibm.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t/xy7oBcmuCDdr6dCy+LK2zeDljHrvF
	5V1z2Cw+9Dxiszj/9zirxacVk5gd2Dx2zrrL7vHg0GYWj90LPjN5fN4k57HpyVumANYoLpuU
	1JzMstQifbsEroxlKy8zFywQrHi2tLaB8S9vFyMHh4SAicT0RRFdjJxAppjEhXvr2boYuTiE
	BJYySvxYeJ8Vwmlkkvh4cRo7hDOLUWL3jk3sIN28AloSl35qgHSzCKhKfJ+2mQXEZhPQk9jQ
	/IMdxBYViJA40PeMFcTmFRCU+DH5HliNiICmxLHWj4wgM5kFljFKPDl9ECwhLOAocW3ndEaI
	ZbMZJRqXzAKbxCngLvH+/HKwScwC6hKT5i1ihrDlJTaveQtmCwFd0b12LRvEP4oSpyefY57A
	KDwLyfJZSNpnIWlfwMi8ilE0tTS5oDgpPddQrzgxt7g0L10vOT93EyMkRr7sYFx8zOoQowAH
	oxIPr8Tc1cFCrIllxZW5hxglOJiVRHiPSa0JFuJNSaysSi3Kjy8qzUktPsTIxMEp1cDoIp7D
	wVPDe4oh0PDZuxd79sZL+13adyjaPNd7jpKk/hc27bUX/X+m3t4h8X+5+JT95xm+uazPjA5j
	uXvppiibfVW7j/CJqR11p55LFdZopLx8krP2vvWBrR9kTAz+PZHZeHD9fQ7ZcsYbTwJMK8Ns
	/cWP1ZY3xy9zOa9gfuX8xmcTsqc6xFgosRRnJBpqMRcVJwIA7I19Im8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/06/14 15:49, Mimi Zohar wrote:
> On Tue, 2014-06-24 at 16:27 +0300, Dmitry Kasatkin wrote: 
>> 3.16 commit aad4f8bb42af06371aa0e85bf0cd9d52c0494985
>> 'switch simple generic_file_aio_read() users to ->read_iter()'
>> replaced ->aio_read with ->read_iter in most of the file systems
>> and introduced new_sync_read() as a replacement for do_sync_read().
>>
>> Most of file systems set '->read' and ima_kernel_read is not affected.
>> When ->read is not set, this patch adopts fallback call changes from the
>> vfs_read.
> So every time there are changes in vfs_read(), we're going to have to
> play catch up.  A better solution would be to refactor vfs_read() so
> that we could call it.
>
> Mimi

vfs_read was stable for decade.
And next will be the same.

I followed the same approach we took to have an own version.

Refactoring vfs_read is not the best approach as we have set_fs things
there.

I would prefer to have "kernel_read_nosec" function along with
kernel_read/vfs_read, so changes could be
made noticeably together..

- Dmitry


>
>> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
>> ---
>>  security/integrity/ima/ima_crypto.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
>> index ccd0ac8..b126a78 100644
>> --- a/security/integrity/ima/ima_crypto.c
>> +++ b/security/integrity/ima/ima_crypto.c
>> @@ -40,19 +40,19 @@ static int ima_kernel_read(struct file *file, loff_t offset,
>>  {
>>  	mm_segment_t old_fs;
>>  	char __user *buf = addr;
>> -	ssize_t ret;
>> +	ssize_t ret = -EINVAL;
>>
>>  	if (!(file->f_mode & FMODE_READ))
>>  		return -EBADF;
>> -	if (!file->f_op->read && !file->f_op->aio_read)
>> -		return -EINVAL;
>>
>>  	old_fs = get_fs();
>>  	set_fs(get_ds());
>>  	if (file->f_op->read)
>>  		ret = file->f_op->read(file, buf, count, &offset);
>> -	else
>> +	else if (file->f_op->aio_read)
>>  		ret = do_sync_read(file, buf, count, &offset);
>> +	else if (file->f_op->read_iter)
>> +		ret = new_sync_read(file, buf, count, &offset);
>>  	set_fs(old_fs);
>>  	return ret;
>>  }
>
>

