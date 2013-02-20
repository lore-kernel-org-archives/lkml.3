Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934113Ab3BTBtv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 20:49:51 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:18989 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758545Ab3BTBtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 20:49:49 -0500
Message-ID: <51242BB0.3060103@huawei.com>
Date: Wed, 20 Feb 2013 09:49:36 +0800
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
References: <5122D3E0.6070800@huawei.com> <20130219091931.GB21945@quack.suse.cz> <51236652.1050608@huawei.com> <20130219125913.GD21945@quack.suse.cz>
In-Reply-To: <20130219125913.GD21945@quack.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/2/19 20:59, Jan Kara wrote:
> On Tue 19-02-13 19:47:30, Li Zefan wrote:
>> On 2013/2/19 17:19, Jan Kara wrote:
>>> On Tue 19-02-13 09:22:40, Li Zefan wrote:
>>>> There's a long long-standing bug...As long as I don't know when it dates
>>>> from.
>>>>
>>>> I've written and attached a simple program to reproduce this bug, and it can
>>>> immediately trigger the bug in my box. It uses two threads, one keeps calling
>>>> read(), and the other calling readdir(), both on the same directory fd.
>>>   So the fact that read() or even write() to fd opened O_RDONLY has *any*
>>> effect on f_pos looks really unexpected to me. I think we really should
>>> have there:
>>> 	if (ret >= 0)
>>> 		file_pos_write(...);
>>
>> I thought about this. The problem is then we have to check every fop->write()
>> to see if any of them can return -errno with file->f_pos changed and fix them,
>> though it's do-able.
>   But returning error and advancing f_pos would be a bug - specification
> says write() returns the number of bytes written or -1 and f_pos should be
> advanced by the number of bytes written.
> 

Oh, I had an illusion that vfs saves f_pos and calls write() and restore f_pos
if write() fails.

