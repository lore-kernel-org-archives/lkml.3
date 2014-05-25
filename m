Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482AbaEYUEM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 16:04:12 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:62017 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaEYUEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 16:04:10 -0400
MIME-Version: 1.0
In-Reply-To: <1399314889-9829-1-git-send-email-plamen.sisi@gmail.com>
References: <1399314889-9829-1-git-send-email-plamen.sisi@gmail.com>
Date: Sun, 25 May 2014 13:04:09 -0700
X-Google-Sender-Auth: AhRwGK-ol00QNAHJOUs0E7F2HKM
Message-ID: <CA+55aFwxF2xnYerLdJZ2gQdZizK3953L16X5KkUAqD-YePausQ@mail.gmail.com>
Subject: Re: [PATCH] do_mounts: try all available filesystems before panicking
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Plamen Petrov <plamen.sisi@gmail.com>, Dave Chinner <david@fromorbit.com>
Cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Content-Type: multipart/mixed; boundary=047d7b3432363bf83f04fa3ef71d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b3432363bf83f04fa3ef71d
Content-Type: text/plain; charset=UTF-8

On Mon, May 5, 2014 at 11:34 AM, Plamen Petrov <plamen.sisi@gmail.com> wrote:
>
> The story short: on systems with btrfs root I have a kernel .config with ext4,
> xfs and btrfs built-in which works fine with 3.13.x, but 3.14.x panics. After
> inserting some debug printks, I got this info from mount_block_root:
>
> ---> EACCESS=13, EINVAL=22, Available filesystems: ext3 ext2 ext4 fuseblk xfs btrfs
> -----> Tried ext3, error code is -22.
> -----> Tried ext2, error code is -22.
> -----> Tried ext4, error code is -22.
> -----> Tried fuseblk, error code is -22.
> -----> Tried xfs, error code is -38.
> VFS: Cannot open root device "sda2" or unknown-block(8,2): error -38
> Please append a correct "root=" boot option; here are the available partitions:
>
> Last one tried is xfs, the needed btrfs in this case never gets a chance.
> Looking at the code in init/do_mounts.c we can see that it "continue"s only if
> the return code it got is EINVAL, yet xfs clearly does not fit - so the kernel
> panics. Maybe there are other filesystems like xfs - I did not check. This
> patch fixes mount_block_root to try all available filesystems first, and then
> panic. The patched 3.14.x works for me.

Hmm. I don't really dislike your patch, but it makes all the code
_after_ the switch-statement dead, since there is now no way to ever
fall through the switch statement.

So now that

                /*
                 * Allow the user to distinguish between failed sys_open
                 * and bad superblock on root device.
                 * and give them a list of the available devices
                 */

comment ends up being entirely stale, and the code after it is
pointless and it all looks very misleading. And I'm assuming somebody
cared about that difference at some point.

The fact is, I think xfs is just buggy. Returning 38 (ENOSYS) is
totally insane. "No such system call"? Somebody is on some bad bad
drugs. Not that the mount_block_root() loop and error handling might
not be a good thing to perhaps tweak _too_, but at the very least your
patch means that now it no longer prints out the error number at all.

Maybe just making it do something like the attached patch instead? It
doesn't panic on unrecognized errors, just prints them out (just once,
if it repeats). It also doesn't do the "goto repeat" if we already
have the RDONLY bit set, because if somebody is returning insane error
numbers, that could otherwise result in an endless loop.

Anyway, I'm also not seeing why that xfs error would be new to 3.14,
though.. Adding the XFS people to the cc.

Comments (patch obviously TOTALLY UNTESTED)

              Linus

--047d7b3432363bf83f04fa3ef71d
Content-Type: text/plain; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hvmrw5xg0

