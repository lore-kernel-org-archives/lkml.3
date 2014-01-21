Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119AbaAUN6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 08:58:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15538 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754382AbaAUN6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 08:58:16 -0500
From: Florian Weimer <fweimer@redhat.com>
Date: Tue, 21 Jan 2014 14:51:25 +0100
Subject: [PATCH 0/3] Implement the f*xattrat family of functions
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Message-Id: <20140121135811.1261F401159C6@oldenburg.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To my knowledge, it is not possible to implement AT_EMPTY_PATH in
userspace in a race-free manner (even with the /proc/self/fd kludge), so
I'd like to add the for missing system calls.

coreutils, libselinux and policycoreutils need these interfaces to
address some corner cases.

I will wire up ppc64 and s390x in a second round.  I can't test other
architectures.  I'll submit glibc and strace patches as well, once this
is in.  Anything else that needs to be taken care of?

This is the test program I used:

#include <errno.h>
#include <fcntl.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/xattr.h>
#include <sys/xattr.h>
#include <unistd.h>

#include <asm/unistd.h>

#ifndef O_PATH
#define O_PATH 010000000
#endif

#ifndef AT_EMPTY_PATH
#define AT_EMPTY_PATH 0x1000
#endif

#define EXPECT_FAIL(code, ret) expect_fail((code), (ret), __FILE__, __LINE__)

static void
expect_fail(int code, long ret, const char *file, int line)
{
  if (ret != -1) {
    fprintf(stderr, "%s:%d: unexpected success\n", file, line);
    abort();
  }
  if (errno != code) {
    fprintf(stderr, "%s:%d: unexpected errno=%d (%s)\n",
            file, line, errno, strerror(errno));
    abort();
  }
}

#define EXPECT_CHECK(expr) expect_check(!!(expr), __FILE__, __LINE__)

static void
expect_check(int expr, const char *file, int line)
{
  if (!expr) {
    fprintf(stderr, "%s:%d: unexpected failure errno=%d (%s)\n",
            file, line, errno, strerror(errno));
    abort();
  }
}

#define EXPECT_SUCCESS(ret) expect_success((ret), __FILE__, __LINE__)

static long
expect_success(long ret, const char *file, int line)
{
  if (ret == -1) {
    fprintf(stderr, "%s:%d: unexpected failure ret=%ld errno=%d (%s)\n",
            file, line, ret, errno, strerror(errno));
    abort();
  }
  return ret;
}

#define VERIFY(expr) verify(!!(expr), __FILE__, __LINE__)

static void
verify(int check, const char *file, int line)
{
  if (!check) {
    fprintf(stderr, "%s:%d: failure\n", file, line);
    abort();
  }
}

static char tempdir[128];
static int dirfd;

static void
setup(void)
{
  // Use /var/tmp because it is less likely to be backed by tmpfs.
  snprintf(tempdir, sizeof(tempdir), "/var/tmp/fsetxattr-test.XXXXXX");
  EXPECT_CHECK(mkdtemp(tempdir) != NULL);
  dirfd = EXPECT_SUCCESS(open(tempdir, O_DIRECTORY | O_RDONLY | O_CLOEXEC));
  int filefd;
  filefd = EXPECT_SUCCESS(openat(dirfd, "file1",
                                 O_WRONLY | O_CREAT | O_CLOEXEC, 0666));
  EXPECT_SUCCESS(close(filefd));
  filefd = EXPECT_SUCCESS(openat(dirfd, "file2",
                                 O_WRONLY | O_CREAT | O_CLOEXEC, 0666));
  EXPECT_SUCCESS(symlinkat("file1", dirfd, "symlink1"));
  EXPECT_SUCCESS(symlinkat("does-not-exist", dirfd, "symlink3"));
}

