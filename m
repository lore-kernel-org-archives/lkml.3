Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123Ab3LIXGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 18:06:50 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:49251 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab3LIXGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 18:06:46 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Karl Dahlke <eklhad@comcast.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>, <stable@vger.kernel.org>
Subject: Re: Bug in tty cooked mode kernel 3.12.3
Date: Mon,  9 Dec 2013 18:06:07 -0500
Message-Id: <1386630367-4658-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <20131107184607.eklhad@comcast.net>
References: <20131107184607.eklhad@comcast.net>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2013 06:46 PM, Karl Dahlke wrote:
> This may have appeared in 3.9.11 with the changes to tty.
> Don't know; I just started running 3.12 from kernel.org.
> Perhaps nobody saw it before because nobody runs command line programs,
> we're all on desktops or x or whatever,
> and even those in the command line are still raw.
> bash is raw by default, but I run it cooked.
> You can supress its readline functions like this.
> 
> set +o emacs
> set +o vi
> set +o histexpand
> set +o history
> 
> That puts its tty back into cooked mode.
> 
> Come up in run level 3, command line mode,
> and bring up two consoles with bash in cooked mode as above.
> Set a simple prompt like this.
> 
> PS1='$ '
> 
> Switch to console 2 via alt-f2.
> Hit return.
> The cursor should drop to a new line then give you the $ prompt.
> But it puts the $ prompt next too the old one, then drops down
> to a blank line.
> The $ prompt and the crlf are out of sequence.
> Hit return a few more times and it will straighten itself out.
> Then switch back to console 1 alt-f1
> Hit return and the same bug,
> $ $
> 
> hit return a few more times to straighten it out.
> Switch back to console 2 and the same problem.
> For me it's repeatable.
> 
> It's also very confusing when I'm running other command line programs with cooked tty.
> For unknown reasons the crlf can come out at the wrong time,
> breaking lines or leaving lines together.
> My editor can run either way, so I've switched it over to readline mode
> and I haven't noticed any problems this way, yet.
> But I would prefer the cooked mode.
> 
> I looked through MAINTAINERS but couldn't find
> a clear maintainer for drivers/tty/tty*.c
> Please forward this to the appropriate people.

Thanks for the report, Karl.

Please test the patch below (requires
commit 39434abd942c8e4b9c14c06a03b3245beaf8467f,
'n_tty: Fix missing newline echo').
This should fix the 'newline output after the new prompt' problem.

Note however that the other output order you observe is correct:
you press enter, a newline is echoed to terminal which mixes
with program output, the program ends, and the cooked mode
shell outputs an extra prompt because it reads a newline (which
the program did not read).

Regards,
Peter Hurley

--- >% ---
From: Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH] n_tty: Fix apparent order of echoed output

With block processing of echoed output, observed output order is still
required. Push completed echoes and echo commands prior to output.

Introduce echo_mark echo buffer index, which tracks completed echo
commands; ie., those submitted via commit_echoes but which may not
have been committed. Ensure that completed echoes are output prior
to subsequent terminal writes in process_echoes().

Fixes newline/prompt output order in cooked mode shell.

Cc: <stable@vger.kernel.org> # 3.12.x : 39434ab n_tty: Fix missing newline echo
Reported-by: Karl Dahlke <eklhad@comcast.net>
Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index ab24fe1..e9304b6 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -94,6 +94,7 @@ struct n_tty_data {
 	size_t canon_head;
 	size_t echo_head;
 	size_t echo_commit;
+	size_t echo_mark;
 	DECLARE_BITMAP(char_map, 256);
 
 	/* private to n_tty_receive_overrun (single-threaded) */
@@ -339,6 +340,7 @@ static void reset_buffer_flags(struct n_tty_data *ldata)
 {
 	ldata->read_head = ldata->canon_head = ldata->read_tail = 0;
 	ldata->echo_head = ldata->echo_tail = ldata->echo_commit = 0;
+	ldata->echo_mark = 0;
 	ldata->line_start = 0;
 
 	ldata->erasing = 0;
@@ -791,6 +793,7 @@ static void commit_echoes(struct tty_struct *tty)
 	size_t head;
 
 	head = ldata->echo_head;
+	ldata->echo_mark = head;
 	old = ldata->echo_commit - ldata->echo_tail;
 
 	/* Process committed echoes if the accumulated # of bytes
@@ -815,10 +818,11 @@ static void process_echoes(struct tty_struct *tty)
 	size_t echoed;
 
 	if ((!L_ECHO(tty) && !L_ECHONL(tty)) ||
-	    ldata->echo_commit == ldata->echo_tail)
+	    ldata->echo_mark == ldata->echo_tail)
 		return;
 
 	mutex_lock(&ldata->output_lock);
+	ldata->echo_commit = ldata->echo_mark;
 	echoed = __process_echoes(tty);
 	mutex_unlock(&ldata->output_lock);
 
@@ -826,6 +830,7 @@ static void process_echoes(struct tty_struct *tty)
 		tty->ops->flush_chars(tty);
 }
 
+/* NB: echo_mark and echo_head should be equivalent here */
 static void flush_echoes(struct tty_struct *tty)
 {
 	struct n_tty_data *ldata = tty->disc_data;
-- 
1.8.1.2

