Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902Ab3FFOST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 10:18:19 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:60334 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751120Ab3FFOSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 10:18:18 -0400
Message-ID: <51B09A26.3080603@hurleysoftware.com>
Date: Thu, 06 Jun 2013 10:18:14 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Markus Trippelsdorf <markus@trippelsdorf.de>
CC: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Strange intermittent EIO error when writing to stdout since v3.8.0
References: <20130606115417.GA520@x4>
In-Reply-To: <20130606115417.GA520@x4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2013 07:54 AM, Markus Trippelsdorf wrote:
> Since v3.8.0 several people reported intermittent IO errors that happen
> during high system load while using "emerge" under Gentoo:
> ...
>    File "/usr/lib64/portage/pym/portage/util/_eventloop/EventLoop.py", line 260, in iteration
>      if not x.callback(f, event, *x.args):
>    File "/usr/lib64/portage/pym/portage/util/_async/PipeLogger.py", line 99, in _output_handler
>      stdout_buf[os.write(stdout_fd, stdout_buf):]
>    File "/usr/lib64/portage/pym/portage/__init__.py", line 246, in __call__
>      rval = self._func(*wrapped_args, **wrapped_kwargs)
> OSError: [Errno 5] Input/output error

Looks to me like a user-space bug: EIO is returned when the other
end of the "pipe" has been closed.

FWIW, I didn't see where the OP tried to revert
    'SpawnProcess: stdout_fd FD_CLOEXEC'

The only non-emerge related comment (#21 in the link provided) refers to
   'a similar issue sometimes happened when I built Firefox by hand [..snip..]
    And it would randomly crash during the build.

    Since I've recompiled Python with gcc-4.6 this issue also never occurred
    again.'

That comment doesn't really corroborate the reported bug.

Regards,
Peter Hurley

> Basically 'emerge' just writes the build output to stdout in a loop:
> ...
> def _output_handler(self, fd, event):
>
>         background = self.background
>         stdout_fd = self.stdout_fd
>         log_file = self._log_file
>
>         while True:
>                 buf = self._read_buf(fd, event)
>
>                 if buf is None:
>                         # not a POLLIN event, EAGAIN, etc...
>                         break
>
>                 if not buf:
>                         # EOF
>                         self._unregister()
>                         self.wait()
>                         break
>
>                 else:
>                         if not background and stdout_fd is not None:
>                                 failures = 0
>                                 stdout_buf = buf
>                                 while stdout_buf:
>                                         try:
>                                                 stdout_buf = \
>                                                         stdout_buf[os.write(stdout_fd, stdout_buf):]
>                                         except OSError as e:
>                                                 if e.errno != errno.EAGAIN:
>                                                         raise
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
>