static void
cleanup(void)
{
  EXPECT_SUCCESS(unlinkat(dirfd, "file1", 0));
  EXPECT_SUCCESS(unlinkat(dirfd, "file2", 0));
  EXPECT_SUCCESS(unlinkat(dirfd, "symlink1", 0));
  EXPECT_SUCCESS(unlinkat(dirfd, "symlink3", 0));
  EXPECT_SUCCESS(close(dirfd));
  EXPECT_SUCCESS(rmdir(tempdir));
}

static void
check_attr(const char *path, const char *attrname, const char *attrvalue,
           int flags)
{
  char buf[128];
  memset(buf, 'X', sizeof(buf));
  ssize_t ret = syscall(__NR_fgetxattrat, dirfd, path, attrname,
                        buf, sizeof(buf), flags);
  if (attrvalue == NULL) {
    EXPECT_FAIL(ENODATA, ret);
  } else {
    EXPECT_SUCCESS(ret);
    VERIFY((size_t)ret == strlen(attrvalue));
    VERIFY(memcmp(buf, attrvalue, ret) == 0);
    for (unsigned i = ret; i < sizeof(buf); ++i) {
      VERIFY(buf[i] == 'X');
    }
  }
}


struct expected_list {
  size_t length;
  const char *data;
};

#define EXPECTED_LIST(string) \
  (&(struct expected_list){.length = sizeof(string), .data = (string)})

static void
check_attr_list(const char *path, const struct expected_list *exp, int flags)
{
  char buf[4096];
  memset(buf, 'X', sizeof(buf));
  ssize_t ret = syscall(__NR_flistxattrat, dirfd, path,
                        buf, sizeof(buf), flags);
  EXPECT_SUCCESS(ret);
  VERIFY((size_t)ret <= sizeof(buf));
  unsigned buf_count = 0;
  unsigned exp_count = 0;
  for (unsigned bufpos = 0; bufpos < ret;
       bufpos += strlen(buf + bufpos) + 1) {
    bool found = false;
    ++buf_count;
    exp_count = 0;
    for (unsigned exppos = 0; exppos < exp->length;
         exppos += strlen(exp->data + exppos) + 1) {
      ++exp_count;
      if (strcmp(exp->data + exppos, buf + bufpos) == 0) {
        found = true;
      }
    }
    VERIFY(found);
  }
  VERIFY(buf_count == exp_count);
}

static void
check_without_at(void)
{
  int curdirfd = open(".", O_DIRECTORY | O_CLOEXEC);
  EXPECT_SUCCESS(curdirfd);
  EXPECT_SUCCESS(fchdir(dirfd));
  // The EPERM failure might be specific to XFS.
  EXPECT_FAIL(EPERM, lsetxattr("symlink1", "user.test-attr",
                               "symlink1-attr", strlen("symlink1-attr"), 0));
  EXPECT_SUCCESS(fchdir(curdirfd));
  EXPECT_SUCCESS(close(curdirfd));
}

