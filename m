Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509Ab3BSLrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 06:47:49 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:53925 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055Ab3BSLrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 06:47:47 -0500
Message-ID: <51236652.1050608@huawei.com>
Date: Tue, 19 Feb 2013 19:47:30 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andrew Morton <akpm@linux-foundation.org>, <andi@firstfloor.org>,
        Wuqixuan <wuqixuan@huawei.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        <gregkh@linuxfoundation.org>
Subject: Re: [RFC][PATCH] vfs: always protect diretory file->fpos with inode
 mutex
References: <5122D3E0.6070800@huawei.com> <20130219091931.GB21945@quack.suse.cz>
In-Reply-To: <20130219091931.GB21945@quack.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/2/19 17:19, Jan Kara wrote:
> On Tue 19-02-13 09:22:40, Li Zefan wrote:
>> There's a long long-standing bug...As long as I don't know when it dates
>> from.
>>
>> I've written and attached a simple program to reproduce this bug, and it can
>> immediately trigger the bug in my box. It uses two threads, one keeps calling
>> read(), and the other calling readdir(), both on the same directory fd.
>   So the fact that read() or even write() to fd opened O_RDONLY has *any*
> effect on f_pos looks really unexpected to me. I think we really should
> have there:
> 	if (ret >= 0)
> 		file_pos_write(...);

I thought about this. The problem is then we have to check every fop->write()
to see if any of them can return -errno with file->f_pos changed and fix them,
though it's do-able.

>   That would solve problems with read() and write() on directories for
> pretty much every filesystem since the first usually returns -EISDIR and
> the second -EBADF.

Yeah, seems ceph is the only filesystem that allows read() on directories.

> 
>> When I ran it on ext3 (can be replaced with ext2/ext4) which has _dir_index_
>> feature disabled, I got this:
>>
>> EXT3-fs error (device loop1): ext3_readdir: bad entry in directory #34817: rec_len is smaller than minimal - offset=993, inode=0, rec_len=0, name_len=0
>> EXT3-fs error (device loop1): ext3_readdir: bad entry in directory #34817: rec_len is smaller than minimal - offset=1009, inode=0, rec_len=0, name_len=0
>> EXT3-fs error (device loop1): ext3_readdir: bad entry in directory #34817: rec_len is smaller than minimal - offset=993, inode=0, rec_len=0, name_len=0
>> EXT3-fs error (device loop1): ext3_readdir: bad entry in directory #34817: rec_len is smaller than minimal - offset=1009, inode=0, rec_len=0, name_len=0
>> ...
>>
>> If we configured errors=remount-ro, the filesystem will become read-only.
>>
>> SYSCALL_DEFINE3(read, unsigned int, fd, char __user *, buf, size_t, count)
>> {
>> 	...
>> 		loff_t pos = file_pos_read(file);
>> 		ret = vfs_read(file, buf, count, &pos);
>> 		file_pos_write(file, pos);
>> 		fput_light(file, fput_needed);
>> 	...
>> }
>>
>> While readdir() is protected with i_mutex, f_pos can be changed without
>> any locking in various read()/write() syscalls, which leads to this bug.
>>
>> What makes things worse is Andi removed i_mutex from generic_file_llseek,
>> so you can trigger the same bug by replacing read() with lseek() in the
>> test program.
>   Yes, and here I'd say it's a filesystem issue. If filesystem needs f_pos
> changed only under i_mutex, it should use default_llseek() or get the mutex
> itself. That's what the callback is for. We shouldn't unnecessarily impose
> the i_mutex restriction on llseek on a directory for every filesystem.
> 

One of my concern is, concurrent lseek() and readdir() doesn't seem to be
well tested. I'll add a test case in xfstests.

