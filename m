Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751018AbbAVDWH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 22:22:07 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:45212 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbbAVDV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 22:21:57 -0500
Message-ID: <54C06CBE.7080607@huawei.com>
Date: Thu, 22 Jan 2015 11:21:34 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: =?UTF-8?B?SsOpcsOpbWllIEdhbGFybmVhdQ==?= 
	<jeremie.galarneau@efficios.com>
CC: Jiri Olsa <jolsa@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Li Zefan <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 1/2] perf: convert: fix duplicate field names and avoid
 reserved keywords.
References: <20150120130609.GC15315@krava.brq.redhat.com>	<1421810634-1373-1-git-send-email-wangnan0@huawei.com>	<20150121141101.GA6835@krava.brq.redhat.com>	<CA+jJMxtaEF587MyW00YQ_7d7BYmW-QpcgQ8g1KByYWwzMg-_cw@mail.gmail.com>	<54C0547B.7000407@huawei.com> <CA+jJMxu-QPVQTW0rSwUQH0dCy=mZo+0LimnPMVhOoJ9-ybc-9A@mail.gmail.com>
In-Reply-To: <CA+jJMxu-QPVQTW0rSwUQH0dCy=mZo+0LimnPMVhOoJ9-ybc-9A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.111.69.129]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020201.54C06CD4.005B,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 8c0be398d45634712c36fef7ad4ab05b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/22 11:14, Jérémie Galarneau wrote:
> On Wed, Jan 21, 2015 at 8:38 PM, Wang Nan <wangnan0@huawei.com> wrote:
>> On 2015/1/21 23:56, Jérémie Galarneau wrote:
>>> On Wed, Jan 21, 2015 at 9:11 AM, Jiri Olsa <jolsa@redhat.com> wrote:
>>>> On Wed, Jan 21, 2015 at 11:23:54AM +0800, Wang Nan wrote:
>>>>> Some parameters of syscall tracepoints named as 'nr', 'event', etc.
>>>>> When dealing with them, perf convert to ctf meets some problem:
>>>>>
>>>>>  1. If a parameter with name 'nr', it will duplicate syscall's
>>>>>     common field 'nr'. One such syscall is io_submit().
>>>>>
>>>>>  2. If a parameter with name 'event', it is denied to be inserted
>>>>>     because 'event' is a babeltrace keywork. One such syscall is
>>>>>     epoll_ctl.
>>>>
>>>> hum, so this problem 2 is detectable only via bt_ctf_event_class_add_field function?
>>>>
>>>> how big is the blaklist?
>>>>
>>>
>>> The blacklist is defined by the CTF specification here [1].
>>>
>>> Jérémie
>>>
>>> [1] http://git.efficios.com/?p=ctf.git;a=blob;f=common-trace-format-specification.txt;h=abe4fb70fff7f17f6e8242f313fb74bff44cf89a;hb=HEAD#l1477
>>
>> Is there any possibility that the someone expand the list?
>>
> 
> Good question. There is discussion around a v1.9 version of the CTF
> spec going on at the moment (which should not affect the Babeltrace
> API).
> 

Since the blacklist is expanding, do you think babeltrace API should provide a mean to
notify users the reason about the failure, such as returning meanful error code instead
of -1, or exporting validate_identifier() to users?

> As far as I know, adding "__attribute__" has been discussed. CC'ing
> Mathieu Desnoyer who may have other extensions in mind.
> 
> Jérémie
> 
>>>
>>>> SNIP
>>>>
>>>>> +}
>>>>> +
>>>>>  static int add_tracepoint_fields_types(struct ctf_writer *cw,
>>>>>                                      struct format_field *fields,
>>>>>                                      struct bt_ctf_event_class *event_class)
>>>>> @@ -577,6 +609,9 @@ static int add_tracepoint_fields_types(struct ctf_writer *cw,
>>>>>       for (field = fields; field; field = field->next) {
>>>>>               struct bt_ctf_field_type *type;
>>>>>               unsigned long flags = field->flags;
>>>>> +             struct bt_ctf_field_type *f = NULL;
>>>>> +             char *name;
>>>>> +             int dup = 1;
>>>>>
>>>>>               pr2("  field '%s'\n", field->name);
>>>>>
>>>>> @@ -595,14 +630,36 @@ static int add_tracepoint_fields_types(struct ctf_writer *cw,
>>>>>               if (flags & FIELD_IS_ARRAY)
>>>>>                       type = bt_ctf_field_type_array_create(type, field->arraylen);
>>>>>
>>>>> -             ret = bt_ctf_event_class_add_field(event_class, type,
>>>>> -                             field->name);
>>>>> +             /* Check name duplication */
>>>>> +             name = field->name;
>>>>
>>>> could you please put this in separated function like 'get_field_name(..)'
>>>> so we dont polute this function even more
>>>>
>>>>                 name == get_field_name(...)
>>>>                 if (!name)
>>>>                         error path
>>>>
>>>>
>>>> thanks,
>>>> jirka
>>>
>>>
>>>
>>
>>
> 
> 
> 


