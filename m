Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab3DWOYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 10:24:18 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:39938 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450Ab3DWOYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 10:24:17 -0400
Date: Tue, 23 Apr 2013 10:24:16 -0400 (EDT)
From: Eric Paris <eparis@redhat.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-audit@redhat.com
Message-ID: <748499455.6843018.1366727056683.JavaMail.root@redhat.com>
In-Reply-To: <87mwsrhtss.fsf@openvz.org>
References: <1364799600-10338-1-git-send-email-dmonakhov@openvz.org> <87mwsrhtss.fsf@openvz.org>
Subject: Re: [PATCH] audit: destroy filename correctly PING.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.12]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF20 (Linux)/8.0.3_GA_5664)
Thread-Topic: audit: destroy filename correctly PING.
Thread-Index: CHvReJwIZpTM99Pi0kcntBJ1tYNQXQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I picked it up for 3.10.  Sorry, should have said something.  Thanks!

-Eric

----- Original Message -----
> On Mon,  1 Apr 2013 11:00:00 +0400, Dmitry Monakhov <dmonakhov@openvz.org>
> wrote:
> Ping. Patch (https://lkml.org/lkml/2013/4/1/65) was not a 1'st April's joke.
> Add CC:linux-audit@redhat.com
> > filename should be destroyed via final_putname() instead of __putname()
> > Otherwise this result in following BUGON() in case of long names:
> >   kernel BUG at mm/slab.c:3006!
> >   Call Trace:
> >   kmem_cache_free+0x1c1/0x850
> >   audit_putname+0x88/0x90
> >   putname+0x73/0x80
> >   sys_symlinkat+0x120/0x150
> >   sys_symlink+0x16/0x20
> >   system_call_fastpath+0x16/0x1b
> > 
> > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> > ---
> >  kernel/auditsc.c |    6 +++---
> >  1 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > index a371f85..bfe7ca6 100644
> > --- a/kernel/auditsc.c
> > +++ b/kernel/auditsc.c
> > @@ -1010,7 +1010,7 @@ static inline void audit_free_names(struct
> > audit_context *context)
> >  	list_for_each_entry_safe(n, next, &context->names_list, list) {
> >  		list_del(&n->list);
> >  		if (n->name && n->name_put)
> > -			__putname(n->name);
> > +			final_putname(n->name);
> >  		if (n->should_free)
> >  			kfree(n);
> >  	}
> > @@ -2036,7 +2036,7 @@ void audit_putname(struct filename *name)
> >  	BUG_ON(!context);
> >  	if (!context->in_syscall) {
> >  #if AUDIT_DEBUG == 2
> > -		printk(KERN_ERR "%s:%d(:%d): __putname(%p)\n",
> > +		printk(KERN_ERR "%s:%d(:%d): final_putname(%p)\n",
> >  		       __FILE__, __LINE__, context->serial, name);
> >  		if (context->name_count) {
> >  			struct audit_names *n;
> > @@ -2047,7 +2047,7 @@ void audit_putname(struct filename *name)
> >  				       n->name, n->name->name ?: "(null)");
> >  			}
> >  #endif
> > -		__putname(name);
> > +		final_putname(name);
> >  	}
> >  #if AUDIT_DEBUG
> >  	else {
> > --
> > 1.7.1
> > 
> 
