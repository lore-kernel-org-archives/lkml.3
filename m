Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbaBLRRr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 12:17:47 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:32984 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbaBLRRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 12:17:44 -0500
Date: Wed, 12 Feb 2014 18:18:52 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: Dave Chinner <david@fromorbit.com>
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        bfields@fieldses.org, hch@infradead.org, akpm@linux-foundation.org,
        dhowells@redhat.com, zab@redhat.com, jack@suse.cz, luto@amacapital.net,
        mszeredi@suse.cz
Subject: Re: [PATCH 00/13] cross rename v4
Message-ID: <20140212171852.GA4026@tucsk.piliscsaba.szeredi.hu>
References: <1391791751-2533-1-git-send-email-miklos@szeredi.hu>
 <20140210105145.GW13997@dastard>
 <20140211160141.GD8204@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140211160141.GD8204@tucsk.piliscsaba.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 05:01:41PM +0100, Miklos Szeredi wrote:
> On Mon, Feb 10, 2014 at 09:51:45PM +1100, Dave Chinner wrote:

> > Miklos, can you please write an xfstest for this new API? That way
> > we can verify that the behaviour is as documented, and we can ensure
> > that when we implement it on other filesystems it works exactly the
> > same on all filesystems?

This is a standalone testprog, but I guess it's trivial to integrate into
xfstests.

Please let me know what you think.

Thanks,
Miklos
----

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <dirent.h>
#include <utime.h>
#include <errno.h>
#include <assert.h>
#include <sys/types.h>
#include <sys/stat.h>


static char testfile[1024];
static char testfile2[1024];
static char testdir[1024];
static char testdir2[1024];

static char testname[256];
static char testdata[] = "abcdefghijklmnopqrstuvwxyz";
static char testdata2[] = "1234567890-=qwertyuiop[]\asdfghjkl;'zxcvbnm,./";
static const char *testdir_files[] = { "f1", "f2", NULL};
static const char *testdir_files2[] = { "f3", "f4", "f5", NULL};
static const char *testdir_empty[] = { NULL};
static int testdatalen = sizeof(testdata) - 1;
static int testdata2len = sizeof(testdata2) - 1;
static unsigned int testnum = 1;
static unsigned int select_test = 0;
static unsigned int skip_test = 0;

#define swap(a, b) \
	do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)

#define MAX_ENTRIES 1024

static void test_perror(const char *func, const char *msg)
{
	printf("%s %s() - %s: %s\n", testname, func, msg,
	       strerror(errno));
}

static void test_error(const char *func, const char *msg, ...)
	__attribute__ ((format (printf, 2, 3)));

static void __start_test(const char *fmt, ...)
	__attribute__ ((format (printf, 1, 2)));

static void test_error(const char *func, const char *msg, ...)
{
	va_list ap;
	printf("%s %s() - ", testname, func);
	va_start(ap, msg);
	vfprintf(stdout, msg, ap);
	va_end(ap);
	fprintf(stdout, "\n");
}

static void success(void)
{
	printf("%s OK\n", testname);
}

static void __start_test(const char *fmt, ...)
{
	unsigned int n;
	va_list ap;
	n = sprintf(testname, "%3i [", testnum++);
	va_start(ap, fmt);
	n += vsprintf(testname + n, fmt, ap);
	va_end(ap);
	sprintf(testname + n, "]");
}

#define start_test(msg, args...) { \
	if ((select_test && testnum != select_test) || \
	    (testnum == skip_test)) { \
		testnum++; \
		return 0; \
	} \
	__start_test(msg, ##args);		\
}

#define PERROR(msg) test_perror(__FUNCTION__, msg)
#define ERROR(msg, args...) test_error(__FUNCTION__, msg, ##args)

static int check_size(const char *path, int len)
{
	struct stat stbuf;
	int res = stat(path, &stbuf);
	if (res == -1) {
		PERROR("stat");
		return -1;
	}
	if (stbuf.st_size != len) {
		ERROR("length %u instead of %u", (int) stbuf.st_size,
		      (int) len);
		return -1;
	}
	return 0;
}

