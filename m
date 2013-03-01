Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab3CAIhB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 03:37:01 -0500
Received: from mout.gmx.net ([212.227.17.20]:54518 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200Ab3CAIg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 03:36:59 -0500
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX18dBs1vEQAdtjQlw7cLoXyM/602SMXVycWqMHb3nP
	JyswJWB//Ywedb
From: Sven Joachim <svenjoac@gmx.de>
To: justin <jlec@gentoo.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kconfig: use config scripts to detect ncurses libs
References: <jlec@gentoo.org>
	<1362045557-9123-1-git-send-email-jlec@gentoo.org>
	<874ngwhzuy.fsf@turtle.gmx.de> <51305AC4.2030008@gentoo.org>
Date: Fri, 01 Mar 2013 09:36:53 +0100
In-Reply-To: <51305AC4.2030008@gentoo.org> (justin's message of "Fri, 01 Mar
	2013 08:37:40 +0100")
Message-ID: <87obf35xei.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-03-01 08:37 +0100, justin wrote:

> On 28/02/13 22:50, Sven Joachim wrote:
>> On 2013-02-28 10:59 +0100, jlec@gentoo.org wrote:
>> 
>>> Ncurses provides a config script (ncurses5-config) to assist finding ncurses.
>>> This patch makes use of it to detect the necessary libs for linking of the
>>> ncurses nconfig dialog.
>> 
>> That script is not necessarily called ncurses5-config, it might also be
>> called ncurses6-config is ncurses is configured for a different ABI
>> (--enable-ext-colors, --enable-ext-mouse).  Although I would suspect
>> that any distribution who does that provides a compatibility symlink.
>>
>
> We don't do that, but I rechecked with building ncurses manually. You
> are right. How widely spread is the usage of this options? Or is it
> rather an experimental option?

Pretty much, since it changes the ABI and everyone wants to be
compatible with the existing ncurses ABI.

> What we could do is simple extending the syntax to additionally check
> for the ABI version 6 config scripts. Is this an option to consider?

Probably.

>>>  scripts/kconfig/Makefile | 4 +++-
>>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
>>> index 3091794..c372976 100644
>>> --- a/scripts/kconfig/Makefile
>>> +++ b/scripts/kconfig/Makefile
>>> @@ -216,7 +216,9 @@ HOSTCFLAGS_gconf.o	= `pkg-config --cflags gtk+-2.0 gmodule-2.0 libglade-2.0` \
>>>  
>>>  HOSTLOADLIBES_mconf   = $(shell $(CONFIG_SHELL) $(check-lxdialog) -ldflags $(HOSTCC))
>>>  
>>> -HOSTLOADLIBES_nconf	= -lmenu -lpanel -lncurses
>>> +HOSTLOADLIBES_nconf	= -lmenu -lpanel
>>> +HOSTLOADLIBES_nconf	+= $(shell    ncursesw5-config --libs 2>/dev/null \
>>> +				   || ncurses5-config --libs 2>/dev/null  )
>> 
>> This will link with ncursesw, not ncurses.  Probably not what you want,
>> since nconf.h does not #include the right headers for that.
>> 
>
> That's true, and again it would change two things at once. I will go
> back to simple -lncurses as it was before.
>
>> On Debian/Ubuntu, there's also the problem that ncursesw5-config exists
>> even if the libncursesw5-dev package is not installed, so this patch
>> makes the build fail in such cases.
>
> Will be solved when reverting as described above. But actually it smells
> like a bug in the package management, doesn't it? Why are build time
> config scripts shipped in runtime only packages? What is their purpose?

Historically it seems to be an accident, and the ncurses{w,5}-config
scripts should have better been shipped in their development packages.
But nowadays we want to make the development packages multiarch-aware,
and since the scripts differ on architectures, moving them away from
ncurses-bin would mean adding two additional binary packages just for
these scripts.

See http://bugs.debian.org/480437 for a discussion on that topic.

>> Can we just call ncurses5-config and not ncursesw5-config, or are there
>> any distros who ship the latter and not the former?
>> 
>
> I can't talk about distro wide situation, but manual building gives only
> one of the two. So there might be a situation where only one of the two
> is present.
>
> It seems we have a little dilemma here. Any suggestions how to solve it?

Well, at least until nconf does not make any effort to explicitly detect
and use the wide API, trying ncurses5-config first should work.  If you
build ncurses yourself with --enable-widec, there is no -lmenu or -lpanel
anyway, these libraries are called menuw and panelw then.

Cheers,
       Sven
