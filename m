Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbaFMKmu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 06:42:50 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:38889 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbaFMKms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 06:42:48 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.11.1406020331100.1259@eggly.anvils>
References: <1397587118-1214-1-git-send-email-dh.herrmann@gmail.com>
	<1397587118-1214-3-git-send-email-dh.herrmann@gmail.com>
	<alpine.LSU.2.11.1405191916300.2970@eggly.anvils>
	<CANq1E4TORuZU7frtR167P-GNPzEuvbjXXEfi9KdvTwGojqGruA@mail.gmail.com>
	<alpine.LSU.2.11.1406020331100.1259@eggly.anvils>
Date: Fri, 13 Jun 2014 12:42:47 +0200
Message-ID: <CANq1E4RcmyUwmhySqvvVaiVJoiKjgpm=Sh+aKQcxbdkJFS80tQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] shm: add memfd_create() syscall
From: David Herrmann <dh.herrmann@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: Tony Battersby <tonyb@cybernetics.com>,
        Andy Lutomirsky <luto@amacapital.net>,
        Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Michael Kerrisk <mtk.manpages@gmail.com>, Ryan Lortie <desrt@desrt.ca>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <greg@kroah.com>,
        John Stultz <john.stultz@linaro.org>,
        Kristian Hogsberg <krh@bitplanet.net>,
        Lennart Poettering <lennart@poettering.net>,
        Daniel Mack <zonque@gmail.com>, Kay Sievers <kay@vrfy.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Mon, Jun 2, 2014 at 12:59 PM, Hugh Dickins <hughd@google.com> wrote:
> On Fri, 23 May 2014, David Herrmann wrote:
>> On Tue, May 20, 2014 at 4:20 AM, Hugh Dickins <hughd@google.com> wrote:
>> > But this does highlight how the "size" arg to memfd_create() is
>> > perhaps redundant.  Why give a size there, when size can be changed
>> > afterwards?  I expect your answer is that many callers want to choose
>> > the size at the beginning, and would prefer to avoid the extra call.
>> > I'm not sure if that's a good enough reason for a redundant argument.
>>
>> At one point in time we might be required to support atomic-sealing.
>> So a memfd_create() call takes the initial seals as upper 32bits in
>> "flags" and sets them before returning the object. If these seals
>> contain SEAL_GROW/SHRINK, we must pass the size during setup (think
>> CLOEXEC with fork()).
>
> That does sound like over-design to me.  You stop short of passing
> in an optional buffer of the data it's to contain, good.
>
> I think it would be a clearer interface without the size, but really
> that's an issue for the linux-api people you'll be Cc'ing next time.
>
> You say "think CLOEXEC with fork()": you have thought about this, I
> have not, please spell out for me what the atomic size guards against.
> Do you want an fd that's not shared across fork?

My thinking was:
Imagine a seal called SEAL_OPEN that prevents against open()
(specifically on /proc/self/fd/). That seal obviously has to be set
before creating the object, otherwise there's a race. Therefore, I'd
need a "seals" argument for memfd_create(). Now imagine there's a
similar seal that has such a race but prevents any following resize.
Then I'd have to set the size during initialization, too.

However, in my opinion SEAL_OPEN does not protect against any real
attack (it only protects you from yourself). Therefore, I never added
it. Furthermore, I couldn't think of any similar situation, so I now
removed the "size" argument and made "flags" just an "unsigned int".
It was just a precaution, but I'm fine with dropping it as we cannot
come up with a real possible race.

Sorry for the confusion. I'll send v3 in a minute.

Thanks
David
