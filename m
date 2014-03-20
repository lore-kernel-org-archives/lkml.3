Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759573AbaCTSma (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 14:42:30 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:54212 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757067AbaCTSm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 14:42:29 -0400
Message-ID: <532B3691.1070602@hurleysoftware.com>
Date: Thu, 20 Mar 2014 14:42:25 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Michael Kerrisk <mtk.manpages@gmail.com>
CC: linux kernel <linux-kernel@vger.kernel.org>,
        linux-serial <linux-serial@vger.kernel.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Ivan <athlon_@mail.ru>
Subject: man termios
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

Some issues have arisen [1] regarding a discrepancy between the Linux behavior of
read() on a tty and 'man termios' and 'Linux Programming Interface', Chapter 62.

Firstly, if MIN==0 and TIME==0 and no input is available, read() returns 0,
even if O_NONBLOCK is set. This is also true of the other non-canonical read()'s with
timeout (TIME > 0).

'man termios' is silent here, but 62.6.2 in LPI implies that O_NONBLOCK will return
-1 with errno==EAGAIN; it does not.

This is unspecified by POSIX (11.1.7).

Secondly, in all 4 of the non-canonical read() modes, the MIN value does not limit
the number of bytes which may be returned by the read(). Only the 'count' parameter
to read() has this effect.

LPI has this to say (man-pages reads similar):

"MIN > 0, TIME == 0 (blocking read)

The read() blocks (possibly indefinitely) until the lesser of the number of bytes
requested or MIN bytes are available, and returns the lesser of the two values."

However, read() may unblock when MIN bytes are available but return up to the
'count' parameter if more input arrives in between waking and copying into the
user buffer.

So, for example, if MIN == 5,

   n = read(tty, &buffer, 30 /*sizeof(buffer)*/)

n may be up to 30 on return.

Finally, if the 'count' parameter is less than MIN, read() may return before MIN
bytes have been received, if 'count' bytes have been received.

Regards,
Peter Hurley

[1] https://bugzilla.kernel.org/show_bug.cgi?id=71671
