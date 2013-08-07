Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732Ab3HGRC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 13:02:59 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:49444 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932490Ab3HGRC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 13:02:57 -0400
MIME-Version: 1.0
In-Reply-To: <20130807134058.GC12843@quack.suse.cz>
References: <cover.1375729665.git.luto@amacapital.net> <20130807134058.GC12843@quack.suse.cz>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 7 Aug 2013 10:02:36 -0700
Message-ID: <CALCETrVT=pmA06VRjmLRZZnWA5PUjcRP_Lwo7f1ze5Lj9FWJeQ@mail.gmail.com>
Subject: Re: [RFC 0/3] Add madvise(..., MADV_WILLWRITE)
To: Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 7, 2013 at 6:40 AM, Jan Kara <jack@suse.cz> wrote:
> On Mon 05-08-13 12:43:58, Andy Lutomirski wrote:
>> My application fallocates and mmaps (shared, writable) a lot (several
>> GB) of data at startup.  Those mappings are mlocked, and they live on
>> ext4.  The first write to any given page is slow because
>> ext4_da_get_block_prep can block.  This means that, to get decent
>> performance, I need to write something to all of these pages at
>> startup.  This, in turn, causes a giant IO storm as several GB of
>> zeros get pointlessly written to disk.
>>
>> This series is an attempt to add madvise(..., MADV_WILLWRITE) to
>> signal to the kernel that I will eventually write to the referenced
>> pages.  It should cause any expensive operations that happen on the
>> first write to happen immediately, but it should not result in
>> dirtying the pages.
>>
>> madvice(addr, len, MADV_WILLWRITE) returns the number of bytes that
>> the operation succeeded on or a negative error code if there was an
>> actual failure.  A return value of zero signifies that the kernel
>> doesn't know how to "willwrite" the range and that userspace should
>> implement a fallback.
>>
>> For now, it only works on shared writable ext4 mappings.  Eventually
>> it should support other filesystems as well as private pages (it
>> should COW the pages but not cause swap IO) and anonymous pages (it
>> should COW the zero page if applicable).
>>
>> The implementation leaves much to be desired.  In particular, it
>> generates dirty buffer heads on a clean page, and this scares me.
>>
>> Thoughts?
>   One question before I look at the patches: Why don't you use fallocate()
> in your application? The functionality you require seems to be pretty
> similar to it - writing to an already allocated block is usually quick.

I do use fallocate, and, IIRC, the problem was worse before I added
the fallocate call.

This could be argued to be a filesystem problem -- perhaps
page_mkwrite should never block.  I don't expect that to be fixed any
time soon (if ever).

--Andy
