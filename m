Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbaHNMOZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 08:14:25 -0400
Received: from relay.parallels.com ([195.214.232.42]:53528 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322AbaHNMOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 08:14:24 -0400
Message-ID: <53ECA81D.7040805@parallels.com>
Date: Thu, 14 Aug 2014 16:14:21 +0400
From: Maxim Patlasov <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: fuse-devel <fuse-devel@lists.sourceforge.net>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] fuse: close file synchronously (v2)
References: <20140606132541.30321.68679.stgit@localhost.localdomain> <CAJfpegts+jjLDqOYnK7SmcWnbmuwYBfgt4CXHWhVdxNjz1vA1g@mail.gmail.com>
In-Reply-To: <CAJfpegts+jjLDqOYnK7SmcWnbmuwYBfgt4CXHWhVdxNjz1vA1g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.22.200]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2014 04:44 PM, Miklos Szeredi wrote:
> On Fri, Jun 6, 2014 at 3:27 PM, Maxim Patlasov <MPatlasov@parallels.com> wrote:
>> Hi,
>>
>> There is a long-standing demand for synchronous behaviour of fuse_release:
>>
>> http://sourceforge.net/mailarchive/message.php?msg_id=19343889
>> http://sourceforge.net/mailarchive/message.php?msg_id=29814693
>>
>> A year ago Avati and me explained why such a feature would be useful:
>>
>> http://sourceforge.net/mailarchive/message.php?msg_id=29889055
>> http://sourceforge.net/mailarchive/message.php?msg_id=29867423
>>
>> In short, the problem is that fuse_release (that's called on last user
>> close(2)) sends FUSE_RELEASE to userspace and returns without waiting for
>> ACK from userspace. Consequently, there is a gap when user regards the
>> file released while userspace fuse is still working on it. An attempt to
>> access the file from another node leads to complicated synchronization
>> problems because the first node still "holds" the file.
> Tying RELEASE to close(2) is not going to work.  Look at all the
> places that call fput() (or fdput() in recent kernels), those are all
> potential triggers for RELEASE, some realistic, some not quite, but
> all are certainly places that a synchronous release could block
> *instead* of close.
>
> Which just means, that close will still be asynchronous with release
> some of the time.  So it's not clear to me what is to be gained from
> this patchset.

The patch-set doesn't tie RELEASE to close(2), it ensures that we report 
to user space exactly the last fput(). That's correct because this is 
exactly the moment when any file system with sharing mode connected to 
open/close must drop sharing mode. This is the case even for some local 
filesystems, for example, ntfs-3g.

Could you please look closely at your commit 
5a18ec176c934ca1bc9dc61580a5e0e90a9b5733. It actually implemented two 
different things: 1) synchronous release and 2) delayed path_put. The 
latter was well explained by the comment:

 >        /*
 >         * If this is a fuseblk mount, then it's possible that
 >         * releasing the path will result in releasing the
 >         * super block and sending the DESTROY request.  If
 >         * the server is single threaded, this would hang.
 >         * For this reason do the path_put() in a separate
 >         * thread.
 >         */

So it's clear why the delay needed and why it's bound to fuseblk 
condition. But synchronous close was made under the same condition, 
which is obviously wrong. I understand why you made that decision in 
2011: otherwise, we could block in a wrong context (last decrement of 
ff->count might happen in scope of read-ahead or mmap-ed writeback). But 
now, with the approach implemented in this patch-set, this is impossible 
-- we wait for completion of all async operations before triggering 
synchronous release. Thus the patch-set untie a functionality which 
already existed before (synchronous release) from wrong condition 
(fuseblk mount) putting it under well-defined control (FUSE_CLOSE_WAIT).

Thanks,
Maxim
