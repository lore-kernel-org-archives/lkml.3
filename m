Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab3AaL54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 06:57:56 -0500
Received: from mail-ve0-f170.google.com ([209.85.128.170]:35867 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab3AaL5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 06:57:54 -0500
MIME-Version: 1.0
In-Reply-To: <1359537244-20588-1-git-send-email-yuanhan.liu@linux.intel.com>
References: <1359537244-20588-1-git-send-email-yuanhan.liu@linux.intel.com>
Date: Thu, 31 Jan 2013 03:57:51 -0800
Message-ID: <CANN689GwGh2sHwoP66JjoXs2ZMQAXbVpA0MHQahWq5M+baNfSQ@mail.gmail.com>
Subject: Re: [PATCH] rwsem-spinlock: let rwsem write lock stealable
From: Michel Lespinasse <walken@google.com>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 1:14 AM, Yuanhan Liu
<yuanhan.liu@linux.intel.com> wrote:
> We(Linux Kernel Performance project) found a regression introduced by
> commit 5a50508, which just convert all mutex lock to rwsem write lock.
> The semantics is same, but the results is quite huge in some cases.
> After investigation, we found the root cause: mutex support lock
> stealing. Here is the link for the detailed regression report:
>     https://lkml.org/lkml/2013/1/29/84
>
> Ingo suggests to add write lock stealing to rwsem as well:
>     "I think we should allow lock-steal between rwsem writers - that
>      will not hurt fairness as most rwsem fairness concerns relate to
>      reader vs. writer fairness"
>
> I then tried it with rwsem-spinlock first as I found it much easier to
> implement it than lib/rwsem.c. And here I sent out this patch first for
> comments. I'd try lib/rwsem.c later once the change to rwsem-spinlock
> is OK to you guys.

I noticed that you haven't modified __down_write_trylock() - for
consistency with __down_write() you should replace
        if (sem->activity == 0 && list_empty(&sem->wait_list)) {
with
        if (sem->activity == 0) {

Other than that, I like the idea. I was originally uncomfortable with
doing lock stealing for the rwsem, but I think doing it for writers
only as you propose should be fine. Readers wait for any queued
writers, and in exchange they are guaranteed to get the lock once
they've blocked. You *still* want to check for regressions that this
change might cause - not with anon_vma as this was a mutex not long
ago, but possibly with mmap_sem - but I'm crossing my fingers and
thinking that it'll most likely turn out fine.

I may be able to help with the non-spinlock version of this as I still
remember how this works.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
