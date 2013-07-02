Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab3GBAoI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 20:44:08 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:44214 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204Ab3GBAoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 20:44:04 -0400
Message-ID: <51D2224E.8090700@gmail.com>
Date: Tue, 02 Jul 2013 08:43:58 +0800
From: Jiaxing Wang <lkml.wjx@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: fangdong <fangdong@pipul.org>
CC: Jiaxing Wang <hello.wjx@gmail.com>, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] seq_file:update file->f_pos when lseek() to m->read_pos
References: <1372497096-15914-1-git-send-email-hello.wjx@gmail.com> <51D178FA.4020601@pipul.org>
In-Reply-To: <51D178FA.4020601@pipul.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2013 08:41 PM, fangdong wrote:
> On 06/29/2013 05:11 AM, Jiaxing Wang wrote:
>> After pread(), file->f_pos and m->read_pos get different,
>> and lseek() to m->read_pos did not update file->f_pos, then
>> a subsequent read may read from a wrong position, the following
>> program shows the problem:
>>
>>      char str1[32] = { 0 };
>>      char str2[32] = { 0 };
>>      int poffset = 10;
>>      int count = 20;
>>
>>      /*open any seq file*/
>>      int fd = open("/proc/modules", O_RDONLY);
>>
>>      pread(fd, str1, count, poffset);
>>      printf("pread:%s\n", str1);
>>
>>      /*seek to where m->read_pos is*/
>>      lseek(fd, poffset+count, SEEK_SET);
>>
>>      /*supposed to read from poffset+count, but this read from position 0*/
>>      read(fd, str2, count);
>>      printf("read:%s\n", str2);
>>
>> Signed-off-by: Jiaxing Wang <hello.wjx@gmail.com>
>> ---
>>   fs/seq_file.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/seq_file.c b/fs/seq_file.c
>> index 774c1eb..4b22b26 100644
>> --- a/fs/seq_file.c
>> +++ b/fs/seq_file.c
>> @@ -328,7 +328,8 @@ loff_t seq_lseek(struct file *file, loff_t offset, int whence)
>>                   m->read_pos = offset;
>>                   retval = file->f_pos = offset;
>>               }
>> -        }
>> +        } else
>> +            file->f_pos = offset;
>>       }
>>       file->f_version = m->version;
>>       mutex_unlock(&m->lock);
>>
> This does not appear to be a problem, in linux man page, the behaver seems clearly defined:
>
> DESCRIPTION
>        pread() reads up to count bytes from file descriptor fd at offset  off-set  (from the start of the file) into the buffer starting at buf.  The file offset is not changed.
>
>        pwrite() writes up to count bytes from the buffer starting at buf  to the  file  descriptor  fd  at  offset  offset.   The file offset is not changed.
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
There's no problem that pread() don't change file->f_pos, but I think lseek() should have changed it.
Any comments from other people, and Alexander?
