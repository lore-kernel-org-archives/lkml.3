Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaAZKwh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 05:52:37 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:35516 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbaAZKwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 05:52:35 -0500
MIME-Version: 1.0
In-Reply-To: <5288BD3D.1050302@nod.at>
References: <52811BDA.2090705@google.com>
	<5288BD3D.1050302@nod.at>
Date: Sun, 26 Jan 2014 11:52:34 +0100
Message-ID: <CAFLxGvxX_ojwSMvpgzX+3DiBT5xDQSSuo2AyVGPwOe9Z5TMV+Q@mail.gmail.com>
Subject: Re: [uml-devel] [PATCH] uml: Simplify tempdir logic.
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: Tristan Schmelcher <tschmelcher@google.com>,
        Thomas Meyer <thomas@m3y3r.de>, LKML <linux-kernel@vger.kernel.org>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 17, 2013 at 1:57 PM, Richard Weinberger <richard@nod.at> wrote:
> Am 11.11.2013 19:03, schrieb Tristan Schmelcher:
>> From: Tristan Schmelcher <tschmelcher@google.com>
>>
>> Inferring the mount hierarchy correctly from /proc/mounts is hard when MS_MOVE
>> may have been used, and the previous code did it wrongly. This change simplifies
>> the logic to only require that /dev/shm be _on_ tmpfs (which can be checked
>> trivially with statfs) rather than that it be a _mountpoint_ of tmpfs, since
>> there isn't a compelling reason to be that strict. We also now check for tmpfs
>> on whatever directory we ultimately use so that the user is better informed.
>>
>> This change also moves the more standard TMPDIR environment variable check ahead
>> of the others.
>>
>> Applies to 3.12.
>>
>> Signed-off-by: Tristan Schmelcher <tschmelcher@google.com>
>
> I like what I see but so far I didn't had to time to review your changes carefully.
> Stay tuned. :)

Shame on me, I've completely forgotten this patch.
I'll put it into -next such that we can merge it with v3.15.

Sorry for the delay.

