Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616AbaJ2RrJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 13:47:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756246AbaJ2RrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 13:47:06 -0400
Date: Wed, 29 Oct 2014 18:46:07 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: zhanghailiang <zhang.zhanghailiang@huawei.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andres Lagar-Cavilla <andreslc@google.com>,
        Dave Hansen <dave@sr71.net>, Paolo Bonzini <pbonzini@redhat.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>, Hugh Dickins <hughd@google.com>,
        Peter Feiner <pfeiner@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Christopher Covington <cov@codeaurora.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Mike Hommey <mh@glandium.org>,
        Taras Glek <tglek@mozilla.com>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>, Keith Packard <keithp@keithp.com>,
        "Huangpeng (Peter)" <peter.huangpeng@huawei.com>,
        Isaku Yamahata <yamahata@valinux.co.jp>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        Wenchao Xia <wenchaoqemu@gmail.com>, Andrew Jones <drjones@redhat.com>,
        Juan Quintela <quintela@redhat.com>
Subject: Re: [PATCH 00/17] RFC: userfault v2
Message-ID: <20141029174607.GK19606@redhat.com>
References: <1412356087-16115-1-git-send-email-aarcange@redhat.com>
 <544E1143.1080905@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544E1143.1080905@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zhanghailiang,

On Mon, Oct 27, 2014 at 05:32:51PM +0800, zhanghailiang wrote:
> Hi Andrea,
> 
> Thanks for your hard work on userfault;)
> 
> This is really a useful API.
> 
> I want to confirm a question:
> Can we support distinguishing between writing and reading memory for userfault?
> That is, we can decide whether writing a page, reading a page or both trigger userfault.
> 
> I think this will help supporting vhost-scsi,ivshmem for migration,
> we can trace dirty page in userspace.
> 
> Actually, i'm trying to relize live memory snapshot based on pre-copy and userfault,
> but reading memory from migration thread will also trigger userfault.
> It will be easy to implement live memory snapshot, if we support configuring
> userfault for writing memory only.

Mail is going to be long enough already so I'll just assume tracking
dirty memory in userland (instead of doing it in kernel) is worthy
feature to have here.

After some chat during the KVMForum I've been already thinking it
could be beneficial for some usage to give userland the information
about the fault being read or write, combined with the ability of
mapping pages wrprotected to mcopy_atomic (that would work without
false positives only with MADV_DONTFORK also set, but it's already set
in qemu). That will require "vma->vm_flags & VM_USERFAULT" to be
checked also in the wrprotect faults, not just in the not present
faults, but it's not a massive change. Returning the read/write
information is also a not massive change. This will then payoff mostly
if there's also a way to remove the memory atomically (kind of
remap_anon_pages).

Would that be enough? I mean are you still ok if non present read
fault traps too (you'd be notified it's a read) and you get
notification for both wrprotect and non present faults?

The question then is how you mark the memory readonly to let the
wrprotect faults trap if the memory already existed and you didn't map
it yourself in the guest with mcopy_atomic with a readonly flag.

My current plan would be:

- keep MADV_USERFAULT|NOUSERFAULT just to set VM_USERFAULT for the
  fast path check in the not-present and wrprotect page fault

- if VM_USERFAULT is set, find if there's a userfaultfd registered
  into that vma too

    if yes engage userfaultfd protocol

    otherwise raise SIGBUS (single threaded apps should be fine with
    SIGBUS and it'll avoid them to spawn a thread in order to talk the
    userfaultfd protocol)

- if userfaultfd protocol is engaged, return read|write fault + fault
  address to read(ufd) syscalls

- leave the "userfault" resolution mechanism independent of the
  userfaultfd protocol so we keep the two problems separated and we
  don't mix them in the same API which makes it even harder to
  finalize it.

    add mcopy_atomic (with a flag to map the page readonly too)

    The alternative would be to hide mcopy_atomic (and even
    remap_anon_pages in order to "remove" the memory atomically for
    the externalization into the cloud) as userfaultfd commands to
    write into the fd. But then there would be no much point to keep
    MADV_USERFAULT around if I do so and I could just remove it
    too or it doesn't look clean having to open the userfaultfd just
    to issue an hidden mcopy_atomic.

    So it becomes a decision if the basic SIGBUS mode for single
    threaded apps should be supported or not. As long as we support
    SIGBUS too and we don't force to use userfaultfd as the only
    mechanism to be notified about userfaults, having a separate
    mcopy_atomic syscall sounds cleaner.
 
    Perhaps mcopy_atomic could be used in other cases that may arise
    later that may not be connected with the userfault.

Questions to double check the above plan is ok:

1) should I drop the SIGBUS behavior and MADV_USERFAULT?

2) should I hide mcopy_atomic as a write into the userfaultfd?

   NOTE: even if I hide mcopy_atomic as a userfaultfd command to write
   into the fd, the buffer pointer passed to write() syscall would
   still _not_ be pointing to the data like a regular write, but it
   would be a pointer to a command structure that points to the source
   and destination data of the "hidden" mcopy_atomic, the only
   advantage is that perhaps I could wakeup the blocked page faults
   without requiring an additional syscall.

   The standalone mcopy_atomic would still require a write into the
   userfaultfd as it happens now after remap_anon_pages returns, in
   order to wakeup the stopped page faults.

3) should I add a registration command to trap only write faults?

   The protocol can always be extended later anyway in a backwards
   compatible way but it's better if we get it fully featured from the
   start.

For completeness, some answers for other questions I've seen floating
around but that weren't posted on the list yet (you can skip reading
the below part if not interested):

- open("/dev/userfault") instead of sys_userfaultfd(), I don't see the
  benefit: userfaultfd is just like eventfd in terms of kernel API and
  registering a /dev/ device actually sounds trickier. userfault is a
  core VM feature and generally we prefer syscalls for core VM
  features instead of running ioctl on some chardev that may or may
  not exist. (like we did with /dev/ksm -> MADV_MERGEABLE)

- there was a suggestion during KVMForum about allowing an external
  program to attach to any MM. Like ptrace. So you could have a single
  process managing all userfaults for different processes. However
  because I cannot allow multiple userfaultfd to register into the
  same range, this doesn't look very reliable (ptrace is kind of an
  optional/debug feature while if userfault goes wrong and returns
  -EBUSY things go bad) and there may be other complications. If I'd
  allow multiple userfaultfd to register into the same range, I
  wouldn't even know who to deliver the userfault to. It is an erratic
  behavior. Currently it'd return -EBUSY if the app has a bug and does
  that, but maybe later this can be relaxed to allow higher
  scalability with a flag (userfaultfd gets flags as parameters), but
  it still would need to be the same logic that manages userfaults and
  the only point of allowing multiple ufd to map the same range would
  be SMP scalability. So I tend to see the userfaultfd as a MM local
  thing. The thread managing the userfaults can still talk with
  another process in the local machine using pipes or sockets if it
  needs to.

- the userfaultfd protocol version handshake was done this way because
  it looked more reliable.

  Of course we could pass the version of the protocol as parameter to
  userfaultfd too, but running the syscall multiple times until
  -EPROTO didn't return anymore doesn't seem any better than writing
  into the fd the wanted protocol until you read it back instead of
  -1ULL. It just looked more reliable not having to run the syscall
  again and again while depending on -EPROTO or some other
  -Esomething.

Thanks,
Andrea
