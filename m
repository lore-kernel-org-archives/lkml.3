Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965136Ab3DHKQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:16:38 -0400
Received: from intranet.asianux.com ([58.214.24.6]:9939 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935617Ab3DHKQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 06:16:34 -0400
X-Spam-Score: -100.7
Message-ID: <516298E0.9000905@asianux.com>
Date: Mon, 08 Apr 2013 18:16:00 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: module: strncpy issue, using strlcpy instead
 of strncpy
References: <51615AB0.9060502@asianux.com> <87r4ila8sb.fsf@rustcorp.com.au>
In-Reply-To: <87r4ila8sb.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月08日 13:30, Rusty Russell wrote:
> Chen Gang <gang.chen@asianux.com> writes:
>> >   ownername and namebuf are all NUL terminated string.
>> >
>> >   need always let them ended by '\0'.
>> >
>> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> > ---
>> >  kernel/module.c |    4 ++--
>> >  1 files changed, 2 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/kernel/module.c b/kernel/module.c
>> > index 3c2c72d..597efd8 100644
>> > --- a/kernel/module.c
>> > +++ b/kernel/module.c
>> > @@ -1283,7 +1283,7 @@ static const struct kernel_symbol *resolve_symbol(struct module *mod,
>> >  
>> >  getname:
>> >  	/* We must make copy under the lock if we failed to get ref. */
>> > -	strncpy(ownername, module_name(owner), MODULE_NAME_LEN);
>> > +	strlcpy(ownername, module_name(owner), MODULE_NAME_LEN);
> This should just be strcpy().
> 

  for me, either strcpy or strlcpy are ok.
    strcpy is quicker than strlcpy (in our case, it seems not quite important).
    strlcpy is more clearer to readers (they do not care about the buffer length again).

  since you prefer strcpy, I need respect your (the original maintainer's) willing.
  so I need change to strcpy.

  :-)


>> >  unlock:
>> >  	mutex_unlock(&module_mutex);
>> >  	return sym;
>> > @@ -3464,7 +3464,7 @@ const char *module_address_lookup(unsigned long addr,
>> >  	}
>> >  	/* Make a copy in here where it's safe */
>> >  	if (ret) {
>> > -		strncpy(namebuf, ret, KSYM_NAME_LEN - 1);
>> > +		strlcpy(namebuf, ret, KSYM_NAME_LEN);
> This isn't a bug, because the caller (kallsyms_lookup) puts a NUL in
> ret[KSYM_NAME_LEN].
> 

  originally, it is really not a bug (so subject need delete "strncpy issue").
  now, I still prefer to set tail '\0' in function module_address_lookup.
  future, if it is used by others, it is necessary to set tail '\0' in this function.



and for this patch, is it suitable to send patch v2 ?




> However, kallsyms_lookup also calls kallsyms_expand_symbol, which
> doesn't stop at KSYM_NAME_LEN, so if a name was longer than that we'd
> have a real bug.
> 
> Would you like to take a look at that, too?
> 

  it looks like a bug.  for me, I prefer to give length check for it.

  but I am sorry, now, I can not be sure whether it is really a bug.

    I have to need additional time resources to make sure about it.
      I am not quite familiar with kernel (especially kernel of kernel).
      I even do not know about kallsyms_names (it seems not a normal variable)
      I have to spend time resources to process other things within company.

  so I think I should make sure whether it is a bug, before 2013-4-20, is it ok ?

  welcome any suggestions or completions.


> Thanks,
> Rusty.
> 
> 


-- 
Chen Gang

Asianux Corporation
