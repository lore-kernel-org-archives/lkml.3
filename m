Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965578AbaKNOxD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 09:53:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34615 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965341AbaKNOxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 09:53:00 -0500
Date: Fri, 14 Nov 2014 15:52:49 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Miroslav Benes <mbenes@suse.cz>
Cc: Seth Jennings <sjenning@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, jslaby@suse.cz,
        live-patching@vger.kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kernel: add support for live patching
Message-ID: <20141114145249.GD7969@dhcp128.suse.cz>
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com>
 <1415284748-14648-3-git-send-email-sjenning@redhat.com>
 <alpine.LNX.2.00.1411131105290.10080@pobox.suse.cz>
 <20141113171203.GA10996@cerebellum.variantweb.net>
 <alpine.LNX.2.00.1411141407280.27190@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1411141407280.27190@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-11-14 14:30:30, Miroslav Benes wrote:
> On Thu, 13 Nov 2014, Seth Jennings wrote:
> 
> > On Thu, Nov 13, 2014 at 11:16:00AM +0100, Miroslav Benes wrote:
> > > 
> > > Hi,
> > > 
> > > thank you for the first version of the united live patching core.
> > > 
> > > The patch below implements some of our review objections. Changes are 
> > > described in the commit log. It simplifies the hierarchy of data 
> > > structures, removes data duplication (lp_ and lpc_ structures) and 
> > > simplifies sysfs directory.
> > > 
> > > I did not try to repair other stuff (races, function names, function 
> > > prefix, api symmetry etc.). It should serve as a demonstration of our 
> > > point of view.
> > > 
> > > There are some problems with this. try_module_get and module_put may be 
> > > called several times for each kernel module where some function is 
> > > patched in. This should be fixed with module going notifier as suggested 
> > > by Petr. 
> > > 
> > > The modified core was tested with modified testing live patch originally 
> > > from Seth's github. It worked as expected.
> > > 
> > > Please take a look at these changes, so we can discuss them in more 
> > > detail.
> > 
> > Thanks Miroslav.
> > 
> > The functional changes are a little hard to break out from the
> > formatting changes like s/disable/unregister and s/lp_/lpc_/ or adding
> > LPC_ prefix to the enum, most (all?) of which I have included for v2.
> > 
> > A problem with getting rid of the object layer is that there are
> > operations we do that are object-level operations.  For example,
> > module lookup and deferred module patching.  Also, the dynamic
> > relocations need to be associated with an object, not a patch, as not
> > all relocations will be able to be applied at patch load time for
> > patches that apply to modules that aren't loaded.  I understand that you
> > can walk the patch-level dynrela table and skip dynrela entries that
> > don't match the target object, but why do that when you can cleanly
> > express the relationship with a data structure hierarchy?
> > 
> > One example is the call to is_object_loaded() (renamed and reworked in
> > v2 btw) per function rather than per object.  That is duplicate work and
> > information that could be more cleanly expressed through an object
> > layer.
> 
> I understand your arguments as I had thought about this before. It is true 
> that some operations which are connected with the object level could be 
> duplicated in our approach. However the list of patched functions and 
> especially objects (vmlinux or modules) would be always relatively short. 
> Two-level hierarchy (functions and patches) is in my opinion more compact 
> and easier to maintain. I do not think that object-level outweighs this. 
> Let us think about it some more...
> 
> > I also understand that sysfs/kobject stuff adds code length.  However,
> > the new "funcs" attribute is procfs style, not sysfs style.  sysfs
> > attribute should convey _one_ value.
> > 
> > >From Documenation/filesystems/sysfs.txt:
> > ==========
> > Attributes should be ASCII text files, preferably with only one value
> > per file. It is noted that it may not be efficient to contain only one
> > value per file, so it is socially acceptable to express an array of
> > values of the same type. 
> > 
> > Mixing types, expressing multiple lines of data, and doing fancy
> > formatting of data is heavily frowned upon. Doing these things may get
> > you publicly humiliated and your code rewritten without notice. 
> > ==========
> 
> Ah, you are right. My mistake. Thank you.
> 
> > Also the function list would have object ambiguity.  If there was a
> > patched function my_func() in both vmlinux and a module, it would just
> > appear on the list twice. You can fix this by using the mod:func syntax
> > like kallsyms, but it isn't as clean as expressing it in a hierarchy.
> 
> Yes, using mod:func or check against module name (and not only function 
> name) would be necessary. Ambiguity would be also the problem in sysfs 
> directory tree without object level. But it is doable.
> 
> > As far as the unification of the API structures with the internal
> > structures I have two points.  First is that, IMHO, we should assume that
> > the structures coming from the user are const.  In kpatch, for example,
> > we pass through some structures that are not created in the code, but by
> > the patch generation tool and stored in an ELF section (read-only).
> > Additionally, I am really against exposing the internal fields.
> > Commenting them as "internal" is just messy and we have to change the .h
> > file every time when want to add a field for internal use.
> 
> Changing the header file and thus API between different kernel releases 
> is not a problem in my opinion. First live patching module would be 
> created against specific kernel version (so the correct API is known). 
> Second we would like to add userspace tool for automatic patch generation 
> to upstream sometime in the future. API would be of "no importance" there 
> as the situation in perf now (if I understand it correctly).
>  
> > It seems that the primary purpose of this patch is to reduce the lines
> > of code.  However, I think that the object layer of the data structure
> > cleanly expresses the object<->function relationship and makes code like
> > the deferred patching much more straightforward since you already have
> > the functions/dynrelas organized by object.  You don't have to do the
> > nasty "if (strcmp(func->obj_name, objname)) continue;" business over the
> > entire patch every time.

I think that it was not primary about the number of lines but about
the complexity.

> The primary purpose was to show our point of view. I do not pretend that 
> there are no problems, but there are also some benefits.

As discussed above, there were three main points where we had
different opinion.

1. The sysfs structure. It has to stay more complex as proposed in the
   original patch. We have somehow missed the rule about one value per
   file.

   Well, we might want to show the status instead of the addresses.
   Note that particular functions might be obsolete by another patch
   and it would be nice to show this in the sysfs tree.


2. The three level structure (patch -> object -> func) vs. the two
   level one (patch -> func). I have personally neutral feeling about
   it.

   The tree level structure looks cleaner, for example the problem
   with functions of the same name in different modules. It allows to
   optimize the structures and some operations, for example, it
   reduces the number of checks for loaded module,
   the functions for coming and going module are at one place.

   But it creates more spaghetti code, for example, the call
   create_patch() -> create_objects() -> create_object() ->
   create_funcs -> create_func(). Also the more structures
   create more complex abstraction that might be harder to keep in
   head, understand, and operate with.

   I think that we should compare the number of operations with all
   functions or just with the object. Then we could see if it is really
   worth it.

   Also we might take inspiration in some similar existing stuff,
   for example with ftrace, kprobe, kallsyms.


3. The separation of public and internal structures. I would really
   like to avoid the duplication.

   If I get it correctly that main motivation is the API stability
   but I think that it is not a real problem here.

   The separation creates extra code (copying). Also it creates a
   confusion because there are many variables and functions of the
   same name that differ only in one character (lp vs lpc).

   From my point of view, this is not worth having.


> > Be advised, I have also done away with the new_addr/old_addr attributes
> > for v2 and replaced the patched module ref'ing with a combination of a
> > GOING notifier with lpc_mutex for protection.

Great.

> Great. I'll wait for v2 and resend our patch based on that, rebased and 
> split to several patches. We can continue the discussion afterwards. Is it 
> ok?

Sounds like a good plan.

Best Regards,
Petr