static int check_type(const char *path, mode_t type)
{
	struct stat stbuf;
	int res = lstat(path, &stbuf);
	if (res == -1) {
		PERROR("lstat");
		return -1;
	}
	if ((stbuf.st_mode & S_IFMT) != type) {
		ERROR("type 0%o instead of 0%o", stbuf.st_mode & S_IFMT, type);
		return -1;
	}
	return 0;
}
static int check_mode(const char *path, mode_t mode)
{
	struct stat stbuf;
	int res = lstat(path, &stbuf);
	if (res == -1) {
		PERROR("lstat");
		return -1;
	}
	if ((stbuf.st_mode & 07777) != mode) {
		ERROR("mode 0%o instead of 0%o", stbuf.st_mode & 07777, mode);
		return -1;
	}
	return 0;
}

static int check_nlink(const char *path, nlink_t nlink)
{
	struct stat stbuf;
	int res = lstat(path, &stbuf);
	if (res == -1) {
		PERROR("lstat");
		return -1;
	}
	if (stbuf.st_nlink != nlink) {
		ERROR("nlink %li instead of %li", (long) stbuf.st_nlink,
		      (long) nlink);
		return -1;
	}
	return 0;
}

static int check_nonexist(const char *path)
{
	struct stat stbuf;
	int res = lstat(path, &stbuf);
	if (res == 0) {
		ERROR("file should not exist");
		return -1;
	}
	if (errno != ENOENT) {
		ERROR("file should not exist: %s", strerror(errno));
		return -1;
	}
	return 0;
}

static int check_buffer(const char *buf, const char *data, unsigned len)
{
	if (memcmp(buf, data, len) != 0) {
		ERROR("data mismatch");
		return -1;
	}
	return 0;
}

static int check_data(const char *path, const char *data, int offset,
		      unsigned len)
{
	char buf[4096];
	int res;
	int fd = open(path, O_RDONLY);
	if (fd == -1) {
		PERROR("open");
		return -1;
	}
	if (lseek(fd, offset, SEEK_SET) == (off_t) -1) {
		PERROR("lseek");
		close(fd);
		return -1;
	}
	while (len) {
		int rdlen = len < sizeof(buf) ? len : sizeof(buf);
		res = read(fd, buf, rdlen);
		if (res == -1) {
			PERROR("read");
			close(fd);
			return -1;
		}
		if (res != rdlen) {
			ERROR("short read: %u instead of %u", res, rdlen);
			close(fd);
			return -1;
		}
		if (check_buffer(buf, data, rdlen) != 0) {
			close(fd);
			return -1;
		}
		data += rdlen;
		len -= rdlen;
	}
	res = close(fd);
	if (res == -1) {
		PERROR("close");
		return -1;
	}
	return 0;
}

static int check_dir_contents(const char *path, const char **contents)
{
	int i;
	int res;
	int err = 0;
	int found[MAX_ENTRIES];
	const char *cont[MAX_ENTRIES];
	DIR *dp;

	for (i = 0; contents[i]; i++) {
		assert(i < MAX_ENTRIES - 3);
		found[i] = 0;
		cont[i] = contents[i];
	}
	found[i] = 0;
	cont[i++] = ".";
	found[i] = 0;
	cont[i++] = "..";
	cont[i] = NULL;

	dp = opendir(path);
	if (dp == NULL) {
		PERROR("opendir");
		return -1;
	}
	memset(found, 0, sizeof(found));
	while(1) {
		struct dirent *de;
		errno = 0;
		de = readdir(dp);
		if (de == NULL) {
			if (errno) {
				PERROR("readdir");
				closedir(dp);
				return -1;
			}
			break;
		}
		for (i = 0; cont[i] != NULL; i++) {
			assert(i < MAX_ENTRIES);
			if (strcmp(cont[i], de->d_name) == 0) {
				if (found[i]) {
					ERROR("duplicate entry <%s>",
					      de->d_name);
					err--;
				} else
					found[i] = 1;
				break;
			}
		}
		if (!cont[i]) {
			ERROR("unexpected entry <%s>", de->d_name);
			err --;
		}
	}
	for (i = 0; cont[i] != NULL; i++) {
		if (!found[i]) {
			ERROR("missing entry <%s>", cont[i]);
			err--;
		}
	}
	res = closedir(dp);
	if (res == -1) {
		PERROR("closedir");
		return -1;
	}
	if (err)
		return -1;

	return 0;
}

