Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbaCYPAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 11:00:34 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:35804 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbaCYPAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 11:00:32 -0400
Date: Tue, 25 Mar 2014 16:00:17 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        mtk.manpages@gmail.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, zab@redhat.com
Subject: splicing pages to the same file
Message-ID: <20140325150017.GA2336@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In pipe_to_file() I noticed the "if (buf->page != page)" and started thinking
about this.  What should be the correct behavior?

Currently we just skip pages that are equal, but the results can be pretty
strange.  E.g. see the output of the following with attached test prog.

 seq -f "%07.0f" 0 1023 > /tmp/x
 ./splice_test /tmp/x 800 /tmp/x 1600 4096

Adding memmove() to an "else" branch will result in even more strangeness: by
the time splice moves onto the second page of the destination, the first buffer
was already "corrupted".

We could clone the page in the pipe buffer in this case, but is it worth the
effort?

Or should we just return EINVAL?

Or just leave it and document the strangeness?

Thanks,
Miklos
----

#define _GNU_SOURCE

#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h>
#include <err.h>

int main(int argc, char *argv[])
{
	const char *in_file, *out_file;
	int in_fd, out_fd;
	off_t in_off, out_off;
	size_t size;
	int pip[2];
	ssize_t res;

	if (argc != 6) {
		errx(1, "usage: %s in_file in_off out_file out_off size",
		     argv[0]);
	}

	in_file = argv[1];
	in_off = strtoull(argv[2], NULL, 0);
	out_file = argv[3];
	out_off = strtoull(argv[4], NULL, 0);
	size = strtoul(argv[5], NULL, 0);

	in_fd = open(in_file, O_RDONLY);
	if (in_fd == -1)
		err(1, "creating %s", in_file);

	out_fd = open(out_file, O_WRONLY);
	if (out_fd == -1)
		err(1, "creating %s", out_file);

	res = pipe(pip);
	if (res == -1)
		err(1, "pipe");

	res = splice(in_fd, &in_off, pip[1], NULL, size, 0);
	if (res == -1)
		err(1, "splice to pipe");
	if ((size_t) res != size)
		errx(1, "short splice to pipe");

	res = splice(pip[0], NULL, out_fd, &out_off, size, 0);
	if (res == -1)
		err(1, "splice from pipe");
	if ((size_t) res != size)
		errx(1, "short splice from pipe");

	return 0;
}
