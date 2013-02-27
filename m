Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760550Ab3B0Rio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 12:38:44 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51397 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760417Ab3B0Rim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 12:38:42 -0500
Date: Wed, 27 Feb 2013 17:36:44 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Joe Perches <joe@perches.com>
Cc: Peter Korsgaard <jacmet@sunsite.dk>, Nicolas Pitre <nico@fluxnic.net>,
        "Markus F.X.J. Oberhumer" <markus@oberhumer.com>,
        Kyungsik Lee <kyungsik.lee@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, x86@kernel.org,
        celinux-dev@lists.celinuxforum.org,
        Nitin Gupta <nitingupta910@gmail.com>,
        Richard Purdie <rpurdie@openedhand.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>, David Sterba <dsterba@suse.cz>,
        Richard Cochran <richardcochran@gmail.com>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        Egon Alter <egon.alter@gmx.net>, hyojun.im@lge.com, chan.jeong@lge.com,
        raphael.andy.lee@gmail.com
Subject: Re: [RFC PATCH v2 0/4] Add support for LZ4-compressed kernel
Message-ID: <20130227173644.GC17833@n2100.arm.linux.org.uk>
References: <1361859870-15751-1-git-send-email-kyungsik.lee@lge.com> <512D1C12.4080109@oberhumer.com> <alpine.LFD.2.03.1302261557220.1254@syhkavp.arg> <87fw0i7n6d.fsf@dell.be.48ers.dk> <20130226221027.GW17833@n2100.arm.linux.org.uk> <1361929234.1924.8.camel@joe-AO722> <20130227095609.GY17833@n2100.arm.linux.org.uk> <1361980152.2035.13.camel@joe-AO722> <20130227163118.GB17833@n2100.arm.linux.org.uk> <1361984688.2035.20.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361984688.2035.20.camel@joe-AO722>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 09:04:48AM -0800, Joe Perches wrote:
> On Wed, 2013-02-27 at 16:31 +0000, Russell King - ARM Linux wrote:
> > On Wed, Feb 27, 2013 at 07:49:12AM -0800, Joe Perches wrote:
> > > On Wed, 2013-02-27 at 09:56 +0000, Russell King - ARM Linux wrote:
> > > > On Tue, Feb 26, 2013 at 05:40:34PM -0800, Joe Perches wrote:
> > > > > On Tue, 2013-02-26 at 22:10 +0000, Russell King - ARM Linux wrote:
> > > > > > So... for a selected kernel version of a particular size, can we please
> > > > > > have a comparison between the new LZO code and this LZ4 code, so that
> > > > > > we can see whether it's worth updating the LZO code or replacing the
> > > > > > LZO code with LZ4?
> > > > > 
> > > > > How could it be questionable that it's worth updating the LZO code?
> > > > 
> > > > Please read the comments against the previous posting of these patches
> > > > where I first stated this argument - and with agreement from those
> > > > following the thread.  The thread started on 26 Jan 2013.  Thanks.
> > > 
> > > https://lkml.org/lkml/2013/1/29/145
> > > 
> > > I did not and do not see significant value in
> > > adding LZ4 given Markus' LZO improvements.
> > 
> > Sorry, a 66% increase in decompression speed over the updated LZO code
> > isn't "significant value" ?
> 
> We disagree.

ROTFL.

> > I'm curious - what in your mind qualifies "significant value" ?
> 
> faster boot time. smaller, faster overall code.

ROTFL again!  Because you've just disagreed with your above statement.
"66% increase in decompression speed" as far as I know _is_ "faster
boot time" !

> > Maybe "significant value" is a patch which buggily involves converting
> > all those "<n>" printk format strings in assembly files to KERN_* macros,
> > thereby breaking those strings because you've not paid attention to what
> > .asciz means?  (Yes, I've just cleaned that crap up after you...)
> 
> If you mean commit 0cc41e4a21d43, perhaps you could clarify with an
> example.  I don't see any relevant changes by you in -next, but
> maybe I'm not looking in the right spot.

While recently asking someone to enable VFP debugging, so I could help
sort out a problem they had reported, this is the debug output I was
greeted by thanks to your meddling:

[  927.235546] \x01\x01\x01\x01\x01\x01\x01\x01
...
[  927.241505] \x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01                     

Yes, really useful debug output isn't it?  You can really see what's
going on there.  These are coming from ultimately two commits - the
one you refer to above, which on its own would've changed the printk
string to be merely "<7>" - and the follow on commit changing the
way printk levels are dealt with.

The above output is produced by:

#define KERN_SOH        "\001"          /* ASCII Start Of Header */
#define KERN_DEBUG      KERN_SOH "7"    /* debug-level messages */

	.asciz  KERN_DEBUG "VFP: \str\n"

7.6 `.asciz "STRING"'...
========================

`.asciz' is just like `.ascii', but each string is followed by a zero
                                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
byte.  The "z" in `.asciz' stands for "zero".
^^^^^

 0000 01003700 5646503a 20696e73 74722025  ..7.VFP: instr %
        ^^  ^^
 0010 30387820 70632025 30387820 73746174  08x pc %08x stat
 0020 65202570 0a000100 37005646 503a2066  e %p....7.VFP: f
                 ^^
...

That is: \x01 \x00 7 \x00 VFP: instr %08x pc %08x state %p \x00

See - three separately terminated strings because you changed:

	.asciz	"<7>VFP: \str\n"

to:

	.asciz	"<7>" "VFP: \str\n"

which turned it into _two_ separately NUL-terminated strings, and then
the follow-on changes to printk kern levels changed this to:

	.asciz	"\001" "7" "VFP: \str\n"

producing _three_ separately NUL-terminated strings.

The commit is not in mainline, nor linux-next, but in my tree as of
yesterday (e36815e2e), ready to be pushed out when I've finished working
on fixing other problems with VFP - or when I decide to push it out ready
for submission during this merge window.

> The change did enable reducing code size.

??? Yea, right, meanwhile breaking the ability of stuff to produce
kernel messages.

> > > Why would the LZO code not be updated?
> > I'm not saying that the LZO code should not be updated.
> 
> You said:
> 
> > > > > > so that we can see whether it's worth updating the LZO code
> 
> Sounded as if you were doubtful to me.

_In_ the decompressor.  We're talking about the _decompressor_ in
this thread.
