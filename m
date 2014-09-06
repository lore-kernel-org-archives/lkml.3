Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250AbaIFXoY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 19:44:24 -0400
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:42596 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbaIFXoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 19:44:23 -0400
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Sat, 6 Sep 2014 19:44:05 -0400
To: Alexander Holler <holler@ahsoftware.de>
Cc: Rob Landley <rob@landley.net>, Rogelio Serrano <rogelio.serrano@gmail.com>,
        Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
        =?utf-8?B?TcOlbnMgUnVsbGfDpXJk?= <mans@mansr.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Christopher Barry <christopher.r.barry@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: OT: Open letter to the Linux World
Message-ID: <20140906234405.GA17692@csclub.uwaterloo.ca>
References: <20140812202129.GA20344@home.goodmis.org>
 <yw1xr40l2whi.fsf@unicorn.mansr.com>
 <20140813082756.GB2923@twins.programming.kicks-ass.net>
 <20140813090013.GA20581@pd.tnic>
 <53F242D1.4050506@ahsoftware.de>
 <CANszf4jauBAhaTogvSprhhspKywXSu_8xkWh+ETsWMMUDKo0=g@mail.gmail.com>
 <5408B069.9080708@ahsoftware.de>
 <CAOS_Y6RAiwY=Zh4g6Ei4UYm3FMybwf+bSo_CwqQhaMsaJh10uw@mail.gmail.com>
 <540958AD.8030503@ahsoftware.de>
 <540B6819.9030201@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540B6819.9030201@ahsoftware.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 06, 2014 at 10:01:29PM +0200, Alexander Holler wrote:
> I've brought up the critics about using C in a critical and very
> security sensitive piece of software in userland, so I've decided a
> bit more explanations might make sense.
> 
> First, as you don't seem to have noticed or you don't know or you
> ignore the difference, let me repeat that this thread is about a
> piece of SW which runs in userland. So, please, keep away with any
> comments from Linus where he talks about kernelspace. I'm pretty
> sure he knows the difference.
> 
> Now let me bring up a very small piece of code which you can find in
> a similiar fashion in almost every piece of software which gets in
> contact with strings. And not just in one place or function, but in
> dozens or even hundred of places (inline, not in functions) in one
> project.
> 
> First in C++:
> 
> void foo_bar(const std::string& foo, const std::string& bar,
> std::string& foobar)
> {
> 	foobar = foo + bar;
> }
> 
> For those which don't know C++, this concatenates the two strings
> named foo and bar and puts the result into foobar.
> 
> Now an example how you would have to do that in C:
> 
> char *foo_bar(const char *foo, const char *bar)
> {
> 	char *foobar = malloc(strlen(foo) + strlen(bar));
> 
> 	strcpy(foobar, foo);
> 	strcat(foobar, bar);
> 
> 	return foobar;
> }
> 
> Do you see the difference and spot all the problems?
> 
> First I've though about not posting the answer to see the response,
> but that would just have ended up with a lot of people calling me a
> fool and/or assuming I can't write proper C. And it bears the
> problem that some inexperienced people might copy and paste and use
> it.
> 
> So at first: THE ABOVE EXAMPLE IN C IS BROKEN.
> 
> The very first problem is that foobar is allocated with the wrong
> size, because it doesn't take care of the terminating null byte. A
> very common problem already found at uncountable places.
> 
> But there are several more problems:
> 
> - What happens if foo or bar isn't terminated with a null byte?
> 
> - What happens if malloc fails?
> 
> - Who is the owner of foo, bar and/or foobar? Does the caller still
> owns foo and bar afterwards? Will the caller own foobar? (That means
> who is repsonsible to free foo, bar and foobar if they aren't used
> anymore).
> 
> So now we extend the above C example:
> 
> char *foo_bar(const char *foo, const char *bar)
> {
> 	char *foobar;
> 
> 	if (!foo || !bar)
> 		return NULL;
> 
> 	foobar = malloc(strlen(foo) + strlen(bar) + 1);
> 
> 	if (!foobar)
> 		return NULL;
> 
> 	strcpy(foobar, foo);
> 	strcat(foobar, bar);
> 
> 	return foobar;
> }
> 
> This has still some problems. First, the caller has to check if
> foo_bar() hasn't returned NULL. A very common bug already found in
> uncountable places too.
> 
> Next, there is still the unsolvable problem about what happens if
> foo or bar isn't terminated with a null byte (in other words they
> aren't C strings).
> So you have to check all callers up to the source of foo and bar to
> be sure the program doesn't crash in the possible far far away place
> called foo_bar().
> 
> And still no comment about ownership. That means someone who just
> looks at the prototype or sees a call of foo_bar() somewhere has no
> idea about the ownership of foo, bar and the returned foobar without
> a comment.
> 
> So just this very simple functionality about string handling in C
> already contains several still open questions and is 17 lines long
> which have to be reviewed very carefull (e.g. to not miss the
> off-by-one bug).
> Compare this with the 4 lines in C++ which are almost impossible to
> do or to use wrong.
> 
> And, again, this thread is about a piece of software which runs with
> process ID 1, wants to control the whole system and owns all
> permissions to modify the system in almost every possible way. It
> doesn't run as some user  with restricted permissions or in chroot
> or something similar. Some parts might do, but for sure not all
> (read again the above "far far away").
> 
> And now some stats. I've just checked out systemd:
> 
> git grep -E "strcat|strncat|strcpy|strncpy|strlen" | wc -l
> 570
> 
> git grep -E "strcat|strncat|strcpy|strncpy|memcpy|strlen" | wc -l
> 850
> 
> Ok, not every of those places might be part of pid 1. And several
> places are trivial calls like strlen("ATTR"), but it gives an idea
> about how many places do exist in systemd which might contain a
> problem wich isn't trivial to spot.
> 
> And regardless how clever and experienced these people are which are
> writing this piece of software, everyone is prone to do e.g. such an
> off-by-one bug.
> Maybe he writes the piece of code after having worked 12 hours,
> maybe he got interrupted while writing the code and continued it a
> day later, maybe it's full moon or maybe his last meal wasn't like
> it should have been.
> 
> Whatever.
> 
> This means, every piece of code in that piece of software has to be
> reviewed multiple times (reviewers aren't perfect too), and, as long
> as the software changes, every piece which changes has to be
> reviewed multiple times again.
> 
> I could continue with examples for lists, sets and similiar data
> structures, which have to be inventent again and again and again in
> C, whereas in C++ people can reuse some code which is already in use
> by many, many people in many, many other projects.
> 
> And to come to your argument about how simple everything in C is.
> Just look at the macro for container_of(). I wouldn't say it's such
> simple that everyone understands what it does. And it's just part of
> the Linux kernel, that means limited documentation and many people
> never heard of it before, compared with stuff which can be found
> standard libraries.
> 
> And, again, this is not about the kernelspace, it isn't the Linux
> kernel where Linus has managed it to organize an army of people
> which do look at every line again and again (and still do sometimes
> miss a bug).
> Most software projects don't have that many resources (human or not)
> available as the Linux kernel. In fact it's an absolute exception.
> 
> So you just don't want to use error prone C in new and non-trivial
> projects (if not really necessary) which are a major problem if
> something fails in the code.
> 
> Doing so just means nothing has be learned from the (of corse
> relatively short) history of software development.

So why C++ then if you care about making the code easy to make safe when
there are clearly even better options.  Why not OCAML or Erlang or one
of the other much more robust languages that don't contain all the
dangers of C?

-- 
Len Sorensen
