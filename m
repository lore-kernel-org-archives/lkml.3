Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab3KZBRC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 20:17:02 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:56588 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab3KZBRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 20:17:00 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Margarita Manterola <margamanterola@gmail.com>,
        Maximiliano Curia <maxy@gnuservers.com.ar>
Cc: Pavel Machek <pavel@ucw.cz>, Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
        Stas Sergeev <stsp@users.sourceforge.net>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: Re: Large pastes into readline enabled programs causes breakage from v2.6.31 onwards
Date: Mon, 25 Nov 2013 20:16:14 -0500
Message-Id: <1385428582-5577-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <5291E92F.7010609@hurleysoftware.com>
References: <5291E92F.7010609@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2013 06:55 AM, Peter Hurley wrote:
> On 11/23/2013 07:29 PM, One Thousand Gnomes wrote:
>>> 7) Rescan line discipline buffer when changing from non-canonical to canonical
>>> mode. The real problem with this approach (besides the inefficiency) is that this
>>> solution could break some (admittedly unknown) program that contrived to exchange
>>> data in non-canonical mode but read in canonical mode (just not exceeding the
>>> line discipline buffer limit).
>>
>> See bugzilla 55981, 55991 btw
>
> Thanks for the bug references, Alan.
>
> The solution proposed in 55991 (to perform an EOF push when switching from
> non-canon to canon) would further break paste to readline().
>
> The caller to readline() may not actually perform any read() but may
> simply loop, calling readline();  in this case, when readline()
> switches back to non-canonical, it will eventually read the inserted '\0'.
> That would be bad.

Stas Sergeev (the reporter of kernel bug# 55991) had proposed a
solution allowing data in the read buffer to become immediately
available for read when switching to canonical mode.

With one minor change, the proposed solution appears to solve the
readline() paste overflow problem (at least, that's the result of
my testing on the test bench originally provided by Margarita
earlier in the thread).

This patch should apply cleanly to 3.13-rc1+ (or to 3.12-final+ with
'git am -C1 <patch_file_name>'.

Please test ASAP as I'd like to see this in 3.13. I'll backport it
to the stable kernels once this is in mainline.

Regards,
Peter Hurley

--- >% ---
Subject: [PATCH v2] n_tty: Fix buffer overruns with larger-than-4k pastes

readline() inadvertently triggers an error recovery path when
pastes larger than 4k overrun the line discipline buffer. The
error recovery path discards input when the line discipline buffer
is full and operating in canonical mode and no newline has been
received. Because readline() changes the termios to non-canonical
mode to read the line char-by-char, the line discipline buffer
can become full, and then when readline() restores termios back
to canonical mode for the caller, the now-full line discipline
buffer triggers the error recovery.

When changing termios from non-canon to canon mode and the read
buffer contains data, simulate an EOF push _without_ the
DISABLED_CHAR in the read buffer. canon_copy_to_read_buf()
correctly interprets this condition and will return data in the
read buffer as one line.

Importantly for the readline() problem, the termios can be
changed back to non-canonical mode without changes to the read
buffer occurring; ie., as if the previous termios change had not
happened (as long as no intervening read took place).

Patch based on original proposal and discussion here
https://bugzilla.kernel.org/show_bug.cgi?id=55991
by Stas Sergeev <stsp@users.sourceforge.net>

Reported-by: Margarita Manterola <margamanterola@gmail.com>
Cc: Maximiliano Curia <maxy@gnuservers.com.ar>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Acked-by: Stas Sergeev <stsp@users.sourceforge.net>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 3919ced..2184d7b 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1778,7 +1778,13 @@ static void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
 
 	if (!old || (old->c_lflag ^ tty->termios.c_lflag) & ICANON) {
 		bitmap_zero(ldata->read_flags, N_TTY_BUF_SIZE);
-		ldata->line_start = ldata->canon_head = ldata->read_tail;
+		if (!L_ICANON(tty) || !read_cnt(ldata))
+			ldata->line_start = ldata->canon_head = ldata->read_tail;
+		else {
+			set_bit((ldata->read_head - 1) & (N_TTY_BUF_SIZE - 1),
+				ldata->read_flags);
+			ldata->canon_head = ldata->read_head;
+		}
 		ldata->erasing = 0;
 		ldata->lnext = 0;
 	}
@@ -1993,6 +1999,12 @@ static int copy_from_read_buf(struct tty_struct *tty,
  *	it copies one line of input up to and including the line-delimiting
  *	character into the user-space buffer.
  *
+ *	NB: When termios is changed from non-canonical to canonical mode and
+ *	the read buffer contains data, n_tty_set_termios() simulates an EOF
+ *	push (as if C-d were input) _without_ the DISABLED_CHAR in the buffer.
+ *	This causes data already processed as input to be immediately available
+ *	as input although a newline has not been received.
+ *
  *	Called under the atomic_read_lock mutex
  *
  *	n_tty_read()/consumer path:
-- 
1.8.1.2

