Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbaGTFsO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 01:48:14 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:36630 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623AbaGTFsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 01:48:12 -0400
Message-ID: <53CB580E.6060804@parallels.com>
Date: Sun, 20 Jul 2014 09:47:58 +0400
From: Vasily Averin <vvs@parallels.com>
Organization: Parallels
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch] fs: umount on symlinlk leaks mnt count
Content-Type: multipart/mixed;
 boundary="------------000201080905070406060409"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000201080905070406060409
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Currently umount on symlink blocks following umount:

/vz is separate mount

# ls /vz/ -al | grep test
drwxr-xr-x.  2 root root       4096 Jul 19 01:14 testdir
lrwxrwxrwx.  1 root root         11 Jul 19 01:16 testlink -> /vz/testdir

# umount -l /vz/testlink
umount: /vz/testlink: not mounted (expected)

# lsof /vz
# umount /vz
umount: /vz: device is busy. (unexpected)

Looks like an extra refcount on mnt was taken in mountpoint_last()
Patch below fixes the problem on my test node.

Signed-off-by:	Vasily Averin <vvs@openvz.org>

--------------000201080905070406060409
Content-Type: text/plain; charset=us-ascii;
 name="diff-umount-symlink-ms"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="diff-umount-symlink-ms"

ZGlmZiAtLWdpdCBhL2ZzL25hbWVpLmMgYi9mcy9uYW1laS5jCmluZGV4IDk4NWM2ZjMuLjBk
MzJhMGYgMTAwNjQ0Ci0tLSBhL2ZzL25hbWVpLmMKKysrIGIvZnMvbmFtZWkuYwpAQCAtMjMw
NSw2ICsyMzA1LDcgQEAgcGF0aF9tb3VudHBvaW50KGludCBkZmQsIGNvbnN0IGNoYXIgKm5h
bWUsIHN0cnVjdCBwYXRoICpwYXRoLCB1bnNpZ25lZCBpbnQgZmxhZ3MKIAkJCWJyZWFrOwog
CQllcnIgPSBtb3VudHBvaW50X2xhc3QoJm5kLCBwYXRoKTsKIAkJcHV0X2xpbmsoJm5kLCAm
bGluaywgY29va2llKTsKKwkJbW50cHV0KGxpbmsubW50KTsKIAl9CiBvdXQ6CiAJaWYgKGJh
c2UpCg==
--------------000201080905070406060409--