static int create_file(const char *path, const char *data, int len)
{
	int res;
	int fd;

	unlink(path);
	fd = open(path, O_CREAT | O_WRONLY | O_TRUNC | O_EXCL, 0644);
	if (fd == -1) {
		PERROR("creat");
		return -1;
	}
	if (len) {
		res = write(fd, data, len);
		if (res == -1) {
			PERROR("write");
			close(fd);
			return -1;
		}
		if (res != len) {
			ERROR("write is short: %u instead of %u", res, len);
			close(fd);
			return -1;
		}
	}
	res = close(fd);
	if (res == -1) {
		PERROR("close");
		return -1;
	}
	res = check_type(path, S_IFREG);
	if (res == -1)
		return -1;
	res = check_mode(path, 0644);
	if (res == -1)
		return -1;
	res = check_nlink(path, 1);
	if (res == -1)
		return -1;
	res = check_size(path, len);
	if (res == -1)
		return -1;

	if (len) {
		res = check_data(path, data, 0, len);
		if (res == -1)
			return -1;
	}

	return 0;
}

static int cleanup_dir(const char *path, const char **dir_files, int quiet)
{
	int i;
	int err = 0;

	for (i = 0; dir_files[i]; i++) {
		int res;
		char fpath[1024];
		sprintf(fpath, "%s/%s", path, dir_files[i]);
		res = unlink(fpath);
		if (res == -1 && !quiet) {
			PERROR("unlink");
			err --;
		}
	}
	if (err)
		return -1;

	return 0;
}

static int create_dir(const char *path, const char **dir_files)
{
	int res;
	int i;

	rmdir(path);
	res = mkdir(path, 0755);
	if (res == -1) {
		PERROR("mkdir");
		return -1;
	}
	res = check_type(path, S_IFDIR);
	if (res == -1)
		return -1;
	res = check_mode(path, 0755);
	if (res == -1)
		return -1;

	for (i = 0; dir_files[i]; i++) {
		char fpath[1024];
		sprintf(fpath, "%s/%s", path, dir_files[i]);
		res = create_file(fpath, "", 0);
		if (res == -1) {
			cleanup_dir(path, dir_files, 1);
			return -1;
		}
	}
	res = check_dir_contents(path, dir_files);
	if (res == -1) {
		cleanup_dir(path, dir_files, 1);
		return -1;
	}

	return 0;
}

static void cleanup_one(const char *path)
{
	int res;

	res = unlink(path);
	if (res == -1 && errno != ENOENT) {
		res = rmdir(path);
		if (res == -1) {
			DIR *dp = opendir(path);
			if (dp != NULL) {
				int fd = dirfd(dp);
				while (1) {
					struct dirent *de = readdir(dp);
					if (de == NULL)
						break;
					res = unlinkat(fd, de->d_name, 0);
					if (res == -1) {
						unlinkat(fd, de->d_name,
							 AT_REMOVEDIR);
					}
				}
				closedir(dp);
				rmdir(path);
			}
		}
	}
}

static void cleanup(void)
{
	cleanup_one(testfile);
	cleanup_one(testfile2);
	cleanup_one(testdir);
	cleanup_one(testdir2);
}

#define SYS_renameat2 316
#define RENAME_NOREPLACE	(1 << 0)	/* Don't overwrite target */
#define RENAME_EXCHANGE		(1 << 1)	/* Exchange source and dest */

