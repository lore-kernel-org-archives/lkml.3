Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab3J3VTB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 17:19:01 -0400
Received: from mx-out.ocsa-data.net ([194.36.166.37]:65462 "EHLO
	mx-out.ocsa-data.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab3J3VTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 17:19:00 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Wed, 30 Oct 2013 22:18:56 +0100
From: Yann Droneaud <ydroneaud@opteya.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        ydroneaud@opteya.com
Subject: Re: [PATCH v4 6/7] events: use =?UTF-8?Q?get=5Funused=5Ffd=5Fflag?=
 =?UTF-8?Q?s=28=30=29=20instead=20of=20get=5Funused=5Ffd=28=29?=
Organization: OPTEYA
In-Reply-To: <20131030202041.GS16117@laptop.programming.kicks-ass.net>
References: <cover.1383121137.git.ydroneaud@opteya.com>
 <3b0bc009ff1410d04f8a1e71bfae0d27e1254b90.1383121137.git.ydroneaud@opteya.com>
 <20131030202041.GS16117@laptop.programming.kicks-ass.net>
Message-ID: <94b641a81a06ba4943cf77e80bc271c8@meuh.org>
User-Agent: Roundcube Webmail/0.9.2
X-abuse-contact: abuse@ocsa-data.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Le 30.10.2013 21:20, Peter Zijlstra a écrit :
> On Wed, Oct 30, 2013 at 08:47:46PM +0100, Yann Droneaud wrote:
>> This patch replaces calls to get_unused_fd() with equivalent call to
>> get_unused_fd_flags(0) to preserve current behavor for existing code.
>> 
>> The hard coded flag value (0) should be reviewed on a per-subsystem 
>> basis,
>> and, if possible, set to O_CLOEXEC.
> 
> And how am I supposed to know if that is 'possible'? You provide a 
> total
> number of 0 useful clues on how to determine this.

Fair.

Short: Will it break kernel ABI ? If no, use O_CLOEXEC, if yes, use 0.

Long: If userspace expect to retrieve a file descriptor with plain old 
Unix(tm)
       semantics, O_CLOEXEC must not be the default, as it could break 
some applications
       expecting that the file descriptor will be inherited during 
exec().

       But for some subsystems, such as InfiniBand, KVM, VFIO, it make no 
sense to have
       file descriptors inherited since those are tied to resources that 
will vanish
       when a another program will replace the current one by mean of 
exec(),
       so it's safe to use O_CLOEXEC in such cases.

       For others, like XFS, the file descriptor is retrieved by one 
program and will
       be used by a different program, executed as a child. In this case, 
setting O_CLOEXEC
       would break existing application, which do not expect to have to 
call fcntl(fd, F_SETFD,
       FD_CLOEXEC) to make it available across exec().

       If file descriptor created by events subsystem are not tied to the 
current process
       resources, it's likely legal to use it in a different process 
context, thus O_CLOEXEC
       must not be the default.

Aside: If O_CLOEXEC cannot be made the default, it would be interesting 
to think to extend
        the API to have a (set of) function(s) taking a flags parameter 
so that userspace can
        set O_CLOEXEC if wanted. And I have a patch for this :)

PS: I like the title of this article: "Excuse me son, but your code is 
leaking !!!" [1]
     by Dan Walsh but one should probably read PEP-446 "Make newly 
created file descriptors
     non-inheritable" [2] instead since it has lot more background 
information on file
     descriptor leaking.

[1] http://danwalsh.livejournal.com/53603.html
[2] http://www.python.org/dev/peps/pep-0446/


Regards.

-- 
Yann Droneaud
OPTEYA

