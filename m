Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094Ab3K0MNx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 07:13:53 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:46667 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754647Ab3K0MNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 07:13:52 -0500
Message-ID: <5295E1FB.8090607@hurleysoftware.com>
Date: Wed, 27 Nov 2013 07:13:47 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: tty/serial eating \n regression in 3.13-rc1
References: <20131126215349.GA4818@obsidianresearch.com>
In-Reply-To: <20131126215349.GA4818@obsidianresearch.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 04:53 PM, Jason Gunthorpe wrote:
> Hello Peter,
>
> I have been testing 3.13-rc1 and I noticed a change in behavior in the
> tty/serial layer. Specifically I have a login running on serial that
> presents the usual login:/password: prompt.
>
> 3.10.12 does this:
>
> login: admin
> password:
> prompt>
>
> While 3.13-rc1 does this:
>
> login: admin
> password: prompt>
>
> That is to say, a \n got lost. I have also noticed while using the
> serial console that '\n's are occasionally lost, and the lossage is
> highly repeatable and seemingly based on number of chars being output
> in a burst, eg entering 'foo bar' at a shell prompt might loose the \n,
> while entering 'foo bar ' will not.
>
> I ran a full git bisect search and determined that the attached patch
> introduced the problem.
>
> This seems like a bug - at least the commit comment seems like it
> should not cause any change in behaviour. I can reproduce it and help
> debug, if you can give some guidance, I am not a tty layer expert :)

Hi Jason,

Thanks for the bisect: this is definitely a bug and not designed behavior.
But just to be clear here, the error you're seeing is strictly wrt.
echo output; normal output remains uncorrupted?

Also, you're not seeing other echo drop-outs?

Although there are some fixes due for 3.13-rc2 concerning echoes, I
think this may be a smp weak memory ordering problem.

> I have seen this bug on ppc with an out-of-tree serial driver, and on
> ARM kirkwood with the serial8250 driver. I did the bisection search on
> PPC.

Ah, the games processors play. I assume the ppc is the host machine; the
serial terminal remained unchanged, yes?

Would you please test with the patch below which uses ftrace to
capture the output? [The trace only tracks the echo buffer indices, not
any of the data.]

When you see the lost '\n', copy /sys/kernel/debug/tracing/trace
to a file and send it to me (compressed if too big for the lists). Or
you can send it off-list, if you'd prefer.

[Apologies if the patch is white-space mangled; my mailer [Thunderbird]
is dain-bramaged. I think git am will still do the right thing.]

--- >% ----
Subject: [PATCH] n_tty: Add trace support for echo output

Debug patch.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
  drivers/tty/n_tty.c | 24 ++++++++++++++++++++++++
  1 file changed, 24 insertions(+)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 7cdd1eb..b055838 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -79,6 +79,12 @@
  #define ECHO_BLOCK		256
  #define ECHO_DISCARD_WATERMARK	N_TTY_BUF_SIZE - (ECHO_BLOCK + 32)

+#define trace_facility trace_printk
+#define _n_tty_trace(tty, f, args...)					\
+	do {								\
+		char buf[64];						\
+		trace_facility("[%s] " f, tty_name(tty, buf), ##args);	\
+	} while (0)

  #undef N_TTY_TRACE
  #ifdef N_TTY_TRACE
@@ -87,6 +93,15 @@
  # define n_tty_trace(f, args...)
  #endif

+#undef N_TTY_TRACE_ECHOES
+#define N_TTY_TRACE_ECHOES 1
+#ifdef N_TTY_TRACE_ECHOES
+# define n_tty_trace_echoes(tty, f, args...)	_n_tty_trace(tty, f, args)
+#else
+# define n_tty_trace_echoes(tty, f, args...)	do { } while (0)
+#endif
+
+
  struct n_tty_data {
  	/* producer-published */
  	size_t read_head;
@@ -763,10 +778,19 @@ static size_t __process_echoes(struct tty_struct *tty)
  		}
  	}

+	n_tty_trace_echoes(tty, "echoes:%zu,%zu commit:%zu head:%zu\n",
+			   ldata->echo_tail, tail, ldata->echo_commit,
+			   ldata->echo_head);
+
  	/* If the echo buffer is nearly full (so that the possibility exists
  	 * of echo overrun before the next commit), then discard enough
  	 * data at the tail to prevent a subsequent overrun */
  	while (ldata->echo_commit - tail >= ECHO_DISCARD_WATERMARK) {
+
+		n_tty_trace_echoes(tty, "discard echoes (%zu - %zu > %d)\n",
+				   ldata->echo_commit, tail,
+				   ECHO_DISCARD_WATERMARK);
+
  		if (echo_buf(ldata, tail) == ECHO_OP_START) {
  			if (echo_buf(ldata, tail) == ECHO_OP_ERASE_TAB)
  				tail += 3;
-- 
1.8.1.2



