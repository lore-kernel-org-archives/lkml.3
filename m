Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759614Ab3BYCGO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 21:06:14 -0500
Received: from relais.videotron.ca ([24.201.245.36]:9215 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759505Ab3BYCGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 21:06:12 -0500
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Feb 2013 21:06:12 EST
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_JXxiLJQ1Nxu9LMjSAdn1Qw)"
Date: Sun, 24 Feb 2013 20:06:09 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?ISO-8859-15?Q?Jean-Fran=E7ois_Moine?= <moinejf@free.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] tty vt: fix character insertion overflow
Message-id: <alpine.LFD.2.03.1302242001070.2213@syhkavp.arg>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
Content-id: <alpine.LFD.2.03.1302242005071.2213@syhkavp.arg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_JXxiLJQ1Nxu9LMjSAdn1Qw)
Content-id: <alpine.LFD.2.03.1302242005072.2213@syhkavp.arg>
Content-type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-transfer-encoding: 8BIT

Commit 81732c3b2f (tty vt: Fix line garbage in virtual console on
command line edition) broke insert_char() in multiple ways.  Then
commit b1a925f44a (tty vt: Fix a regression in command line edition)
partially fixed it.  However, the buffer being moved is still too large
and overflowing beyond the end of the current line, corrupting existing
characters on the next line.

Example test case:

echo -e "abc\nde\x1b[A\x1b[4h \x1b[4l\x1b[B"

Expected result:

ab c
de

Current result:

ab c
 e

Needless to say that this is very annoying when inserting words in the
middle of paragraphs with certain text editors.

Signed-off-by: Nicolas Pitre <nico@linaro.org>
Cc: Jean-François Moine <moinejf@free.fr>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org>

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 1a27280..6c4abea 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -539,7 +539,7 @@ static void insert_char(struct vc_data *vc, unsigned int nr)
 {
 	unsigned short *p = (unsigned short *) vc->vc_pos;
 
-	scr_memmovew(p + nr, p, (vc->vc_cols - vc->vc_x) * 2);
+	scr_memmovew(p + nr, p, (vc->vc_cols - vc->vc_x - nr) * 2);
 	scr_memsetw(p, vc->vc_video_erase_char, nr * 2);
 	vc->vc_need_wrap = 0;
 	if (DO_UPDATE(vc))

--Boundary_(ID_JXxiLJQ1Nxu9LMjSAdn1Qw)--
