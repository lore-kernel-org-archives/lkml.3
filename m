Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbaJFTMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 15:12:55 -0400
Received: from mout.gmx.net ([212.227.15.18]:52843 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011AbaJFTMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 15:12:53 -0400
Message-ID: <5432E921.7040306@gmx.de>
Date: Mon, 06 Oct 2014 21:10:25 +0200
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH 1/1] fallocate: create FAN_MODIFY and IN_MODIFY events
References: <1412287587-5392-1-git-send-email-xypron.glpk@gmx.de> <1412324370-959-1-git-send-email-xypron.glpk@gmx.de> <20141006141227.GF7526@quack.suse.cz>
In-Reply-To: <20141006141227.GF7526@quack.suse.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:TjNRaEmnMozMyCzHXkaJUClFs+ExHLdChH6r+0yK2PKNlGSa1xH
 uxW3WIHxhgiM/gQ4Lm99ndtEmP7Vq9WardOxFVqTfRWpLdxZfRAL/WTEcf/WRPK7qA2bvi6
 zSUMOCT9SJ3Bdg0IF6lRXxyc4STTepY+wYGGqKwHodhgRw7jlDc+rZjADYx3HsQLYQ8NsKw
 uIpCIprCXllRB2RrZ/qJQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.10.2014 16:12, Jan Kara wrote:
> On Fri 03-10-14 10:19:30, Heinrich Schuchardt wrote:
>> The fanotify and the inotify API can used to monitor changes of the file
>> system.
>>
>> System call fallocate modifies files. Hence it should trigger the corresponding
>> fanotify (FAN_MODIFY) and inotify (IN_MODIFY) events.
>>
>> This patch adds the missing call to fsnotify_modify.
>    Well, there are different fallocate() commands and e.g. pure
> FALLOC_FL_KEEP_SIZE call will not change any data in the file. I'm not sure
> how much we care but I wanted to point that out...

The most interesting case is FALLOC_FL_COLLAPSE_RANGE because this value 
allows to create arbitrary file content from random data. Hence I think 
we really need to create FAN_MODIFY in this case.

As the fallocate(2) man page teaches:
After a successful call, subsequent writes into the range specified by 
offset and len are guaranteed not to fail because of lack of disk space.

So calling fallocate(fd, FALLOC_FL_KEEP_SIZE, offset, len) may result in 
different outcomes of a subsequent write depending on the values of 
offset and len.

Calling fallocate for a region already zeroed will not result in any 
data change.

I would like to compare fallocate() with write().

When we call write() we always create a FAN_MODIFY event even in the 
case of overwriting with identical data.

So event FAN_MODIFY does not provide any guarantee that data was 
actually changed.

In analogy to write() I suggest to keep the logic for fallocate() as 
trivial as possible:
If fallocate() succeeds, create IN_MODIFY and FAN_MODIFY events.

Best regards

Heinrich Schuchardt
>
>> Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
>> ---
>>   fs/open.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/fs/open.c b/fs/open.c
>> index d6fd3ac..03aa8e5 100644
>> --- a/fs/open.c
>> +++ b/fs/open.c
>> @@ -295,6 +295,11 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>>
>>   	sb_start_write(inode->i_sb);
>>   	ret = file->f_op->fallocate(file, mode, offset, len);
>> +
>> +	/* Create inotify and fanotify events. */
>> +	if (ret == 0)
>> +		fsnotify_modify(file);
>> +
>>   	sb_end_write(inode->i_sb);
>>   	return ret;
>>   }
>> --
>> 2.1.0
>>

