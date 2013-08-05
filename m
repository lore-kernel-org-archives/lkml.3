Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab3HEQlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:41:18 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:37962 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab3HEQlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:41:17 -0400
MIME-Version: 1.0
In-Reply-To: <CA+8MBbJ7x46FGC7dPSdNzf8z=fZz20w1kiNgnZr4QQB6SUELhg@mail.gmail.com>
References: <20130715164844.1520.27771.stgit@aruna-ThinkPad-T420>
	<51FA3B02.7060004@linux.vnet.ibm.com>
	<3908561D78D1C84285E8C5FCA982C28F31CAA167@ORSMSX106.amr.corp.intel.com>
	<CA+8MBbLuhVDCb26ag3AH0vXrP4MXHLxS5aVn8pTi4=qL1NdR5w@mail.gmail.com>
	<CA+8MBbJ7x46FGC7dPSdNzf8z=fZz20w1kiNgnZr4QQB6SUELhg@mail.gmail.com>
Date: Mon, 5 Aug 2013 09:41:16 -0700
Message-ID: <CA+8MBbJYhSQ455rdC5DuHiNkGBeSgySRLBtuFAKYyNG5CLq7gA@mail.gmail.com>
Subject: Re: [PATCH 00/11] Add compression support to pstore
From: Tony Luck <tony.luck@gmail.com>
To: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "paulus@samba.org" <paulus@samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "keescook@chromium.org" <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One more experiment - removed previous hack that disabled compression.
Added a new hack to skip decompression.

System died cleanly when I forced a panic.
On reboot I found 3 files in pstore:
-r--r--r--   1 root root 3972 Aug  5 09:24 dmesg-erst-5908671953186586625
-r--r--r--   1 root root 2565 Aug  5 09:24 dmesg-erst-5908671953186586626
-r--r--r--   1 root root 4067 Aug  5 09:24 dmesg-erst-5908671953186586627

Using  "openssl zlib -d" to decompress then ends up with some garbage
at the end of the decompressed file - some text that should be there is
missing.  E.g. the tail of decompressed version of *625 ends with:

<4>Call Trace:
<4> [<ffffffff815f85f4>] dump_stack+0x45/0x56
<4> [<ffffffff815f41ca>] panic+0xc2/0x1cb
<4> [<ffffffff815f4327>] ? printk+0x54/0x56
<4> [<ffffffff811cfe45>] aegl+0x25/0x30
<4> [<ffffffff811c719d>] proc_reg_write+0x3d/0x80
<4> [<ffffffff81165945>] vfs_write+0xc5/0x1e0
<4> [<ffffffff81165e32>] SyS_write+0x52/0xa0
<4> [<ffffffff81606882>] system_call_fastpath+0x16/0x1b
 )c10^@^@^@^@^@^@^@^@^@

But my serial console logged this:

Call Trace:
 [<ffffffff815f85f4>] dump_stack+0x45/0x56
 [<ffffffff815f41ca>] panic+0xc2/0x1cb
 [<ffffffff815f4327>] ? printk+0x54/0x56
 [<ffffffff811cfe45>] aegl+0x25/0x30
 [<ffffffff811c719d>] proc_reg_write+0x3d/0x80
 [<ffffffff81165945>] vfs_write+0xc5/0x1e0
 [<ffffffff81165e32>] SyS_write+0x52/0xa0
 [<ffffffff81606882>] system_call_fastpath+0x16/0x1b
------------[ cut here ]------------
WARNING: CPU: 18 PID: 381 at arch/x86/kernel/smp.c:124
native_smp_send_reschedule+0x5b/0x60()
Modules linked in:
CPU: 18 PID: 381 Comm: kworker/18:1 Not tainted 3.11.0-rc3-11-ge41db9e #6

-Tony
