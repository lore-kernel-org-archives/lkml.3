Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab3DOVx2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 17:53:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47262 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787Ab3DOVx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 17:53:26 -0400
Date: Mon, 15 Apr 2013 14:53:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthieu CASTET <matthieu.castet@parrot.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] binfmt_elf: fix return value in case of interpreter
 load failure
Message-Id: <20130415145324.d63be917d438b3f4ec37f845@linux-foundation.org>
In-Reply-To: <51681F0E.1040900@parrot.com>
References: <1365688389-29908-1-git-send-email-matthieu.castet@parrot.com>
	<20130411150401.8bf008e05f5dd2239277e2c1@linux-foundation.org>
	<51681F0E.1040900@parrot.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Apr 2013 16:49:50 +0200 Matthieu CASTET <matthieu.castet@parrot.com> wrote:

> Hi Andrew,
> 
> thanks for your quick review.
> 
> Andrew Morton a __crit :
> > On Thu, 11 Apr 2013 15:53:09 +0200 Matthieu CASTET <matthieu.castet@parrot.com> wrote:
> > 
> >> The current code return the address instead of using PTR_ERR.
> > 
> > I don't understand what you mean here - please describe this error in
> > much more detail.  Help people to identify the section of code which
> > is being discussed.
> 
> I was speaking of
> 
> 
>  elf_entry = load_elf_interp(&loc->interp_elf_ex,
>                         interpreter,
>                         &interp_map_addr,
>                         load_bias);
> [...]
>         if (BAD_ADDR(elf_entry)) {
>             force_sig(SIGSEGV, current);
>             retval = IS_ERR((void *)elf_entry) ?
>                     (int)elf_entry : -EINVAL;
>             goto out_free_dentry;
>         }
> 
> and was expecting we should use PTR_ERR when IS_ERR is true to match what is
> done in [1].
> 
> But didn't saw that PTR_ERR((void *)elf_entry) and (int)elf_entry are equivalent.
> 
> > 
> >> Also the check is done after adding e_entry. This can cause weird behaviour
> >> because -errno + loc->interp_elf_ex.e_entry can produce a valid address.
> > 
> > Which check?
> 
> I am really confused here. Reading again the code this can't happen because if
> load_elf_interp return -errno
> 
> 
> We don't enter this condition
> >         if (!IS_ERR((void *)elf_entry)) {
> >             /*
> >              * load_elf_interp() returns relocation
> >              * adjustment
> >              */
> >             interp_load_addr = elf_entry;
> >             elf_entry += loc->interp_elf_ex.e_entry;
> >         }
> we still have -errno here
> >         if (BAD_ADDR(elf_entry)) {
> >             force_sig(SIGSEGV, current);
> >             retval = IS_ERR((void *)elf_entry) ?
> >                     (int)elf_entry : -EINVAL;
> >             goto out_free_dentry;
> >         }
> 
> 
> Sorry for my mistake.
> 
> The only valid remaining part of my patch is to return SIGKILL when
> load_elf_interp fail (IS_ERR((void *)elf_entry) is true) (for example load
> address of linker is bad) instead of SIGSEGV. This will follow what is done when
> loading binary.
> 
> But is it even worth doing?

SIGSEGV can be caught so that would be a user-visible change.  I just
don't know what the implications of such a change would be :(

(hopefully cc's Oleg)
