Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbbAWCxf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 21:53:35 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:2179 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015AbbAWCxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 21:53:31 -0500
Message-ID: <54C1B793.3020509@huawei.com>
Date: Fri, 23 Jan 2015 10:53:07 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: <jeremie.galarneau@efficios.com>, <rostedt@goodmis.org>,
        <bigeasy@linutronix.de>, <lizefan@huawei.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 2/2] perf: convert: fix duplicate field names and
 avoid reserved keywords.
References: <1421904958-24106-1-git-send-email-wangnan0@huawei.com> <1421905003-24242-1-git-send-email-wangnan0@huawei.com> <20150122132734.GB2473@krava.brq.redhat.com> <54C1AAA1.4000300@huawei.com>
In-Reply-To: <54C1AAA1.4000300@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.111.69.129]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/23 9:57, Wang Nan wrote:
> On 2015/1/22 21:27, Jiri Olsa wrote:
>> On Thu, Jan 22, 2015 at 01:36:43PM +0800, Wang Nan wrote:
>>> (If Steven Rostedt accept the previous patch which introduce a priv
>>>  field to 'struct format_field', we can use a relative simple method
>>>  for name conversion. If not , perf must track name conversion by
>>>  itself.)
>>>
>>> Some parameters of syscall tracepoints named as 'nr', 'event', etc.
>>> When dealing with them, perf convert to ctf meets some problem:
>>>
>>>  1. If a parameter with name 'nr', it will duplicate syscall's
>>>     common field 'nr'. One such syscall is io_submit().
>>>
>>>  2. If a parameter with name 'event', it is denied to be inserted
>>>     because 'event' is a babeltrace keywork. One such syscall is
>>>     epoll_ctl.
>>>
>>> This patch appends '_dupl_X' suffix to avoid problem 1, prepend a '_'
>>> prefix to avoid problem 2.
>>
>> I've got compilation error:
>>
>> util/data-convert-bt.c: In function ‘event_class_add_field’:
>> util/data-convert-bt.c:629:2: error: suggest parentheses around assignment used as truth value [-Werror=parentheses]
>>   while (t = bt_ctf_event_class_get_field_by_name(event_class, name)) {
>>
>> what's your gcc version? mine's caught that..
>>
> 
> I also curious why you got so many Werror problems I'm not ever seen,
> until I found a '-w' in my gcc options, which is introduced by your commit
> 
> 47810c1d429bc690e1f5e9467697538921962171: perf data: Disable Werror convert object.
> 
> I'll revert that commit in my tree.
> 
>> [jolsa@krava perf]$ gcc --version
>> gcc (GCC) 4.8.3 20140911 (Red Hat 4.8.3-7)
>>
>> SNIP
>>
>>>  
>>> +/* If dup < 0, add a prefix. Else, add _dupl_X suffix. */
>>> +static char *change_name(char *name, char *orig_name, int dup)
>>> +{
>>> +	char *new_name = NULL;
>>> +	size_t len;
>>> +
>>> +	if (!name)
>>> +		name = orig_name;
>>> +
>>> +	if (dup >= 10)
>>> +		goto out;
>>> +
>>> +	if (dup < 0)
>>> +		len = strlen(name) + sizeof("_");
>>> +	else
>>> +		len = strlen(orig_name) + sizeof("_dupl_X");
>>
>> if we allow for _dupl_10, should we use 'sizeof("_dupl_x")' ^^^ in here?
>>

We don't allow _dupl_10. If dup is 10 or larger (see above two if clause), this function will
return NULL.

>>> +
>>> +	new_name = malloc(len);
>>> +	if (!new_name)
>>> +		goto out;
>>> +
>>> +	if (dup < 0)
>>> +		snprintf(new_name, len, "_%s", name);
>>> +	else
>>> +		snprintf(new_name, len, "%s_dupl_%d", orig_name, dup);
>>> +
>>> +out:
>>> +	if (name != orig_name)
>>> +		free(name);
>>> +	return new_name;
>>
>> SNIP
>>
>>> +
>>> +	name = field->name;
>>> +	while (t = bt_ctf_event_class_get_field_by_name(event_class, name)) {
>>> +		bt_ctf_field_type_put(t);
>>> +		name = change_name(name, field->name, dup++);
>>> +		if (!name) {
>>> +			pr_err("Failed to create dup name for '%s'\n", field->name);
>>> +			return -1;
>>> +		}
>>> +	}
>>> +
>>> +	ret = bt_ctf_event_class_add_field(event_class, type, name);
>>> +
>>> +	/* if failed, we may hit a keywork. try again with a '_' prefix */
>>> +	if (ret) {
>>> +		name = change_name(name, field->name, -1);
>>> +		if (!name) {
>>> +			pr_err("Failed to alloc name for '_%s'\n", field->name);
>>> +			return -1;
>>> +		}
>>> +		ret = bt_ctf_event_class_add_field(event_class, type, name);
>>
>> so there's no other way on checking up with the blacklist right?
>>
> 
> AFAIK there's no official method to check blacklist right now. Utilizing existing
> functions to check blacklist is possible. For example, we can create a clock using
> bt_ctf_clock_create() with the checked name and then free it. However, it is hacky
> and I think you won't like it.
> 
> I believe my solution should be acceptable before babeltrace export its
> validate_identifier() function to users. Jérémie Galarneau, do you have better
> idea on it?
> 
> Thanks.
> 
>> thanks,
>> jirka
>>
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


