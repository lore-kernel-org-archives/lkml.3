Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750921Ab3FVFUF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 01:20:05 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:41464 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab3FVFUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 01:20:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAH9JG2Uif-d-osTsCT-EqKw+ZWJ1S-rFJA-nQ9nkqTH7sbcSsQ@mail.gmail.com>
References: <CAMbhsRQU=xrcum+ZUbG3S+JfFUJK_qm_VB96Vz=PpL=vQYhUvg@mail.gmail.com>
	<CAH9JG2Uif-d-osTsCT-EqKw+ZWJ1S-rFJA-nQ9nkqTH7sbcSsQ@mail.gmail.com>
Date: Fri, 21 Jun 2013 22:20:02 -0700
Message-ID: <CAMbhsRSz-eP-8UwMRsNXah3QDY1jUUhCctDH5RvcL=_VMwi2=Q@mail.gmail.com>
Subject: Re: RFC: named anonymous vmas
From: Colin Cross <ccross@google.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Hyunhee Kim <hyunhee.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 10:12 PM, Kyungmin Park <kmpark@infradead.org> wrote:
> On Sat, Jun 22, 2013 at 8:42 AM, Colin Cross <ccross@google.com> wrote:
>> One of the features of ashmem (drivers/staging/android/ashmem.c) that
>> hasn't gotten much discussion about moving out of staging is named
>> anonymous memory.
>>
>> In Android, ashmem is used for three different features, and most
>> users of it only care about one feature at a time.  One is volatile
>> ranges, which John Stultz has been implementing.  The second is
>> anonymous shareable memory without having a world-writable tmpfs that
>> untrusted apps could fill with files.  The third and most heavily used
>> feature within the Android codebase is named anonymous memory, where a
>> region of anonymous memory can have a name associated with it that
>> will show up in /proc/pid/maps.  The Dalvik VM likes to use this
>
> Good to know it. I didn't know ashmem provides these features.
> we are also discussing these requirement internally. and study how to
> show who request these anon memory and which callback is used for it.
>
>> feature extensively, even for memory that will never be shared and
>> could easily be allocated using an anonymous mmap, and even malloc has
>> used it in the past.  It provides an easy way to collate memory used
>> for different purposes across multiple processes, which Android uses
>> for its "dumpsys meminfo" and "librank" tools to determine how much
>> memory is used for java heaps, JIT caches, native mallocs, etc.
> Same requirement for app developers. they want to know what's the
> meaning these anon memory is allocated and how to find out these anon
> memory is allocated at their codes.
>>
>> I'd like to add this feature for anonymous mmap memory.  I propose
>> adding an madvise2(unsigned long start, size_t len_in, int behavior,
>> void *ptr, size_t size) syscall and a new MADV_NAME behavior, which
>> treats ptr as a string of length size.  The string would be copied
>> somewhere reusable in the kernel, or reused if it already exists, and
>> the kernel address of the string would get stashed in a new field in
>> struct vm_area_struct.  Adjacent vmas would only get merged if the
>> name pointer matched, and naming part of a mapping would split the
>> mapping.  show_map_vma would print the name only if none of the other
>> existing names rules match.
> Do you want to create new syscall? can it use current madvise and only
> allow this feature at linux only?
> As you know it's just hint and it doesn't break existing memory behaviors.

The existing madvise syscall only takes a single int to modify the
vma, which is not enough to pass a pointer to a string.
