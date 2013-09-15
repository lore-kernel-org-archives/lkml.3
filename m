Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186Ab3IOQpf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 12:45:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757124Ab3IOQpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 12:45:34 -0400
Date: Sun, 15 Sep 2013 18:39:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: security@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kthread: Make kthread_create() killable.
Message-ID: <20130915163919.GC13344@redhat.com>
References: <201309132318.HEC05218.OtVOFOFMLJHFQS@I-love.SAKURA.ne.jp> <20130914160515.GA8627@redhat.com> <201309150846.HED51521.tJOFOMVFSOHQFL@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201309150846.HED51521.tJOFOMVFSOHQFL@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15, Tetsuo Handa wrote:
>
> Oleg Nesterov wrote:
> > I am wondering if this can be simplified...
> >
> > At least you can move create->done from kthread_create_info to the
> > stack, and turn create->owner into the pointer to that completion.
>
> Use of DECLARE_COMPLETION_ONSTACK() looks harmful to me because current thread
> needs to be able to terminate as soon as possible if SIGKILLed

Sure.

> If we move something from kmalloc()ed zone to stack,
> current thread cannot be terminated until that something is guaranteed to no
> longer be used.

Please look at call_usermodehelper_exec() which does this trick. The
logic is the same, just you need to xchg(create->completion) instead
of create->owner.

In any case "void *owner" looks strange. It is in fact boolean (in
your patch). You can even use, say, test_and_set_bit() instead of
xchg.

Oleg.

