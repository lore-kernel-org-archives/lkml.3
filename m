Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005Ab3CTWEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 18:04:21 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:63093 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab3CTWEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 18:04:20 -0400
MIME-Version: 1.0
Date: Wed, 20 Mar 2013 16:04:19 -0600
Message-ID: <CAKTPYJQeCW2fGy3bb6G2uxeQN2WYgeA63_7Lwt9ytpcwZwrnQA@mail.gmail.com>
Subject: Re: Linux 3.0.70
From: Andrew Collins <bsderandrew@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook (1):
      signal: always clear sa_restorer on execve

This commit seems to cause the following build breakage on MIPS in 3.0.70:

kernel/signal.c: In function 'flush_signal_handlers':
kernel/signal.c:441:9: error: 'struct sigaction' has no member named
'sa_restorer'
make[3]: *** [kernel/signal.o] Error 1
make[2]: *** [kernel] Error 2
make[2]: *** Waiting for unfinished jobs....

I'm testing with a variety of additional patches applied and it's a
bit difficult to test vanilla, but this looks unrelated to my local
patches.  Looks like MIPS defines SA_RESTORER but doesn't have a
sa_restorer in sigaction so:

--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -437,6 +437,9 @@ flush_signal_handlers(struct task_struct *t, int
force_default)
                if (force_default || ka->sa.sa_handler != SIG_IGN)
                        ka->sa.sa_handler = SIG_DFL;
                ka->sa.sa_flags = 0;
+#ifdef SA_RESTORER
+               ka->sa.sa_restorer = NULL;
+#endif
                sigemptyset(&ka->sa.sa_mask);
                ka++;
        }

goes kaboom.

Andrew Collins
