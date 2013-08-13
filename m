Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851Ab3HMRWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:22:00 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:47249 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758481Ab3HMRV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:21:58 -0400
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 13 Aug 2013 10:21:36 -0700
Message-ID: <CALCETrWOmLF6DoAAdjccx3UHwuciAnu=FjGzdv5D+MKO2UutwA@mail.gmail.com>
Subject: flink (AT_EMPTY_PATH / AT_SYMLINK_FOLLOW) security considerations
To: linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, spender@grsecurity.net,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: multipart/mixed; boundary=047d7b624cbe58dbe604e3d77a68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b624cbe58dbe604e3d77a68
Content-Type: text/plain; charset=ISO-8859-1

Linux 3.10 (and many earlier kernels) allow flink using an incantation
like linkat(AT_FDCWD, "/proc/self/fd/N", destdirfd, newname,
AT_SYMLINK_FOLLOW);  It's possible to do much the same thing using
linkat(oldfd, "", destdirfd, newname, AT_EMPTY_PATH) if you're
privileged on 3.10, and the requirement for privilege is dropped in
3.11-rc5.

The immediate motivation for dropping the privilege requirement is the
O_TMPFILE changes: you can create a temporary file with O_TMPFILE,
write to it, and then give it a name with linkat(..., AT_EMPTY_PATH).
You can prevent this behavior by using O_TMPFILE | O_EXCL.

Apparently there's some kind of new security issue here [1], but I
don't know what it is.  So I'd like to get other people's thoughts.

Some notes:

All linkat variations do this:

	/* Make sure we don't allow creating hardlink to an unlinked file */
	if (inode->i_nlink == 0 && !(inode->i_state & I_LINKABLE))
		error =  -ENOENT;

That means that deleted files (except for O_TMPFILE, which sets
I_LINKABLE) can't be flinked.

Both flink variants work on O_PATH fds.

I've attached some test code if you want to play with this stuff.

Possible changes include inspecting f_cred before flink, requiring
I_ILINKABLE if unprivileged, and reverting the 3.11 change.

[1] https://lwn.net/Articles/562488/ -- see the comments

--047d7b624cbe58dbe604e3d77a68
Content-Type: text/x-csrc; charset=US-ASCII; name="tmpfile_flink.c"
Content-Disposition: attachment; filename="tmpfile_flink.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hkbdmhda0

I2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxlcnIuaD4KI2luY2x1ZGUgPGZjbnRsLmg+CiNp
bmNsdWRlIDx1bmlzdGQuaD4KI2luY2x1ZGUgPHN0cmluZy5oPgoKI2RlZmluZSBfX09fVE1QRklM
RSAwMjAwMDAwMDAKI2RlZmluZSBPX1RNUEZJTEUgKF9fT19UTVBGSUxFIHwgT19ESVJFQ1RPUlkp
CiNkZWZpbmUgQVRfRU1QVFlfUEFUSCAweDEwMDAKCmludCBtYWluKGludCBhcmdjLCBjaGFyICoq
YXJndikKewogIGNoYXIgYnVmWzEyOF07CgogIGlmIChhcmdjICE9IDQpCiAgICBlcnJ4KDEsICJV
c2FnZTogZmxpbmt0ZXN0IFRNUERJUiBQQVRIIGxpbmthdHxwcm9jIik7CgogIGludCBmZCA9IG9w
ZW4oYXJndlsxXSwgT19UTVBGSUxFIHwgT19SRFdSLCAwMTA2MDApOwogIGlmIChmZCA9PSAtMSkK
ICAgIGVycigxLCAiT19UTVBGSUxFIik7CiAgd3JpdGUoZmQsICJ0ZXN0IiwgNCk7CgogIGlmICgh
c3RyY21wKGFyZ3ZbM10sICJsaW5rYXQiKSkgewogICAgaWYgKGxpbmthdChmZCwgIiIsIEFUX0ZE
Q1dELCBhcmd2WzJdLCBBVF9FTVBUWV9QQVRIKSAhPSAwKQogICAgICBlcnIoMSwgImxpbmthdCIp
OwogIH0gZWxzZSBpZiAoIXN0cmNtcChhcmd2WzNdLCAicHJvYyIpKSB7CiAgICBzcHJpbnRmKGJ1
ZiwgIi9wcm9jL3NlbGYvZmQvJWQiLCBmZCk7CiAgICBpZiAobGlua2F0KEFUX0ZEQ1dELCBidWYs
IEFUX0ZEQ1dELCBhcmd2WzJdLCBBVF9TWU1MSU5LX0ZPTExPVykgIT0gMCkKICAgICAgZXJyKDEs
ICJsaW5rYXQiKTsKICB9IGVsc2UgewogICAgZXJyeCgxLCAiaW52YWxpZCBtb2RlIik7CiAgfQog
IHJldHVybiAwOwp9Cg==
--047d7b624cbe58dbe604e3d77a68
Content-Type: text/x-csrc; charset=US-ASCII; name="o_path_flink.c"
Content-Disposition: attachment; filename="o_path_flink.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hkbdmjsg1

