Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221AbaCTLNu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 07:13:50 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:41062 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757375AbaCTLNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 07:13:47 -0400
MIME-Version: 1.0
In-Reply-To: <20140313003740.GL18016@ZenIV.linux.org.uk>
References: <1393859798-1407-1-git-send-email-dh.herrmann@gmail.com>
	<CA+55aFwzBoTc+09jZTGjfTQTfkgZwrN5m09snb+F9inLaDn0OA@mail.gmail.com>
	<20140312181925.GK18016@ZenIV.linux.org.uk>
	<CANq1E4QSFjDiYVmfrNJFfK6zW_HhSBd5d0QF-2t48DzUP+B6pw@mail.gmail.com>
	<20140313003740.GL18016@ZenIV.linux.org.uk>
Date: Thu, 20 Mar 2014 12:13:46 +0100
Message-ID: <CANq1E4SxooTu9-sYzcyrt=vbHM6qgxnekPoJH3EW4Awia3s+vw@mail.gmail.com>
Subject: Re: [PATCH] fs: fix i_writecount on shmem and friends
From: David Herrmann <dh.herrmann@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        stable <stable@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001a1133d458e74de704f507dc7e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a1133d458e74de704f507dc7e
Content-Type: text/plain; charset=ISO-8859-1

Hi

On Thu, Mar 13, 2014 at 1:37 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> We do, but how do you get anything even attempt deny_write_access() on
> those?  And what would the semantics of that be, anyway?

I just discovered /proc/self/map_files/ (only enabled with
CONFIG_CHECKPOINT_RESTORE). Attached is an example to trigger an
i_writecount underrun on an anon-mapping with your recommended fix
applied. You can also find it at [1].

This example is a bit more complex, but basically does this:
 - get a fresh, executable zero-mapping
 - write an executable into the mapping
 - get a read-only file-descriptor to the underlying shmem file via
/proc/self/map_files/
 - execute that mapping via /proc/self/map_files/
 - try to get a writable FD via /proc/self/map_files, this will fail
with ETXTBUSY _even though_ we still own a writable mapping

Ok, maybe this example is stupid, uses non-standard functionality
(CONFIG_CHECKPOINT_RESTORE) and is a very unlikely use-case, but it
shows that there _are_ ways to trigger this underrun. The hard part is
to get access to an executable file-descriptor that was created via
alloc_file() rather than open(). Once you got this, you can always
trigger the underrun by executing the file while you still have a
_single_ writable mapping which wasn't accounted for in i_writecount.

/proc/self/map_files/ is root only, so this is not a security problem.
I'm fine if you argue /proc/self/map_files/ is insecure and shouldn't
be used. Or maybe it must be non-executable. I'm just saying there
might always be new interfaces that give you a file-descriptor to
files allocated with alloc_file() rather than open(). And once you got
this FD, you can always execve() it via /proc and get
deny_write_access() this way. By initializing i_writecount on all
files, we make sure this never happens.

Anyhow, as I really want this fixed either way, please let me know how
to proceed. I can polish your patch and resend it if you don't intend
to apply it yourself.

Thanks
david

[1] https://gist.githubusercontent.com/dvdhrm/9661331/raw/b751cc7859267bb62af393ba3817b92c5225a372/gistfile1.txt

--001a1133d458e74de704f507dc7e
Content-Type: text/x-csrc; charset=US-ASCII; name="test.c"
Content-Disposition: attachment; filename="test.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hszxukek0

