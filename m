Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312AbaISOcH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 10:32:07 -0400
Received: from pegasus3.altlinux.org ([194.107.17.103]:41066 "EHLO
	pegasus3.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756365AbaISOcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 10:32:05 -0400
X-Greylist: delayed 580 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Sep 2014 10:32:04 EDT
Date: Fri, 19 Sep 2014 18:22:21 +0400
From: Mikhail Efremov <sem@altlinux.ru>
To: Mateusz Guzik <mguzik@redhat.com>
Cc: Mikhail Efremov <sem@altlinux.org>, linux-kernel@vger.kernel.org,
        Miklos Szeredi <mszeredi@suse.cz>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] vfs: Don't exchange filenames unconditionally.
Message-ID: <20140919182221.0d8c2a92@sem.office.altlinux.ru>
In-Reply-To: <20140918112206.GA26866@mguzik>
References: <1411037700-28966-1-git-send-email-sem@altlinux.org>
	<20140918112206.GA26866@mguzik>
Organization: ALT Linux
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-alt-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2014 13:22:07 +0200 Mateusz Guzik wrote:
> On Thu, Sep 18, 2014 at 02:55:00PM +0400, Mikhail Efremov wrote:
> > Only exchange source and destination filenames
> > if flags contain RENAME_EXCHANGE.
> 
> But names are still exchanged without RENAME_EXCHANGE, provided they are
> long enough.
> 
> da1ce0670c14 introduced this behaviour also for short names and this is
> what you are reverting here.
> 
> That said, I think the patch is fine as an interim change, but should
> note facts mentioned above.
> 
> For more info please see https://lkml.org/lkml/2014/9/7/6

Thanks for pointing out that thread to me, I didn't read it before
sending the patch.

> I'll be posting a RFC patch for actual problem next week.

I suppose then that no sense to resend this patch right now, I'll just
wait the proper solution from you.
Yet this patch can be used as a temporary workaround (as you mentioned
above) if the proper solution takes longer than expected to implement.

> > In case if executable file was running and replaced by
> > other file /proc/PID/exe should still show correct file name,
> > not the old name of the file by which it was replaced.
> 
> 
> 
> 
> > The scenario when this bug manifests itself was like this:
> > * ALT Linux uses rpm and start-stop-daemon;
> > * during a package upgrade rpm creates a temporary file
> >   for an executable to rename it upon successful unpacking;
> > * start-stop-daemon is run subsequently and it obtains
> >   the (nonexistant) temporary filename via /proc/PID/exe
> >   thus failing to identify the running process.
> > 
> > Cc: Miklos Szeredi <mszeredi@suse.cz>
> > Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> > Cc: linux-fsdevel@vger.kernel.org
> > 
> > Fixes: da1ce0670c14 "vfs: add cross-rename"
> > Signed-off-by: Mikhail Efremov <sem@altlinux.org>
> > ---
> >  fs/dcache.c | 27 +++++++++++++++++++--------
> >  1 file changed, 19 insertions(+), 8 deletions(-)
> > 
> > diff --git a/fs/dcache.c b/fs/dcache.c
> > index 7a5b514..3218570 100644
> > --- a/fs/dcache.c
> > +++ b/fs/dcache.c
> > @@ -2372,7 +2372,8 @@ void dentry_update_name_case(struct dentry *dentry, struct qstr *name)
> >  }
> >  EXPORT_SYMBOL(dentry_update_name_case);
> >  
> > -static void switch_names(struct dentry *dentry, struct dentry *target)
> > +static void switch_names(struct dentry *dentry, struct dentry *target,
> > +			 bool exchange)
> >  {
> >  	if (dname_external(target)) {
> >  		if (dname_external(dentry)) {
> > @@ -2404,11 +2405,21 @@ static void switch_names(struct dentry *dentry, struct dentry *target)
> >  			/*
> >  			 * Both are internal.
> >  			 */
> > -			unsigned int i;
> > -			BUILD_BUG_ON(!IS_ALIGNED(DNAME_INLINE_LEN, sizeof(long)));
> > -			for (i = 0; i < DNAME_INLINE_LEN / sizeof(long); i++) {
> > -				swap(((long *) &dentry->d_iname)[i],
> > -				     ((long *) &target->d_iname)[i]);
> > +			if (exchange) {
> > +				unsigned int i;
> > +
> > +				BUILD_BUG_ON(!IS_ALIGNED(DNAME_INLINE_LEN,
> > +							 sizeof(long)));
> > +				for (i = 0; i < DNAME_INLINE_LEN / sizeof(long);
> > +									i++) {
> > +					swap(((long *) &dentry->d_iname)[i],
> > +					     ((long *) &target->d_iname)[i]);
> > +				}
> > +			} else {
> > +				memcpy(dentry->d_iname, target->d_name.name,
> > +						target->d_name.len + 1);
> > +				dentry->d_name.len = target->d_name.len;
> > +				return;
> >  			}
> >  		}
> >  	}
> > @@ -2510,7 +2521,7 @@ static void __d_move(struct dentry *dentry, struct dentry *target,
> >  	list_del(&target->d_u.d_child);
> >  
> >  	/* Switch the names.. */
> > -	switch_names(dentry, target);
> > +	switch_names(dentry, target, exchange);
> >  	swap(dentry->d_name.hash, target->d_name.hash);
> >  
> >  	/* ... and switch the parents */
> > @@ -2649,7 +2660,7 @@ static void __d_materialise_dentry(struct dentry *dentry, struct dentry *anon)
> >  
> >  	dparent = dentry->d_parent;
> >  
> > -	switch_names(dentry, anon);
> > +	switch_names(dentry, anon, false);
> >  	swap(dentry->d_name.hash, anon->d_name.hash);
> >  
> >  	dentry->d_parent = dentry;
> > -- 
> > 1.8.5.5
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
WBR, Mikhail Efremov
