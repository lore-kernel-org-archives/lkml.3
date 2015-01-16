Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbbAPCae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 21:30:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35172 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900AbbAPCad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 21:30:33 -0500
Message-ID: <54B877BC.3070905@redhat.com>
Date: Thu, 15 Jan 2015 21:30:20 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Suresh Siddha <sbsiddha@gmail.com>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        matt.fleming@intel.com, bp@suse.de, pbonzini@redhat.com,
        tglx@linutronix.de, luto@amacapital.net
Subject: Re: [PATCH 3/3] x86, fpu: fix math_state_restore() race with kernel_fpu_begin()
References: <1421012793-30106-1-git-send-email-riel@redhat.com> <20150115191918.GA27332@redhat.com> <20150115192028.GD27332@redhat.com>
In-Reply-To: <20150115192028.GD27332@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 01/15/2015 02:20 PM, Oleg Nesterov wrote:
> math_state_restore() can race with kernel_fpu_begin() if irq comes 
> right after __thread_fpu_begin(), __save_init_fpu() will overwrite 
> fpu->state we are going to restore.
> 
> Add 2 simple helpers, kernel_fpu_disable() and kernel_fpu_enable() 
> which simply set/clear in_kernel_fpu, and change
> math_state_restore() to exclude kernel_fpu_begin() in between.
> 
> Alternatively we could use local_irq_save/restore, but probably
> these new helpers can have more users.
> 
> Perhaps they should disable/enable preemption themselves, in this
> case we can remove preempt_disable() in __restore_xstate_sig().

Given that math_state_restore does an implicit preempt_disable
through local_irq_disable, I am not sure whether adding an
explicit preempt_disable would be good or bad.

It's not like the additional locking rule makes this code any
more complex.

> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUuHe8AAoJEM553pKExN6Ds4kH/2dIkmOlhUNF7npjpvRNy6As
a7/QVBJOvo2IOD5My4An2f/pdfNiJyC4dwIN8tM3JngA2LM57VFR5TzaODByq9TI
xxPKCm+SY6M3apCBx7CWyTEloEXYLjvxnVvNkbfkOhArrqJzJLGqDiV5nkMi13fs
96ibGr04vIYRJ6VJNOfmCq1psAO31Yy6ZKfAADbkiOn7VmZ/qZykyjylfeidNiyj
PTSAx9htvb39N2EMjYRnqhypZ90LMCffYg7YMT4Wdc9+BorMz3oiwzZZSjI/WcBS
Dr2rH80KNMQvSg2iYAtuWZB7BY4cnvhRqoFHqJsFQNzgVAksC0LYE+66bvQO0JQ=
=nxZE
-----END PGP SIGNATURE-----