I2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxlcnIuaD4KI2luY2x1ZGUgPGZjbnRsLmg+CiNp
bmNsdWRlIDx1bmlzdGQuaD4KI2luY2x1ZGUgPHN0cmluZy5oPgoKI2RlZmluZSBBVF9FTVBUWV9Q
QVRIIDB4MTAwMAojaWZuZGVmIE9fUEFUSAojZGVmaW5lIE9fUEFUSCAgICAgICAgICAwMTAwMDAw
MDAKI2VuZGlmCgppbnQgbWFpbihpbnQgYXJnYywgY2hhciAqKmFyZ3YpCnsKICBjaGFyIGJ1Zlsx
MjhdOwoKICBpZiAoYXJnYyAhPSA1KQogICAgZXJyeCgxLCAiVXNhZ2U6IGZsaW5rdGVzdCBPTERQ
QVRIIE5FV1BBVEggPG5vcm1hbHxPX1BBVEg+IEFUX0VNUFRZX1BBVEh8cHJvYyIpOwoKICBpbnQg
ZmxhZzsKICBpZiAoIXN0cmNtcChhcmd2WzNdLCAibm9ybWFsIikpCiAgICBmbGFnID0gT19SRE9O
TFk7CiAgZWxzZSBpZiAoIXN0cmNtcChhcmd2WzNdLCAiT19QQVRIIikpCiAgICBmbGFnID0gT19Q
QVRIOwogIGVsc2UKICAgIGVycngoMSwgImJhZCBvcGVuIG1vZGUiKTsKCiAgaW50IGZkID0gb3Bl
bihhcmd2WzFdLCBmbGFnKTsKICBpZiAoZmQgPT0gLTEpCiAgICBlcnIoMSwgIm9wZW4iKTsKCiAg
aWYgKCFzdHJjbXAoYXJndls0XSwgIkFUX0VNUFRZX1BBVEgiKSkgewogICAgaWYgKGxpbmthdChm
ZCwgIiIsIEFUX0ZEQ1dELCBhcmd2WzJdLCBBVF9FTVBUWV9QQVRIKSAhPSAwKQogICAgICBlcnIo
MSwgImxpbmthdCIpOwogIH0gZWxzZSBpZiAoIXN0cmNtcChhcmd2WzRdLCAicHJvYyIpKSB7CiAg
ICBzcHJpbnRmKGJ1ZiwgIi9wcm9jL3NlbGYvZmQvJWQiLCBmZCk7CiAgICBpZiAobGlua2F0KEFU
X0ZEQ1dELCBidWYsIEFUX0ZEQ1dELCBhcmd2WzJdLCBBVF9TWU1MSU5LX0ZPTExPVykgIT0gMCkK
ICAgICAgZXJyKDEsICJsaW5rYXQiKTsKICB9IGVsc2UgewogICAgZXJyeCgxLCAiaW52YWxpZCBt
b2RlIik7CiAgfQogIHJldHVybiAwOwp9Cg==
--047d7b624cbe58dbe604e3d77a68--
