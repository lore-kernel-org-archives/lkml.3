Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab3CVEzN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 00:55:13 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:64643 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab3CVEzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 00:55:12 -0400
MIME-Version: 1.0
In-Reply-To: <20130322043715.GL21522@ZenIV.linux.org.uk>
References: <20130321221256.GA30620@redhat.com>
	<CA+55aFx+O13YuJsZyrTS6O9Kws=1ff-knsSv9rV8wTf8yBrPJg@mail.gmail.com>
	<20130321233630.GE21522@ZenIV.linux.org.uk>
	<CA+55aFyLJ9vVm1T994EaE4tnEbV8rHj43m+cWsFFBi_qndao1A@mail.gmail.com>
	<CA+55aFyWNkOnrQ41xCAU8q5sVXdq1-u2P8n+quLY50OdiFo3Zw@mail.gmail.com>
	<20130322001257.GH21522@ZenIV.linux.org.uk>
	<CA+55aFz5Ce7h2ja0m++tENXuG-1d346VNu9N=ZKy2UfojaSf0g@mail.gmail.com>
	<20130322012208.GJ21522@ZenIV.linux.org.uk>
	<CA+55aFzPD08kJi=x8wLBi5FAjr1TqSGXWbv5KXy5Ymm0PJL0wA@mail.gmail.com>
	<20130322014037.GK21522@ZenIV.linux.org.uk>
	<20130322043715.GL21522@ZenIV.linux.org.uk>
Date: Thu, 21 Mar 2013 21:55:10 -0700
X-Google-Sender-Auth: CvhSfJ_WGiBWF2L4eHkTNB6jU9g
Message-ID: <CA+55aFzUobqDR0RSh8t18m32BdTvm4k7j2PCseXpFVCH_gR=Fw@mail.gmail.com>
Subject: Re: [CFT] Re: VFS deadlock ?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: multipart/mixed; boundary=089e01537644880e7004d87c421b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e01537644880e7004d87c421b
Content-Type: text/plain; charset=UTF-8

On Thu, Mar 21, 2013 at 9:37 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> FWIW, a relatively crude solution is this:
>
> -                       d_add(dentry, inode);
> -                       return NULL;
> +                       return d_materialise_unique(dentry, inode);
>
> It *is* crude, but it restores the assert, killing the deadlock and lets
> everything work more or less as it used to.  The case where things start
> to look odd is this:
>
> root@kvm-amd64:~# cd /proc/1/net/stat/; ls /proc/2/net/stat; /bin/pwd
> arp_cache  ndisc_cache  rt_cache
> /proc/2/net/stat
>
> IOW, if we were about to create a directory alias, the old dentry gets moved
> in new place.

Ugh, no, this is worse than the bug we're trying to fix.

However, I do wonder if we could take another approach... There's
really no reason why we should look up an old inode with iget_locked()
in proc_get_inode() and only fill it in if it is new. We might as well
just always create a new inode. The "iget_locked()" logic really comes
from the bad old days when the inode was the primary data structure,
but it's really the dentry that is the important data structure, and
the inode might as well follow the dentry, instead of the other way
around.

So why not just use "new_inode_pseudo()" instead? IOW, something like
this (totally untested, natch) patch? This way, if you have a new
dentry, you are guaranteed to always have a new inode. None of the
silly inode alias issues..

This seems too simple, but I don't see why iget_locked() would be any
better. It just wastes time hashing the inode that we aren't really
interested in hashing. The inode is always filled by the caller
anyway, so we migth as well just get a fresh pseudo-filesystem inode
without any crazy hashing..

                     Linus

--089e01537644880e7004d87c421b
Content-Type: application/octet-stream; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hekvhlfq0

IGZzL3Byb2MvaW5vZGUuYyB8IDUgKysrLS0KIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMo
KyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvcHJvYy9pbm9kZS5jIGIvZnMvcHJv
Yy9pbm9kZS5jCmluZGV4IGE4NmFlYmM5YmE3Yy4uYTIzOTUzMTdiM2JmIDEwMDY0NAotLS0gYS9m
cy9wcm9jL2lub2RlLmMKKysrIGIvZnMvcHJvYy9pbm9kZS5jCkBAIC00NDYsOSArNDQ2LDEwIEBA
IHN0YXRpYyBjb25zdCBzdHJ1Y3QgZmlsZV9vcGVyYXRpb25zIHByb2NfcmVnX2ZpbGVfb3BzX25v
X2NvbXBhdCA9IHsKIAogc3RydWN0IGlub2RlICpwcm9jX2dldF9pbm9kZShzdHJ1Y3Qgc3VwZXJf
YmxvY2sgKnNiLCBzdHJ1Y3QgcHJvY19kaXJfZW50cnkgKmRlKQogewotCXN0cnVjdCBpbm9kZSAq
aW5vZGUgPSBpZ2V0X2xvY2tlZChzYiwgZGUtPmxvd19pbm8pOworCXN0cnVjdCBpbm9kZSAqaW5v
ZGUgPSBuZXdfaW5vZGVfcHNldWRvKHNiKTsKIAotCWlmIChpbm9kZSAmJiAoaW5vZGUtPmlfc3Rh
dGUgJiBJX05FVykpIHsKKwlpZiAoaW5vZGUpIHsKKwkJaW5vZGUtPmlfaW5vID0gZGUtPmxvd19p
bm87CiAJCWlub2RlLT5pX210aW1lID0gaW5vZGUtPmlfYXRpbWUgPSBpbm9kZS0+aV9jdGltZSA9
IENVUlJFTlRfVElNRTsKIAkJUFJPQ19JKGlub2RlKS0+cGRlID0gZGU7CiAK
--089e01537644880e7004d87c421b--
