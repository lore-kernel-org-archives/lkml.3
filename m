Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab3FGPjl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 11:39:41 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:43416 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756031Ab3FGPjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 11:39:40 -0400
Message-ID: <51B1FEB1.8040103@hurleysoftware.com>
Date: Fri, 07 Jun 2013 11:39:29 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Markus Trippelsdorf <markus@trippelsdorf.de>
CC: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Mikael Pettersson <mikpe@it.uu.se>,
        David Howells <dhowells@redhat.com>
Subject: Re: Strange intermittent EIO error when writing to stdout since v3.8.0
References: <20130606115417.GA520@x4> <51B09A26.3080603@hurleysoftware.com> <20130606143750.GB520@x4>
In-Reply-To: <20130606143750.GB520@x4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2013 10:37 AM, Markus Trippelsdorf wrote:
> On 2013.06.06 at 10:18 -0400, Peter Hurley wrote:
>> On 06/06/2013 07:54 AM, Markus Trippelsdorf wrote:
>>> Since v3.8.0 several people reported intermittent IO errors that happen
>>> during high system load while using "emerge" under Gentoo:
>>> ...
>>>     File "/usr/lib64/portage/pym/portage/util/_eventloop/EventLoop.py", line 260, in iteration
>>>       if not x.callback(f, event, *x.args):
>>>     File "/usr/lib64/portage/pym/portage/util/_async/PipeLogger.py", line 99, in _output_handler
>>>       stdout_buf[os.write(stdout_fd, stdout_buf):]
>>>     File "/usr/lib64/portage/pym/portage/__init__.py", line 246, in __call__
>>>       rval = self._func(*wrapped_args, **wrapped_kwargs)
>>> OSError: [Errno 5] Input/output error
>>
>> Looks to me like a user-space bug: EIO is returned when the other
>> end of the "pipe" has been closed.
>>
>> FWIW, I didn't see where the OP tried to revert
>>      'SpawnProcess: stdout_fd FD_CLOEXEC'
>>
>> The only non-emerge related comment (#21 in the link provided) refers to
>>     'a similar issue sometimes happened when I built Firefox by hand [..snip..]
>>      And it would randomly crash during the build.
>>
>>      Since I've recompiled Python with gcc-4.6 this issue also never occurred
>>      again.'
>>
>> That comment doesn't really corroborate the reported bug.
>
> That comment was from me (I use 'octoploid' for blog trolling, etc.) and
> is wrong. The Firefox build issue happend again today. See also the rest
> of my mail:
>
>> (A similar issue also happens when building Firefox since v3.8.0. But
>> because Firefox's build process doesn't raise an exception it just
>> dies at random points without giving a clue.)
>
> Please note that both the Firefox build process and Portage (emerge)
> are implemented in Python.

Based on the other reports from Mikael and David, I suspect this problem
may have to do with my commit 699390354da6c258b65bf8fa79cfd5feaede50b6:

   pty: Ignore slave pty close() if never successfully opened

This commit poisons the pty under certain error conditions that may
occur from parallel open()s (or parallel close() with pending write()).

It's unclear to me which error condition is triggered and how user-space
got an open file descriptor but that seems the most likely. Is the problem
reproducible enough that a debug patch would likely trigger?

Regards,
Peter Hurley


