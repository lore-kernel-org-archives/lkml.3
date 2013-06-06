Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512Ab3FFOo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 10:44:29 -0400
Received: from smtp1.uu.se ([130.238.7.54]:43667 "EHLO smtp1.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733Ab3FFOo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 10:44:27 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20912.40860.284968.764407@pilspetsen.it.uu.se>
Date: Thu, 6 Jun 2013 16:41:32 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Strange intermittent EIO error when writing to stdout since v3.8.0
In-Reply-To: <20130606115417.GA520@x4>
References: <20130606115417.GA520@x4>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus Trippelsdorf writes:
 > Since v3.8.0 several people reported intermittent IO errors that happen
 > during high system load while using "emerge" under Gentoo:
 > ...
 >   File "/usr/lib64/portage/pym/portage/util/_eventloop/EventLoop.py", line 260, in iteration
 >     if not x.callback(f, event, *x.args):
 >   File "/usr/lib64/portage/pym/portage/util/_async/PipeLogger.py", line 99, in _output_handler
 >     stdout_buf[os.write(stdout_fd, stdout_buf):]
 >   File "/usr/lib64/portage/pym/portage/__init__.py", line 246, in __call__
 >     rval = self._func(*wrapped_args, **wrapped_kwargs)
 > OSError: [Errno 5] Input/output error
 > 
 > Basically 'emerge' just writes the build output to stdout in a loop:
 > ...
 > def _output_handler(self, fd, event):
 > 
 >        background = self.background
 >        stdout_fd = self.stdout_fd
 >        log_file = self._log_file 
 > 
 >        while True:
 >                buf = self._read_buf(fd, event)
 > 
 >                if buf is None:
 >                        # not a POLLIN event, EAGAIN, etc...
 >                        break
 > 
 >                if not buf:
 >                        # EOF
 >                        self._unregister()
 >                        self.wait()
 >                        break
 > 
 >                else:
 >                        if not background and stdout_fd is not None:
 >                                failures = 0
 >                                stdout_buf = buf
 >                                while stdout_buf:
 >                                        try:
 >                                                stdout_buf = \
 >                                                        stdout_buf[os.write(stdout_fd, stdout_buf):]
 >                                        except OSError as e:
 >                                                if e.errno != errno.EAGAIN:
 >                                                        raise
 > 				...
 > 
 > see: https://bugs.gentoo.org/show_bug.cgi?id=459674
 > 
 > (A similar issue also happens when building Firefox since v3.8.0. But
 > because Firefox's build process doesn't raise an exception it just dies
 > at random points without giving a clue.)
 > 
 > Now the question is: Could this be a kernel bug? Maybe in the TTY layer?
 > 
 > Unfortunately the issue is not easily reproducible and a git-bisect is
 > out of the question.

I'm seeing a similar regression.  I do a lot of gcc bootstraps and regression
test suite runs, and for the bootstraps I do

	make -jN bootstrap |& tee build-log

(tcsh syntax, adjust as appropriate for your preferred shell) to get a complete
log for later inspection in case of error.  N is typically the number of cores
or threads on the machine, e.g. -j8 on my Core-i7 IVB.

Up to the 3.7 kernel this never had any problems.  Starting with the 3.8 kernel,
or possibly 3.9-rc1, this usually dies at some random point with an EIO.

I haven't had time to bisect it.

/Mikael
