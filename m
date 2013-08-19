Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470Ab3HSW3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 18:29:44 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:58375 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab3HSW3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 18:29:42 -0400
MIME-Version: 1.0
In-Reply-To: <20130819221716.GA17869@fieldses.org>
References: <520BB9EF.5020308@linux.intel.com> <20130814194359.GA22316@thunk.org>
 <520BED7A.4000903@intel.com> <20130814230648.GD22316@thunk.org>
 <CALCETrVaRQ3WQ5++Uu_0JTaVnjUugAaAhqQK__7r5YWvLxpAhw@mail.gmail.com>
 <20130815011101.GA3572@thunk.org> <20130815021028.GM6023@dastard>
 <CALCETrUfuzgG9U=+eSzCGvbCx-ZskWw+MhQ-qmEyWZK=XWNVmg@mail.gmail.com>
 <20130815060149.GP6023@dastard> <20130819221716.GA17869@fieldses.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 19 Aug 2013 15:29:21 -0700
Message-ID: <CALCETrXT0uc9KO90yvGdcAmLRZ=JJNCwA_KsTUvxRB6+4poGEg@mail.gmail.com>
Subject: Re: page fault scalability (ext3, ext4, xfs)
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Dave Hansen <dave.hansen@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 3:17 PM, J. Bruce Fields <bfields@fieldses.org> wrote:
> On Thu, Aug 15, 2013 at 04:01:49PM +1000, Dave Chinner wrote:
>> On Wed, Aug 14, 2013 at 09:32:13PM -0700, Andy Lutomirski wrote:
>> > On Wed, Aug 14, 2013 at 7:10 PM, Dave Chinner <david@fromorbit.com> wrote:
>> > > On Wed, Aug 14, 2013 at 09:11:01PM -0400, Theodore Ts'o wrote:
>> > >> On Wed, Aug 14, 2013 at 04:38:12PM -0700, Andy Lutomirski wrote:
>> > >> > > It would be better to write zeros to it, so we aren't measuring the
>> > >> > > cost of the unwritten->written conversion.
>> > >> >
>> > >> > At the risk of beating a dead horse, how hard would it be to defer
>> > >> > this part until writeback?
>> > >>
>> > >> Part of the work has to be done at write time because we need to
>> > >> update allocation statistics (i.e., so that we don't have ENOSPC
>> > >> problems).  The unwritten->written conversion does happen at writeback
>> > >> (as does the actual block allocation if we are doing delayed
>> > >> allocation).
>> > >>
>> > >> The point is that if the goal is to measure page fault scalability, we
>> > >> shouldn't have this other stuff happening as the same time as the page
>> > >> fault workload.
>> > >
>> > > Sure, but the real problem is not the block mapping or allocation
>> > > path - even if the test is changed to take that out of the picture,
>> > > we still have timestamp updates being done on every single page
>> > > fault. ext4, XFS and btrfs all do transactional timestamp updates
>> > > and have nanosecond granularity, so every page fault is resulting in
>> > > a transaction to update the timestamp of the file being modified.
>> >
>> > I have (unmergeable) patches to fix this:
>> >
>> > http://comments.gmane.org/gmane.linux.kernel.mm/92476
>>
>> The big problem with this approach is that not doing the
>> timestamp update on page faults is going to break the inode change
>> version counting because for ext4, btrfs and XFS it takes a
>> transaction to bump that counter. NFS needs to know the moment a
>> file is changed in memory, not when it is written to disk.
>
> I don't think the in-memory updates of the data and the version have to
> be completely atomic, if that's what you mean.
>
>> Also, NFS
>> requires the change to the counter to be persistent over server
>> failures, so it needs to be changed as part of a transaction....
>
> I'm not sure those two updates have to be a single atomic transaction on
> disk, either.
>

I hope not, because they aren't currently in the same transaction, and
putting them in the same transaction require starting a transaction on
page fault and doing the equivalent of writepages when the same
transaction is committed.

With my changes [1], they still aren't, but putting them in the same
transaction would probably be only a couple lines of code, and it
would actually improve performance.  (I won't write those couple lines
of code because I don't know anything at all about jbd2.)

[1] https://lkml.org/lkml/2013/8/16/510

--Andy
