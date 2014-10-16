Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbaJPKb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 06:31:28 -0400
Received: from relay.parallels.com ([195.214.232.42]:48492 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbaJPKb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 06:31:26 -0400
Message-ID: <543F9E75.2090509@parallels.com>
Date: Thu, 16 Oct 2014 14:31:17 +0400
From: Maxim Patlasov <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Anand Avati <avati@gluster.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael j Theall <mtheall@us.ibm.com>,
        fuse-devel <fuse-devel@lists.sourceforge.net>
Subject: Re: [PATCH 0/5] fuse: handle release synchronously (v4)
References: <20140925120244.540.31506.stgit@dhcp-10-30-22-200.sw.ru>	<CA+55aFwfTeoCJDs6RJg++0SY=SsPrn7Y_Y0Ag_TsNvd6Vsj1Eg@mail.gmail.com>	<CAFboF2yhGyjk4e_CHQV5b2WvB-QhsWNyHvFiFG_OM_=3-KArLQ@mail.gmail.com>	<CA+55aFwqAOGbQ-LYmD-aSALTyA0p9=0vNdsJWd+uweUQyzsW8w@mail.gmail.com>	<20140930191933.GC5011@tucsk.piliscsaba.szeredi.hu>	<CA+55aFyD2Q6tJzRUbNyNFRdbSN09SAN9CqC5BTmCtOu4W9PKGw@mail.gmail.com>	<542BE551.1010705@parallels.com> <CAJfpegs4Up_feUbqEGxfhq+rZneTmy0qcZy-k3so7VjufQY7-w@mail.gmail.com>
In-Reply-To: <CAJfpegs4Up_feUbqEGxfhq+rZneTmy0qcZy-k3so7VjufQY7-w@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.22.200]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miklos,

On 10/09/2014 12:14 PM, Miklos Szeredi wrote:
> On Wed, Oct 1, 2014 at 1:28 PM, Maxim Patlasov <mpatlasov@parallels.com> wrote:
>> Given those patches must die, do you have any ideas how to resolve that
>> "spurious EBUSY" problem?
> Check the "sync_release" branch of fuse:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git sync_release
>
> And same branch name for libfuse:
>
>    git://git.code.sf.net/p/fuse/fuse sync_release
>
> What it does is send RELEASE from ->flush() after checking the
> refcount of file (being careful about RCU accesses).
>
> Lightly tested, more testing, as well as review, is welcome.

Thank you very much for efforts, highly appreciated! I've had a close 
look at your patches and found a few issues. Most of them can be easily 
fixed, but one puzzles me: the way how you detect last flush is not race 
free. Something as simple as:

int main(int argc, char *argv[])
{
     int fd = open(argv[1], O_RDWR);
     fork();
}

may easily dive into fuse_try_sync_release() concurrently and both 
observe file->f_count == 2. Then both return falling back to sending the 
release asynchronously. This makes sync/async behaviour unpredictable 
even for well-behaved applications which don't do any esoteric things 
like racing i/o with close or exiting while a descriptor is in-flight in 
a unix domain socket.

I cannot see any way to recognise last flush without help of VFS layer, 
can you?

Thanks,
Maxim
