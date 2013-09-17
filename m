Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab3IQNHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 09:07:15 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:54039 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab3IQNHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 09:07:13 -0400
X-Nat-Received: from [202.181.97.72]:51599 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1379423166.25389
To: keescook@chromium.org, geert@linux-m68k.org
Cc: linux-kernel@vger.kernel.org, joe@perches.com, linux@horizon.com,
        dan.carpenter@oracle.com, viro@zeniv.linux.org.uk, JBeulich@suse.com,
        kosaki.motohiro@gmail.com, akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] remove all uses of printf's %n
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1379317437-28329-1-git-send-email-keescook@chromium.org>
	<1379317437-28329-2-git-send-email-keescook@chromium.org>
	<CAMuHMdUw7J6TmQ=13_zoC=rvGy0PZwd8VF5t3g8pjPQX5WaVUg@mail.gmail.com>
	<CAGXu5j+f_vTknA0KCROUh3CY5spc8pE0_SxJ2uwqQhfFpuSmXQ@mail.gmail.com>
In-Reply-To: <CAGXu5j+f_vTknA0KCROUh3CY5spc8pE0_SxJ2uwqQhfFpuSmXQ@mail.gmail.com>
Message-Id: <201309172206.FGE12970.FQFtOSMJOVHOFL@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 17 Sep 2013 22:06:02 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 17092013 #11068910, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook wrote:
> On Mon, Sep 16, 2013 at 1:09 AM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
> > On Mon, Sep 16, 2013 at 9:43 AM, Kees Cook <keescook@chromium.org> wrote:
> >> All users of %n are calculating padding size when using seq_file, so
> >> instead use the new last_len member for discovering the length of the
> >> written strings.
> >
> > Would it make sense to provide a seq_pad(...) function instead, to avoid
> > exposing more seq_file internals to its callers?
> 
> We'd still need to track how much to pad.

If we add "size_t pad_until;" to "struct seq_file", we can do

void seq_setwidth(struct seq_file *m, size_t size)
{
	m->pad_until = m->count + size;
}

void seq_pad(struct seq_file *m, char c)
{
	int size = m->pad_until - m->count;
	if (size > 0)
		seq_printf(m, "%*s", size, "");
	if (c)
		seq_putc(m, c);
}

and use like

  seq_setwidth(m, 21);
  seq_printf(m, "%s%d", con->name, con->index);
  seq_pad(m, '\n');

.
