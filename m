Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776Ab3GaXIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 19:08:36 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:56604 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab3GaXIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 19:08:35 -0400
Message-ID: <51F998EE.80208@gmail.com>
Date: Thu, 01 Aug 2013 01:08:30 +0200
From: Gabriel de Perthuis <g2p.code@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: Jeff Dike <jdike@addtoit.com>, user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] um: Accept /dev/fd/* uml block devices
References: <1374938607-25747-1-git-send-email-g2p.code@gmail.com> <51F4D275.70009@nod.at> <51F4F19D.3000300@gmail.com>
In-Reply-To: <51F4F19D.3000300@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 28/07/2013 12:25, Gabriel de Perthuis a écrit :
> Le dim. 28 juil. 2013 10:12:37 CEST, Richard Weinberger a écrit :
>> Am 27.07.2013 17:23, schrieb Gabriel de Perthuis:
>>> Useful for
>>> * limiting privileges
>>> * opening block devices O_EXCL
>>
>> So, the goal of this patch is to allow passing a file descriptor
>> number as block device instead of a file?
> 
> Yes.  It turns out it already works, but not after dropping privileges.
> 
>> I assume you have already a wrapper around UML which exec()'s it such that
>> it can reuse a fd?
> 
> Yes, vido: https://github.com/g2p/vido
> 
> Here's the relevant commit:
> https://github.com/g2p/vido/commit/42d4b86eab13d90ee63138b73146485dc4e47ec6
> 
>>> Use dup to work around the fact /proc/self/fd
>>> can't be opened after dropping privileges.
>>> This proc behaviour doesn't match TLPI and might be a bug.
>>>
>>> Qemu has a slightly more complex fdset approach
>>> that provides fds with different access permissions.
>>
>> I really don't like that you patch os_open_file(), this is a
>> generic function.
> 
> The justification was that it unbreaks open("/dev/fd") to be more like
> standards suggest, but I can see how that makes it a special case.
> 
>> What about this one?
>> Allow ubda= (and all other UML block device kernel parameters) to
>> accept arguments like file:/foo/bar and fd:N.
>> Where N is a number and file: is default such that we do not break
>> old kernels.
> 
> Okay, I'll add a prefix.  Maybe file:// + /abs/path | rel/path
> since that's already standard.

I've done some work on this approach, but it turns out to clash
with the cow syntax; in ubd0=file:cowfile, ":" is a path separator.
Changing things in ubd_kern.c is also more intrusive, even with
the limited goal of making it work for plain, non-cow files I
need to duplicate a few code paths to work with fds instead of
names and the diffstat is getting large.

Because of that I'd like to come back to /dev/fd/<n>.
It does overload the generic file opener, but does so consistently,
so that you can think of /dev/fd as a virtual filesystem.
The (arguably broken) /proc/self/fd behaviour remains available
through the /proc path.

