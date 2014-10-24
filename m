Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434AbaJXQFD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 12:05:03 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:43020 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755887AbaJXQFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 12:05:01 -0400
Message-ID: <1414166455.2120.53.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH v2 1/2] ima: check xattr value length in
 ima_inode_setxattr()
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: linux-security-module@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        jack@suse.cz, jmorris@namei.org, dmitry.kasatkin@gmail.com
Date: Fri, 24 Oct 2014 12:00:55 -0400
In-Reply-To: <544A6B66.6060009@samsung.com>
References: <cover.1414134113.git.d.kasatkin@samsung.com>
	 <53afed717c1dc6b3588cca7c0a6b69650edc2ad2.1414134113.git.d.kasatkin@samsung.com>
	 <1414160329.2120.30.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <544A699B.5080806@samsung.com> <544A6B66.6060009@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102416-0029-0000-0000-000000E12E7D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-24 at 18:08 +0300, Dmitry Kasatkin wrote: 
> On 24/10/14 18:00, Dmitry Kasatkin wrote:
> > On 24/10/14 17:18, Mimi Zohar wrote:
> >> On Fri, 2014-10-24 at 10:07 +0300, Dmitry Kasatkin wrote: 
> >>> ima_inode_setxattr() can be called with no value. Function does not
> >>> check the length so that following command can be used to produce
> >>> kernel oops: setfattr -n security.ima FOO. This patch fixes it.
> >>>
> >>> Changes in v2:
> >>> * testing validity of xattr type
> >>> * allow setting hash only in fix or log mode (Mimi)
> >> I only mentioned "fix" mode, not "log" mode (explanation below).
> >>
> > We need it in log mode as well (explanation bellow)
> >>> [  261.562522] BUG: unable to handle kernel NULL pointer dereference at           (null)
> >>> [  261.564109] IP: [<ffffffff812af272>] ima_inode_setxattr+0x3e/0x5a
> >>> [  261.564109] PGD 3112f067 PUD 42965067 PMD 0
> >>> [  261.564109] Oops: 0000 [#1] SMP
> >>> [  261.564109] Modules linked in: bridge stp llc evdev serio_raw i2c_piix4 button fuse
> >>> [  261.564109] CPU: 0 PID: 3299 Comm: setxattr Not tainted 3.16.0-kds+ #2924
> >>> [  261.564109] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> >>> [  261.564109] task: ffff8800428c2430 ti: ffff880042be0000 task.ti: ffff880042be0000
> >>> [  261.564109] RIP: 0010:[<ffffffff812af272>]  [<ffffffff812af272>] ima_inode_setxattr+0x3e/0x5a
> >>> [  261.564109] RSP: 0018:ffff880042be3d50  EFLAGS: 00010246
> >>> [  261.564109] RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000000000015
> >>> [  261.564109] RDX: 0000001500000000 RSI: 0000000000000000 RDI: ffff8800375cc600
> >>> [  261.564109] RBP: ffff880042be3d68 R08: 0000000000000000 R09: 00000000004d6256
> >>> [  261.564109] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88002149ba00
> >>> [  261.564109] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> >>> [  261.564109] FS:  00007f6c1e219740(0000) GS:ffff88005da00000(0000) knlGS:0000000000000000
> >>> [  261.564109] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >>> [  261.564109] CR2: 0000000000000000 CR3: 000000003b35a000 CR4: 00000000000006f0
> >>> [  261.564109] Stack:
> >>> [  261.564109]  ffff88002149ba00 ffff880042be3df8 0000000000000000 ffff880042be3d98
> >>> [  261.564109]  ffffffff812a101b ffff88002149ba00 ffff880042be3df8 0000000000000000
> >>> [  261.564109]  0000000000000000 ffff880042be3de0 ffffffff8116d08a ffff880042be3dc8
> >>> [  261.564109] Call Trace:
> >>> [  261.564109]  [<ffffffff812a101b>] security_inode_setxattr+0x48/0x6a
> >>> [  261.564109]  [<ffffffff8116d08a>] vfs_setxattr+0x6b/0x9f
> >>> [  261.564109]  [<ffffffff8116d1e0>] setxattr+0x122/0x16c
> >>> [  261.564109]  [<ffffffff811687e8>] ? mnt_want_write+0x21/0x45
> >>> [  261.564109]  [<ffffffff8114d011>] ? __sb_start_write+0x10f/0x143
> >>> [  261.564109]  [<ffffffff811687e8>] ? mnt_want_write+0x21/0x45
> >>> [  261.564109]  [<ffffffff811687c0>] ? __mnt_want_write+0x48/0x4f
> >>> [  261.564109]  [<ffffffff8116d3e6>] SyS_setxattr+0x6e/0xb0
> >>> [  261.564109]  [<ffffffff81529da9>] system_call_fastpath+0x16/0x1b
> >>> [  261.564109] Code: 48 89 f7 48 c7 c6 58 36 81 81 53 31 db e8 73 27 04 00 85 c0 75 28 bf 15 00 00 00 e8 8a a5 d9 ff 84 c0 75 05 83 cb ff eb 15 31 f6 <41> 80 7d 00 03 49 8b 7c 24 68 40 0f 94 c6 e8 e1 f9 ff ff 89 d8
> >>> [  261.564109] RIP  [<ffffffff812af272>] ima_inode_setxattr+0x3e/0x5a
> >>> [  261.564109]  RSP <ffff880042be3d50>
> >>> [  261.564109] CR2: 0000000000000000
> >>> [  261.599998] ---[ end trace 39a89a3fc267e652 ]---
> >>>
> >>> Reported-by: Jan Kara <jack@suse.cz>
> >>> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> >>> ---
> >>>  security/integrity/ima/ima_appraise.c | 13 +++++++++++--
> >>>  1 file changed, 11 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
> >>> index 9226854..e302cbf 100644
> >>> --- a/security/integrity/ima/ima_appraise.c
> >>> +++ b/security/integrity/ima/ima_appraise.c
> >>> @@ -378,8 +378,17 @@ int ima_inode_setxattr(struct dentry *dentry, const char *xattr_name,
> >>>  	result = ima_protect_xattr(dentry, xattr_name, xattr_value,
> >>>  				   xattr_value_len);
> >>>  	if (result == 1) {
> >>> -		ima_reset_appraise_flags(dentry->d_inode,
> >>> -			 (xvalue->type == EVM_IMA_XATTR_DIGSIG) ? 1 : 0);
> >>> +		bool digsig;
> >>> +
> >>> +		if (!xattr_value_len ||
> >>> +		    (xvalue->type != IMA_XATTR_DIGEST &&
> >>> +		     xvalue->type != IMA_XATTR_DIGEST_NG &&
> >>> +		     xvalue->type != EVM_IMA_XATTR_DIGSIG))
> >> "xvalue->type" is an enumerated type.  Testing each possible value seems
> >> kind of a brittle method for vetting the value.  I suggest testing the
> >> existing last value or, better yet, define a last value, so if someone
> >> adds or changes the order, nothing breaks.
> > I was considering to define _LAST value, but we have EVM_XATTR_HMAC in
> > the middle...
> > In fact I was expecting to get some feedback about it, because in
> > reality it is just a sanity check.
> > It does not prevent DoS because it is possible to set correctly
> > formatted but wrong value and force DoS.

This patch prevents the oops and hash values from being written.
Verifying the signature would require access to the public key, which
isn't necessarily loaded on the keyring.  For now, I think this is fine.
Future patches, as described in Dave's LSS 2014 talk, will address this
issue.
http://kernsec.org/wiki/index.php/Linux_Security_Summit_2014/Abstracts/Safford 

> 
> Forgot to ask. If possibility to set HMAC type is fine with you I can
> define _LAST..

Setting anything other than a digital signature is prevented by this
patch, except in "fix" or "log" mode.  That should be fine.

> 
> Thanks.
> 
> >>> +			return -EINVAL;
> >>> +		digsig = (xvalue->type == EVM_IMA_XATTR_DIGSIG);
> >>> +		if (!digsig && (ima_appraise & IMA_APPRAISE_ENFORCE))
> >>> +			return -EPERM;
> >> According to the new ima_appraise "log" mode, commit "2faa6ef ima:
> >> provide 'ima_appraise=log' kernel option", "log" mode permits normal
> >> execution without "fixing" anything.  Normal execution, here, prevents
> >> writing the extended attribute.
> > 'log' mode is also special mode for system developing and debugging.
> > It is beneficial to be able to 'label' target object with correct value...

Ok.  After re-reading the patch description, "without fixing it" refers
to fixing existing labels, as opposed to directly labeling the
filesystem.

Mimi

