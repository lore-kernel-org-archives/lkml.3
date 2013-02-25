Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503Ab3BYWU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 17:20:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55227 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932334Ab3BYWUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 17:20:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nicolas Pitre <nico@linaro.org>,
        =?UTF-8?q?Jean-Fran=C3=A7ois=20Moine?= <moinejf@free.fr>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 24/58] tty vt: fix character insertion overflow
Date: Mon, 25 Feb 2013 14:19:20 -0800
Message-Id: <20130225221641.281645117@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130225221636.018756060@linuxfoundation.org>
References: <20130225221636.018756060@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Pitre <nicolas.pitre@linaro.org>

commit a883b70d8e0a88278c0a1f80753b4dc99962b541 upstream.

Commit 81732c3b2fed ("tty vt: Fix line garbage in virtual console on
command line edition") broke insert_char() in multiple ways.  Then
commit b1a925f44a3a ("tty vt: Fix a regression in command line edition")
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
Acked-by: Jean-François Moine <moinejf@free.fr>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/vt/vt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -539,7 +539,7 @@ static void insert_char(struct vc_data *
 {
 	unsigned short *p = (unsigned short *) vc->vc_pos;
 
-	scr_memmovew(p + nr, p, (vc->vc_cols - vc->vc_x) * 2);
+	scr_memmovew(p + nr, p, (vc->vc_cols - vc->vc_x - nr) * 2);
 	scr_memsetw(p, vc->vc_video_erase_char, nr * 2);
 	vc->vc_need_wrap = 0;
 	if (DO_UPDATE(vc))


