Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab3IPHoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 03:44:22 -0400
Received: from smtp.outflux.net ([198.145.64.163]:57990 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419Ab3IPHoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 03:44:21 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, George Spelvin <linux@horizon.com>,
        dan.carpenter@oracle.com, viro@zeniv.linux.org.uk,
        Jan Beulich <JBeulich@suse.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        akpm@linux-foundation.org
Subject: [PATCH 0/2] vsprintf: ignore %n again
Date: Mon, 16 Sep 2013 00:43:55 -0700
Message-Id: <1379317437-28329-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whether seq_printf should return void or error, %n still needs to be removed.
As such, instead of changing the seq_file structure and adding instructions
to all callers of seq_printf, just examine seq->count for the callers that
care about how many characters were put into the buffer, as suggested by
George Spelvin. First patch removes all %n usage in favor of checking
seq->count before/after. Second patch makes %n ignore its argument.

Testing shows this all works happily, and everything is still getting
padded correctly:

/proc/consoles:
ttyS0                -W- (EC   a)    4:64
netcon0              -W- (E     )

/proc/self/maps:
...
01ee7000-01f08000 rw-p 00000000 00:00 0                                  [heap]
7fdc79bd4000-7fdc79bf6000 r-xp 00000000 fd:01 394247                     /lib/x86_64-linux-gnu/libtinfo.so.5.9
...

/proc/net/tcp
  sl  local_address rem_address   st tx_queue rx_queue tr tm->when retrnsmt   uid  timeout inode
   0: 00000000:0016 00000000:0000 0A 00000000:00000000 00:00000000 00000000     0        0 2239 1 ffff88007bfd0000 100 0 0 10 0
...

/proc/net/udp
  sl  local_address rem_address   st tx_queue rx_queue tr tm->when retrnsmt   uid  timeout inode ref pointer drops
   12: 0DAAA8C0:D9D1 0100000A:0035 01 00000000:00000000 00:00000000 00000000     0        0 7534 2 ffff880078048000 0


And a test with a %n in a format string shows the warning:

[   10.693638] ------------[ cut here ]------------
[   10.693657] WARNING: CPU: 0 PID: 2048 at lib/vsprintf.c:1693 vsnprintf+0x5c1/0x600()
[   10.693660] Please remove ignored %n in '%n
[   10.693663] '
...

Fixing the other callers of seq_printf to do the right thing (void or not)
can be separate from this series.

-Kees

