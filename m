Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab3J2Tdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 15:33:40 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:55089 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab3J2Tdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 15:33:38 -0400
MIME-Version: 1.0
In-Reply-To: <52700C24.9050001@linux.vnet.ibm.com>
References: <1383059634-55512-1-git-send-email-tim.gardner@canonical.com>
	<CA+55aFwUdXp4412F5LdmCRrGZCYiFpiPk7oksGi30CzP6i5O+w@mail.gmail.com>
	<52700C24.9050001@linux.vnet.ibm.com>
Date: Tue, 29 Oct 2013 12:33:37 -0700
X-Google-Sender-Auth: bW5tK7ouzeNdEiuE4lx8jSaQ_hU
Message-ID: <CA+55aFzqumDX8hRyC4avbpA2g_RRb28ZPYk=_-4atGJ=67Zu1A@mail.gmail.com>
Subject: Re: [PATCH 3.12-rc7] KVM: Fix modprobe failure for kvm_intel/kvm_amd
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Tim Gardner <tim.gardner@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Gleb Natapov <gleb@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM list <kvm@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 12:27 PM, Raghavendra K T
<raghavendra.kt@linux.vnet.ibm.com> wrote:
>
> Could one solution be cascading actual error
> that is lost in fs/debugfs/inode.c:__create_file(), so that we could
> take correct action in case of failure of debugfs_create_dir()?
>
> (ugly side is we increase total number of params for __create_file to
> 6). or I hope there could be some better solution.

The solution to this would be to simply return an error-pointer. See
<linux/err.h>. That's what we do for most complex subsystems that
return a pointer to a struct: rather than returning "NULL" as an
error, return the actual error number encoded in the pointer itself.

But that would require every user of debugfs_create_dir() to be
updated to check errors using IS_ERR() instead of checking against
NULL, and there's quite a few of them.

So I think just making the error be EEXIST is a simpler solution right now.

              Linus
