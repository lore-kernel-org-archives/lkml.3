Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920Ab3IJSZr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 14:25:47 -0400
Received: from mail-vb0-f49.google.com ([209.85.212.49]:37373 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab3IJSZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 14:25:45 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFympAk-hnekaew8po5wLJdiY+DC_b4h=pa-y5i9=s303Q@mail.gmail.com>
References: <CA+5PVA4k9tTPs9vtTbMuG7pzw4kb3KFK-CLaqDDG4dm=0twyCQ@mail.gmail.com>
	<CA+55aFzg_r2c09TkGwmsMV3HbNAkSFJLGAFWweLNzofqs4o4Ug@mail.gmail.com>
	<CA+5PVA6EDV3zuDEyCvcGNvEAPtgY_Oy9xVbaM03ggRBPtq5Mmg@mail.gmail.com>
	<CA+55aFympAk-hnekaew8po5wLJdiY+DC_b4h=pa-y5i9=s303Q@mail.gmail.com>
Date: Tue, 10 Sep 2013 11:25:44 -0700
X-Google-Sender-Auth: uBAyLu0c6m_gHKH7S9mgUVLU2jI
Message-ID: <CA+55aFygRtwwknO4Jb+nna046VhdNCXh2S0ybRBPf=b1GH9FPg@mail.gmail.com>
Subject: Re: kernel BUG at fs/dcache.c:648! with v3.11-7890-ge5c832d
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Waiman Long <Waiman.Long@hp.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        moneta.mace@gmail.com
Content-Type: multipart/mixed; boundary=001a11c1e98011673e04e60ba2f3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c1e98011673e04e60ba2f3
Content-Type: text/plain; charset=UTF-8

On Tue, Sep 10, 2013 at 10:47 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> But yes, e5c832d is obviously the "fixed" kernel. Let me think about this.

Ok, I think I found it.

I missed that "terminate_walk()" for the RCU case does this:

                nd->flags &= ~LOOKUP_RCU;
                if (!(nd->flags & LOOKUP_ROOT))
                        nd->root.mnt = NULL;
                unlock_rcu_walk();

and my unlazy_walk() essentially terminated the walk _without_
clearing that nd->root.mnt thing (it did clear the LOOKUP_RCU bit and
unlock_rcy_walk(). So then later, we'd end up doing an extra
path_put(). Explaining a zero d_lockref.count.

The whole damn root.mnt behavior with !LOOKUP_ROOT is a mystery and
needs more comments. But the attached trivial patch should do the
missing portion of terminate_walk().

Al, can you walk us through the rules for what "root.mnt == NULL"
really means? It's basically used as a flag for whether we've gotten
the root pointer or not. But it's pretty damn esoteric.

Now I'm starting to wonder how come _I_ never saw any issues. Maybe it
ends up underflowing so quickly that most people just see a big
negative number..

Patch is entirely untested. Not that my testing apparently has been much good.

Moneta, are you comfortable compiling a test-kernel, or does this need
to become a rawhide package?

              Linus

--001a11c1e98011673e04e60ba2f3
Content-Type: application/octet-stream; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hlfg5pd50

IGZzL25hbWVpLmMgfCA1ICsrKystCiAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCAx
IGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZnMvbmFtZWkuYyBiL2ZzL25hbWVpLmMKaW5kZXgg
NTZlNGY0ZDUzN2QwLi41ZTZhYWFkYzFkY2QgMTAwNjQ0Ci0tLSBhL2ZzL25hbWVpLmMKKysrIGIv
ZnMvbmFtZWkuYwpAQCAtNTc0LDkgKzU3NCwxMiBAQCB1bmxvY2tfYW5kX2Ryb3BfZGVudHJ5Ogog
ZHJvcF9kZW50cnk6CiAJdW5sb2NrX3JjdV93YWxrKCk7CiAJZHB1dChkZW50cnkpOwotCXJldHVy
biAtRUNISUxEOworCWdvdG8gZHJvcF9yb290X21udDsKIG91dDoKIAl1bmxvY2tfcmN1X3dhbGso
KTsKK2Ryb3Bfcm9vdF9tbnQ6CisJaWYgKCEobmQtPmZsYWdzICYgTE9PS1VQX1JPT1QpKQorCQlu
ZC0+cm9vdC5tbnQgPSBOVUxMOwogCXJldHVybiAtRUNISUxEOwogfQogCg==
--001a11c1e98011673e04e60ba2f3--
