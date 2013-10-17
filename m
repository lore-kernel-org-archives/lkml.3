Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759356Ab3JQS54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 14:57:56 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:44910 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758121Ab3JQS5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 14:57:55 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
Date: Thu, 17 Oct 2013 11:57:54 -0700
Message-ID: <CAOesGMgV2UsBffPveaE+j1s-mDZ+cQvvQGLGAXjWSAv+a_56Fw@mail.gmail.com>
Subject: Corrupted low memory in v3.9+
From: Olof Johansson <olof@lixom.net>
To: "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

When booting a newer kernel on a Chromebox (Samsung SNB system,
coreboot firmware, verified boot and not using seabios), I get reports
of:

[    1.727520] Corrupted low memory at ffff880000002a90 (2a90 phys) = 100000000
[    1.734565] Corrupted low memory at ffff880000002a98 (2a98 phys) =
50000000000

I bisected it down to:

commit 95c9608478d639dcffc14ea47b31bff021a99ed1
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Thu Feb 14 14:02:52 2013 -0800

    x86, mm: Move reserving low memory later in initialization

    Move the reservation of low memory, except for the 4K which actually
    does belong to the BIOS, later in the initialization; in particular,
    after we have already reserved the trampoline.

    The current code locates the trampoline as high as possible, so by
    deferring the allocation we will still be able to reserve as much
    memory as is possible.  This allows us to run with reservelow=640k
    without getting a crash on system startup.


My config has:

CONFIG_X86_RESERVE_LOW=64

...but /proc/iomem says:

00000000-00000fff : reserved
00001000-0009ffff : System RAM
000a0000-000fffff : reserved
[...]


While before the above patch it said:

00000000-00000fff : reserved
00001000-0000ffff : reserved
00010000-0009ffff : System RAM
[...]

And the low memory checker never even ran before, since it had nothing
to check. Earlier the lower reserved region would be included in the
e820-reserved area if I read the code correctly, and now it's just
marked reserved by the memblock code.

I guess it could be argued either way whether this is a regression or
not; but at the end of the day we now have systems where this warning
pops when it didn't use to. :(


-Olof
