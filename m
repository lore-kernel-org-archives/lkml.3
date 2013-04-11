Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab3DKNkl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:40:41 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:34430 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab3DKNkk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:40:40 -0400
Date: Thu, 11 Apr 2013 09:40:29 -0400 (EDT)
From: Eric Paris <eparis@redhat.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Message-ID: <992669598.15460218.1365687629641.JavaMail.root@redhat.com>
In-Reply-To: <516637BB.90606@asianux.com>
References: <51653645.90401@asianux.com> <51653C7A.6030405@asianux.com> <2119919725.12278128.1365628773876.JavaMail.root@redhat.com> <516637BB.90606@asianux.com>
Subject: Re: [PATCH] kernel: auditfilter: looping issue, memory leak if has
 2 or more AUDIT_FILTERKEYs
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.5.82.11]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF20 (Linux)/8.0.3_GA_5664)
Thread-Topic: kernel: auditfilter: looping issue, memory leak if has 2 or more AUDIT_FILTERKEYs
Thread-Index: 63laQR1W3qViPt7WidLPQWQCOIY1xw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> On 2013年04月11日 05:19, Eric Paris wrote:
> > ----- Original Message -----
> > 
> >> >   b. has an new issue for AUDIT_DIR:
> >> >        after AUDIT_DIR succeed, it will set rule->tree.
> >> >        next, the other case fail, then will call audit_free_rule.
> >> >        but audit_free_rule will not free rule->tree.
> > Definitely a couple of leaks here...
> > 
> > I'm seeing leaks on size 8, 64, and 128.
> > 
> > Al, what do you think?  Should I be calling audit_put_tree() in the error
> > case if entry->tree != NULL?  The audit trees are some of the most complex
> > code in the kernel I think.
> > 
> > 
> 
>   can we add it in audit_free_rule ?
> 
>   maybe like this:
> 
> @@ -75,6 +75,8 @@ static inline void audit_free_rule(struct audit_entry *e)
>  	/* some rules don't have associated watches */
>  	if (erule->watch)
>  		audit_put_watch(erule->watch);
> +	if (erule->tree)
> +		audit_put_tree(erule->tree);
>  	if (erule->fields)
>  		for (i = 0; i < erule->field_count; i++) {
>  			struct audit_field *f = &erule->fields[i];

Where does the tree information get freed normally?  That's the code you need to run down.  You don't want to start getting double frees on the non-error case.  I'll try to dig into it if Al doesn't.  It's easy to show the leak on current kernels.

while(1)
    auditctl -a exit,always -w /etc -F auid=-1

