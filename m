Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161485Ab3DKOx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 10:53:28 -0400
Received: from intranet.asianux.com ([58.214.24.6]:13882 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936304Ab3DKOx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 10:53:26 -0400
X-Spam-Score: -100.8
Message-ID: <5166CE42.2080100@asianux.com>
Date: Thu, 11 Apr 2013 22:52:50 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel: auditfilter: looping issue, memory leak if has
 2 or more AUDIT_FILTERKEYs
References: <51653645.90401@asianux.com> <51653C7A.6030405@asianux.com> <2119919725.12278128.1365628773876.JavaMail.root@redhat.com> <516637BB.90606@asianux.com> <992669598.15460218.1365687629641.JavaMail.root@redhat.com> <5166C9DB.9030606@asianux.com>
In-Reply-To: <5166C9DB.9030606@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月11日 22:34, Chen Gang wrote:
> On 2013年04月11日 21:40, Eric Paris wrote:
>>>> >> >   can we add it in audit_free_rule ?
>>>> >> > 
>>>> >> >   maybe like this:
>>>> >> > 
>>>> >> > @@ -75,6 +75,8 @@ static inline void audit_free_rule(struct audit_entry *e)
>>>> >> >  	/* some rules don't have associated watches */
>>>> >> >  	if (erule->watch)
>>>> >> >  		audit_put_watch(erule->watch);
>>>> >> > +	if (erule->tree)
>>>> >> > +		audit_put_tree(erule->tree);
>>>> >> >  	if (erule->fields)
>>>> >> >  		for (i = 0; i < erule->field_count; i++) {
>>>> >> >  			struct audit_field *f = &erule->fields[i];
>> > Where does the tree information get freed normally?  That's the code you need to run down.  You don't want to start getting double frees on the non-error case.  I'll try to dig into it if Al doesn't.  It's easy to show the leak on current kernels.
>> > 

  oh.. it seems another issues need consider !!

    a. in function audit_remove_watch_rule, it does not set NULL for krule->watch.

    b. function audit_del_rule and audit_remove_watch_rule need lock protected.
         it seems we should call audit_del_rule in audit_free_rule.
           audit_del_rule will instead of audit_put_watch and audit_put_tree.
         but we need consider whether will cause dead lock !

       I will continue to see it.


>   I think:
>     it is in function audit_del_rule. when del, also set NULL.
>     so the deletion in audit_free_rule is safe.
>     the process of erule->watch and erule->tree are similar.
> 
>   please check, thanks.
> 
> 
>> > while(1)
>> >     auditctl -a exit,always -w /etc -F auid=-1
>> > 
>> > 
>> > 
>   it is valuable to me, thanks.
> 


-- 
Chen Gang

Asianux Corporation
