Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab3LCN4f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 08:56:35 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:33496 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab3LCN4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 08:56:34 -0500
MIME-Version: 1.0
In-Reply-To: <87txeqmpzp.fsf@sejong.aot.lge.com>
References: <20131202140322.4ad6a151@gandalf.local.home>
	<87txeqmpzp.fsf@sejong.aot.lge.com>
Date: Tue, 3 Dec 2013 08:56:33 -0500
X-Google-Sender-Auth: cUpSWJFG7M-BsgTWlFtiudOn2Y4
Message-ID: <CA+5PVA7YYhxcfnJ3NpGU6kZo-iJKHJ7NvnSp+3WL75wKq929GA@mail.gmail.com>
Subject: Re: [RFC] Packaging libtraceevent.so
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Arjan van de Ven <arjan@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 3, 2013 at 1:02 AM, Namhyung Kim <namhyung@kernel.org> wrote:
> Hi Steve,
>
> (also add Jiri to CC list, hi!)
>
> On Mon, 2 Dec 2013 14:03:22 -0500, Steven Rostedt wrote:
>> Hi all!
>>
>> The question has recently come up in Fedora about packaging the
>> libtraceevent.so library. Currently there's 4 users of it:
>>
>>  1) perf
>>  2) trace-cmd
>>  3) powertop
>>  4) rasdaemon
>>
>> But each have their own copy of the code.
>>
>> Both perf and trace-cmd are the major developers of the package, and I
>> would recommend that they continue using the *.a version, but for those
>> tools that are simple users of the library, it would probably make
>> sense to have them use libtraceevent.so and remove their copies from
>> the code (powertop and rasdaemon).
>>
>> The question that I'm posing here is, what currently needs to be done
>> to have this happen?
>
> I think the most important thing is error handling.  The filter parser
> code still has some calls to die().  It should be converted to return
> error and appropriate error messages IMHO.  But I didn't check it'd
> affect to the end-user APIs though.
>
> And it needs to add plugin APIs before the public release.
>
>>
>> Is the API stable enough for a release?
>
> Well, afaics the plugin unregister API should pass pevent as an argument
> so that it can unregister individual event/function handlers in it.
>
> Other than that I think it's pretty stable. :)

So the level of stable I think would be needed is basically being able
to ship a new libtraceevent.so and have it not break a powertop that
was linked against a previous version.  E.g. libtraceevent.so provided
with the 3.15 kernel release can be used as an update to the
libtraceevent.so from the 3.13 release and powertop doesn't need to be
rebuilt.

That's typically done with soname and/or symbol versioning.  Clearly
applications wishing to use new libtraceevent features would need to
be rebuilt to take advantage of those, but basic functionality should
be pretty stable.  Changing soname/ABI happens elsewhere in userspace
libs and isn't a big deal for development, but those bumps typically
aren't done in the middle of a released distro version.  There are
several distros that do major kernel version updates during the
lifetime of a release so anything coming from those needs to be
handled carefully.

josh
