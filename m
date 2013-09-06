Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab3IFUwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 16:52:51 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:53107 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab3IFUwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 16:52:50 -0400
MIME-Version: 1.0
In-Reply-To: <1378483738-10129-2-git-send-email-Waiman.Long@hp.com>
References: <1378483738-10129-1-git-send-email-Waiman.Long@hp.com>
	<1378483738-10129-2-git-send-email-Waiman.Long@hp.com>
Date: Fri, 6 Sep 2013 13:52:49 -0700
X-Google-Sender-Auth: kPdYd1Ep8dFZ-WsNnQpVRSRctuc
Message-ID: <CA+55aFw8UuEmKsSdGZPUmcekZheNimEt4U81i7Bz0LipGzsFmg@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] dcache: Translating dentry into pathname without
 taking rename_lock
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>, John Stoffel <john@stoffel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 6, 2013 at 9:08 AM, Waiman Long <Waiman.Long@hp.com> wrote:
>
> This patch will replace the writer's write_seqlock/write_sequnlock
> sequence of the rename_lock of the callers of the prepend_path() and
> __dentry_path() functions with the reader's read_seqbegin/read_seqretry
> sequence within these 2 functions.

Ok, this actually looks really good.

I do have one comment, from just reading the patch:

I would really like the stuff inside the

   restart:
      bptr = *buffer;
      blen = *buflen;
      if (retry_cnt) {
            seq = read_seqbegin(&rename_lock);
            rcu_read_lock();
      } else
            write_seqlock(&rename_lock);

      ... guts of path generation ...

      if (retry_cnt) {
            retry_cnt--;
            rcu_read_unlock();
            if (read_seqretry(&rename_lock, seq))
                  goto restart;
      } else
            write_sequnlock(&rename_lock);

could possible be done as a separate function?

Alternatively (or perhaps additionally), maybe the locking could be
done as an inline function too (taking the retry count as an argument)
to make things a bit more easy to understand.

Right now there is a lot of fairly subtle things going on in that
__dentry_path() function. It's not a huge function, but I think that
"while()" loop inside that locking could be done as its own function
and make it even more readable.

But I could already apply this as-is, so it's not a big deal.

Al - do you have comments? Do you want to take this through your tree,
or are you working on other things? I can take this directly too..

                 Linus
