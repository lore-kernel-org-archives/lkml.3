Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762709Ab3IEBIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 21:08:11 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:61880 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab3IEBIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 21:08:09 -0400
MIME-Version: 1.0
In-Reply-To: <20130903121046.GE22899@redhat.com>
References: <20130903121046.GE22899@redhat.com>
Date: Wed, 4 Sep 2013 18:08:08 -0700
X-Google-Sender-Auth: U9WveM8J_VJzzeY9mmF9dqp9QDo
Message-ID: <CA+55aFwYvhLS8onJphR0PnL5e0zyS1ki65O_fSC05TeVSw0hDg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM changes for 3.12
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Gleb Natapov <gleb@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 3, 2013 at 5:10 AM, Gleb Natapov <gleb@redhat.com> wrote:
>
> This pull request adds tlb_gather_mmu() caller in S390 code, but 2b047252
> in your tree added another parameter to the function, so the patch bellow
> have to be applied during merge to resolve the conflicts. The patch was
> used in linux-next for awhile.

Hmm. Fine. Except:

>         /* Reallocate the page tables with pgstes */
>         mm->context.has_pgste = 1;
> -       tlb_gather_mmu(&tlb, mm, 0);
> +       tlb_gather_mmu(&tlb, mm, 0, TASK_SIZE);
>         page_table_realloc(&tlb, mm, 0, TASK_SIZE);
>         tlb_finish_mmu(&tlb, 0, -1);
>         up_write(&mm->mmap_sem);

Realistically, the begin/end arguments to tlb_gather_mmu() and
tlb_finish_mmu() should match. In fact, I considered getting rid of
the ones to tlb_finish_mmu() because they are kind of pointless these
days (but didn't, because I wanted to keep the patches minimal).

And in your case they don't. Which implies a certain amount of confusion.

It looks like it's not really a full-mm invalidate (it's not the final
TLB flush before getting rid of the VM), so I think "0, TASK_SIZE" is
correct. I just think I'm going to also change that tlb_finish_mmu()
to have the same "0, TASK_SIZE" range, so that it's all consistent.

It appears that s390 doesn't actually care about the range to
tlb_finish_mmu(), so this is pretty academic, but I thought I'd
mention it so that it doesn't come as a surprise that my merge
resolution looks different from your suggested one.

              Linus
