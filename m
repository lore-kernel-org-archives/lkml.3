Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209AbaFZLoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 07:44:18 -0400
Received: from odin2.bull.net ([129.184.85.11]:50102 "EHLO odin2.bull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757016AbaFZLoR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 07:44:17 -0400
Message-ID: <53AC078C.4090005@bull.net>
Date: Thu, 26 Jun 2014 13:44:12 +0200
From: Sebastien Buisson <sebastien.buisson@bull.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: <rob@landley.net>, <viro@zeniv.linux.org.uk>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] Allow increasing the buffer-head per-CPU LRU size
References: <53A99EA0.3010800@bull.net> <20140625151638.00b7c2aa29f79f63dce7ae56@linux-foundation.org>
In-Reply-To: <20140625151638.00b7c2aa29f79f63dce7ae56@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
X-Originating-IP: [10.192.1.123]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 26/06/2014 00:16, Andrew Morton a écrit :
> On Tue, 24 Jun 2014 17:52:00 +0200 Sebastien Buisson <sebastien.buisson@bull.net> wrote:
>
>> Allow increasing the buffer-head per-CPU LRU size to allow efficient
>> filesystem operations that access many blocks for each transaction.
>> For example, creating a file in a large ext4 directory with quota
>> enabled will accesses multiple buffer heads and will overflow the LRU
>> at the default 8-block LRU size:
>>
>> * parent directory inode table block (ctime, nlinks for subdirs)
>> * new inode bitmap
>> * inode table block
>> * 2 quota blocks
>> * directory leaf block (not reused, but pollutes one cache entry)
>> * 2 levels htree blocks (only one is reused, other pollutes cache)
>> * 2 levels indirect/index blocks (only one is reused)
>>
>> Make this tuning be a kernel parameter 'bh_lru_size'.
>
> I don't think it's a great idea to make this a boot-time tunable.  It's
> going to take a ton of work by each and every kernel
> user/installer/distributor to work out what is the best setting for
> them.  And the differences will be pretty small anyway.  And we didn't
> provide them with any documentation to help them even get started with
> the project.
>

I am sorry, I meant to leave the default bh_lru_size as is, ie set to 8 
(instead of 16 in my proposed patch). That way, kernel users and 
integrators of all kind would not have to bother about the new boot-time 
tunable, and could change nothing and stay with the same value as they 
did before.

At the same time, advanced users like those playing with Lustre would 
have the ability to tune the buffer-head per-CPU LRU size without the 
need to recompile the kernel.

Does it sound better?
