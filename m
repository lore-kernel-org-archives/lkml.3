Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbaKGMst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 07:48:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47800 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbaKGMss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 07:48:48 -0500
Date: Fri, 7 Nov 2014 13:48:45 +0100
From: Vojtech Pavlik <vojtech@suse.cz>
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Seth Jennings <sjenning@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        live-patching@vger.kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Kernel Live Patching
Message-ID: <20141107124845.GA6086@suse.cz>
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com>
 <20141106184446.GA12779@infradead.org>
 <20141106185157.GB29272@suse.cz>
 <20141106185857.GA7106@infradead.org>
 <20141106202423.GB2266@suse.cz>
 <20141107123154.GA4071@treble.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141107123154.GA4071@treble.redhat.com>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 06:31:54AM -0600, Josh Poimboeuf wrote:
> On Thu, Nov 06, 2014 at 09:24:23PM +0100, Vojtech Pavlik wrote:
> > On Thu, Nov 06, 2014 at 10:58:57AM -0800, Christoph Hellwig wrote:
> > 
> > > On Thu, Nov 06, 2014 at 07:51:57PM +0100, Vojtech Pavlik wrote:
> > > > I don't think this specific example was generated. 
> > > > 
> > > > I also don't think including the whole kpatch automation into the kernel
> > > > tree is a viable development model for it. (Same would apply for kGraft
> > > > automation.)
> > > 
> > > Why?  We (IMHO incorrectly) used the argument of tight coupling to put
> > > perf into the kernel tree.  Generating kernel live patches is way more
> > > integrated that it absolutely has to go into the tree to be able to do
> > > proper development on it in an integrated fashion.
> > 
> > One reason is that there are currently at least two generators using
> > very different methods of generation (in addition to the option of doing
> > the patch module by hand), and neither of them are currently in a state
> > where they would be ready for inclusion into the kernel (although the
> > kpatch one is clearly closer to that).
> 
> What generator does kGraft have?  Is that the one that generates the
> source patch, or is there one that generates a binary patch module?

The generator for kGraft:

	* extracts a list of changed functions from a patch (rather naïvely so far)
	* uses DWARF debuginfo of the old kernel to handle things like inlining
	  and create a complete list of functions that need to be replaced
	* compiles the kernel with -fdata-sections -ffunction-sections
	* uses a modified objcopy to extract functions from the kernel
	  into a single .o file
	* creates a stub .c file that references those functions
	* compiles the .c and links with the .o to build a .ko

The main difference is in that the kGraft generator doesn't try to
compare the old and new binary objects, but rather works with function
lists and the DWARF info of the old code and extracts new functions from
the new binary.

However, as I said before, we have found enough trouble around eg.
IPA-SRA and other optimizations that make any automated approach fragile
and in our view more effort than benefit. Hence, we're intend to use the
manual way of creating live patches until proven that we were wrong in
this assessment. :)

-- 
Vojtech Pavlik
Director SUSE Labs
