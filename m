Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbaKGNH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 08:07:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbaKGNHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 08:07:25 -0500
Date: Fri, 7 Nov 2014 07:06:54 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Vojtech Pavlik <vojtech@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Seth Jennings <sjenning@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        live-patching@vger.kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Kernel Live Patching
Message-ID: <20141107130654.GC4071@treble.redhat.com>
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com>
 <20141106184446.GA12779@infradead.org>
 <20141106185157.GB29272@suse.cz>
 <20141106185857.GA7106@infradead.org>
 <20141106202423.GB2266@suse.cz>
 <20141107123154.GA4071@treble.redhat.com>
 <20141107124845.GA6086@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141107124845.GA6086@suse.cz>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 01:48:45PM +0100, Vojtech Pavlik wrote:
> On Fri, Nov 07, 2014 at 06:31:54AM -0600, Josh Poimboeuf wrote:
> > On Thu, Nov 06, 2014 at 09:24:23PM +0100, Vojtech Pavlik wrote:
> > > On Thu, Nov 06, 2014 at 10:58:57AM -0800, Christoph Hellwig wrote:
> > > 
> > > > On Thu, Nov 06, 2014 at 07:51:57PM +0100, Vojtech Pavlik wrote:
> > > > > I don't think this specific example was generated. 
> > > > > 
> > > > > I also don't think including the whole kpatch automation into the kernel
> > > > > tree is a viable development model for it. (Same would apply for kGraft
> > > > > automation.)
> > > > 
> > > > Why?  We (IMHO incorrectly) used the argument of tight coupling to put
> > > > perf into the kernel tree.  Generating kernel live patches is way more
> > > > integrated that it absolutely has to go into the tree to be able to do
> > > > proper development on it in an integrated fashion.
> > > 
> > > One reason is that there are currently at least two generators using
> > > very different methods of generation (in addition to the option of doing
> > > the patch module by hand), and neither of them are currently in a state
> > > where they would be ready for inclusion into the kernel (although the
> > > kpatch one is clearly closer to that).
> > 
> > What generator does kGraft have?  Is that the one that generates the
> > source patch, or is there one that generates a binary patch module?
> 
> The generator for kGraft:
> 
> 	* extracts a list of changed functions from a patch (rather naïvely so far)
> 	* uses DWARF debuginfo of the old kernel to handle things like inlining
> 	  and create a complete list of functions that need to be replaced
> 	* compiles the kernel with -fdata-sections -ffunction-sections
> 	* uses a modified objcopy to extract functions from the kernel
> 	  into a single .o file
> 	* creates a stub .c file that references those functions
> 	* compiles the .c and links with the .o to build a .ko
> 
> The main difference is in that the kGraft generator doesn't try to
> compare the old and new binary objects, but rather works with function
> lists and the DWARF info of the old code and extracts new functions from
> the new binary.

Thanks, interesting.  Sounds like we're mostly on the same page here.

> 
> However, as I said before, we have found enough trouble around eg.
> IPA-SRA and other optimizations that make any automated approach fragile
> and in our view more effort than benefit. Hence, we're intend to use the
> manual way of creating live patches until proven that we were wrong in
> this assessment. :)

Yeah.  We've already put in a lot of effort to support the gcc optimizations
like IPA-SRA, partial inlining, static variable renaming, etc.  And also
added support for many kernel special sections.

For now, at least, it works very well, and we find that generation is
_much_ easier and less error-prone than the manual approach.  So in our
experience, the benefits far outweigh the effort.

But I do agree that it's fragile, and at the mercy of any future gcc
optimization features.  Which is why I like our current approach of
supporting the manual approach as well.  The manual approach isn't
optimal, but it is a nice backup solution for us in case something
causes the generator to break.

-- 
Josh
