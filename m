Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758471AbaJaT4N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 15:56:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54236 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583AbaJaT4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 15:56:11 -0400
Date: Fri, 31 Oct 2014 19:56:07 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Tejun Heo <tj@kernel.org>, Marcel Holtmann <marcel@holtmann.org>,
        Ryan Lortie <desrt@desrt.ca>, hadess@hadess.net,
        David Herrmann <dh.herrmann@gmail.com>,
        Djalal Harouni <tixxdz@opendz.org>,
        Simon McVittie <simon.mcvittie@collabora.co.uk>,
        Daniel Mack <daniel@zonque.org>,
        Alban Crequy <alban.crequy@collabora.co.uk>,
        javier.martinez@collabora.co.uk, teg@jklm.no
Subject: Re: How Not To Use kref (was Re: kdbus: add code for buses, domains
 and endpoints)
Message-ID: <20141031195607.GM7996@ZenIV.linux.org.uk>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <1414620056-6675-9-git-send-email-gregkh@linuxfoundation.org>
 <20141030233801.GF7996@ZenIV.linux.org.uk>
 <CA+55aFxB=jWGvPH3TMhB=ungOg9TBai5Ak-ma5vChBB-H2AgnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxB=jWGvPH3TMhB=ungOg9TBai5Ak-ma5vChBB-H2AgnQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 11:00:01AM -0700, Linus Torvalds wrote:
> On Thu, Oct 30, 2014 at 4:38 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > If you remove an object from some search structures, taking the lock in
> > destructor is Too Fucking Late(tm).  Somebody might have already found
> > that puppy and decided to pick it (all under that lock) just as we'd
> > got to that point in destructor and blocked there.  Oops...
> 
> Ugh, yes. This is a much too common anti-pattern.

*nod*

kref is badly oversold; it's fine for the case when there's no non-counting
references to the object, but in this kind of situations the things get
subtle.  And the main attraction of kref is the promise that it's easy to
use and avoids all the subtle issues.  It's not specific to kref, of course -
the same breakage can and does occur when refcounting is open-coded; for
example, we used to have that kind of bug in dput().  What makes it really
unpleasant is that easy-to-use-don't-worry-it-takes-care-of-everything
assumption...

FWIW, here's another lovely instance (drivers/infiniband/hw/ipath/ipath_mmap.c):
static void ipath_vma_close(struct vm_area_struct *vma)
{
        struct ipath_mmap_info *ip = vma->vm_private_data;

        kref_put(&ip->ref, ipath_release_mmap_info);
}
void ipath_release_mmap_info(struct kref *ref)
{
        struct ipath_mmap_info *ip =
                container_of(ref, struct ipath_mmap_info, ref);
        struct ipath_ibdev *dev = to_idev(ip->context->device);

        spin_lock_irq(&dev->pending_lock);
        list_del(&ip->pending_mmaps);
        spin_unlock_irq(&dev->pending_lock);

        vfree(ip->obj);
        kfree(ip);
}
static void ipath_vma_open(struct vm_area_struct *vma)
{
        struct ipath_mmap_info *ip = vma->vm_private_data;

        kref_get(&ip->ref);
}
int ipath_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
{
...
        spin_lock_irq(&dev->pending_lock);
        list_for_each_entry_safe(ip, pp, &dev->pending_mmaps,
                /* Only the creator is allowed to mmap the object */
                if (context != ip->context || (__u64) offset != ip->offset)
                        continue;
                /* Don't allow a mmap larger than the object. */
                if (size > ip->size)
                        break;

                list_del_init(&ip->pending_mmaps);
                spin_unlock_irq(&dev->pending_lock);

                ret = remap_vmalloc_range(vma, ip->obj, 0);
                if (ret)
                        goto done;
                vma->vm_ops = &ipath_vm_ops;
                vma->vm_private_data = ip;
                ipath_vma_open(vma);
                goto done;


> > Normally I'd say "just use kref_put_mutex()", but this case is even worse.
> > Look:
> 
> Yeah the whole "release the structure the lock is in" is another one.
> 
> Both of these patterns have happened so many times that I'd love to
> have some kind of automated tool to see them, but I suspect it is
> *much* too complex to be easily checked for.

Especially since here the lock is *not* in the object being fed to
destructor - it's in the object ours holds a reference to, with destructor
dropping that reference and _sometimes_ it ends up being the last one.

As for the first pattern...  Frankly, git grep -n -w kref_put, followed
by quick look through the destructors for something like list_del catches
a _lot_ of that ;-/  Not every match is a bug of that sort, but the
fraction of false positives is not too high...
