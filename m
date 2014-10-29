Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbaJ2FI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 01:08:28 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:40570 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbaJ2FIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 01:08:25 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.11.1410291450290.28213@namei.org>
References: <alpine.LRH.2.11.1410291450290.28213@namei.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 28 Oct 2014 22:08:03 -0700
Message-ID: <CALCETrUskFJY6hd9OCN_N1645VZ6zfwbGAuSEJNt6F_FPUi3gg@mail.gmail.com>
Subject: Re: [GIT PULL] Fix for Integrity subsystem null pointer deref
To: James Morris <jmorris@namei.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "security@kernel.org" <security@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 8:55 PM, James Morris <jmorris@namei.org> wrote:
> These changes fix a bug in xattr handling, where the evm and ima
> inode_setxattr() functions do not check for empty xattrs being passed from
> userspace (leading to user-triggerable null pointer dereferences).
>
> Please pull.
>
>
> The following changes since commit 9f76628da20f96a179ca62b504886f99ecc29223:
>
>   Merge branch 'for-3.18' of git://linux-nfs.org/~bfields/linux (2014-10-28 13:32:06 -0700)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus
>
> Dmitry Kasatkin (2):
>       ima: check xattr value length and type in the ima_inode_setxattr()

I haven't read this one, but:

>       evm: check xattr value length and type in evm_inode_setxattr()

const struct evm_ima_xattr_data *xattr_data = xattr_value;
- if ((strcmp(xattr_name, XATTR_NAME_EVM) == 0)
- && (xattr_data->type == EVM_XATTR_HMAC))
- return -EPERM;
+ if (strcmp(xattr_name, XATTR_NAME_EVM) == 0) {
+ if (!xattr_value_len)
+ return -EINVAL;
+ if (xattr_data->type != EVM_IMA_XATTR_DIGSIG)
+ return -EPERM;
+ }

Huh?  (Sorry about severe whitespace damage.)

Shouldn't there be something like if (xattr_value_len < sizeof(struct
evm_ima_xattr_data)) return -EINVAL?

--Andy

>
> James Morris (1):
>       Merge branch 'for-linus' of git://git.kernel.org/.../zohar/linux-integrity into for-linus
>
>  security/integrity/evm/evm_main.c     |    9 ++++++---
>  security/integrity/ima/ima_appraise.c |    2 ++
>  security/integrity/integrity.h        |    1 +
>  3 files changed, 9 insertions(+), 3 deletions(-)



-- 
Andy Lutomirski
AMA Capital Management, LLC
