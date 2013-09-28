Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab3I1Tny (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 15:43:54 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:36790 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab3I1Tnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 15:43:52 -0400
MIME-Version: 1.0
In-Reply-To: <20130928193739.GA8642@gmail.com>
References: <1380308424-31011-1-git-send-email-Waiman.Long@hp.com>
	<CA+55aFxXeQ69B1bfrO+0QtBqm0gt688LOshx=ppNjch10JF8FQ@mail.gmail.com>
	<20130928074144.GA17773@gmail.com>
	<CA+55aFyx-Lpqd8i2tHvhXCqL+nJZPq-6SikEkb-cQZEU9ogRjA@mail.gmail.com>
	<20130928192123.GA8228@gmail.com>
	<20130928193739.GA8642@gmail.com>
Date: Sat, 28 Sep 2013 12:43:51 -0700
X-Google-Sender-Auth: vYBFGFLgCSVm-uNfAM35URziHd4
Message-ID: <CA+55aFyMXxH-PGewqxse=VJzMdHWkyN4iKMh-VgQ1X2yJFnAgw@mail.gmail.com>
Subject: Re: [PATCH] anon_vmas: Convert the rwsem to an rwlock_t
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Waiman Long <Waiman.Long@hp.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Alex Shi <alex.shi@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 28, 2013 at 12:37 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> -               down_write_nest_lock(&anon_vma->root->rwsem, &mm->mmap_sem);
> +               down_write_nest_lock(&anon_vma->root->rwlock, &mm->mmap_sem);

That's just completely bogus, and cannot work.

Maybe just a "write_lock(&anon_vma->root->rwlock)" (which is just
anon_vma_unlock_write(anon_vma)). But I think we might have a lockdep
issue. I'm not quite sure what's up with the nesting there.

> -       if (rwsem_is_locked(&anon_vma->root->rwsem)) {
> +       if (write_can_lock(&anon_vma->root->rwlock)) {
>                 anon_vma_lock_write(anon_vma);
>                 anon_vma_unlock_write(anon_vma);
>         }

That's the wrong way around. It should be

        if (!write_can_lock(&anon_vma->root->rwlock)) {

so some more testing definitely needed.

          Linus
