Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964915Ab3DPKiw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 06:38:52 -0400
Received: from intranet.asianux.com ([58.214.24.6]:10267 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab3DPKiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 06:38:50 -0400
X-Spam-Score: -100.8
Message-ID: <516D2A11.2080502@asianux.com>
Date: Tue, 16 Apr 2013 18:38:09 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel: auditfilter: looping issue, memory leak if has
 2 or more AUDIT_FILTERKEYs
References: <51653645.90401@asianux.com> <51653C7A.6030405@asianux.com> <2119919725.12278128.1365628773876.JavaMail.root@redhat.com> <516637BB.90606@asianux.com> <5167D6FC.3070504@asianux.com> <516D2718.2010205@asianux.com>
In-Reply-To: <516D2718.2010205@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月16日 18:25, Chen Gang wrote:
> On 2013年04月12日 17:42, Chen Gang wrote:
>> On 2013年04月11日 12:10, Chen Gang wrote:
>>> On 2013年04月11日 05:19, Eric Paris wrote:
>>>> ----- Original Message -----
>>>>
>>>>>>   b. has an new issue for AUDIT_DIR:
>>>>>>        after AUDIT_DIR succeed, it will set rule->tree.
>>>>>>        next, the other case fail, then will call audit_free_rule.
>>>>>>        but audit_free_rule will not free rule->tree.
>>>> Definitely a couple of leaks here...
>>>>
>>>> I'm seeing leaks on size 8, 64, and 128.
>>>>
>>>> Al, what do you think?  Should I be calling audit_put_tree() in the error case if entry->tree != NULL?  The audit trees are some of the most complex code in the kernel I think.
>>>>
>>>>

  oh, also need buffering optarg of auditctl under fedora 17.
  or "-F auid=-1" will be truncated to "-F auid".
  it is ok if not looping again. but in our case, we need loop again.

  to see memory usage, I think:
    in top, really used memory = 'used' - 'cached'
    it is enough for us.

  welcome any suggestions or completions.

  thanks.


> 
>   I am just testing about it with:
> 
> ---
> while(1)
>     auditctl -a exit,always -w /etc -F auid=-1
> ---
> 
>   under fedora 17, we need modify the auditctl source code:
>     a. let -w /etc can pass auditctl checking.
>     b. let loop infinitely in a process (if process quit, will free mem)
>     c. need fix a bug for auditctl (under Fedora 17)
>          audit_open may open 2 times.
>          when loop infinitely, it will cause resource handle leak.
> 
>   I have checked (by insert printf in kernel/auditfilter.c):
>     after modify the auditct, the work flow is just what we want to be.
>       (will alloc watch, alloc tree, then failure occurs)
> 
> 
>   I guess, we need 2-3 days to get a test result.
> 
> 
>   welcome any suggestions and completions.
> 
>   thanks.
> 
> 
> 
>>
>>   it seems, your way is the only executable way (if not change code much).
>>   what my original idea is incorrect.
>>
>>     we need add related code at failure process area in audit_data_to_entry.
>>     and another functions need not add these code (should not add).
>>     'watch' also need be processed, since audit_to_watch let ref count = 2.
>>       (it just like the function audit_del_rule has done)
>>
>>   please help check thanks.
>>
>>   :-)
>>
>>
>> diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
>> index 81f63f9..f5327ce 100644
>> --- a/kernel/auditfilter.c
>> +++ b/kernel/auditfilter.c
>> @@ -594,6 +594,10 @@ exit_nofree:
>>  	return entry;
>>  
>>  exit_free:
>> +	if (entry->rule.watch)
>> +		audit_put_watch(entry->rule.watch); /* matches initial get */
>> +	if (entry->rule.tree)
>> +		audit_put_tree(entry->rule.tree); /* that's the temporary one */
>>  	audit_free_rule(entry);
>>  	return ERR_PTR(err);
>>  }
>>
>>
>>
>>>
>>>   can we add it in audit_free_rule ?
>>>
>>>   maybe like this:
>>>
>>> @@ -75,6 +75,8 @@ static inline void audit_free_rule(struct audit_entry *e)
>>>  	/* some rules don't have associated watches */
>>>  	if (erule->watch)
>>>  		audit_put_watch(erule->watch);
>>> +	if (erule->tree)
>>> +		audit_put_tree(erule->tree);
>>>  	if (erule->fields)
>>>  		for (i = 0; i < erule->field_count; i++) {
>>>  			struct audit_field *f = &erule->fields[i];
>>>
>>>
>>>   thanks.
>>>
>>>   :-)
>>>
>>
>>
> 
> 


-- 
Chen Gang

Asianux Corporation
