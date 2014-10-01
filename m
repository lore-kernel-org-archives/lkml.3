Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbaJARGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 13:06:35 -0400
Received: from mail-yh0-f51.google.com ([209.85.213.51]:61939 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbaJARG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 13:06:29 -0400
MIME-Version: 1.0
In-Reply-To: <20141001155159.GA7019@google.com>
References: <1412153797-6667-1-git-send-email-aarcange@redhat.com>
	<1412153797-6667-3-git-send-email-aarcange@redhat.com>
	<20141001155159.GA7019@google.com>
Date: Wed, 1 Oct 2014 10:06:27 -0700
Message-ID: <CAJu=L58vaT7BXfR+RHZ397zJJYL9KwozN0qzCQRadm-=wVYcUw@mail.gmail.com>
Subject: Re: [PATCH 2/4] mm: gup: add get_user_pages_locked and get_user_pages_unlocked
From: Andres Lagar-Cavilla <andreslc@google.com>
To: Peter Feiner <pfeiner@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Gleb Natapov <gleb@kernel.org>, Radim Krcmar <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>, Jianyu Zhan <nasa4836@gmail.com>,
        Paul Cassella <cassella@cray.com>, Hugh Dickins <hughd@google.com>,
        "\\Dr. David Alan Gilbert\\" <dgilbert@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 1, 2014 at 8:51 AM, Peter Feiner <pfeiner@google.com> wrote:
> On Wed, Oct 01, 2014 at 10:56:35AM +0200, Andrea Arcangeli wrote:
>> +static inline long __get_user_pages_locked(struct task_struct *tsk,
>> +                                        struct mm_struct *mm,
>> +                                        unsigned long start,
>> +                                        unsigned long nr_pages,
>> +                                        int write, int force,
>> +                                        struct page **pages,
>> +                                        struct vm_area_struct **vmas,
>> +                                        int *locked,
>> +                                        bool notify_drop)
>> +{
>> +     int flags = FOLL_TOUCH;
>> +     long ret, pages_done;
>> +     bool lock_dropped;
>> +
>> +     if (locked) {
>> +             /* if VM_FAULT_RETRY can be returned, vmas become invalid */
>> +             BUG_ON(vmas);
>> +             /* check caller initialized locked */
>> +             BUG_ON(*locked != 1);
>> +     }
>> +
>> +     if (pages)
>> +             flags |= FOLL_GET;
>> +     if (write)
>> +             flags |= FOLL_WRITE;
>> +     if (force)
>> +             flags |= FOLL_FORCE;
>> +
>> +     pages_done = 0;
>> +     lock_dropped = false;
>> +     for (;;) {
>> +             ret = __get_user_pages(tsk, mm, start, nr_pages, flags, pages,
>> +                                    vmas, locked);
>> +             if (!locked)
>> +                     /* VM_FAULT_RETRY couldn't trigger, bypass */
>> +                     return ret;
>> +
>> +             /* VM_FAULT_RETRY cannot return errors */
>> +             if (!*locked) {
>> +                     BUG_ON(ret < 0);
>> +                     BUG_ON(nr_pages == 1 && ret);
>
> If I understand correctly, this second BUG_ON is asserting that when
> __get_user_pages is asked for a single page and it is successfully gets the
> page, then it shouldn't have dropped the mmap_sem. If that's the case, then
> you could generalize this assertion to
>
>                         BUG_ON(nr_pages == ret);

Even more strict:
     BUG_ON(ret >= nr_pages);

Reviewed-by: Andres Lagar-Cavilla <andreslc@google.com>

>
> Otherwise, looks good!
>
> Peter



-- 
Andres Lagar-Cavilla | Google Kernel Team | andreslc@google.com
