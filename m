Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab3HOVnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 17:43:32 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:58055 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab3HOVna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 17:43:30 -0400
MIME-Version: 1.0
In-Reply-To: <20130815213725.GT6023@dastard>
References: <520BED7A.4000903@intel.com> <20130814230648.GD22316@thunk.org>
 <CALCETrVaRQ3WQ5++Uu_0JTaVnjUugAaAhqQK__7r5YWvLxpAhw@mail.gmail.com>
 <20130815011101.GA3572@thunk.org> <20130815021028.GM6023@dastard>
 <CALCETrUfuzgG9U=+eSzCGvbCx-ZskWw+MhQ-qmEyWZK=XWNVmg@mail.gmail.com>
 <20130815060149.GP6023@dastard> <CALCETrUF+dGhE3qv4LoYmc7A=a+ry93u-d-GgHSAwHXvYN+VNw@mail.gmail.com>
 <20130815071141.GQ6023@dastard> <CALCETrWyKSMDkgSbg20iWBRfHk0-oU+6A3X9xAEMg3vO=G_gDg@mail.gmail.com>
 <20130815213725.GT6023@dastard>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 15 Aug 2013 14:43:09 -0700
Message-ID: <CALCETrV7F-47_nRx1AVFqeF8sNoREutbo3kf78ddBLvKKmFCzg@mail.gmail.com>
Subject: Re: page fault scalability (ext3, ext4, xfs)
To: Dave Chinner <david@fromorbit.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Dave Hansen <dave.hansen@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 2:37 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Aug 15, 2013 at 08:17:18AM -0700, Andy Lutomirski wrote:
>> I didn't think of that at all.
>>
>> If userspace does:
>>
>> ptr = mmap(...);
>> ptr[0] = 1;
>> sleep(1);
>> ptr[0] = 2;
>> sleep(1);
>> munmap();
>>
>> Then current kernels will mark the inode changed on (only) the ptr[0]
>> = 1 line.  My patches will instead mark the inode changed when munmap
>> is called (or after ptr[0] = 2 if writepages gets called for any
>> reason).
>>
>> I'm not sure which is better.  POSIX actually requires my behavior
>> (which is most irrelevant).
>
> Not by my reading of it. Posix states that c/mtime needs to be
> updated between the first access and the next msync() call. We
> update mtime on the first access, and so therefore we conform to the
> posix requirement....

It says "between a write reference to the mapped region and the next
call to msync()."  Most write references don't cause page faults.

>
>> My behavior also means that, if an NFS
>> client reads and caches the file between the two writes, then it will
>> eventually find out that the data is stale.
>
> "eventually" is very different behaviour to the current behaviour.
>
> My understanding is that NFS v4 delegations require the underlying
> filesystem to bump the version count on *any* modification made to
> the file so that delegations can be recalled appropriately. So not
> informing the filesystem that the file data has been changed is
> going to cause problems.

We don't do that right now (and we can't without utterly destroying
performance) because we don't trap on every modification.  See
below...

>
>> The current behavior, on
>> the other hand, means that a single pass of mmapped writes through the
>> file will update the times much faster.
>>
>> I could arrange for the first page fault to *also* update times when
>> the FS is exported or if a particular mount option is set.  (The ext4
>> change to request the new behavior is all of four lines, and it's easy
>> to adjust.)
>
> What does "first page fault" mean?

The first write to the page triggers a page fault and marks the page
writable.  The second write to the page (assuming no writeback happens
in the mean time) does not trigger a page fault or notify the kernel
in any way.


In current kernels, this chain of events won't work:

 - Server goes down
 - Server comes up
 - Userspace on server calls mmap and writes something
 - Client reconnects and invalidates its cache
 - Userspace on server writes something else *to the same page*

The client will never notice the second write, because it won't update
any inode state.  With my patches, the client will as soon as the
server starts writeback.

So I think that there are cases where my changes make things better
and cases where they make things worse.

--Andy
