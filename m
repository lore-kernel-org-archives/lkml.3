Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbaIKIEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:04:16 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:44545 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbaIKIEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:04:07 -0400
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 11 Sep 2014 03:03:45 -0500
Message-ID: <CAH2r5mvCAatcvpUKdyexqeHjRCQ8niFpO6ovZsh6xiMU=rXwvg@mail.gmail.com>
Subject: 64 bit signed division
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does 64 bit signed division work on all archs?

Since do_div (currently used by cifs and ntfs to convert time formats
from DCE time to Linux time) does not handle negative numbers, and
there does not appear to be a kernel equivalent of Ildiv, I was
wondering if there really is a problem with simply doing s64 division
on other architectures (it obviously works on my systems but they are
Intel and AMD).

ie I have to change from
- u64 t = le64_to_cpu(ntutc) - NTFS_TIME_OFFSET;
-
- ts.tv_nsec = do_div(t, 10000000) * 100;
- ts.tv_sec = t;

to something like

+ s64 t = le64_to_cpu(ntutc) - NTFS_TIME_OFFSET;
+
+ ts.tv_sec = t / 10000000;
+ ts.tv_nsec = (t % 10000000) * 100;

If 64 bit division does not work on all archs then I will need to fall
back to something uglier,

+    s64 t = le64_to_cpu(ntutc) - NTFS_TIME_OFFSET;
+
+    if (t < 0) {
+        t = -t;
+        ts.tv_nsec = -(do_div(t, 10000000) * 100);
+        ts.tv_sec = -t;
+    } else {
+        ts.tv_nsec = do_div(t, 10000000) * 100;
+        ts.tv_sec = t;
+    }

Are there better alternatives?

-- 
Thanks,

Steve
