Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbaEAV3C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 17:29:02 -0400
Received: from smtp.outflux.net ([198.145.64.163]:38205 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303AbaEAV2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 17:28:19 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>, Aaron Tomlin <atomlin@redhat.com>,
        Li Zefan <lizefan@huawei.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ryan Mallon <rmallon@gmail.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Dario Faggioli <raistlin@linux.it>, Jens Axboe <axboe@fb.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michael Ellerman <michael@ellerman.id.au>, linux-doc@vger.kernel.org
Subject: [PATCH v3 0/4] sysctl: fix incorrect write position handling
Date: Thu,  1 May 2014 14:26:33 -0700
Message-Id: <1398979597-3589-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When writing to a sysctl string, each write, regardless of VFS position,
began writing the string from the start. This meant the contents of
the last write to the sysctl controlled the string contents instead of
the first.

This misbehavior was featured in an exploit against Chrome OS. While it's
not in itself a vulnerability, it's a weirdness that isn't on the mind
of most auditors: "This filter looks correct, the first line written
would not be meaningful to sysctl" doesn't apply here, since the size
of the write and the contents of the final write are what matter when
writing to sysctls.

This adds the sysctl kernel.sysctl_writes_strict to control the write
behavior. The default (0) reports when VFS position is non-0 on a write,
but retains legacy behavior, -1 disables the warning, and 1 enables the
position-respecting behavior.

Thanks,

-Kees

