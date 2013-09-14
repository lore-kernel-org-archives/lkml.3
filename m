Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459Ab3INXqd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 19:46:33 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:53605 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756895Ab3INXqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 19:46:19 -0400
X-Nat-Received: from [202.181.97.72]:55251 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1379202372.3491
To: oleg@redhat.com
Cc: security@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kthread: Make kthread_create() killable.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201309132318.HEC05218.OtVOFOFMLJHFQS@I-love.SAKURA.ne.jp>
	<20130914160515.GA8627@redhat.com>
In-Reply-To: <20130914160515.GA8627@redhat.com>
Message-Id: <201309150846.HED51521.tJOFOMVFSOHQFL@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 15 Sep 2013 08:46:10 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 14092013 #11055784, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> I am wondering if this can be simplified...
> 
> At least you can move create->done from kthread_create_info to the
> stack, and turn create->owner into the pointer to that completion.

Use of DECLARE_COMPLETION_ONSTACK() looks harmful to me because current thread
needs to be able to terminate as soon as possible if SIGKILLed (especially when
SIGKILLed by OOM killer). If we move something from kmalloc()ed zone to stack,
current thread cannot be terminated until that something is guaranteed to no
longer be used.

I think we need to convert from on-stack objects to kmalloc()ed objects so that
current thread acquires ability to terminate as soon as possible.
