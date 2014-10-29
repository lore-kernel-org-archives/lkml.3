Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796AbaJ2SaA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 14:30:00 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:42916 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323AbaJ2S34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 14:29:56 -0400
Message-ID: <1414607389.5330.67.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [GIT PULL] Fix for Integrity subsystem null pointer deref
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "security@kernel.org" <security@kernel.org>,
        James Morris <jmorris@namei.org>
Date: Wed, 29 Oct 2014 14:29:49 -0400
In-Reply-To: <CALCETrWpHXp=7u2777ANJjxQ5rRqmutnEwf76dLX2s_LXf87pQ@mail.gmail.com>
References: <alpine.LRH.2.11.1410291450290.28213@namei.org>
	 <CALCETrUskFJY6hd9OCN_N1645VZ6zfwbGAuSEJNt6F_FPUi3gg@mail.gmail.com>
	 <1414587599.5330.50.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <CALCETrWpHXp=7u2777ANJjxQ5rRqmutnEwf76dLX2s_LXf87pQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102918-0009-0000-0000-000005F1CC7D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-29 at 09:23 -0700, Andy Lutomirski wrote: 
> On Oct 29, 2014 6:00 AM, "Mimi Zohar" <zohar@linux.vnet.ibm.com> wrote:
> >
> > On Tue, 2014-10-28 at 22:08 -0700, Andy Lutomirski wrote:
> > > On Tue, Oct 28, 2014 at 8:55 PM, James Morris <jmorris@namei.org> wrote:
> > > > These changes fix a bug in xattr handling, where the evm and ima
> > > > inode_setxattr() functions do not check for empty xattrs being passed from
> > > > userspace (leading to user-triggerable null pointer dereferences).
> > > >
> > > > Please pull.
> > > >
> > > >
> > > > The following changes since commit 9f76628da20f96a179ca62b504886f99ecc29223:
> > > >
> > > >   Merge branch 'for-3.18' of git://linux-nfs.org/~bfields/linux (2014-10-28 13:32:06 -0700)
> > > >
> > > > are available in the git repository at:
> > > >
> > > >   git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus
> > > >
> > > > Dmitry Kasatkin (2):
> > > >       ima: check xattr value length and type in the ima_inode_setxattr()
> > >
> > > I haven't read this one, but:
> > >
> > > >       evm: check xattr value length and type in evm_inode_setxattr()
> > >
> > > const struct evm_ima_xattr_data *xattr_data = xattr_value;
> > > - if ((strcmp(xattr_name, XATTR_NAME_EVM) == 0)
> > > - && (xattr_data->type == EVM_XATTR_HMAC))
> > > - return -EPERM;
> > > + if (strcmp(xattr_name, XATTR_NAME_EVM) == 0) {
> > > + if (!xattr_value_len)
> > > + return -EINVAL;
> > > + if (xattr_data->type != EVM_IMA_XATTR_DIGSIG)
> > > + return -EPERM;
> > > + }
> > >
> > > Huh?  (Sorry about severe whitespace damage.)
> > >
> > > Shouldn't there be something like if (xattr_value_len < sizeof(struct
> > > evm_ima_xattr_data)) return -EINVAL?
> >
> > Prior to commit 2fb1c9a "evm: prohibit userspace writing 'security.evm'
> > HMAC value", a process with CAP_SYS_ADMIN could write either an HMAC or
> > signature. As the HMAC key should only be known to the kernel, only
> > signatures are now allowed.  Instead of "struct evm_ima_xattr_data", the
> > code should reflect this change and use "struct signature_v2_hdr".
> > We'll clean up this code for the next release.  For now, this patch
> > prevents the oops.
> >
> 
> I have no idea what the semantics are.  All I'm saying is that it
> looks like the code still accesses memory past the end of the buffer.
> The buffer isn't a null pointer, so the symptom is different, but it
> may still be a security bug.

There's no accessing of data here, just writing the data out as an
extended attribute, which requires CAP_SYS_ADMIN privilege.

Mimi

