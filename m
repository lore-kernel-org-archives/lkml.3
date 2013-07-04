Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933443Ab3GDCDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 22:03:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:28303 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932206Ab3GDCDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 22:03:47 -0400
X-IronPort-AV: E=Sophos;i="4.87,992,1363104000"; 
   d="scan'208";a="7777574"
Message-ID: <51D4D740.8030603@cn.fujitsu.com>
Date: Thu, 04 Jul 2013 10:00:32 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jiaxing Wang <lkml.wjx@gmail.com>
CC: fangdong <fangdong@pipul.org>, Jiaxing Wang <hello.wjx@gmail.com>,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] seq_file:update file->f_pos when lseek() to m->read_pos
References: <1372497096-15914-1-git-send-email-hello.wjx@gmail.com> <51D178FA.4020601@pipul.org> <51D2224E.8090700@gmail.com>
In-Reply-To: <51D2224E.8090700@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/04 10:02:15,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/04 10:02:17,
	Serialize complete at 2013/07/04 10:02:17
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiaxing,
	Please refer to inline comment.:)
On 07/02/2013 08:43 AM, Jiaxing Wang wrote:

> On 07/01/2013 08:41 PM, fangdong wrote:
>> On 06/29/2013 05:11 AM, Jiaxing Wang wrote:
>>> After pread(), file->f_pos and m->read_pos get different,
>>> and lseek() to m->read_pos did not update file->f_pos, then
>>> a subsequent read may read from a wrong position, the following
>>> program shows the problem:
>>>
>>>      char str1[32] = { 0 };
>>>      char str2[32] = { 0 };
>>>      int poffset = 10;
>>>      int count = 20;
>>>
>>>      /*open any seq file*/
>>>      int fd = open("/proc/modules", O_RDONLY);
>>>
>>>      pread(fd, str1, count, poffset);
>>>      printf("pread:%s\n", str1);
>>>
>>>      /*seek to where m->read_pos is*/
>>>      lseek(fd, poffset+count, SEEK_SET);
>>>
>>>      /*supposed to read from poffset+count, but this read from position 0*/
>>>      read(fd, str2, count);
>>>      printf("read:%s\n", str2);
>>>
>>> Signed-off-by: Jiaxing Wang <hello.wjx@gmail.com>
>>> ---
>>>   fs/seq_file.c | 3 ++-
>>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/fs/seq_file.c b/fs/seq_file.c
>>> index 774c1eb..4b22b26 100644
>>> --- a/fs/seq_file.c
>>> +++ b/fs/seq_file.c
>>> @@ -328,7 +328,8 @@ loff_t seq_lseek(struct file *file, loff_t offset, int whence)
>>>                   m->read_pos = offset;
>>>                   retval = file->f_pos = offset;
>>>               }
>>> -        }
>>> +        } else
>>> +            file->f_pos = offset;
>>>       }
>>>       file->f_version = m->version;
>>>       mutex_unlock(&m->lock);
>>>
>> This does not appear to be a problem, in linux man page, the behaver seems clearly defined:
>>
>> DESCRIPTION
>>        pread() reads up to count bytes from file descriptor fd at offset  off-set  (from the start of the file) into the buffer starting at buf.  The file offset is not changed.
>>
>>        pwrite() writes up to count bytes from the buffer starting at buf  to the  file  descriptor  fd  at  offset  offset.   The file offset is not changed.
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> There's no problem that pread() don't change file->f_pos, but I think lseek() should have changed it.

No, the way that seq_seek deal with pos is right. Remember this seq file, it is
an iterator interface, e.g. it provides infos of each element of a list, so the
we should make sure that the info we read from seq file is the whole infos of
each entry, so seq_lseek can not set pos to a optional point, only can on the
points that divided by a whole infos size of each entry. If we can not set pos
on the special position, ste it as 0, I think it's reasonable.

Thanks,
Gu  

> Any comments from other people, and Alexander?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


