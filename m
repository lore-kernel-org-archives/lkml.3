Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab3LQBe6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 20:34:58 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:48254 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab3LQBe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 20:34:57 -0500
MIME-Version: 1.0
In-Reply-To: <52AFA766.9070804@linaro.org>
References: <1387229564-19517-1-git-send-email-john.stultz@linaro.org>
	<1387229564-19517-4-git-send-email-john.stultz@linaro.org>
	<CAMbhsRQOWKWBjQJWndr57Cz_Xf0EeU8jNMJOyiOEBHFRf=Tt=Q@mail.gmail.com>
	<52AFA766.9070804@linaro.org>
Date: Mon, 16 Dec 2013 17:34:56 -0800
X-Google-Sender-Auth: TTn5lfWb57tWRHQLQfHEZ_l_A24
Message-ID: <CAMbhsRSeUL3KhrcMZ+e9LBakqs1Z=dNDUODXmNYhOnanAv_=SQ@mail.gmail.com>
Subject: Re: [RFC][PATCH 3/3] staging: ion: Avoid using rt_mutexes directly.
From: Colin Cross <ccross@android.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 5:22 PM, John Stultz <john.stultz@linaro.org> wrote:
> On 12/16/2013 04:17 PM, Colin Cross wrote:
>> The lock is only used to protect the heap's free_list and
>> free_list_size members, and is not held for any long or sleeping
>> operations.  Converting to a spinlock should prevent priority
>> inversion without using the rt_mutex.  I'd also rename it to free_lock
>> to so it doesn't get used as a general heap lock.
>
> Hrm.. So at least a trivial conversion to use spinlocks doesn't quite
> work out, as we call ion_buffer_destroy() in ion_heap_freelist_drain()
> while holding the lock, and that calls all sorts of not safe stuff.
>
> I'll spend some more time looking at it later tonight, but let me know
> if you have an approach for this case in mind.

Drop and re-grab the lock around ion_buffer_destroy, it's not
necessary during the destroy, and the list iteration is already using
list_for_each_entry_safe, so it doesn't matter if another caller
modifies the list during the destroy.
