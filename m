Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751207AbaJAL20 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 07:28:26 -0400
Received: from relay.parallels.com ([195.214.232.42]:58754 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbaJAL2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 07:28:24 -0400
Message-ID: <542BE551.1010705@parallels.com>
Date: Wed, 1 Oct 2014 15:28:17 +0400
From: Maxim Patlasov <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>
CC: Anand Avati <avati@gluster.org>,
        "open list:FUSE: FILESYSTEM..." <fuse-devel@lists.sourceforge.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <mtheall@us.ibm.com>
Subject: Re: [PATCH 0/5] fuse: handle release synchronously (v4)
References: <20140925120244.540.31506.stgit@dhcp-10-30-22-200.sw.ru>	<CA+55aFwfTeoCJDs6RJg++0SY=SsPrn7Y_Y0Ag_TsNvd6Vsj1Eg@mail.gmail.com>	<CAFboF2yhGyjk4e_CHQV5b2WvB-QhsWNyHvFiFG_OM_=3-KArLQ@mail.gmail.com>	<CA+55aFwqAOGbQ-LYmD-aSALTyA0p9=0vNdsJWd+uweUQyzsW8w@mail.gmail.com>	<20140930191933.GC5011@tucsk.piliscsaba.szeredi.hu> <CA+55aFyD2Q6tJzRUbNyNFRdbSN09SAN9CqC5BTmCtOu4W9PKGw@mail.gmail.com>
In-Reply-To: <CA+55aFyD2Q6tJzRUbNyNFRdbSN09SAN9CqC5BTmCtOu4W9PKGw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.22.200]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2014 12:44 AM, Linus Torvalds wrote:
> On Tue, Sep 30, 2014 at 12:19 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> What about flock(2), FL_SETLEASE, etc semantics (which are the sane ones,
>> compared to the POSIX locks shit which mandates release of lock on each close(2)
>> instead of "when all [duplicate] descriptors have been closed")?
>>
>> You have to do that from ->release(), there's no question about that.
> We do locks_remove_file() independently on ->release, but yes, it's
> basically done just before the last release.
>
> But it has the *exact* same semantics as release, including very much
> having nothing what-so-ever to do with "last close()".
>
> If the file descriptor is opened for other reasons (ie mmap, /proc
> accesses, whatever), then that delays locks_remove_file() the same way
> it delays release.
>
> None of that has *anothing* to do with "synchronous". Thinking it does is wrong.
>
> And none of this has *anything* to do with the issue that Maxim
> pointed to in the mailing list web page, which was about write caches,
> and how you cannot (and MUST NOT) delay them until release time.

I apologise for mentioning that mailing list web page in my title 
message. This was really misleading, I had to think about it in advance. 
Of course, write caches must be flushed in scope of ->flush(), not 
->release(). Let me please set forth an use-case that led me to those 
patches.

We implemented a FUSE-based distributed storage solution intended for 
keeping images of VMs (virtual machines) and their configuration files. 
The way how VMs use images makes exclusive-open()er semantics very 
attractive: while a VM is using its image on a node, the concurrent 
access from other nodes to that image is neither desirable nor 
necessary. So,  we acquire an exclusive lease on FUSE_OPEN and release 
it on FUSE_RELEASE. This is quite natural and has obviously nothing to 
do with FUSE_FLUSH.

Following such semantics, there are two choices for handling open() if 
the file is currently exclusively locked by a remote node: (a) return 
EBUSY; (b) block until the remote node release the file. We decided for 
(a), because (b) is very inconvenient in practice: most applications 
handle failed open(2) properly, but very few are clever enough to spawn 
a separate thread with open() and kill it if the open() has not 
succeeded in a reasonable time.

The patches I sent make essentially one thing: they make FUSE 
->release() wait for ACK from userspace before return. Without these 
patches, any attempt to test or use our storage in valid use-cases led 
to spurious EBUSY. For example, while migrating a VM from one node to 
another, we firstly close the image file on source node, then try to 
open it on destination node, but fail because FUSE_RELEASE is not 
processed by userspace on source node yet.

Given those patches must die, do you have any ideas how to resolve that 
"spurious EBUSY" problem?

Thanks,
Maxim
