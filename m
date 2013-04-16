Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab3DPSWX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 14:22:23 -0400
Received: from mx2.parallels.com ([199.115.105.18]:49801 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393Ab3DPSWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 14:22:22 -0400
X-Greylist: delayed 515 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Apr 2013 14:22:22 EDT
Message-ID: <516D94D8.2090105@parallels.com>
Date: Tue, 16 Apr 2013 11:13:44 -0700
From: Maxim Patlasov <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: <dev@parallels.com>, <xemul@parallels.com>,
        <fuse-devel@lists.sourceforge.net>, <bfoster@redhat.com>,
        <linux-kernel@vger.kernel.org>, <devel@openvz.org>,
        <anand.avati@gmail.com>
Subject: Re: [PATCH 0/5] fuse: close file synchronously
References: <20121220122702.4101.80042.stgit@maximpc.sw.ru> <CAJfpegsD2iyP2=Z3zL-yb_TjjQxipOBKV7yqpdPPTH9oobQ=bA@mail.gmail.com>
In-Reply-To: <CAJfpegsD2iyP2=Z3zL-yb_TjjQxipOBKV7yqpdPPTH9oobQ=bA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [69.38.217.10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miklos,

On 4/15/13 7:08 PM, Miklos Szeredi wrote:
> On Thu, Dec 20, 2012 at 1:30 PM, Maxim Patlasov<mpatlasov@parallels.com>  wrote:
>> Hi,
>>
>> There is a long-standing demand for syncronous behaviour of fuse_release:
>>
>> http://sourceforge.net/mailarchive/message.php?msg_id=19343889
>> http://sourceforge.net/mailarchive/message.php?msg_id=29814693
>>
>> A few months ago Avati and me explained why such a feature would be useful:
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
>>
>> The patch-set resolves the problem by making fuse_release synchronous:
>> wait for ACK from userspace for FUSE_RELEASE if the feature is ON.
>>
>> To keep single-threaded userspace implementations happy the patch-set
>> ensures that by the time fuse_release_common calls fuse_file_put, no
>> more in-flight I/O exists. Asynchronous fuse callbacks (like
>> fuse_readpages_end) cannot trigger FUSE_RELEASE anymore. Hence, we'll
>> never block in contexts other than close().
> There are a few fput() calls outside sys_close(), all of these can
> trigger FUSE_RELEASE.  Most of those are OK, but for some I'm
> reluctant to enable synchronous release.
>
> For example doing a readlink() on a magic symlink under /proc
> shouldn't result in a synchronous call to a fuse filesystem.  Making
> fput() synchronous may actually end up doing that (even if it's not
> very likely).
>
> At least for the unprivileged fuse daemon case it shouldn't be done.
> If the fuse daemon can be "trusted" then enabling synchronous release
> should be okay, that's why it's enabled for fuseblk.
>
> But maybe I'm just too paranoid...

No, I don't think it's too paranoid. I suggest to put the feature under 
fusermount control by adding "close_wait" mount option. This is very 
simple and straightforward and let sysad to decide whether to allow the 
feature for unprivileged users or not.

Btw, having read last messages on this thread, I realized that the name 
of patchset is a bit misleading - it would be better to name it "process 
last fput() synchronously". But the core idea still looks sensible to 
me: userspace may hold a reference to a file in one way or another (e.g. 
by mmap-ed region), but when all references are released the file should 
be ready for reuse again (e.g. to be accessed from another node).

The patch-set was reviewed by Brian Foster and now you looked at it as 
well. Is it time for me to rebase the patchset to be applied on top of 
writeback-cache patches?

Thanks,
Maxim

