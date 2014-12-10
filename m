Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbaLJKLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 05:11:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37179 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbaLJKLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 05:11:15 -0500
Date: Wed, 10 Dec 2014 11:11:47 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>, live-patching@vger.kernel.org,
        x86@kernel.org, kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] livepatch v5: avoid race when checking for state of
 the patch
Message-ID: <20141210101147.GB2454@pathway.suse.cz>
References: <1418148307-21434-1-git-send-email-pmladek@suse.cz>
 <1418148307-21434-2-git-send-email-pmladek@suse.cz>
 <20141209183249.GA25239@treble.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141209183249.GA25239@treble.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-12-09 12:32:49, Josh Poimboeuf wrote:
> On Tue, Dec 09, 2014 at 07:05:02PM +0100, Petr Mladek wrote:
> > klp_patch_enable() and klp_patch_disable() should check the current state
> > of the patch under the klp_lock. Otherwise, it might detect that the operation
> > is valid but the situation might change before it takes the lock.
> 
> Hi Petr,
> 
> Thanks for the patches.
> 
> I don't think this patch is necessary.  klp_is_enabled() doesn't check
> the state of the patch.  It checks the initialization state of the core
> module (klp_root_kobj), which can only be set in klp_init().  It's not
> protected by the lock, so I don't see the point of this patch.

Ah, I have misread the name and expected that it checked whether
the patch was enabled or disabled. The original code is OK then.

Well, Jiri Kosina pointed out that the check did not make much sense.
klp_is_enabled() could not be called if the livepatch module is not
loaded. And the later check for klp_patch_is_registered() is enough
to check whether the klp_enable_patch()/klp_disable_patch() calls
are allowed or not.

So, I suggest to remove the checks at all.

Best Regards,
Petr


> > 
> > Signed-off-by: Petr Mladek <pmladek@suse.cz>
> > ---
> >  kernel/livepatch/core.c | 16 ++++++++++------
> >  1 file changed, 10 insertions(+), 6 deletions(-)
> > 
> > diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> > index d6d0f50e81f8..b848069e44cc 100644
> > --- a/kernel/livepatch/core.c
> > +++ b/kernel/livepatch/core.c
> > @@ -425,11 +425,13 @@ int klp_disable_patch(struct klp_patch *patch)
> >  {
> >  	int ret;
> >  
> > -	if (!klp_is_enabled())
> > -		return -ENODEV;
> > -
> >  	mutex_lock(&klp_mutex);
> >  
> > +	if (!klp_is_enabled()) {
> > +		ret = -ENODEV;
> > +		goto err;
> > +	}
> > +
> >  	if (!klp_patch_is_registered(patch)) {
> >  		ret = -EINVAL;
> >  		goto err;
> > @@ -489,11 +491,13 @@ int klp_enable_patch(struct klp_patch *patch)
> >  {
> >  	int ret;
> >  
> > -	if (!klp_is_enabled())
> > -		return -ENODEV;
> > -
> >  	mutex_lock(&klp_mutex);
> >  
> > +	if (!klp_is_enabled()) {
> > +		ret = -ENODEV;
> > +		goto err;
> > +	}
> > +
> >  	if (!klp_patch_is_registered(patch)) {
> >  		ret = -EINVAL;
> >  		goto err;
> > -- 
> > 1.8.5.2
> > 
> 
> -- 
> Josh