> Thanks,
> //richard
>
>> ---
>>  arch/um/os-Linux/mem.c | 372 ++++++++++---------------------------------------
>>  1 file changed, 75 insertions(+), 297 deletions(-)
>>
>> diff --git a/arch/um/os-Linux/mem.c b/arch/um/os-Linux/mem.c
>> index 3c4af77..897e9ad 100644
>> --- a/arch/um/os-Linux/mem.c
>> +++ b/arch/um/os-Linux/mem.c
>> @@ -12,337 +12,117 @@
>>  #include <string.h>
>>  #include <sys/stat.h>
>>  #include <sys/mman.h>
>> -#include <sys/param.h>
>> +#include <sys/vfs.h>
>> +#include <linux/magic.h>
>>  #include <init.h>
>>  #include <os.h>
>>
>> -/* Modified by which_tmpdir, which is called during early boot */
>> -static char *default_tmpdir = "/tmp";
>> -
>> -/*
>> - *  Modified when creating the physical memory file and when checking
>> - * the tmp filesystem for usability, both happening during early boot.
>> - */
>> +/* Set by make_tempfile() during early boot. */
>>  static char *tempdir = NULL;
>>
>> -static void __init find_tempdir(void)
>> +/* Check if dir is on tmpfs. Return 0 if yes, -1 if no or error. */
>> +static int __init check_tmpfs(const char *dir)
>>  {
>> -     const char *dirs[] = { "TMP", "TEMP", "TMPDIR", NULL };
>> -     int i;
>> -     char *dir = NULL;
>> -
>> -     if (tempdir != NULL)
>> -             /* We've already been called */
>> -             return;
>> -     for (i = 0; dirs[i]; i++) {
>> -             dir = getenv(dirs[i]);
>> -             if ((dir != NULL) && (*dir != '\0'))
>> -                     break;
>> -     }
>> -     if ((dir == NULL) || (*dir == '\0'))
>> -             dir = default_tmpdir;
>> +     struct statfs st;
>>
>> -     tempdir = malloc(strlen(dir) + 2);
>> -     if (tempdir == NULL) {
>> -             fprintf(stderr, "Failed to malloc tempdir, "
>> -                     "errno = %d\n", errno);
>> -             return;
>> -     }
>> -     strcpy(tempdir, dir);
>> -     strcat(tempdir, "/");
>> -}
>> -
>> -/*
>> - * Remove bytes from the front of the buffer and refill it so that if there's a
>> - * partial string that we care about, it will be completed, and we can recognize
>> - * it.
>> - */
>> -static int pop(int fd, char *buf, size_t size, size_t npop)
>> -{
>> -     ssize_t n;
>> -     size_t len = strlen(&buf[npop]);
>> -
>> -     memmove(buf, &buf[npop], len + 1);
>> -     n = read(fd, &buf[len], size - len - 1);
>> -     if (n < 0)
>> -             return -errno;
>> -
>> -     buf[len + n] = '\0';
>> -     return 1;
>> -}
>> -
>> -/*
>> - * This will return 1, with the first character in buf being the
>> - * character following the next instance of c in the file.  This will
>> - * read the file as needed.  If there's an error, -errno is returned;
>> - * if the end of the file is reached, 0 is returned.
>> - */
>> -static int next(int fd, char *buf, size_t size, char c)
>> -{
>> -     ssize_t n;
>> -     char *ptr;
>> -
>> -     while ((ptr = strchr(buf, c)) == NULL) {
>> -             n = read(fd, buf, size - 1);
>> -             if (n == 0)
>> -                     return 0;
>> -             else if (n < 0)
>> -                     return -errno;
>> -
>> -             buf[n] = '\0';
>> +     printf("Checking if %s is on tmpfs...", dir);
>> +     if (statfs(dir, &st) < 0) {
>> +             printf("%s\n", strerror(errno));
>> +     } else if (st.f_type != TMPFS_MAGIC) {
>> +             printf("no\n");
>> +     } else {
>> +             printf("OK\n");
>> +             return 0;
>>       }
>> -
>> -     return pop(fd, buf, size, ptr - buf + 1);
>> +     return -1;
>>  }
>>
>>  /*
>> - * Decode an octal-escaped and space-terminated path of the form used by
>> - * /proc/mounts. May be used to decode a path in-place. "out" must be at least
>> - * as large as the input. The output is always null-terminated. "len" gets the
>> - * length of the output, excluding the trailing null. Returns 0 if a full path
>> - * was successfully decoded, otherwise an error.
>> + * Choose the tempdir to use. We want something on tmpfs so that our memory is
>> + * not subject to the host's vm.dirty_ratio. If a tempdir is specified in the
>> + * environment, we use that even if it's not on tmpfs, but we warn the user.
>> + * Otherwise, we try common tmpfs locations, and if no tmpfs directory is found
>> + * then we fall back to /tmp.
>>   */
>> -static int decode_path(const char *in, char *out, size_t *len)
>> +static char * __init choose_tempdir(void)
>>  {
>> -     char *first = out;
>> -     int c;
>> +     static const char * const vars[] = {
>> +             "TMPDIR",
>> +             "TMP",
>> +             "TEMP",
>> +             NULL
>> +     };
>> +     static const char fallback_dir[] = "/tmp";
>> +     static const char * const tmpfs_dirs[] = {
>> +             "/dev/shm",
>> +             fallback_dir,
>> +             NULL
>> +     };
>>       int i;
>> -     int ret = -EINVAL;
>> -     while (1) {
>> -             switch (*in) {
>> -             case '\0':
>> -                     goto out;
>> -
>> -             case ' ':
>> -                     ret = 0;
>> -                     goto out;
>> -
>> -             case '\\':
>> -                     in++;
>> -                     c = 0;
>> -                     for (i = 0; i < 3; i++) {
>> -                             if (*in < '0' || *in > '7')
>> -                                     goto out;
>> -                             c = (c << 3) | (*in++ - '0');
>> -                     }
>> -                     *(unsigned char *)out++ = (unsigned char) c;
>> -                     break;
>> -
>> -             default:
>> -                     *out++ = *in++;
>> -                     break;
>> +     const char *dir;
>> +
>> +     printf("Checking environment variables for a tempdir...");
>> +     for (i = 0; vars[i]; i++) {
>> +             dir = getenv(vars[i]);
>> +             if ((dir != NULL) && (*dir != '\0')) {
>> +                     printf("%s\n", dir);
>> +                     if (check_tmpfs(dir) >= 0)
>> +                             goto done;
>> +                     else
>> +                             goto warn;
>>               }
>>       }
>> +     printf("none found\n");
>>
>> -out:
>> -     *out = '\0';
>> -     *len = out - first;
>> -     return ret;
>> -}
>> -
>> -/*
>> - * Computes the length of s when encoded with three-digit octal escape sequences
>> - * for the characters in chars.
>> - */
>> -static size_t octal_encoded_length(const char *s, const char *chars)
>> -{
>> -     size_t len = strlen(s);
>> -     while ((s = strpbrk(s, chars)) != NULL) {
>> -             len += 3;
>> -             s++;
>> -     }
>> -
>> -     return len;
>> -}
>> -
>> -enum {
>> -     OUTCOME_NOTHING_MOUNTED,
>> -     OUTCOME_TMPFS_MOUNT,
>> -     OUTCOME_NON_TMPFS_MOUNT,
>> -};
>> -
>> -/* Read a line of /proc/mounts data looking for a tmpfs mount at "path". */
>> -static int read_mount(int fd, char *buf, size_t bufsize, const char *path,
>> -                   int *outcome)
>> -{
>> -     int found;
>> -     int match;
>> -     char *space;
>> -     size_t len;
>> -
>> -     enum {
>> -             MATCH_NONE,
>> -             MATCH_EXACT,
>> -             MATCH_PARENT,
>> -     };
>> -
>> -     found = next(fd, buf, bufsize, ' ');
>> -     if (found != 1)
>> -             return found;
>> -
>> -     /*
>> -      * If there's no following space in the buffer, then this path is
>> -      * truncated, so it can't be the one we're looking for.
>> -      */
>> -     space = strchr(buf, ' ');
>> -     if (space) {
>> -             match = MATCH_NONE;
>> -             if (!decode_path(buf, buf, &len)) {
>> -                     if (!strcmp(buf, path))
>> -                             match = MATCH_EXACT;
>> -                     else if (!strncmp(buf, path, len)
>> -                              && (path[len] == '/' || !strcmp(buf, "/")))
>> -                             match = MATCH_PARENT;
>> -             }
>> -
>> -             found = pop(fd, buf, bufsize, space - buf + 1);
>> -             if (found != 1)
>> -                     return found;
>> -
>> -             switch (match) {
>> -             case MATCH_EXACT:
>> -                     if (!strncmp(buf, "tmpfs", strlen("tmpfs")))
>> -                             *outcome = OUTCOME_TMPFS_MOUNT;
>> -                     else
>> -                             *outcome = OUTCOME_NON_TMPFS_MOUNT;
>> -                     break;
>> -
>> -             case MATCH_PARENT:
>> -                     /* This mount obscures any previous ones. */
>> -                     *outcome = OUTCOME_NOTHING_MOUNTED;
>> -                     break;
>> -             }
>> +     for (i = 0; tmpfs_dirs[i]; i++) {
>> +             dir = tmpfs_dirs[i];
>> +             if (check_tmpfs(dir) >= 0)
>> +                     goto done;
>>       }
>>
>> -     return next(fd, buf, bufsize, '\n');
>> +     dir = fallback_dir;
>> +warn:
>> +     printf("Warning: tempdir %s is not on tmpfs\n", dir);
>> +done:
>> +     /* Make a copy since getenv results may not remain valid forever. */
>> +     return strdup(dir);
>>  }
>>
>> -/* which_tmpdir is called only during early boot */
>> -static int checked_tmpdir = 0;
>> -
>>  /*
>> - * Look for a tmpfs mounted at /dev/shm.  I couldn't find a cleaner
>> - * way to do this than to parse /proc/mounts.  statfs will return the
>> - * same filesystem magic number and fs id for both /dev and /dev/shm
>> - * when they are both tmpfs, so you can't tell if they are different
>> - * filesystems.  Also, there seems to be no other way of finding the
>> - * mount point of a filesystem from within it.
>> - *
>> - * If a /dev/shm tmpfs entry is found, then we switch to using it.
>> - * Otherwise, we stay with the default /tmp.
>> + * Create an unlinked tempfile in a suitable tempdir. template must be the
>> + * basename part of the template with a leading '/'.
>>   */
>> -static void which_tmpdir(void)
>> +static int __init make_tempfile(const char *template)
>>  {
>> +     char *tempname;
>>       int fd;
>> -     int found;
>> -     int outcome;
>> -     char *path;
>> -     char *buf;
>> -     size_t bufsize;
>>
>> -     if (checked_tmpdir)
>> -             return;
>> -
>> -     checked_tmpdir = 1;
>> -
>> -     printf("Checking for tmpfs mount on /dev/shm...");
>> -
>> -     path = realpath("/dev/shm", NULL);
>> -     if (!path) {
>> -             printf("failed to check real path, errno = %d\n", errno);
>> -             return;
>> -     }
>> -     printf("%s...", path);
>> -
>> -     /*
>> -      * The buffer needs to be able to fit the full octal-escaped path, a
>> -      * space, and a trailing null in order to successfully decode it.
>> -      */
>> -     bufsize = octal_encoded_length(path, " \t\n\\") + 2;
>> -
>> -     if (bufsize < 128)
>> -             bufsize = 128;
>> -
>> -     buf = malloc(bufsize);
>> -     if (!buf) {
>> -             printf("malloc failed, errno = %d\n", errno);
>> -             goto out;
>> -     }
>> -     buf[0] = '\0';
>> -
>> -     fd = open("/proc/mounts", O_RDONLY);
>> -     if (fd < 0) {
>> -             printf("failed to open /proc/mounts, errno = %d\n", errno);
>> -             goto out1;
>> -     }
>> -
>> -     outcome = OUTCOME_NOTHING_MOUNTED;
>> -     while (1) {
>> -             found = read_mount(fd, buf, bufsize, path, &outcome);
>> -             if (found != 1)
>> -                     break;
>> -     }
>> -
>> -     if (found < 0) {
>> -             printf("read returned errno %d\n", -found);
>> -     } else {
>> -             switch (outcome) {
>> -             case OUTCOME_TMPFS_MOUNT:
>> -                     printf("OK\n");
>> -                     default_tmpdir = "/dev/shm";
>> -                     break;
>> -
>> -             case OUTCOME_NON_TMPFS_MOUNT:
>> -                     printf("not tmpfs\n");
>> -                     break;
>> -
>> -             default:
>> -                     printf("nothing mounted on /dev/shm\n");
>> -                     break;
>> +     if (tempdir == NULL) {
>> +             tempdir = choose_tempdir();
>> +             if (tempdir == NULL) {
>> +                     fprintf(stderr, "Failed to choose tempdir: %s\n",
>> +                             strerror(errno));
>> +                     return -1;
>>               }
>>       }
>>
>> -     close(fd);
>> -out1:
>> -     free(buf);
>> -out:
>> -     free(path);
>> -}
>> -
>> -static int __init make_tempfile(const char *template, char **out_tempname,
>> -                             int do_unlink)
>> -{
>> -     char *tempname;
>> -     int fd;
>> -
>> -     which_tmpdir();
>> -     tempname = malloc(MAXPATHLEN);
>> +     tempname = malloc(strlen(tempdir) + strlen(template) + 1);
>>       if (tempname == NULL)
>>               return -1;
>>
>> -     find_tempdir();
>> -     if ((tempdir == NULL) || (strlen(tempdir) >= MAXPATHLEN))
>> -             goto out;
>> -
>> -     if (template[0] != '/')
>> -             strcpy(tempname, tempdir);
>> -     else
>> -             tempname[0] = '\0';
>> -     strncat(tempname, template, MAXPATHLEN-1-strlen(tempname));
>> +     strcpy(tempname, tempdir);
>> +     strcat(tempname, template);
>>       fd = mkstemp(tempname);
>>       if (fd < 0) {
>>               fprintf(stderr, "open - cannot create %s: %s\n", tempname,
>>                       strerror(errno));
>>               goto out;
>>       }
>> -     if (do_unlink && (unlink(tempname) < 0)) {
>> +     if (unlink(tempname) < 0) {
>>               perror("unlink");
>>               goto close;
>>       }
>> -     if (out_tempname) {
>> -             *out_tempname = tempname;
>> -     } else
>> -             free(tempname);
>> +     free(tempname);
>>       return fd;
>>  close:
>>       close(fd);
>> @@ -351,14 +131,14 @@ out:
>>       return -1;
>>  }
>>
>> -#define TEMPNAME_TEMPLATE "vm_file-XXXXXX"
>> +#define TEMPNAME_TEMPLATE "/vm_file-XXXXXX"
>>
>>  static int __init create_tmp_file(unsigned long long len)
>>  {
>>       int fd, err;
>>       char zero;
>>
>> -     fd = make_tempfile(TEMPNAME_TEMPLATE, NULL, 1);
>> +     fd = make_tempfile(TEMPNAME_TEMPLATE);
>>       if (fd < 0)
>>               exit(1);
>>
>> @@ -402,7 +182,6 @@ int __init create_mem_file(unsigned long long len)
>>       return fd;
>>  }
>>
>> -
>>  void __init check_tmpexec(void)
>>  {
>>       void *addr;
>> @@ -410,14 +189,13 @@ void __init check_tmpexec(void)
>>
>>       addr = mmap(NULL, UM_KERN_PAGE_SIZE,
>>                   PROT_READ | PROT_WRITE | PROT_EXEC, MAP_PRIVATE, fd, 0);
>> -     printf("Checking PROT_EXEC mmap in %s...",tempdir);
>> -     fflush(stdout);
>> +     printf("Checking PROT_EXEC mmap in %s...", tempdir);
>>       if (addr == MAP_FAILED) {
>>               err = errno;
>> -             perror("failed");
>> +             printf("%s\n", strerror(err));
>>               close(fd);
>>               if (err == EPERM)
>> -                     printf("%s must be not mounted noexec\n",tempdir);
>> +                     printf("%s must be not mounted noexec\n", tempdir);
>>               exit(1);
>>       }
>>       printf("OK\n");
>>
>
>
> ------------------------------------------------------------------------------
> DreamFactory - Open Source REST & JSON Services for HTML5 & Native Apps
> OAuth, Users, Roles, SQL, NoSQL, BLOB Storage and External API Access
> Free app hosting. Or install the open source package on any LAMP server.
> Sign up and see examples for AngularJS, jQuery, Sencha Touch and Native!
> http://pubads.g.doubleclick.net/gampad/clk?id=63469471&iu=/4140/ostg.clktrk
> _______________________________________________
> User-mode-linux-devel mailing list
> User-mode-linux-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/user-mode-linux-devel



-- 
Thanks,
//richard