IGluaXQvZG9fbW91bnRzLmMgfCAyNCArKysrKystLS0tLS0tLS0tLS0tLS0tLS0KIDEgZmlsZSBj
aGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDE4IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2lu
aXQvZG9fbW91bnRzLmMgYi9pbml0L2RvX21vdW50cy5jCmluZGV4IDgyZjIyODg1Yzg3ZS4uYTZh
NzI1ZjQ2ZjE4IDEwMDY0NAotLS0gYS9pbml0L2RvX21vdW50cy5jCisrKyBiL2luaXQvZG9fbW91
bnRzLmMKQEAgLTM4NSw2ICszODUsNyBAQCB2b2lkIF9faW5pdCBtb3VudF9ibG9ja19yb290KGNo
YXIgKm5hbWUsIGludCBmbGFncykKICNlbHNlCiAJY29uc3QgY2hhciAqYiA9IG5hbWU7CiAjZW5k
aWYKKwlpbnQgbGFzdF9lcnIgPSAwOwogCiAJZ2V0X2ZzX25hbWVzKGZzX25hbWVzKTsKIHJldHJ5
OgpAQCAtMzk0LDI5ICszOTUsMTYgQEAgcmV0cnk6CiAJCQljYXNlIDA6CiAJCQkJZ290byBvdXQ7
CiAJCQljYXNlIC1FQUNDRVM6CisJCQkJaWYgKGZsYWdzICYgTVNfUkRPTkxZKQorCQkJCQlicmVh
azsKIAkJCQlmbGFncyB8PSBNU19SRE9OTFk7CiAJCQkJZ290byByZXRyeTsKIAkJCWNhc2UgLUVJ
TlZBTDoKIAkJCQljb250aW51ZTsKIAkJfQotCSAgICAgICAgLyoKLQkJICogQWxsb3cgdGhlIHVz
ZXIgdG8gZGlzdGluZ3Vpc2ggYmV0d2VlbiBmYWlsZWQgc3lzX29wZW4KLQkJICogYW5kIGJhZCBz
dXBlcmJsb2NrIG9uIHJvb3QgZGV2aWNlLgotCQkgKiBhbmQgZ2l2ZSB0aGVtIGEgbGlzdCBvZiB0
aGUgYXZhaWxhYmxlIGRldmljZXMKLQkJICovCi0jaWZkZWYgQ09ORklHX0JMT0NLCi0JCV9fYmRl
dm5hbWUoUk9PVF9ERVYsIGIpOwotI2VuZGlmCi0JCXByaW50aygiVkZTOiBDYW5ub3Qgb3BlbiBy
b290IGRldmljZSBcIiVzXCIgb3IgJXM6IGVycm9yICVkXG4iLAotCQkJCXJvb3RfZGV2aWNlX25h
bWUsIGIsIGVycik7Ci0JCXByaW50aygiUGxlYXNlIGFwcGVuZCBhIGNvcnJlY3QgXCJyb290PVwi
IGJvb3Qgb3B0aW9uOyBoZXJlIGFyZSB0aGUgYXZhaWxhYmxlIHBhcnRpdGlvbnM6XG4iKTsKLQot
CQlwcmludGtfYWxsX3BhcnRpdGlvbnMoKTsKLSNpZmRlZiBDT05GSUdfREVCVUdfQkxPQ0tfRVhU
X0RFVlQKLQkJcHJpbnRrKCJERUJVR19CTE9DS19FWFRfREVWVCBpcyBlbmFibGVkLCB5b3UgbmVl
ZCB0byBzcGVjaWZ5ICIKLQkJICAgICAgICJleHBsaWNpdCB0ZXh0dWFsIG5hbWUgZm9yIFwicm9v
dD1cIiBib290IG9wdGlvbi5cbiIpOwotI2VuZGlmCi0JCXBhbmljKCJWRlM6IFVuYWJsZSB0byBt
b3VudCByb290IGZzIG9uICVzIiwgYik7CisJCWlmIChlcnIgIT0gbGFzdF9lcnIpCisJCQlwcmlu
dGsoIlZGUzogQ2Fubm90IG9wZW4gcm9vdCBkZXZpY2UgXCIlc1wiIG9yICVzOiBlcnJvciAlZFxu
IiwKKwkJCQkJcm9vdF9kZXZpY2VfbmFtZSwgYiwgZXJyKTsKIAl9CiAKIAlwcmludGsoIkxpc3Qg
b2YgYWxsIHBhcnRpdGlvbnM6XG4iKTsK
--047d7b3432363bf83f04fa3ef71d--
