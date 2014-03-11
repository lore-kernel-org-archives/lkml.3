Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbaCKTFM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 15:05:12 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:35355 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047AbaCKTFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 15:05:10 -0400
MIME-Version: 1.0
In-Reply-To: <1393859798-1407-1-git-send-email-dh.herrmann@gmail.com>
References: <1393859798-1407-1-git-send-email-dh.herrmann@gmail.com>
Date: Tue, 11 Mar 2014 12:05:09 -0700
X-Google-Sender-Auth: G6bT4JgKPcl6h_0p1s0nkCScUp4
Message-ID: <CA+55aFwzBoTc+09jZTGjfTQTfkgZwrN5m09snb+F9inLaDn0OA@mail.gmail.com>
Subject: Re: [PATCH] fs: fix i_writecount on shmem and friends
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al, any comments?

David's test-program is some broken mix of C and shell scripting, but
the fixed version does show the issue he talks about:

    int main(int argc, char **argv)
    {
            int p[2], ro;
            char buf[128];

            pipe(p);
            sprintf(buf, "/proc/self/fd/%d", p[1]);
            ro = open(buf, O_RDONLY);
            sprintf(buf, "/proc/self/fd/%d", ro);
            close(p[1]);
            return open(buf, O_RDWR);
    }

which returns ETXTBSY (most easily seen by just stracing it).

The patch would also seem to make sense, with the i_readcount_inc()
being immediately below for the FMODE_READ case.

[ Quoting the whole email for context, sorry ]

                  Linus

On Mon, Mar 3, 2014 at 7:16 AM, David Herrmann <dh.herrmann@gmail.com> wrote:
> VM_DENYWRITE currently relies on i_writecount. Unless there's an active
> writable reference to an inode, VM_DENYWRITE is not allowed.
> Unfortunately, alloc_file() does not increase i_writecount, therefore,
> does not prevent a following VM_DENYWRITE even though the new file might
> have been opened with FMODE_WRITE. However, callers of alloc_file() expect
> the file object to be fully instantiated so they can call fput() on it. We
> could now either fix all callers to do an get_write_access() if opened
> with FMODE_WRITE, or simply fix alloc_file() to do that. I chose the
> latter.
>
> Note that this bug allows some rather subtle misbehavior. The following
> sequence of calls should work just fine, but currently fails:
>     int p[2], orig, ro, rw;
>     char buf[128];
>
>     pipe(p);
>     sprintf(buf, "/proc/self/fd/%d", p[1]);
>     ro = open("/proc/self/fd/$orig", O_RDONLY);
>     close(p[1]);
>     rw = open("/proc/self/fd/$ro", O_RDWR);
>
> The final open() cannot succeed as close(p[1]) caused an integer underflow
> on i_writecount, effectively causing VM_DENYWRITE on the inode. The open
> will fail with -ETXTBUSY.
>
> It's a rather odd sequence of calls and given that open() doesn't use
> alloc_file() (and thus not affected by this bug), it's rather unlikely
> that this is a serious issue. But stuff like anon_inode shares a *single*
> inode across a huge set of interfaces. If any of these is broken like
> pipe(), it will affect all of these (ranging from dma-buf to epoll).
>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
> ---
>  fs/file_table.c | 27 ++++++++++++++++++---------
>  1 file changed, 18 insertions(+), 9 deletions(-)
>
> diff --git a/fs/file_table.c b/fs/file_table.c
> index 5fff903..e3c8dd0 100644
> --- a/fs/file_table.c
> +++ b/fs/file_table.c
> @@ -167,6 +167,7 @@ struct file *alloc_file(struct path *path, fmode_t mode,
>                 const struct file_operations *fop)
>  {
>         struct file *file;
> +       int error;
>
>         file = get_empty_filp();
>         if (IS_ERR(file))
> @@ -178,15 +179,23 @@ struct file *alloc_file(struct path *path, fmode_t mode,
>         file->f_mode = mode;
>         file->f_op = fop;
>
> -       /*
> -        * These mounts don't really matter in practice
> -        * for r/o bind mounts.  They aren't userspace-
> -        * visible.  We do this for consistency, and so
> -        * that we can do debugging checks at __fput()
> -        */
> -       if ((mode & FMODE_WRITE) && !special_file(path->dentry->d_inode->i_mode)) {
> -               file_take_write(file);
> -               WARN_ON(mnt_clone_write(path->mnt));
> +       if (mode & FMODE_WRITE) {
> +               error = get_write_access(path->dentry->d_inode);
> +               if (error) {
> +                       put_filp(file);
> +                       return ERR_PTR(error);
> +               }
> +
> +               /*
> +                * These mounts don't really matter in practice
> +                * for r/o bind mounts.  They aren't userspace-
> +                * visible.  We do this for consistency, and so
> +                * that we can do debugging checks at __fput()
> +                */
> +               if (!special_file(path->dentry->d_inode->i_mode)) {
> +                       file_take_write(file);
> +                       WARN_ON(mnt_clone_write(path->mnt));
> +               }
>         }
>         if ((mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ)
>                 i_readcount_inc(path->dentry->d_inode);
> --
> 1.9.0
>
