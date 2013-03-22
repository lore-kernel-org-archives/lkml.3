Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730Ab3CVFtO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 01:49:14 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:32921 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416Ab3CVFtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 01:49:13 -0400
Message-ID: <514BF0BE.1070907@huawei.com>
Date: Fri, 22 Mar 2013 13:48:46 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] sysfs: fix race between readdir and lseek
References: <1363793126-11510-1-git-send-email-ming.lei@canonical.com> <1363793126-11510-2-git-send-email-ming.lei@canonical.com> <514A7340.5040409@huawei.com> <CACVXFVN7urpLM+Q-3o9=hYQLM=544WTXh+BnSo9fBM+d07oapQ@mail.gmail.com> <514A7E72.2090200@huawei.com> <CACVXFVMS644BpX7voMHS-xXoRs9-G4y96=ubk_NAj6KDTy1ENQ@mail.gmail.com>
In-Reply-To: <CACVXFVMS644BpX7voMHS-xXoRs9-G4y96=ubk_NAj6KDTy1ENQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/3/21 12:48, Ming Lei wrote:
> On Thu, Mar 21, 2013 at 11:28 AM, Li Zefan <lizefan@huawei.com> wrote:
>> On 2013/3/21 11:17, Ming Lei wrote:
>>> On Thu, Mar 21, 2013 at 10:41 AM, Li Zefan <lizefan@huawei.com> wrote:
>>>>
>>>> In fact the same race exists between readdir() and read()/write()...
>>>
>>> Fortunately, no read()/write() are implemented on sysfs directory, :-)
>>>
>>
>> That's irrelevant...
> 
> As far as sysfs is concerned, the filp->f_ops can't be changed in
> read/write path.
> 

Yes, it can...As I said, it's irrelevant, because it's vfs that changes
file->f_pos.

SYSCALL_DEFINE3(read, unsigned int, fd, char __user *, buf, size_t, count)
{
        struct fd f = fdget(fd);
        ssize_t ret = -EBADF;

        if (f.file) {
                loff_t pos = file_pos_read(f.file);		<--- read f_pos
                ret = vfs_read(f.file, buf, count, &pos);	<--- return -EISDIR
                file_pos_write(f.file, pos);			<--- write f_pos
                fdput(f);
        }
        return ret;
}

>>
>> See my report:
>>
>> https://patchwork.kernel.org/patch/2160771/
> 
> Yes, I know there might be some mess after the commit ef3d0fd2
> (vfs: do (nearly) lockless generic_file_llseek).
> 
> Also looks it has been stated in Documentation/filesystems/Locking:
> 
> ->llseek() locking has moved from llseek to the individual llseek
> implementations.  If your fs is not using generic_file_llseek, you
> need to acquire and release the appropriate locks in your ->llseek().
> For many filesystems, it is probably safe to acquire the inode
> mutex or just to use i_size_read() instead.
> Note: this does not protect the file->f_pos against concurrent modifications
> since this is something the userspace has to take care about.
> 


