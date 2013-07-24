Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab3GXRqI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 13:46:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19829 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab3GXRqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 13:46:05 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=X7p0W-CcHCoA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=zNXoGfytzK0A:10 a=Ok3p364r5BlQo3MhLOIA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374687963.3356.145.camel@gandalf.local.home>
Subject: Re: [ 000/103] 3.10.3-stable review
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "gregkh@linuxfoundation.org >> Kroah-Hartman, Greg" 
	<gregkh@linuxfoundation.org>,
        Shuah Khan <shuah.kh@samsung.com>, Shuah Khan <shuahkhan@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Date: Wed, 24 Jul 2013 13:46:03 -0400
In-Reply-To: <CA+55aFyKRRDaohVPDSXZ5BRCHqAXAJv16EHS=aCj4B09VYrr6A@mail.gmail.com>
References: <20130723220418.532514378@linuxfoundation.org>
	 <CAKocOOPO61YUj5kTL7k1HuEeDdB_x=sxWga007nBSiLD4Px5Mg@mail.gmail.com>
	 <B8EFE96D1287C24090BAD9D858E15E61748BEA@sisaex01sj>
	 <20130724145506.GC15095@kroah.com>
	 <CA+55aFxdz6X8BfdzM5CwH_5Jmz=R1JMuLoo=r1yhWST+tKA7bw@mail.gmail.com>
	 <1374686174.3356.135.camel@gandalf.local.home>
	 <CA+55aFyKRRDaohVPDSXZ5BRCHqAXAJv16EHS=aCj4B09VYrr6A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-24 at 10:24 -0700, Linus Torvalds wrote:
> On Wed, Jul 24, 2013 at 10:16 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > I don't know why "git apply" doesn't do it by default. Why would you
> > want to apply a patch without having git track new files?
> 
> There's a few reasons for the behavior:
> 
>  - it turns out that for most simple patches, you don't want to add
> them to the index, and you want to stage them separately. Doing a "git
> apply", you'd normally expect the end result to not be staged, so that
> it shows up in "git diff", and then you can do your normal "git add"
> or "git commit -a" or whatever. Yes, this means that you need to know
> about new files, but the expected use is *not* to apply a patch
> blindly and then not even care about the index.

Heh, I usually still use the --index, and then just do "git diff HEAD"
to check out what changed. If I don't like it, a "git reset --hard"
fixes things.

> 
>  - "git apply" is actually also designed to be a *replacement* for
> "patch". In particular, you can use it outside a git repository,

OK, this makes more sense.

> exactly like you'd use the standard "patch" program. Except unlike the
> standard "patch" program, "git apply" doesn't accept fuzz by default
> (which to me is a huge deal - I hate how "patch" tries to apply stuff
> that clearly isn't valid any more) and also knows about things like
> file modes and renames etc.

I've learned to use -F0, but yeah, that's a pain.

> 
> That second part is something not enough people use, and when I make
> patches and tar-balls I still generate the old-style non-rename
> patches etc for that reason. But basically the command is designed to
> also be used in non-git environments, so the "standard usage" is very
> much not the "involve git details" behavior.

I just find it funny to use git outside of a git environment. Perhaps
"git apply" should have another name? "pit"?

> 
> Most "true git" workflows end up using "git am" (or, better yet, "git
> pull" etc) to apply patches, which obviously not only does the --index
> thing, but also applies the changelog etc.

I'm still somewhat old school, and my workflow uses git + quilt a bit. I
do a bunch of changes, then I do:

git diff > foo.patch
patch -p1 -R < foo.patch
quilt import foo.patch
rm foo.patch

And save off those changes to another time. When I get back to the
patch, I do:

quilt push
<make final fixes>
quilt refresh
quilt pop
git apply --index < patches/foo.patch

Sometimes I just leave off the pop and apply to do a git commit -a, but
then when I do a quilt pop I need to do a "git reset --hard" to reset
things. Having the patch in quilt gives me a nice record of what I did,
instead of searching through git history.

Note, I do know about git quiltimport, but my quilt queue contains lots
of debug patches and things that are still pending (I modify the series
file a lot). What would help is to add an option to git quiltimport that
will limit the number of patches it imports.

git quiltimport -c 1

-- Steve


