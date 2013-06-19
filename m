Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab3FST7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 15:59:23 -0400
Received: from mail-qe0-f54.google.com ([209.85.128.54]:60325 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756805Ab3FST7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 15:59:22 -0400
MIME-Version: 1.0
In-Reply-To: <51C206C2.2070404@google.com>
References: <51C206C2.2070404@google.com>
From: Tristan Schmelcher <tschmelcher@google.com>
Date: Wed, 19 Jun 2013 15:59:01 -0400
Message-ID: <CADNZ+wTGfASDe23n9fy=+6C060ZjZ0cWMkbs=+wbLaeA46zPgQ@mail.gmail.com>
Subject: Re: [PATCH] uml: Fix which_tmpdir failure when /dev/shm is a symlink,
 and in other edge cases
To: Richard Weinberger <richard@nod.at>, jdike@addtoit.com
Cc: user-mode-linux-devel <user-mode-linux-devel@lists.sourceforge.net>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And of course I found a bug in it moments after sending. Please
ignore, v2 coming shortly.

On 19 June 2013 15:30, Tristan Schmelcher <tschmelcher@google.com> wrote:
> From: Tristan Schmelcher <tschmelcher@google.com>
>
> which_tmpdir did the wrong thing if /dev/shm was a symlink (e.g., to
> /run/shm), if there were multiple mounts on top of each other, if the
> mount(s) were obscured by a later mount, or if /dev/shm was a prefix of
> another mount point. This fixes these cases. Applies to 3.9.6.
>
> Signed-off-by: Tristan Schmelcher <tschmelcher@google.com>
> ---
>
> --- linux-3.9.6/arch/um/os-Linux/mem.c.orig     2013-06-19
> 14:50:14.000000000 -0400
> +++ linux-3.9.6/arch/um/os-Linux/mem.c  2013-06-19 14:53:07.000000000 -0400
> @@ -53,6 +53,25 @@ static void __init find_tempdir(void)
>  }
>   /*
> + * Remove bytes from the front of the buffer and refill it so that if
> there's a
> + * partial string that we care about, it will be completed, and we can
> recognize
> + * it.
> + */
> +static int pop(int fd, char *buf, size_t size, size_t npop)
> +{
> +       ssize_t n;
> +       size_t len = strlen(&buf[npop]);
> +
> +       memmove(buf, &buf[npop], len + 1);
> +       n = read(fd, &buf[len], size - len - 1);
> +       if (n < 0)
> +               return -errno;
> +
> +       buf[len + n] = '\0';
> +       return 1;
> +}
> +
> +/*
>   * This will return 1, with the first character in buf being the
>   * character following the next instance of c in the file.  This will
>   * read the file as needed.  If there's an error, -errno is returned;
> @@ -61,7 +80,6 @@ static void __init find_tempdir(void)
>  static int next(int fd, char *buf, size_t size, char c)
>  {
>         ssize_t n;
> -       size_t len;
>         char *ptr;
>         while ((ptr = strchr(buf, c)) == NULL) {
> @@ -74,20 +92,113 @@ static int next(int fd, char *buf, size_
>                 buf[n] = '\0';
>         }
>  -      ptr++;
> -       len = strlen(ptr);
> -       memmove(buf, ptr, len + 1);
> +       return pop(fd, buf, size, ptr - buf + 1);
> +}
>  -      /*
> -        * Refill the buffer so that if there's a partial string that we
> care
> -        * about, it will be completed, and we can recognize it.
> -        */
> -       n = read(fd, &buf[len], size - len - 1);
> -       if (n < 0)
> -               return -errno;
> +/*
> + * Decode an octal-escaped and space-terminated path of the form used by
> + * /proc/mounts. May be used to decode a path in-place. "out" must be at
> least
> + * as large as the input.
> + */
> +static int decode_path(const char *in, char *out, size_t *ndecoded,
> +                      size_t *decodedlen)
> +{
> +       const char *first_in = in;
> +       char *first_out = out;
> +       int c;
> +       int i;
> +       while (*in) {
> +               switch (*in) {
> +               case ' ':
> +                       *out = '\0';
> +                       *ndecoded = in - first_in + 1;
> +                       *decodedlen = out - first_out;
> +                       return 0;
>  -      buf[len + n] = '\0';
> -       return 1;
> +               case '\\':
> +                       in++;
> +                       c = 0;
> +                       for (i = 0; i < 3; i++) {
> +                               if (*in < '0' || *in > '7')
> +                                       return -EINVAL;
> +                               c = (c << 3) | (*in++ - '0');
> +                       }
> +                       *out++ = (char) c;
> +                       break;
> +
> +               default:
> +                       *out++ = *in++;
> +                       break;
> +               }
> +       }
> +
> +       return -EINVAL;
> +}
> +
> +static size_t octal_encoded_length(const char *s, const char *chars)
> +{
> +       size_t len = strlen(s);
> +       while ((s = strpbrk(s, chars)) != NULL) {
> +               len += 3;
> +               s++;
> +       }
> +
> +       return len;
> +}
> +
> +enum {
> +       OUTCOME_NOT_A_MOUNT_POINT,
> +       OUTCOME_TMPFS_MOUNT,
> +       OUTCOME_NON_TMPFS_MOUNT,
> +};
> +
> +/* Read a line of /proc/mounts data looking for a tmpfs mount at "path". */
> +static int read_mount(int fd, char *buf, size_t bufsize, const char *path,
> +                     int *outcome)
> +{
> +       int found;
> +       int match;
> +       size_t ndecoded;
> +       size_t decodedlen;
> +
> +       enum {
> +               MATCH_NONE,
> +               MATCH_EXACT,
> +               MATCH_PARENT,
> +       };
> +
> +       found = next(fd, buf, bufsize, ' ');
> +       if (found != 1)
> +               return found;
> +
> +       if (!decode_path(buf, buf, &ndecoded, &decodedlen)) {
> +               match = MATCH_NONE;
> +               if (!strcmp(buf, path))
> +                       match = MATCH_EXACT;
> +               else if (!strncmp(buf, path, decodedlen)
> +                        && (path[decodedlen] == '/' || !strcmp(buf, "/")))
> +                       match = MATCH_PARENT;
> +
> +               found = pop(fd, buf, bufsize, ndecoded);
> +               if (found != 1)
> +                       return found;
> +
> +               switch (match) {
> +               case MATCH_EXACT:
> +                       if (!strncmp(buf, "tmpfs", strlen("tmpfs")))
> +                               *outcome = OUTCOME_TMPFS_MOUNT;
> +                       else
> +                               *outcome = OUTCOME_NON_TMPFS_MOUNT;
> +                       break;
> +
> +               case MATCH_PARENT:
> +                       /* This mount obscures any previous ones. */
> +                       *outcome = OUTCOME_NOT_A_MOUNT_POINT;
> +                       break;
> +               }
> +       }
> +
> +       return next(fd, buf, bufsize, '\n');
>  }
>   /* which_tmpdir is called only during early boot */
> @@ -106,8 +217,12 @@ static int checked_tmpdir = 0;
>   */
>  static void which_tmpdir(void)
>  {
> -       int fd, found;
> -       char buf[128] = { '\0' };
> +       int fd;
> +       int found;
> +       int outcome;
> +       char *path;
> +       char *buf;
> +       size_t bufsize;
>         if (checked_tmpdir)
>                 return;
> @@ -116,49 +231,66 @@ static void which_tmpdir(void)
>         printf("Checking for tmpfs mount on /dev/shm...");
>  +      path = realpath("/dev/shm", NULL);
> +       if (!path) {
> +               printf("failed to check real path, errno = %d\n", errno);
> +               return;
> +       }
> +       printf("%s...", path);
> +
> +       /*
> +        * The buffer needs to be able to fit the full octal-escaped path, a
> +        * space, and a trailing null in order to successfully decode it.
> +        */
> +       bufsize = octal_encoded_length(path, " \t\n\\") + 2;
> +
> +       if (bufsize < 128)
> +               bufsize = 128;
> +
> +       buf = malloc(bufsize);
> +       if (!buf) {
> +               printf("malloc failed, errno = %d\n", errno);
> +               goto out;
> +       }
> +       buf[0] = '\0';
> +
>         fd = open("/proc/mounts", O_RDONLY);
>         if (fd < 0) {
>                 printf("failed to open /proc/mounts, errno = %d\n", errno);
> -               return;
> +               goto out1;
>         }
>  +      outcome = OUTCOME_NOT_A_MOUNT_POINT;
>         while (1) {
> -               found = next(fd, buf, ARRAY_SIZE(buf), ' ');
> -               if (found != 1)
> -                       break;
> -
> -               if (!strncmp(buf, "/dev/shm", strlen("/dev/shm")))
> -                       goto found;
> -
> -               found = next(fd, buf, ARRAY_SIZE(buf), '\n');
> +               found = read_mount(fd, buf, bufsize, path, &outcome);
>                 if (found != 1)
>                         break;
>         }
>  -err:
> -       if (found == 0)
> -               printf("nothing mounted on /dev/shm\n");
> -       else if (found < 0)
> +       if (found < 0) {
>                 printf("read returned errno %d\n", -found);
> +       } else {
> +               switch (outcome) {
> +               case OUTCOME_TMPFS_MOUNT:
> +                       printf("OK\n");
> +                       default_tmpdir = "/dev/shm";
> +                       break;
>  -out:
> -       close(fd);
> -
> -       return;
> -
> -found:
> -       found = next(fd, buf, ARRAY_SIZE(buf), ' ');
> -       if (found != 1)
> -               goto err;
> +               case OUTCOME_NON_TMPFS_MOUNT:
> +                       printf("not tmpfs\n");
> +                       break;
>  -      if (strncmp(buf, "tmpfs", strlen("tmpfs"))) {
> -               printf("not tmpfs\n");
> -               goto out;
> +               default:
> +                       printf("nothing mounted on /dev/shm\n");
> +                       break;
> +               }
>         }
>  -      printf("OK\n");
> -       default_tmpdir = "/dev/shm";
> -       goto out;
> +       close(fd);
> +out1:
> +       free(buf);
> +out:
> +       free(path);
>  }
>   static int __init make_tempfile(const char *template, char **out_tempname,
>