static void
check_at_directory(void)
{
  const char *attrname = "user.attr-name";

  check_attr("file1", attrname, NULL, 0);
  check_attr("file1", attrname, NULL, AT_SYMLINK_NOFOLLOW);
  check_attr("file1", attrname, NULL, AT_EMPTY_PATH);
  check_attr("file1", attrname, NULL, AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH);
  check_attr("symlink1", attrname, NULL, 0);
  check_attr("symlink1", attrname, NULL, AT_SYMLINK_NOFOLLOW);
  check_attr("symlink1", attrname, NULL, AT_EMPTY_PATH);
  check_attr("symlink1", attrname, NULL, AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH);
  check_attr_list("file1", EXPECTED_LIST(""), 0);
  check_attr_list("file1", EXPECTED_LIST(""), AT_SYMLINK_NOFOLLOW);
  check_attr_list("file1", EXPECTED_LIST(""), AT_EMPTY_PATH);
  check_attr_list("file1", EXPECTED_LIST(""),
                  AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH);
  check_attr_list("symlink1", EXPECTED_LIST(""), 0);
  check_attr_list("symlink1", EXPECTED_LIST(""), AT_SYMLINK_NOFOLLOW);
  check_attr_list("symlink1", EXPECTED_LIST(""), AT_EMPTY_PATH);
  check_attr_list("symlink1", EXPECTED_LIST(""),
                  AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH);

  EXPECT_SUCCESS(syscall(__NR_fsetxattrat, dirfd, "file1",
                         attrname, "file1-attr", strlen("file1-attr"), 0));

  check_attr("file1", attrname, "file1-attr", 0);
  check_attr("file1", attrname, "file1-attr", AT_SYMLINK_NOFOLLOW);
  check_attr("file1", attrname, "file1-attr", AT_EMPTY_PATH);
  check_attr("file1", attrname, "file1-attr",
             AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH);
  check_attr("symlink1", attrname, "file1-attr", 0);
  check_attr("symlink1", attrname, NULL, AT_SYMLINK_NOFOLLOW);
  check_attr("symlink1", attrname, "file1-attr", AT_EMPTY_PATH);
  check_attr("symlink1", attrname, NULL, AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH);

  // Listing attributes.
  check_attr_list("file1", EXPECTED_LIST("user.attr-name"), 0);
  check_attr_list("file1", EXPECTED_LIST("user.attr-name"),
                  AT_SYMLINK_NOFOLLOW);
  check_attr_list("file1", EXPECTED_LIST("user.attr-name"), AT_EMPTY_PATH);
  check_attr_list("file1", EXPECTED_LIST("user.attr-name"),
                  AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH);
  check_attr_list("symlink1", EXPECTED_LIST("user.attr-name"), 0);
  check_attr_list("symlink1", EXPECTED_LIST("user.attr-name"),
                  AT_SYMLINK_NOFOLLOW);
  check_attr_list("symlink1", EXPECTED_LIST("user.attr-name"), AT_EMPTY_PATH);
  check_attr_list("symlink1", EXPECTED_LIST("user.attr-name"),
                  AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH);

  // Listing multiple attributes.
  EXPECT_SUCCESS(syscall(__NR_fsetxattrat, dirfd, "file2",
                         "user.k1", "v1", 2, 0));
  EXPECT_SUCCESS(syscall(__NR_fsetxattrat, dirfd, "file2",
                         "user.k2", "v2", 2, 0));
  check_attr_list("file2", EXPECTED_LIST("user.k1\000user.k2"), 0);

  // Attributes on symlinks are not supported.
  EXPECT_FAIL(EPERM, syscall(__NR_fsetxattrat, dirfd, "symlink1",
                         attrname, "symlink1-attr", strlen("symlink1-attr"),
                         AT_SYMLINK_NOFOLLOW));
  check_attr("file1", attrname, "file1-attr", 0);
  check_attr("symlink1", attrname, "file1-attr", 0);
  check_attr("symlink1", attrname, NULL, AT_SYMLINK_NOFOLLOW);

  // Attribute removal.
  EXPECT_SUCCESS(syscall(__NR_fremovexattrat, dirfd, "file1",
                         attrname, 0));
  check_attr("file1", attrname, NULL, 0);
  EXPECT_SUCCESS(syscall(__NR_fsetxattrat, dirfd, "file1",
                         attrname, "file1-attr", strlen("file1-attr"), 0));
  EXPECT_SUCCESS(syscall(__NR_fremovexattrat, dirfd, "file1",
                         attrname, AT_SYMLINK_NOFOLLOW));
  check_attr("file1", attrname, NULL, 0);
  EXPECT_SUCCESS(syscall(__NR_fsetxattrat, dirfd, "file1",
                         attrname, "file1-attr", strlen("file1-attr"), 0));
  EXPECT_SUCCESS(syscall(__NR_fremovexattrat, dirfd, "file1",
                         attrname, AT_EMPTY_PATH));
  check_attr("file1", attrname, NULL, 0);
  EXPECT_SUCCESS(syscall(__NR_fsetxattrat, dirfd, "file1",
                         attrname, "file1-attr", strlen("file1-attr"), 0));
  EXPECT_SUCCESS(syscall(__NR_fremovexattrat, dirfd, "file1",
                         attrname, AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH));
  check_attr("file1", attrname, NULL, 0);
  EXPECT_SUCCESS(syscall(__NR_fsetxattrat, dirfd, "file1",
                         attrname, "file1-attr", strlen("file1-attr"), 0));

  // Replacement and creation.
  EXPECT_SUCCESS(syscall(__NR_fsetxattrat, dirfd, "file1",
                         attrname, "file1-attr", strlen("file1-attr"), 0));
  check_attr("file1", attrname, "file1-attr", 0);
  EXPECT_SUCCESS(syscall(__NR_fsetxattrat, dirfd, "file1",
                         attrname, "file1-attr-1", strlen("file1-attr-1"),
                         XATTR_REPLACE));
  check_attr("file1", attrname, "file1-attr-1", 0);
  EXPECT_FAIL(EEXIST, syscall(__NR_fsetxattrat, dirfd, "file1",
                              attrname, "file1-attr", strlen("file1-attr-2"),
                              XATTR_CREATE));
  check_attr("file1", attrname, "file1-attr-1", 0);
  EXPECT_SUCCESS(syscall(__NR_fremovexattrat, dirfd, "file1", attrname, 0));
  EXPECT_FAIL(ENODATA, syscall(__NR_fsetxattrat, dirfd, "file1",
                               attrname, "file1-attr-1", strlen("file1-attr-1"),
                               XATTR_REPLACE));
  check_attr("file1", attrname, NULL, 0);

  // Replacement and creation through symlinks.
  EXPECT_SUCCESS(syscall(__NR_fsetxattrat, dirfd, "symlink1",
                         attrname, "file1-attr", strlen("file1-attr"), 0));
  check_attr("file1", attrname, "file1-attr", 0);
  EXPECT_SUCCESS(syscall(__NR_fsetxattrat, dirfd, "symlink1",
                         attrname, "file1-attr-1", strlen("file1-attr-1"),
                         XATTR_REPLACE));
  check_attr("file1", attrname, "file1-attr-1", 0);
  EXPECT_FAIL(EEXIST, syscall(__NR_fsetxattrat, dirfd, "symlink1",
                              attrname, "file1-attr", strlen("file1-attr-2"),
                              XATTR_CREATE));
  check_attr("file1", attrname, "file1-attr-1", 0);
  EXPECT_SUCCESS(syscall(__NR_fsetxattrat, dirfd, "symlink1",
                         attrname, "file1-attr-2", strlen("file1-attr-2"),
                         XATTR_REPLACE));
  check_attr("file1", attrname, "file1-attr-2", 0);
  EXPECT_SUCCESS(syscall(__NR_fremovexattrat, dirfd, "symlink1", attrname, 0));
  EXPECT_FAIL(ENODATA, syscall(__NR_fsetxattrat, dirfd, "symlink1",
                               attrname, "file1-attr-1", strlen("file1-attr-1"),
                               XATTR_REPLACE));
  check_attr("file1", attrname, NULL, 0);

  // Attribute removal through symlink.
  EXPECT_SUCCESS(syscall(__NR_fsetxattrat, dirfd, "file1",
                         attrname, "file1-attr", strlen("file1-attr"), 0));
  EXPECT_FAIL(EPERM, syscall(__NR_fremovexattrat, dirfd, "symlink1",
                               attrname, AT_SYMLINK_NOFOLLOW));
  check_attr("file1", attrname, "file1-attr", 0);
  EXPECT_FAIL(EPERM, syscall(__NR_fremovexattrat, dirfd, "symlink1",
                               attrname, AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH));
  check_attr("file1", attrname, "file1-attr", 0);
  EXPECT_SUCCESS(syscall(__NR_fremovexattrat, dirfd, "symlink1",
                               attrname, 0));
  check_attr("file1", attrname, NULL, 0);
  EXPECT_SUCCESS(syscall(__NR_fsetxattrat, dirfd, "file1",
                         attrname, "file1-attr", strlen("file1-attr"), 0));
  EXPECT_SUCCESS(syscall(__NR_fremovexattrat, dirfd, "symlink1",
                               attrname, AT_EMPTY_PATH));
  check_attr("file1", attrname, NULL, 0);
}

