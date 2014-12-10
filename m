Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002AbaLJPfX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 10:35:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756341AbaLJPfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 10:35:22 -0500
Date: Wed, 10 Dec 2014 09:34:48 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Petr Mladek <pmladek@suse.cz>
Cc: Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>, live-patching@vger.kernel.org,
        x86@kernel.org, kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] livepatch v5: split init and free code that is done
 only for loaded modules
Message-ID: <20141210153448.GC32670@treble.redhat.com>
References: <1418148307-21434-1-git-send-email-pmladek@suse.cz>
 <1418148307-21434-6-git-send-email-pmladek@suse.cz>
 <20141209185141.GA3955@treble.redhat.com>
 <20141210103016.GC2454@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141210103016.GC2454@pathway.suse.cz>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 11:30:16AM +0100, Petr Mladek wrote:
> On Tue 2014-12-09 12:51:41, Josh Poimboeuf wrote:
> > On Tue, Dec 09, 2014 at 07:05:06PM +0100, Petr Mladek wrote:
> > > This patch makes it clear what initialization and freeing steps need to be done
> > > when an object (module) is being loaded or removed. It will help to maintain
> > > the module coming and going handlers. Also it will remove duplicated
> > > code from these handlers.
> > > 
> > > Signed-off-by: Petr Mladek <pmladek@suse.cz>
> > > ---
> > >  kernel/livepatch/core.c | 92 ++++++++++++++++++++++++++++++++-----------------
> > >  1 file changed, 61 insertions(+), 31 deletions(-)
> > > 
> > > diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> > > index 97a8d4a3d6d8..fe312b9ada78 100644
> > > --- a/kernel/livepatch/core.c
> > > +++ b/kernel/livepatch/core.c
> > > @@ -590,6 +590,12 @@ static struct kobj_type klp_ktype_func = {
> > >  	.sysfs_ops = &kobj_sysfs_ops,
> > >  };
> > >  
> > > +/* Clean up when a patched object is unloaded */
> > > +static void klp_free_func_loaded(struct klp_func *func)
> > > +{
> > > +	func->old_addr = 0;
> > > +}
> > > +
> > >  /*
> > >   * Free all functions' kobjects in the array up to some limit. When limit is
> > >   * NULL, all kobjects are freed.
> > > @@ -603,6 +609,17 @@ static void klp_free_funcs_limited(struct klp_object *obj,
> > >  		kobject_put(&func->kobj);
> > >  }
> > >  
> > > +/* Clean up when a patched object is unloaded */
> > > +static void klp_free_object_loaded(struct klp_object *obj)
> > > +{
> > > +	struct klp_func *func;
> > > +
> > > +	obj->mod = NULL;
> > > +
> > > +	for (func = obj->funcs; func->old_name; func++)
> > > +		klp_free_func_loaded(func);
> > > +}
> > > +
> > >  /*
> > >   * Free all objects' kobjects in the array up to some limit. When limit is
> > >   * NULL, all kobjects are freed.
> > > @@ -626,6 +643,12 @@ static void klp_free_patch(struct klp_patch *patch)
> > >  	kobject_put(&patch->kobj);
> > >  }
> > >  
> > > +/* parts of the initialization that is done only when the object is loaded */
> > > +static int klp_init_func_loaded(struct klp_object *obj, struct klp_func *func)
> > > +{
> > > +	return klp_find_verify_func_addr(obj, func);
> > > +}
> > > +
> > 
> > Creating a new function here for one line of code, which is only called
> > once, seems excessive, and makes the code harder to understand IMO.
> 
> I see your point. Well, note that the split code is code is called
> twice from klp_init_object() and klp_module_coming(), so it helps
> to remove the code duplicity.
> 
> Also it clearly separates the operations that are always done
> and that are done only when the object is loaded.
> 
> If you suggest to call klp_find_verify_func_addr() directly
> from klp_init_object_loaded(), I am fine with it. We could always
> create it later if there are more operations needed for
> struct func.

Thanks, I'll merge the rest of this patch (except for the separate
klp_init_func_loaded and klp_free_func_loaded).

I should have v6 soon.

-- 
Josh
