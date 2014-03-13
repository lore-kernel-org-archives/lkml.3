Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423AbaCMQh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 12:37:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754290AbaCMQh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 12:37:26 -0400
Date: Thu, 13 Mar 2014 17:36:32 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Davidlohr Bueso <davi@redhat.com>, Davidlohr Bueso <davidlohr@hp.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH -next] mm,vmacache: also flush cache for VM_CLONE
Message-ID: <20140313163632.GA30737@redhat.com>
References: <CA+55aFw88xiY+o5FE6VtHNkpUZDK3FPt31oCpNsgn1BH7wAPZw@mail.gmail.com> <20140308194405.GA32403@redhat.com> <CA+55aFzk=XtRFPQM4rGgTXj8AD2RLrm5pfAsKwGOZPHLgb+Ziw@mail.gmail.com> <20140309125710.GA1829@redhat.com> <CA+55aFxyGJFEz5NnHtK1wn8oDLy9n-CttttKL_0AM69gN8JzxQ@mail.gmail.com> <20140309170909.GA13335@redhat.com> <CA+55aFxEGj9poWNLAncvrrOTzjDtrwMnOM_d3ACqRkcvY86qHA@mail.gmail.com> <1394481375.3867.1.camel@buesod1.americas.hpqcorp.net> <20140313145941.GA26215@redhat.com> <CA+55aFyNd7L+G3hFauJPxUOengK-_o2G-SFmVooPZ-sE6xBj=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyNd7L+G3hFauJPxUOengK-_o2G-SFmVooPZ-sE6xBj=g@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13, Linus Torvalds wrote:
>
> On Mar 13, 2014 8:11 AM, "Oleg Nesterov" <oleg@redhat.com> wrote:
> >
> > Suppose that a kernel thread T does, say,
> >
> >         use_mm(foreign_mm);
> >         get_user(...);
> >         unuse_mm();
>
> That would be a major bug. Kernel threads cannot access use memory.

Unless a kernel thread does use_mm() ;)

> Has
> somebody added anything that crazy?

Hmm. aio no longer uses use_mm()... But there are other users:

	drivers/usb/gadget/inode.c  582   use_mm(mm);
	drivers/vhost/vhost.c       211   use_mm(dev->mm);
	virt/kvm/async_pf.c          68   use_mm(mm);

And yes, they do copy_to/from_user().

Hmm, but at first glance async_pf_execute() doesn't need use_mm() at all.
And perhaps other callers can use get_user_pages() too.

> The kernel thread "use_mm" is to avoid unnecessary context switches of the
> tlb when switching to a kennel thread, exactly *because* a kernel thread is
> never supposed to access use space, so it cannot care what user memory is
> attached.

It seems that you are talking about switch_mm-like things or I misunderstood.
use_mm() actually changes ->mm, not only ->active_mm.

> So I object vet much to making kernel threads special on this context,
> unless the "special" bit is some VM_BUG_ON() or similar.

See above. Perhaps we can kill use_mm() (personally I don't think we should),
but until then vmacache needs this check afaics.

Oleg.

