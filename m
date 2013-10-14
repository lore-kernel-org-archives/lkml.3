Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145Ab3JNNhT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 09:37:19 -0400
Received: from service87.mimecast.com ([91.220.42.44]:55754 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756456Ab3JNNhR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 09:37:17 -0400
Message-ID: <1381757834.13099.14.camel@hornet>
Subject: Re: [PATCH] init: fix in-place parameter modification regression
From: Pawel Moll <pawel.moll@arm.com>
To: Krzysztof Mazur <krzysiek@podlesie.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 14 Oct 2013 14:37:14 +0100
In-Reply-To: <20131014125001.GA6015@shrek.podlesie.net>
References: <1381601100-5622-1-git-send-email-krzysiek@podlesie.net>
	 <1381750442.3247.48.camel@hornet>
	 <20131014125001.GA6015@shrek.podlesie.net>
X-Mailer: Evolution 3.8.2-0ubuntu1~raring1
Mime-Version: 1.0
X-OriginalArrivalTime: 14 Oct 2013 13:37:14.0838 (UTC) FILETIME=[7E5AFF60:01CEC8E2]
X-MC-Unique: 113101414371510201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-10-14 at 13:50 +0100, Krzysztof Mazur wrote:
> > Hold on. static_command_line can be only accessed within init/main.c. As
> > far as I can say, it is only used by unknown_bootoption() (so your
> > __setup callbacks) and then in the do_initcall_level().
> 
> But I think it's legal to keep the pointer to the option argument
> (which points to static_command_line) in __setup callback and use it later,
> and assume that the argument value will never change.

Ah, of course. I forgot about this possibility. Yes, I think it's even
mentioned in a comment somewhere.

> However, with my patch it's no longer true for per-initcall arguments
> because they share the same command line buffer, so the tmp_cmdline
> have the __initdata attribute. The same restriction applies to
> the "early params".

Right. I'm glad you've pointed this out :-)

I'm not sure if this is acceptable. I'll stare at the code for a while,
Rusty may have some idea as well.

> > So, assuming that it is actually legal to modify static_command_line in
> > __setup()-s (and I must say I have rather mixed feelings about it ;-),
> 
> I also have mixed feelings about that, but the parse_args() already
> does that, because some characters are replaced with '\0' to split
> command line into separate strings. 

Yeah, that's why I referred to static_command_line as "scratch buffer".
Of course when someone keeps pointer to it, it has to be carefully
modified...

> The ubd driver does the same
> to split parameter into two strings.
> 
> So after parsing, the command line:
> 
> 	"ubd0=cow_file,file hostfs=/path"
> 
> is changed to:
> 
> 	"ubd0\0cow_file\0file\0hostfs\0path"

Ok, such kind of changes, I see... Still ugly, but something I think I
can swallow...

> > Generally I agree that the commit in question changed the semantics in a
> > subtle way - it makes the do_initcalls() use saved_command_line as a
> > string to be parsed instead of static_command_line. I was convinced that
> > at this stage of execution they must be identical (and the
> 
> No, at that stage the static_command_line is already parsed by
> parse_args("Booting kernel", ...).

I meant "identical" with the '\0' approximation. I'm getting the point
though.

> > static_command_line is a de-facto scratch buffer). You're saying that is
> > may not be the case, which can be true, but you're keeping the same
> > behaviour :-)
> > 
> > So either you have some extra changes in your kernel actually using
> > static_command_line for some other reason, or your change makes no
> > difference. The third option is me being brain dead today, which is not
> > impossible ;-)
> > 
> 
> I've been using vanilla v3.12-rc4-92-gb68ba36. Now I'm using v3.12-rc5.

Ok, I think I understand the problem now. Let me think about it for a
while.

Paweł


