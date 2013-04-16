Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964975Ab3DPO2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 10:28:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933715Ab3DPO2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 10:28:40 -0400
Date: Tue, 16 Apr 2013 16:25:56 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthieu CASTET <matthieu.castet@parrot.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] binfmt_elf: fix return value in case of interpreter
	load failure
Message-ID: <20130416142556.GA11333@redhat.com>
References: <1365688389-29908-1-git-send-email-matthieu.castet@parrot.com> <20130411150401.8bf008e05f5dd2239277e2c1@linux-foundation.org> <51681F0E.1040900@parrot.com> <20130415145324.d63be917d438b3f4ec37f845@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130415145324.d63be917d438b3f4ec37f845@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15, Andrew Morton wrote:
>
> On Fri, 12 Apr 2013 16:49:50 +0200 Matthieu CASTET <matthieu.castet@parrot.com> wrote:
>
> > The only valid remaining part of my patch is to return SIGKILL when
> > load_elf_interp fail (IS_ERR((void *)elf_entry) is true) (for example load
> > address of linker is bad) instead of SIGSEGV. This will follow what is done when
> > loading binary.
> >
> > But is it even worth doing?
>
> SIGSEGV can be caught

Actually it can't be, flush_signal_handlers() was already called.
SIGSEGV can be blocked/ignored after that, but please note that
force_sig_info(SIGSEGV) will unblock and set SIG_DFL if necessary.

In short, force_sig() will actuallu kill the task in any case.

But: afaics send_sig(SIGSEGV) above load_elf_interp() is wrong,
we should either use SIGKILL (which can't be ignored/blocked) or
force_sig.

> that would be a user-visible change.

Yes. waitpid(&status) can notice the difference.

> I just
> don't know what the implications of such a change would be :(

Mee too... Looks harmless but still.

OTOH, I do not know why/when we should use SIGKILL or SIGSEGV in
this code.

Oleg.

