Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936479Ab3DHXUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 19:20:36 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:48953 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935446Ab3DHXUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 19:20:34 -0400
Message-ID: <516350BE.2000106@wwwdotorg.org>
Date: Mon, 08 Apr 2013 17:20:30 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Doug Anderson <dianders@chromium.org>, Nathan Zimmer <nzimmer@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Woodhouse <dwmw2@infradead.org>, stable@vger.kernel.org,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: hangs on boot in 9984d7394618df9
References: <20130405173623.GE4068@ZenIV.linux.org.uk> <515F3A71.9080008@sgi.com> <20130405210042.GH4068@ZenIV.linux.org.uk> <5162E36F.5020305@sgi.com> <20130408155847.GS4068@ZenIV.linux.org.uk> <51632DF8.2080402@sgi.com> <20130408212327.GU4068@ZenIV.linux.org.uk> <20130408214834.GV4068@ZenIV.linux.org.uk> <516341ED.5060803@wwwdotorg.org> <CAD=FV=WodJER2g45u5pEw0edf+K4uYJjyt0w4ZfX9q=o1a7pYw@mail.gmail.com> <20130408230658.GY4068@ZenIV.linux.org.uk>
In-Reply-To: <20130408230658.GY4068@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2013 05:06 PM, Al Viro wrote:
> On Mon, Apr 08, 2013 at 03:45:31PM -0700, Doug Anderson wrote:
>> Hi,
>>
>> On Mon, Apr 8, 2013 at 3:17 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>>> Anyway, I've just pushed a splitup of that commit (carved in 3 pieces)
>>>> into vfs.git#pipe-splitup; could you check which part triggers that
>>>> hang?  Should propagate in a few...
>>>
>>> It looks like "pipe: unify ->release() and ->open()" introduces the
>>> problem. Note that I had to add a prototype for fifo_open() before the
>>> structs that reference it for that commit to compile.
>>
>> It sounds like Stephen has provided you the info you needed so not
>> doing any extra testing now, but I figured I'd chime in that I hit
>> problems this morning with linux-next and it appears to be the same
>> thing.  I did a revert of 9984d7394618df9 and (plus a revert of a
>> handful of patches to the same file) and problems are resolved.  The
>> failure case is really weird in that everything works well booting to
>> a simple /bin/bash but fails when you do more complex tasks.
>>
>> Anyway: If you need some extra testing feel free to CC me.
> 
> Folks, see if vfs.git#experimental works for you; the PITA had apparently
> been caused by change of open() semantics for /proc/<pid>/fd/<some_pipe> -
> it started to behave like a FIFO, i.e. wait for peer to show up.  Normally
> that's not a problem, but if you have closed e.g. the write end of a pipe
> and try to open /proc/<pid>/fd/<read_end_of_pipe>, you'll get open() waiting
> for writers to appear.  Which isn't what we used to do here (open succeeded
> immediately) and apparently that was enough to trip drakut.
> 
> Branch head should be at 574179469f7370aadb9cbac1ceca7c3723c17bee.

That branch works.

Thanks!
