Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882Ab3FFLyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 07:54:21 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:46975 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932403Ab3FFLyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 07:54:20 -0400
Date: Thu, 6 Jun 2013 13:54:17 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Strange intermittent EIO error when writing to stdout since v3.8.0
Message-ID: <20130606115417.GA520@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since v3.8.0 several people reported intermittent IO errors that happen
during high system load while using "emerge" under Gentoo:
...
  File "/usr/lib64/portage/pym/portage/util/_eventloop/EventLoop.py", line 260, in iteration
    if not x.callback(f, event, *x.args):
  File "/usr/lib64/portage/pym/portage/util/_async/PipeLogger.py", line 99, in _output_handler
    stdout_buf[os.write(stdout_fd, stdout_buf):]
  File "/usr/lib64/portage/pym/portage/__init__.py", line 246, in __call__
    rval = self._func(*wrapped_args, **wrapped_kwargs)
OSError: [Errno 5] Input/output error

Basically 'emerge' just writes the build output to stdout in a loop:
...
def _output_handler(self, fd, event):

       background = self.background
       stdout_fd = self.stdout_fd
       log_file = self._log_file 

       while True:
               buf = self._read_buf(fd, event)

               if buf is None:
                       # not a POLLIN event, EAGAIN, etc...
                       break

               if not buf:
                       # EOF
                       self._unregister()
                       self.wait()
                       break

               else:
                       if not background and stdout_fd is not None:
                               failures = 0
                               stdout_buf = buf
                               while stdout_buf:
                                       try:
                                               stdout_buf = \
                                                       stdout_buf[os.write(stdout_fd, stdout_buf):]
                                       except OSError as e:
                                               if e.errno != errno.EAGAIN:
                                                       raise
				...

see: https://bugs.gentoo.org/show_bug.cgi?id=459674

(A similar issue also happens when building Firefox since v3.8.0. But
because Firefox's build process doesn't raise an exception it just dies
at random points without giving a clue.)

Now the question is: Could this be a kernel bug? Maybe in the TTY layer?

Unfortunately the issue is not easily reproducible and a git-bisect is
out of the question.

-- 
Markus
