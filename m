Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005Ab3DZNwG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 09:52:06 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:58400 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755625Ab3DZNwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 09:52:04 -0400
Message-ID: <517A84D2.9040500@gmail.com>
Date: Fri, 26 Apr 2013 15:44:50 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Benjamin LaHaise <bcrl@kvack.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        codalist@TELEMANN.coda.cs.cmu.edu, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/4] fsfreeze: added new file_start_write_killable
References: <517A3FEC.7010709@gmail.com> <20130426120640.GA20612@parisc-linux.org>
In-Reply-To: <20130426120640.GA20612@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Il 26/04/2013 14:06, Matthew Wilcox ha scritto:
> On Fri, Apr 26, 2013 at 10:50:52AM +0200, Marco Stornelli wrote:
>> Replace file_start_write with file_start_write_killable where
>> possible.
>
> I feel like I'm missing context here.  Possibly because you only cc'd me
> on patch 2/4.  In particular, file_start_write doesn't exist upstream,
> so I'm not sure what it's for.  But returning 1 for non-regular files
> looks dodgy:

The patch series is based on -next due to several changes done by Al 
about fsfreeze. file_start_write_killable returns 1 because it's mainly 
a wrapper of __st_start_write. __sb_start_write returns 1 when 
everything is ok, 0 when the lock can't be gotten (we are using the 
trylock version) and _now_ a value < 0 when something happens (i.e. -EINTR).

>
>> +static inline int file_start_write_killable(struct file *file)
>> +{
>> +	if (!S_ISREG(file_inode(file)->i_mode))
>> +		return 1;
>> +	return sb_start_write_killable(file_inode(file)->i_sb);
>> +}
>
>> +++ b/fs/aio.c
>> @@ -1103,8 +1103,11 @@ static ssize_t aio_rw_vect_retry(struct kiocb *iocb, int rw, aio_rw_op *rw_op)
>>   	if (iocb->ki_pos < 0)
>>   		return -EINVAL;
>>
>> -	if (rw == WRITE)
>> -		file_start_write(file);
>> +	if (rw == WRITE) {
>> +		ret = file_start_write_killable(file);
>> +		if (ret < 0)
>> +			return ret;
>> +	}
>>   	do {
>
> So ... it's OK to do this write to pipes/directories/devices/... ?  Or is
> that check always taken care of elsewhere?  If so, why do we need this
> check?  I'm confused.  None of the callers check for the 'ret == 1' case,
> so I'm sure there's something wrong here, I just can't tell what it is.
>

See above.

>> +++ b/fs/read_write.c
>> @@ -438,17 +438,19 @@ ssize_t vfs_write(struct file *file, const char __user *buf, size_t count, loff_
>>   	ret = rw_verify_area(WRITE, file, pos, count);
>>   	if (ret >= 0) {
>>   		count = ret;
>> -		file_start_write(file);
>> -		if (file->f_op->write)
>> -			ret = file->f_op->write(file, buf, count, pos);
>> -		else
>> -			ret = do_sync_write(file, buf, count, pos);
>> +		ret = file_start_write_killable(file);
>>   		if (ret > 0) {
>> -			fsnotify_modify(file);
>> -			add_wchar(current, ret);
>> +			if (file->f_op->write)
>> +				ret = file->f_op->write(file, buf, count, pos);
>> +			else
>> +				ret = do_sync_write(file, buf, count, pos);
>> +			if (ret > 0) {
>> +				fsnotify_modify(file);
>> +				add_wchar(current, ret);
>> +			}
>> +			inc_syscw(current);
>> +			file_end_write(file);
>>   		}
>> -		inc_syscw(current);
>> -		file_end_write(file);
>>   	}
>>
>>   	return ret;
>
> I don't like it that you've increased the indentation here.  Better to do
> a preliminary patch which just converts to our normal style with gotos.  ie:
>

Ok, I can change the style here, no problem.

Marco
