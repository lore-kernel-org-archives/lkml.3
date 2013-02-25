Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759497Ab3BYTW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 14:22:59 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:47428 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759190Ab3BYTW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 14:22:58 -0500
Message-ID: <1361820175.6781.13.camel@edumazet-glaptop>
Subject: Re: sendfile and EAGAIN
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Date: Mon, 25 Feb 2013 11:22:55 -0800
In-Reply-To: <CAOPLpQcs5GgVRqXhnxF0Ui0k-39-xX5N2nYWYY4DhVWMYCMQ7w@mail.gmail.com>
References: <CAOPLpQcs5GgVRqXhnxF0Ui0k-39-xX5N2nYWYY4DhVWMYCMQ7w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-25 at 12:22 -0500, Ulrich Drepper wrote:
> When using sendfile with a non-blocking output file descriptor for a
> socket the operation can cause a partial write because of capacity
> issues.  This is nothing critical and the operation could resume after
> the output queue is cleared.  The problem is: there is no way to
> determine where to resume.
> 
> The system call just returns -EAGAIN without any further indication.
> The caller doesn't know what to resend.
> 
> And this even though the interface of sendfile would be capable of
> communicating this information and the man page (I know, it's not
> authoritive) describes this behavior as well.
> 
> The problem is probably in a few places, here is one (fs/splice.c):
> 
> static ssize_t default_file_splice_write(struct pipe_inode_info *pipe,
>                                          struct file *out, loff_t *ppos,
>                                          size_t len, unsigned int flags)
> {
>         ssize_t ret;
> 
>         ret = splice_from_pipe(pipe, out, ppos, len, flags, write_pipe_buf);
>         if (ret > 0)
>                 *ppos += ret;
> 
>         return ret;
> }
> 
> Note that *ppos is only updated if the call doesn't fail.  We could
> also update the position if ret == -EAGAIN.  This would require
> re-architecting the system a bit to either update *ppos in
> splice_from_pipe etc or to communicate number of the bytes which are
> written from the splice_from_pipe call.  In any case, the result would
> be that the caller knows where to resume the operation.
> 
> I would argue that this doesn't break the ABI.  In case existing
> programs today just resend packages today from the beginning they will
> have send an unpredictable number of bytes in the previous sendfile()
> call, making the state of the communication unpredictable.
> 
> Opinions?  I think as is sendfile() isn't useful with O_NONBLOCK.
> --

I don't understand the issue.

sendfile() returns -EAGAIN only if no bytes were copied to the socket.

If some bytes were copied, sendfile() returns the number of bytes,
exactly like write() would do for a partial write.

I guess the following should work (well... with better tests)

offset = 0;
while (offset < len) {
   res = sendfile(sock, fd, &offset, len - offset);
   if (res >= 0) {
        offset += res;
   } else {
        if (errno != EAGAIN)
            break;
        wait_some_event();
    }
}




