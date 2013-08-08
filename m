Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944Ab3HHP4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 11:56:52 -0400
Received: from mail-vb0-f51.google.com ([209.85.212.51]:44854 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757917Ab3HHP4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 11:56:51 -0400
MIME-Version: 1.0
In-Reply-To: <20130808101807.GB4325@quack.suse.cz>
References: <cover.1375729665.git.luto@amacapital.net> <20130807134058.GC12843@quack.suse.cz>
 <520286A4.1020101@intel.com> <CALCETrXAz1fc7y07LhmxNh6zA_KZB4yv57NY2MrhUwKdkypB9w@mail.gmail.com>
 <20130808101807.GB4325@quack.suse.cz>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 8 Aug 2013 08:56:28 -0700
Message-ID: <CALCETrX1GXr58ujqAVT5_DtOx+8GEiyb9svK-SGH9d+7SXiNqQ@mail.gmail.com>
Subject: Re: [RFC 0/3] Add madvise(..., MADV_WILLWRITE)
To: Jan Kara <jack@suse.cz>
Cc: Dave Hansen <dave.hansen@intel.com>, linux-mm@kvack.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 8, 2013 at 3:18 AM, Jan Kara <jack@suse.cz> wrote:
> On Wed 07-08-13 11:00:52, Andy Lutomirski wrote:
>> On Wed, Aug 7, 2013 at 10:40 AM, Dave Hansen <dave.hansen@intel.com> wrote:
>> > On 08/07/2013 06:40 AM, Jan Kara wrote:
>> >>   One question before I look at the patches: Why don't you use fallocate()
>> >> in your application? The functionality you require seems to be pretty
>> >> similar to it - writing to an already allocated block is usually quick.
>> >
>> > One problem I've seen is that it still costs you a fault per-page to get
>> > the PTEs in to a state where you can write to the memory.  MADV_WILLNEED
>> > will do readahead to get the page cache filled, but it still leaves the
>> > pages unmapped.  Those faults get expensive when you're trying to do a
>> > couple hundred million of them all at once.
>>
>> I have grand plans to teach the kernel to use hardware dirty tracking
>> so that (some?) pages can be left clean and writable for long periods
>> of time.  This will be hard.
>   Right that will be tough... Although with your application you could
> require such pages to be mlocked and then I could imagine we would get away
> at least from problems with dirty page accounting.

True.  The nasty part will be all the code that assumes that the acts
of un-write-protecting and dirtying are the same thing, for example
__block_write_begin, which is why I don't really believe in my
willwrite patches...

>
>> Even so, the second write fault to a page tends to take only a few
>> microseconds, while the first one often blocks in fs code.
>   So you wrote blocks are already preallocated with fallocate(). If you
> also preload pages in memory with MADV_WILLNEED is there still big
> difference between the first and subsequent write fault?

I haven't measured it yet, because I suspect that my patches are
rather buggy in their current form.  But the idea is that fallocate
will do the heavy lifting and give me a nice contiguous allocation,
and the MADV_WILLNEED call will take about as long as the first write
fault would have taken.  Then the first write fault after
MADV_WILLNEED will take about as long as the second write fault would
have taken without it.


--Andy