static void
check_at_path_file(const char *name)
{
  const char *attrname = "user.attr-name";
  char buf[128];
  int fd = openat(dirfd, name, O_PATH | O_CLOEXEC);
  EXPECT_SUCCESS(fd);

  // Classic f* functions must not work with O_PATH.
  EXPECT_FAIL(EBADF, fsetxattr(fd, attrname,
                               "file1-attr", strlen("file1-attr"), 0));
  EXPECT_FAIL(EBADF, fsetxattr(fd, attrname,
                               "file1-attr", strlen("file1-attr"),
                               XATTR_REPLACE));
  EXPECT_FAIL(EBADF, fsetxattr(fd, attrname,
                               "file1-attr", strlen("file1-attr"),
                               XATTR_CREATE));
  EXPECT_FAIL(EBADF, fgetxattr(fd, attrname, buf, sizeof(buf)));
  EXPECT_FAIL(EBADF, flistxattr(fd, buf, sizeof(buf)));
  EXPECT_FAIL(EBADF, fremovexattr(fd, attrname));

  // The f*at functions must not work with O_PATH if AT_EMPTY_PATH is
  // not specified.
  EXPECT_FAIL(ENOENT, syscall(__NR_fsetxattrat, fd, "", attrname,
                              "file1-attr", strlen("file1-attr"), 0));
  EXPECT_FAIL(ENOENT, syscall(__NR_fsetxattrat, fd, "", attrname,
                              "file1-attr", strlen("file1-attr"),
                              XATTR_REPLACE));
  EXPECT_FAIL(ENOENT, syscall(__NR_fsetxattrat, fd, "", attrname,
                              "file1-attr", strlen("file1-attr"),
                              XATTR_CREATE));
  EXPECT_FAIL(ENOENT, syscall(__NR_fgetxattrat, fd, "", attrname,
                              buf, sizeof(buf), 0));
  EXPECT_FAIL(ENOENT, syscall(__NR_flistxattrat, fd, "",
                              buf, sizeof(buf), 0));
  EXPECT_FAIL(ENOENT, syscall(__NR_fremovexattrat, fd, "", attrname, 0));

  // Once more, with ".".
  EXPECT_FAIL(ENOTDIR, syscall(__NR_fsetxattrat, fd, ".", attrname,
                               "file1-attr", strlen("file1-attr"), 0));
  EXPECT_FAIL(ENOTDIR, syscall(__NR_fsetxattrat, fd, ".", attrname,
                               "file1-attr", strlen("file1-attr"),
                               XATTR_REPLACE));
  EXPECT_FAIL(ENOTDIR, syscall(__NR_fsetxattrat, fd, ".", attrname,
                               "file1-attr", strlen("file1-attr"),
                               XATTR_CREATE));
  EXPECT_FAIL(ENOTDIR, syscall(__NR_fgetxattrat, fd, ".", attrname,
                               buf, sizeof(buf), 0));
  EXPECT_FAIL(ENOTDIR, syscall(__NR_flistxattrat, fd, ".",
                               buf, sizeof(buf), 0));
  EXPECT_FAIL(ENOTDIR, syscall(__NR_fremovexattrat, fd, ".", attrname, 0));

  // Now tests that are supposed to succeed (at least in part).
  check_attr("file1", attrname, NULL, 0);
  EXPECT_SUCCESS(syscall(__NR_fsetxattrat, fd, "",
                         attrname, "file1-attr", strlen("file1-attr"),
                         AT_EMPTY_PATH));
  check_attr("file1", attrname, "file1-attr", 0);
  EXPECT_SUCCESS(syscall(__NR_fsetxattrat, fd, "", attrname,
                         "file1-attr-2", strlen("file1-attr-2"),
                         AT_EMPTY_PATH | XATTR_REPLACE));
  check_attr("file1", attrname, "file1-attr-2", 0);
  EXPECT_FAIL(EEXIST, syscall(__NR_fsetxattrat, fd, "", attrname,
                              "file1-attr-3", strlen("file1-attr-3"),
                              AT_EMPTY_PATH | XATTR_CREATE));
  check_attr("file1", attrname, "file1-attr-2", 0);
  EXPECT_SUCCESS(syscall(__NR_fremovexattrat, fd, "", attrname,
                         AT_EMPTY_PATH));
  EXPECT_FAIL(ENODATA, syscall(__NR_fsetxattrat, fd, "", attrname,
                               "file1-attr-3", strlen("file1-attr-3"),
                               AT_EMPTY_PATH | XATTR_REPLACE));
  check_attr("file1", attrname, NULL, 0);

  // Compare two different ways for listing attributes.
  {
    char buf1[128];
    char buf2[128];
    ssize_t ret1;
    ssize_t ret2;
    EXPECT_SUCCESS(syscall(__NR_fsetxattrat, fd, "",
                           "user.k1", "v1", 2, AT_EMPTY_PATH));
    EXPECT_SUCCESS(syscall(__NR_fsetxattrat, fd, "",
                           "user.k2", "v2", 2, AT_EMPTY_PATH));
    check_attr_list("file1", EXPECTED_LIST("user.k1\000user.k2"), 0);
    ret1 = syscall(__NR_flistxattrat, dirfd, "file1",
                   buf1, sizeof(buf1), 0);
    EXPECT_SUCCESS(ret1);
    VERIFY((size_t)ret1 < sizeof(buf1));
    ret2 = syscall(__NR_flistxattrat, fd, "",
                   buf2, sizeof(buf2), AT_EMPTY_PATH);
    EXPECT_SUCCESS(ret2);
    VERIFY(ret1 == ret2);
    VERIFY(memcmp(buf1, buf2, ret1) == 0);
    EXPECT_SUCCESS(syscall(__NR_fremovexattrat, fd, "", "user.k1",
                           AT_EMPTY_PATH));
    EXPECT_SUCCESS(syscall(__NR_fremovexattrat, fd, "", "user.k2",
                           AT_EMPTY_PATH));
  }

  EXPECT_SUCCESS(close(fd));
}

