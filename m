Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab3JIAwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 20:52:45 -0400
Received: from mail-vb0-f50.google.com ([209.85.212.50]:57448 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab3JIAwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 20:52:43 -0400
MIME-Version: 1.0
In-Reply-To: <E1VThRL-0002yt-ON@ZenIV.linux.org.uk>
References: <E1VThRL-0002yt-ON@ZenIV.linux.org.uk>
Date: Tue, 8 Oct 2013 17:52:42 -0700
X-Google-Sender-Auth: 42RKhnz9kuQLAX0U8IiLARF_Ha0
Message-ID: <CA+55aFxvNhuXoux88tcYemMWe5Nxdc-srfj3YgBZ7LJ-JaBEdQ@mail.gmail.com>
Subject: Re: [RFC][PATCH 10/13] make dump_emit() use vfs_write() instead of
 banging at ->f_op->write directly
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 8, 2013 at 5:15 PM, Al Viro <viro@ftp.linux.org.uk> wrote:
>
> ... and deal with short writes properly

.. except you don't.

> +       while (nr) {
> +               if (dump_interrupted())
> +                       return 0;
> +               n = vfs_write(file, addr, nr, &pos);
> +               if (n < 0)
> +                       return 0;
> +               file->f_pos = pos;
> +               cprm->written += n;
> +               nr -= n;
> +       }

Please handle 'n == 0' too. Maybe it never happens (ie you get EPIPE
or ENOSPC), but write returning zero is actually possible and a valid
return value and traditional for "end of media". Looping forever is
not a good idea.

               Linus
