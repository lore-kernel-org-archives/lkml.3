Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933Ab3LJCDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 21:03:47 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:42047 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab3LJCDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 21:03:46 -0500
X-AuditID: 9c930197-b7bdbae000000e78-5a-52a676817b39
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 01/14] tools lib traceevent: Get rid of malloc_or_die() in show_error()
References: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
	<1386567251-22751-2-git-send-email-namhyung@kernel.org>
	<20131209183009.GC8098@ghostprotocols.net>
	<20131209140342.5f72298f@gandalf.local.home>
	<20131209191439.GG8098@ghostprotocols.net>
	<20131209142350.5d23108c@gandalf.local.home>
Date: Tue, 10 Dec 2013 11:03:44 +0900
In-Reply-To: <20131209142350.5d23108c@gandalf.local.home> (Steven Rostedt's
	message of "Mon, 9 Dec 2013 14:23:50 -0500")
Message-ID: <87mwk9jwcf.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Dec 2013 14:23:50 -0500, Steven Rostedt wrote:
> On Mon, 9 Dec 2013 16:14:39 -0300
> Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:
>
>> Em Mon, Dec 09, 2013 at 02:03:42PM -0500, Steven Rostedt escreveu:
>> > On Mon, 9 Dec 2013 15:30:09 -0300
>> > Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:
>> > 
>> > 
>> > > > +		error = malloc(MAX_ERR_STR_SIZE);
>> > > > +		if (error == NULL) {
>> > > > +			/* no memory */
>> > > > +			*error_str = "failed to allocate memory";
>> > > > +			return;
>> > > 
>> > > Can *error_str point to either malloc'ed or constant strings? Who
>> > > releases the allocated memory?
>> > > 
>> > 
>> > Good question. Perhaps we should have a flag that states if the string
>> > is allocated or not. Or better yet, since the only reason it would be
>> > pointing to a static string is if the string for error_str itself
>> > failed to allocate. Then we could use a string within pevent for it:
>> > 
>> > static char *pevent_failed_error_alloc = "failed to allocate memory";
>> > 
>> > Then in the freeing of error str:
>> > 
>> > void pevent_free_error_str(error_str)
>> > {
>> > 	if (error_str != pevent_failed_error_alloc)
>> > 		free(error_str);
>> > }
>> 
>> That is a possibility, yes, then any other routine that works in such a
>> way could check against this string, but what is wrong with returning a
>> value to that function and checking against < 0?
>
> Then everyone has to check if show_error() failed. Then report a bug if
> it did. Egad, then we need to check if that error function failed, and
> then that one and that one and that one :-)

What about returning error code rather than string?  This way we won't
worry about the allocation of the error string itself.

But the downside of it is loosing a positional info of the error.
Hmm.. what about using a static buffer in pevent for it then?

Thanks,
Namhyung