static int sys_renameat2(int dfd1, const char *path1,
			 int dfd2, const char *path2,
			 unsigned int flags)
{
	return syscall(SYS_renameat2, dfd1, path1, dfd2, path2, flags);
}

static const char *type_name(int type, int empty)
{
	switch (type) {
	case S_IFREG:
		return "REG ";
	case S_IFLNK:
		return "LNK ";
	case S_IFDIR:
		if (empty)
			return "DIR-";
		else
			return "DIR+";
	case 0:
		return "-   ";
	default:
		return "????";
	}
}

static int check_any(const char *path, int type, void *data, int data_len)
{
	int res;
	char buf[1024];

	if (type) {
		res = check_type(path, type);
		if (res == -1)
			return -1;

	}

	switch (type) {
	case S_IFDIR:
		res = check_mode(path, 0755);
		if (res == -1)
			return -1;
		res = check_dir_contents(path, data);
		if (res == -1)
			return -1;
		res = cleanup_dir(path, data, 0);
		if (res == -1)
			return -1;
		res = rmdir(path);
		if (res == -1)
			return -1;
		break;

	case S_IFREG:
		res = check_mode(path, 0644);
		if (res == -1)
			return -1;
		res = check_nlink(path, 1);
		if (res == -1)
			return -1;
		res = check_size(path, data_len);
		if (res == -1)
			return -1;
		res = check_data(path, data, 0, data_len);
		if (res == -1)
			return -1;
		res = unlink(path);
		if (res == -1) {
			PERROR("unlink");
			return -1;
		}
		break;

	case S_IFLNK:
		res = check_mode(path, 0777);
		if (res == -1)
			return -1;
		res = readlink(path, buf, sizeof(buf));
		if (res == -1) {
			PERROR("readlink");
			return -1;
		}
		if (res != data_len) {
			ERROR("short readlink: %u instead of %u", res,
			      data_len);
			return -1;
		}
		if (memcmp(buf, data, data_len) != 0) {
			ERROR("link mismatch");
			return -1;
		}
		res = unlink(path);
		if (res == -1) {
			PERROR("unlink");
			return -1;
		}
		break;
	}

	res = check_nonexist(path);
	if (res == -1)
		return -1;

	return 0;
}

static int create_any(const char *path, int type, void *data, int data_len)
{
	int res;

	switch (type) {
	case S_IFREG:
		res = create_file(path, data, data_len);
		break;
	case S_IFLNK:
		res = symlink(data, path);
		if (res == -1)
			PERROR("symlink");
		break;
	case S_IFDIR:
		res = create_dir(path, data);
		break;
	case 0:
		res = check_nonexist(path);
		break;
	}
	return res;
}

static const char *rename_flag_name(unsigned int flags)
{
	switch (flags) {
	case 0:
		return "(none)";
	case RENAME_NOREPLACE:
		return "(NOREPLACE)";
	case RENAME_EXCHANGE:
		return "(EXCHANGE)";
	case RENAME_NOREPLACE | RENAME_EXCHANGE:
		return "(NOREPLACE | EXCHANGE)";
	default:
		return "????";
	}
}