static void
check_at_path_symlink(void)
{
  const char *attrname = "user.attr-name";
  char buf[128];
  ssize_t ret;
  int fd = openat(dirfd, "symlink1", O_PATH | O_CLOEXEC | O_NOFOLLOW);
  EXPECT_SUCCESS(fd);
  {
    struct stat st;
    EXPECT_SUCCESS(fstatat(fd, "", &st, AT_EMPTY_PATH));
    VERIFY(S_ISLNK(st.st_mode));
  }


  // The f*at functions must not work with O_PATH if AT_EMPTY_PATH is
  // not specified.
  EXPECT_FAIL(ENOENT, syscall(__NR_fsetxattrat, fd, "", attrname,
                              "file1-attr", strlen("file1-attr"),
                              AT_SYMLINK_NOFOLLOW));
  EXPECT_FAIL(ENOENT, syscall(__NR_fsetxattrat, fd, "", attrname,
                              "file1-attr", strlen("file1-attr"),
                              AT_SYMLINK_NOFOLLOW | XATTR_REPLACE));
  EXPECT_FAIL(ENOENT, syscall(__NR_fsetxattrat, fd, "", attrname,
                              "file1-attr", strlen("file1-attr"),
                              AT_SYMLINK_NOFOLLOW | XATTR_CREATE));
  EXPECT_FAIL(ENOENT, syscall(__NR_fgetxattrat, fd, "", attrname,
                              buf, sizeof(buf), AT_SYMLINK_NOFOLLOW));
  EXPECT_FAIL(ENOENT, syscall(__NR_flistxattrat, fd, "",
                              buf, sizeof(buf), AT_SYMLINK_NOFOLLOW));
  EXPECT_FAIL(ENOENT, syscall(__NR_fremovexattrat, fd, "", attrname,
                              AT_SYMLINK_NOFOLLOW));

  // Once more, with ".".
  EXPECT_FAIL(ENOTDIR, syscall(__NR_fsetxattrat, fd, ".", attrname,
                               "file1-attr", strlen("file1-attr"),
                               AT_SYMLINK_NOFOLLOW));
  EXPECT_FAIL(ENOTDIR, syscall(__NR_fsetxattrat, fd, ".", attrname,
                               "file1-attr", strlen("file1-attr"),
                               AT_SYMLINK_NOFOLLOW | XATTR_REPLACE));
  EXPECT_FAIL(ENOTDIR, syscall(__NR_fsetxattrat, fd, ".", attrname,
                               "file1-attr", strlen("file1-attr"),
                               AT_SYMLINK_NOFOLLOW | XATTR_CREATE));
  EXPECT_FAIL(ENOTDIR, syscall(__NR_fgetxattrat, fd, ".", attrname,
                               buf, sizeof(buf), AT_SYMLINK_NOFOLLOW));
  EXPECT_FAIL(ENOTDIR, syscall(__NR_flistxattrat, fd, ".",
                               buf, sizeof(buf), AT_SYMLINK_NOFOLLOW));
  EXPECT_FAIL(ENOTDIR, syscall(__NR_fremovexattrat, fd, ".", attrname,
                               AT_SYMLINK_NOFOLLOW));

  // Operations directly on the symlink.  First setup.
  EXPECT_SUCCESS(syscall(__NR_fsetxattrat, dirfd, "file1",
                         attrname, "preserve", strlen("preserve"),
                         AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH));
  check_attr("file1", attrname, "preserve", 0);
  //
  EXPECT_FAIL(EPERM, syscall(__NR_fsetxattrat, fd, "",
                             attrname, "file1-attr", strlen("file1-attr"),
                             AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH));
  EXPECT_FAIL(EPERM, syscall(__NR_fremovexattrat, fd, "", attrname,
                             AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH));
  memset(buf, 'X', sizeof(buf));
  ret = syscall(__NR_flistxattrat, fd, "", buf, sizeof(buf),
                AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH);
  EXPECT_SUCCESS(ret);
  VERIFY(ret == 0);
  for (unsigned i = 0; i < sizeof(buf); ++i) {
    VERIFY(buf[i] == 'X');
  }
  //
  check_attr("file1", attrname, "preserve", 0);

  EXPECT_SUCCESS(close(fd));
}

int
main(void)
{
  setup();
  check_without_at();
  check_at_directory();
  cleanup();

  setup();
  check_at_path_file("file1");
  cleanup();

  setup();
  check_at_path_file("symlink1");
  cleanup();

  setup();
  check_at_path_symlink();
  cleanup();
  return 0;
}


Florian Weimer (3):
  vfs: Introduce XATTR_SET_MASK
  vfs: Implement fsetxattrat, fgetxattrat, flistxattrat, fremovexattrat
  x86: wire fsetxattrat, fgetxattrat, flistxattrat, fremovexattrat
    syscalls

 arch/x86/syscalls/syscall_32.tbl |   4 ++
 arch/x86/syscalls/syscall_64.tbl |   4 ++
 fs/xattr.c                       | 126 ++++++++++++++++++++++++++++++++++++++-
 3 files changed, 133 insertions(+), 1 deletion(-)

-- 
1.8.3.1