I2RlZmluZSBfR05VX1NPVVJDRQojaW5jbHVkZSA8ZmNudGwuaD4KI2luY2x1ZGUgPHNpZ25hbC5o
PgojaW5jbHVkZSA8c3RkaW8uaD4KI2luY2x1ZGUgPHN0ZGxpYi5oPgojaW5jbHVkZSA8c3lzL21t
YW4uaD4KI2luY2x1ZGUgPHN5cy9zdGF0Lmg+CiNpbmNsdWRlIDx1bmlzdGQuaD4KCmludCBtYWlu
KGludCBhcmdjLCBjaGFyICoqYXJndikKewoJY2hhciAqYXJnc1s2NF07CglzdHJ1Y3Qgc3RhdCBz
dDsKCXNpZ3NldF90IHNldDsKCWNoYXIgcGF0aFsxMjhdOwoJdm9pZCAqbWFwOwoJc2l6ZV90IHNp
emU7CglpbnQgc2lnLCBmZF9leGUsIGZkX21hcCwgZmQ7CglwaWRfdCBwaWQ7Cglzc2l6ZV90IHJl
czsKCgkvKgoJICogSWYgY2FsbGVkIHdpdGggYXJndW1lbnRzLCB3ZSBqdXN0IGFjdCBhcyBhIHNs
ZWVwaW5nIHByb2Nlc3MgdGhhdAoJICogd2FpdHMgZm9yIGFueSBzaWduYWwgdG8gYXJyaXZlLgoJ
ICovCglpZiAoYXJnYyA+IDEpIHsKCQlwcmludGYoImR1bW15IHdhaXRlciBpbml0XG4iKTsKCQkv
KiBkdW1teSB3YWl0ZXI7IFNJR1RFUk0gdGVybWluYXRlcyB1cyBhbnl3YXkgKi8KCQlzaWdlbXB0
eXNldCgmc2V0KTsKCQlzaWdhZGRzZXQoJnNldCwgU0lHVEVSTSk7CgkJc2lnd2FpdCgmc2V0LCAm
c2lnKTsKCQlwcmludGYoImR1bW15IHdhaXRlciBleGl0XG4iKTsKCQlleGl0KDApOwoJfQoKCWZk
X2V4ZSA9IG9wZW4oIi9wcm9jL3NlbGYvZXhlIiwgT19SRE9OTFkpOwoJaWYgKGZkX2V4ZSA8IDAp
IHsKCQlwcmludGYoIm9wZW4oL3Byb2Mvc2VsZi9leGUpIGZhaWxlZDogJW1cbiIpOwoJCWFib3J0
KCk7Cgl9CgoJaWYgKGZzdGF0KGZkX2V4ZSwgJnN0KSA8IDApIHsKCQlwcmludGYoImZzdGF0KGZk
X2V4ZSkgZmFpbGVkOiAlbVxuIik7CgkJYWJvcnQoKTsKCX0KCgkvKiBwYWdlLWFsaWduICovCglz
aXplID0gKHN0LnN0X3NpemUgKyA0MDk1VUxMKSAmIH40MDk1VUxMOwoKCW1hcCA9IG1tYXAoTlVM
TCwgc2l6ZSwgUFJPVF9SRUFEIHwgUFJPVF9XUklURSB8IFBST1RfRVhFQywKCQkgICBNQVBfU0hB
UkVEIHwgTUFQX0FOT05ZTU9VUywgLTEsIDApOwoJaWYgKG1hcCA9PSBNQVBfRkFJTEVEKSB7CgkJ
cHJpbnRmKCJtbWFwKE1BUF9BTk9OKSBmYWlsZWQ6ICVtXG4iKTsKCQlhYm9ydCgpOwoJfQoKCXJl
cyA9IHJlYWQoZmRfZXhlLCBtYXAsIHN0LnN0X3NpemUpOwoJaWYgKHJlcyAhPSBzdC5zdF9zaXpl
KSB7CgkJaWYgKHJlcyA8IDApCgkJCXByaW50ZigicmVhZChmZF9leGUpIGZhaWxlZDogJW1cbiIp
OwoJCWVsc2UKCQkJcHJpbnRmKCJyZWFkKGZkX2V4ZSkgd2FzIHRydW5jYXRlZCB0byAlenVcbiIs
CgkJCSAgICAgICAoc2l6ZV90KXJlcyk7CgkJYWJvcnQoKTsKCX0KCglzcHJpbnRmKHBhdGgsICIv
cHJvYy9zZWxmL21hcF9maWxlcy8lbHgtJWx4IiwKCQkodW5zaWduZWQgbG9uZyltYXAsCgkJKHVu
c2lnbmVkIGxvbmcpbWFwICsgc2l6ZSk7CglmZF9tYXAgPSBvcGVuKHBhdGgsIE9fUkRPTkxZKTsK
CWlmIChmZF9tYXAgPCAwKSB7CgkJcHJpbnRmKCJvcGVuKCVzKSBmYWlsZWQ6ICVtXG4iLCBwYXRo
KTsKCQlhYm9ydCgpOwoJfQoKCXBpZCA9IGZvcmsoKTsKCWlmIChwaWQgPCAwKSB7CgkJcHJpbnRm
KCJmb3JrKCkgZmFpbGVkOiAlbVxuIik7CgkJYWJvcnQoKTsKCX0gZWxzZSBpZiAoIXBpZCkgewoJ
CWFyZ3NbMF0gPSBhcmd2WzBdOwoJCWFyZ3NbMV0gPSAiZHVtbXkiOwoJCWFyZ3NbMl0gPSBOVUxM
OwoJCWV4ZWN2ZShwYXRoLCBhcmdzLCBOVUxMKTsKCQlwcmludGYoImV4ZWN2ZSgpIGZhaWxlZDog
JW1cbiIpOwoJCWFib3J0KCk7Cgl9CgoJLyogc2xlZXAgMTAwbXMgdG8gbWFrZSBzdXJlIHRoZSBl
eGVjdmUoKSByZWFsbHkgd29ya2VkICovCgl1c2xlZXAoMTAwICogMTAwMFVMTCk7CgoJc3ByaW50
ZihwYXRoLCAiL3Byb2Mvc2VsZi9mZC8lZCIsIGZkX21hcCk7CglmZCA9IG9wZW4ocGF0aCwgT19S
RFdSKTsKCWlmIChmZCA8IDApIHsKCQlwcmludGYoIm9wZW4oJXMpIGZhaWxlZDogJW1cbiIsIHBh
dGgpOwoJCWFib3J0KCk7Cgl9CgoJbXVubWFwKG1hcCwgc2l6ZSk7CgljbG9zZShmZF9leGUpOwoK
CWNsb3NlKGZkKTsKCWNsb3NlKGZkX21hcCk7CglwcmludGYoImV4aXRpbmdcbiIpOwoKCXJldHVy
biAwOwp9Cg==
--001a1133d458e74de704f507dc7e--
