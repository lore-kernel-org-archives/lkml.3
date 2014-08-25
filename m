Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932955AbaHYPMq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 11:12:46 -0400
Received: from relay.parallels.com ([195.214.232.42]:47103 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586AbaHYPMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 11:12:44 -0400
Message-ID: <53FB5268.1010209@parallels.com>
Date: Mon, 25 Aug 2014 19:12:40 +0400
From: Maxim Patlasov <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: fuse-devel <fuse-devel@lists.sourceforge.net>,
        Anand Avati <avati@gluster.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] fuse: wait for end of IO on release
References: <20140821160304.11005.15166.stgit@localhost.localdomain>	<20140821160823.11005.32693.stgit@localhost.localdomain> <CAJfpegu6ZDNK9LyG6Vi2_hRMAW7cisTYZ_7wgT9foYOpbZRoqg@mail.gmail.com>
In-Reply-To: <CAJfpegu6ZDNK9LyG6Vi2_hRMAW7cisTYZ_7wgT9foYOpbZRoqg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.22.200]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2014 06:00 PM, Miklos Szeredi wrote:
> On Thu, Aug 21, 2014 at 6:08 PM, Maxim Patlasov <MPatlasov@parallels.com> wrote:
>> There are two types of I/O activity that can be "in progress" at the time
>> of fuse_release() execution: asynchronous read-ahead and write-back. The
>> patch ensures that they are completed before fuse_release_common sends
>> FUSE_RELEASE to userspace.
>>
>> So far as fuse_release() waits for end of async I/O, its callbacks
>> (fuse_readpages_end and fuse_writepage_finish) calling fuse_file_put cannot
>> be the last holders of fuse file anymore. To emphasize the fact, the patch
>> replaces fuse_file_put with __fuse_file_put there.
> 1) spinlock around __fuse_file_put() is unnecessary,
> wake_up/wait_event will provide the necessary synchronization.
Yes, I agree.

> 2) can't we always wait for I/O and just make the actual RELEASE
> message sync or async based on the flag?
> 3) and can't we merge the fuseblk case into this as well?

I think this is doable, but the same argument that Anand suggested for 
doing sync release selectively:

> In a real world scenario you may want to perform synchronous release 
> selectively. As such performance over lots of small files is generally 
> slow because of context switches, and a synchronous release adds an 
> extra switch.

is applicable here: if an application opened a file read-only and read a 
block initiating read-ahead, it's not obvious why the app doing close(2) 
should always wait for the end of that read-ahead. For some fs it's 
desirable, for others is not. Let's fuse daemon decide which behaviour 
is preferable.

Thanks,
Maxim