static int test_rename(unsigned int flags, int src_type, int src_empty,
		       int dst_type, int dst_empty, int err)
{
	int res;
	const char *src = NULL;
	const char *dst = NULL;
	void *src_data = NULL;
	void *dst_data = NULL;
	int src_datalen = 0;
	int dst_datalen = 0;

	start_test("rename %-11s %s -> %s error: '%s'",
		   rename_flag_name(flags),
		   type_name(src_type, src_empty), 
		   type_name(dst_type, dst_empty),
		   strerror(err));

	res = 0;
	if (src_type == S_IFDIR) {
		src_data = src_empty ? testdir_empty : testdir_files;
		src = testdir;
	} else {
		src = testfile;
		src_data = testdata;
		src_datalen = testdatalen;
	}
	if (dst_type == S_IFDIR) {
		dst = testdir2;
		dst_data = dst_empty ? testdir_empty : testdir_files2;
	} else {
		dst = testfile2;
		dst_data = testdata2;
		dst_datalen = testdata2len;
	}

	res = create_any(src, src_type, src_data, src_datalen);
	if (res == -1)
		goto cleanup;
	res = create_any(dst, dst_type, dst_data, dst_datalen);
	if (res == -1)
		goto cleanup;

	res = sys_renameat2(AT_FDCWD, src, AT_FDCWD, dst, flags);
	if (res == 0) {
		if (err) {
			ERROR("renameat2 should have failed");
			res = -1;
			goto cleanup;
		}
		if (!(flags & RENAME_EXCHANGE)) {
			dst_type = src_type;
			dst_data = src_data;
			dst_datalen = src_datalen;
			src_type = 0;
			src_data = NULL;
			src_datalen = 0;
		} else {
			swap(src_type, dst_type);
			swap(src_data, dst_data);
			swap(dst_datalen, src_datalen);
		}
	} else {
		if (errno == ENOSYS || errno == EINVAL) {
			success(); /* not supported, most likely */
			res = 0;
			goto cleanup;
		}
		if (err != errno) {
			PERROR("wrong errno");
			res = -1;
			goto cleanup;
		}
	}

	res = check_any(src, src_type, src_data, src_datalen);
	if (res == -1)
		goto cleanup;
	res = check_any(dst, dst_type, dst_data, dst_datalen);
	if (res == -1)
		goto cleanup;

	success();
	return 0;

cleanup:
	cleanup();
	return res;
}

