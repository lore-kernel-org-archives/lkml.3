Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbaAFOCv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 09:02:51 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:58552 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbaAFOCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 09:02:50 -0500
X-Nat-Received: from [202.181.97.72]:57707 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1389016929.31577
To: pavel@ucw.cz
Cc: keescook@chromium.org, joe@perches.com, akpm@linux-foundation.org,
        geert@linux-m68k.org, jkosina@suse.cz, viro@zeniv.linux.org.uk,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/vsprintf: add %pT[C012] format specifier
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1388770748.14334.19.camel@joe-AO722>
	<CAGXu5j+gHtgx9MVCaJ2ogJ0WGCeTDkphsH3gm7S=+mTssicABg@mail.gmail.com>
	<201401041126.BHJ81291.VOHLOtMFOJFQFS@I-love.SAKURA.ne.jp>
	<201401051215.ACJ30759.MJSHtFFFVOOOQL@I-love.SAKURA.ne.jp>
	<20140105222752.GA27517@amd.pavel.ucw.cz>
In-Reply-To: <20140105222752.GA27517@amd.pavel.ucw.cz>
Message-Id: <201401062302.FJG51045.tFSOFJQLOOHFMV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 6 Jan 2014 23:02:09 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 06012014 #7264628, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> > + * Please use this wrapper function which will be updated in the future to read
> > + * @tsk->comm in a consistent way.
> > + */
> > +static inline int commcmp(const struct task_struct *tsk, const char *comm)
> > +{
> > +	return strcmp(tsk->comm, comm);
> > +}
> 
> Is this useful to something? Printing command name is
> useful. Comparing it...?
>

(a) Using tsk->comm for reducing duplicated printk() messages.

    if (strcmp(p->comm, last_comm)) {
        printk("hello\n");
        strcpy(last_comm, p->comm);
    }

(b) Using tsk->pid for reducing duplicated printk() messages.

    if (p->pid != last_pid) {
        printk("hello\n");
        last_pid = p->pid;
    }

(c) Using printk_ratelimit() for reducing printk() flooding.

    printk_ratelimit("hello\n");

(d) Using plain printk().

    printk("hello\n");

(e) Other purposes. (e.g. drivers/target/iscsi/iscsi_target_tq.c )

    if (!strncmp(current->comm, ISCSI_RX_THREAD_NAME,
                 strlen(ISCSI_RX_THREAD_NAME)))
        thread_called = ISCSI_RX_THREAD;
    else if (!strncmp(current->comm, ISCSI_TX_THREAD_NAME,
                      strlen(ISCSI_TX_THREAD_NAME)))
        thread_called = ISCSI_TX_THREAD;

commcmp() and commcpy() are for wrappring (a).
Though (a) should consider changing to (b) or (c).

(e) should be rewritten not to depend on current->comm .