static int test_renames(void)
{
	int err = 0;

	err += test_rename(0, 0, 0, S_IFREG, 0, ENOENT);
	err += test_rename(0, 0, 0, S_IFLNK, 0, ENOENT);
	err += test_rename(0, 0, 0, S_IFDIR, 0, ENOENT);
	err += test_rename(0, 0, 0, S_IFDIR, 1, ENOENT);
	err += test_rename(0, 0, 0, 0, 0, ENOENT);

	err += test_rename(0, S_IFREG, 0, S_IFREG, 0, 0);
	err += test_rename(0, S_IFREG, 0, S_IFLNK, 0, 0);
	err += test_rename(0, S_IFREG, 0, S_IFDIR, 0, EISDIR);
	err += test_rename(0, S_IFREG, 0, S_IFDIR, 1, EISDIR);
	err += test_rename(0, S_IFREG, 0, 0, 0, 0);

	err += test_rename(0, S_IFLNK, 0, S_IFREG, 0, 0);
	err += test_rename(0, S_IFLNK, 0, S_IFLNK, 0, 0);
	err += test_rename(0, S_IFLNK, 0, S_IFDIR, 0, EISDIR);
	err += test_rename(0, S_IFLNK, 0, S_IFDIR, 1, EISDIR);
	err += test_rename(0, S_IFLNK, 0, 0, 0, 0);

	err += test_rename(0, S_IFDIR, 0, S_IFREG, 0, ENOTDIR);
	err += test_rename(0, S_IFDIR, 0, S_IFLNK, 0, ENOTDIR);
	err += test_rename(0, S_IFDIR, 0, S_IFDIR, 0, ENOTEMPTY);
	err += test_rename(0, S_IFDIR, 0, S_IFDIR, 1, 0);
	err += test_rename(0, S_IFDIR, 0, 0, 0, 0);

	err += test_rename(0, S_IFDIR, 1, S_IFREG, 0, ENOTDIR);
	err += test_rename(0, S_IFDIR, 1, S_IFLNK, 0, ENOTDIR);
	err += test_rename(0, S_IFDIR, 1, S_IFDIR, 0, ENOTEMPTY);
	err += test_rename(0, S_IFDIR, 1, S_IFDIR, 1, 0);
	err += test_rename(0, S_IFDIR, 1, 0, 0, 0);

	err += test_rename(RENAME_NOREPLACE, 0, 0, S_IFREG, 0, ENOENT);
	err += test_rename(RENAME_NOREPLACE, 0, 0, S_IFLNK, 0, ENOENT);
	err += test_rename(RENAME_NOREPLACE, 0, 0, S_IFDIR, 0, ENOENT);
	err += test_rename(RENAME_NOREPLACE, 0, 0, S_IFDIR, 1, ENOENT);
	err += test_rename(RENAME_NOREPLACE, 0, 0, 0, 0, ENOENT);

	err += test_rename(RENAME_NOREPLACE, S_IFREG, 0, S_IFREG, 0, EEXIST);
	err += test_rename(RENAME_NOREPLACE, S_IFREG, 0, S_IFLNK, 0, EEXIST);
	err += test_rename(RENAME_NOREPLACE, S_IFREG, 0, S_IFDIR, 0, EEXIST);
	err += test_rename(RENAME_NOREPLACE, S_IFREG, 0, S_IFDIR, 1, EEXIST);
	err += test_rename(RENAME_NOREPLACE, S_IFREG, 0, 0, 0, 0);

	err += test_rename(RENAME_NOREPLACE, S_IFLNK, 0, S_IFREG, 0, EEXIST);
	err += test_rename(RENAME_NOREPLACE, S_IFLNK, 0, S_IFLNK, 0, EEXIST);
	err += test_rename(RENAME_NOREPLACE, S_IFLNK, 0, S_IFDIR, 0, EEXIST);
	err += test_rename(RENAME_NOREPLACE, S_IFLNK, 0, S_IFDIR, 1, EEXIST);
	err += test_rename(RENAME_NOREPLACE, S_IFLNK, 0, 0, 0, 0);

	err += test_rename(RENAME_NOREPLACE, S_IFDIR, 0, S_IFREG, 0, EEXIST);
	err += test_rename(RENAME_NOREPLACE, S_IFDIR, 0, S_IFLNK, 0, EEXIST);
	err += test_rename(RENAME_NOREPLACE, S_IFDIR, 0, S_IFDIR, 0, EEXIST);
	err += test_rename(RENAME_NOREPLACE, S_IFDIR, 0, S_IFDIR, 1, EEXIST);
	err += test_rename(RENAME_NOREPLACE, S_IFDIR, 0, 0, 0, 0);

	err += test_rename(RENAME_NOREPLACE, S_IFDIR, 1, S_IFREG, 0, EEXIST);
	err += test_rename(RENAME_NOREPLACE, S_IFDIR, 1, S_IFLNK, 0, EEXIST);
	err += test_rename(RENAME_NOREPLACE, S_IFDIR, 1, S_IFDIR, 0, EEXIST);
	err += test_rename(RENAME_NOREPLACE, S_IFDIR, 1, S_IFDIR, 1, EEXIST);
	err += test_rename(RENAME_NOREPLACE, S_IFDIR, 1, 0, 0, 0);


	err += test_rename(RENAME_EXCHANGE, 0, 0, S_IFREG, 0, ENOENT);
	err += test_rename(RENAME_EXCHANGE, 0, 0, S_IFLNK, 0, ENOENT);
	err += test_rename(RENAME_EXCHANGE, 0, 0, S_IFDIR, 0, ENOENT);
	err += test_rename(RENAME_EXCHANGE, 0, 0, S_IFDIR, 1, ENOENT);
	err += test_rename(RENAME_EXCHANGE, 0, 0, 0, 0, ENOENT);

	err += test_rename(RENAME_EXCHANGE, S_IFREG, 0, S_IFREG, 0, 0);
	err += test_rename(RENAME_EXCHANGE, S_IFREG, 0, S_IFLNK, 0, 0);
	err += test_rename(RENAME_EXCHANGE, S_IFREG, 0, S_IFDIR, 0, 0);
	err += test_rename(RENAME_EXCHANGE, S_IFREG, 0, S_IFDIR, 1, 0);
	err += test_rename(RENAME_EXCHANGE, S_IFREG, 0, 0, 0, ENOENT);

	err += test_rename(RENAME_EXCHANGE, S_IFLNK, 0, S_IFREG, 0, 0);
	err += test_rename(RENAME_EXCHANGE, S_IFLNK, 0, S_IFLNK, 0, 0);
	err += test_rename(RENAME_EXCHANGE, S_IFLNK, 0, S_IFDIR, 0, 0);
	err += test_rename(RENAME_EXCHANGE, S_IFLNK, 0, S_IFDIR, 1, 0);
	err += test_rename(RENAME_EXCHANGE, S_IFLNK, 0, 0, 0, ENOENT);

	err += test_rename(RENAME_EXCHANGE, S_IFDIR, 0, S_IFREG, 0, 0);
	err += test_rename(RENAME_EXCHANGE, S_IFDIR, 0, S_IFLNK, 0, 0);
	err += test_rename(RENAME_EXCHANGE, S_IFDIR, 0, S_IFDIR, 0, 0);
	err += test_rename(RENAME_EXCHANGE, S_IFDIR, 0, S_IFDIR, 1, 0);
	err += test_rename(RENAME_EXCHANGE, S_IFDIR, 0, 0, 0, ENOENT);

	err += test_rename(RENAME_EXCHANGE, S_IFDIR, 1, S_IFREG, 0, 0);
	err += test_rename(RENAME_EXCHANGE, S_IFDIR, 1, S_IFLNK, 0, 0);
	err += test_rename(RENAME_EXCHANGE, S_IFDIR, 1, S_IFDIR, 0, 0);
	err += test_rename(RENAME_EXCHANGE, S_IFDIR, 1, S_IFDIR, 1, 0);
	err += test_rename(RENAME_EXCHANGE, S_IFDIR, 1, 0, 0, ENOENT);

	err += test_rename(RENAME_NOREPLACE | RENAME_EXCHANGE,
			   S_IFREG, 0, S_IFREG, 0, EINVAL);

	return err;
}

int main(int argc, char *argv[])
{
	const char *basepath;
	int err = 0;
	int res;

	umask(0);
	if (argc != 2) {
		fprintf(stderr, "usage: %s testdir\n", argv[0]);
		return 1;
	}
	basepath = argv[1];
	assert(strlen(basepath) < 512);
	if (basepath[0] != '/') {
		fprintf(stderr, "testdir must be an absolute path\n");
		return 1;
	}

	sprintf(testfile, "%s/testfile", basepath);
	sprintf(testfile2, "%s/testfile2", basepath);
	sprintf(testdir, "%s/testdir", basepath);
	sprintf(testdir2, "%s/testdir2", basepath);

	if (check_nonexist(testfile) == -1 ||
	    check_nonexist(testfile2) == -1 ||
	    check_nonexist(testdir) == -1 ||
	    check_nonexist(testdir2) == -1)
		return 1;

	err += test_renames();

	res = mkdir(testdir, 0755);
	if (res == -1) {
		perror(testdir);
		return 1;
	}
	res = mkdir(testdir2, 0755);
	if (res == -1) {
		perror(testdir2);
		return 1;
	}
	printf("------- Doing cross-directory renames...\n");

	sprintf(testfile, "%s/testdir/subfile", basepath);
	sprintf(testdir, "%s/testdir/subdir", basepath);
	sprintf(testfile2, "%s/testdir2/subfile2", basepath);
	sprintf(testdir2, "%s/testdir2/subdir2", basepath);

	err += test_renames();

	sprintf(testdir, "%s/testdir", basepath);
	sprintf(testdir2, "%s/testdir2", basepath);
	cleanup();

	if (err) {
		fprintf(stderr, "%i tests failed\n", -err);
		return 1;
	}

	return 0;
}
