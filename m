Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbbAWUpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 15:45:46 -0500
Received: from mail.efficios.com ([78.47.125.74]:59992 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025AbbAWUpo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 15:45:44 -0500
Date: Fri, 23 Jan 2015 20:45:46 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: =?utf-8?B?SsOpcsOpbWll?= Galarneau 
	<jeremie.galarneau@efficios.com>
Cc: Wang Nan <wangnan0@huawei.com>, Jiri Olsa <jolsa@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Li Zefan <lizefan@huawei.com>, linux-kernel@vger.kernel.org
Message-ID: <1074266107.40857.1422045946295.JavaMail.zimbra@efficios.com>
In-Reply-To: <CA+jJMxu-QPVQTW0rSwUQH0dCy=mZo+0LimnPMVhOoJ9-ybc-9A@mail.gmail.com>
References: <20150120130609.GC15315@krava.brq.redhat.com> <1421810634-1373-1-git-send-email-wangnan0@huawei.com> <20150121141101.GA6835@krava.brq.redhat.com> <CA+jJMxtaEF587MyW00YQ_7d7BYmW-QpcgQ8g1KByYWwzMg-_cw@mail.gmail.com> <54C0547B.7000407@huawei.com> <CA+jJMxu-QPVQTW0rSwUQH0dCy=mZo+0LimnPMVhOoJ9-ybc-9A@mail.gmail.com>
Subject: Re: [PATCH 1/2] perf: convert: fix duplicate field names and avoid
 reserved keywords.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [173.246.22.116]
X-Mailer: Zimbra 8.0.7_GA_6021 (ZimbraWebClient - FF35 (Linux)/8.0.7_GA_6021)
Thread-Topic: perf: convert: fix duplicate field names and avoid reserved keywords.
Thread-Index: coiQeLP5ZsFK8rrUXWduzcGmRVB2Yw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Jérémie Galarneau" <jeremie.galarneau@efficios.com>
> To: "Wang Nan" <wangnan0@huawei.com>
> Cc: "Jiri Olsa" <jolsa@redhat.com>, "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>, "Li Zefan"
> <lizefan@huawei.com>, linux-kernel@vger.kernel.org, "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> Sent: Wednesday, January 21, 2015 10:14:16 PM
> Subject: Re: [PATCH 1/2] perf: convert: fix duplicate field names and avoid reserved keywords.
> 
> On Wed, Jan 21, 2015 at 8:38 PM, Wang Nan <wangnan0@huawei.com> wrote:
> > On 2015/1/21 23:56, Jérémie Galarneau wrote:
> >> On Wed, Jan 21, 2015 at 9:11 AM, Jiri Olsa <jolsa@redhat.com> wrote:
> >>> On Wed, Jan 21, 2015 at 11:23:54AM +0800, Wang Nan wrote:
> >>>> Some parameters of syscall tracepoints named as 'nr', 'event', etc.
> >>>> When dealing with them, perf convert to ctf meets some problem:
> >>>>
> >>>>  1. If a parameter with name 'nr', it will duplicate syscall's
> >>>>     common field 'nr'. One such syscall is io_submit().
> >>>>
> >>>>  2. If a parameter with name 'event', it is denied to be inserted
> >>>>     because 'event' is a babeltrace keywork. One such syscall is
> >>>>     epoll_ctl.
> >>>
> >>> hum, so this problem 2 is detectable only via
> >>> bt_ctf_event_class_add_field function?
> >>>
> >>> how big is the blaklist?
> >>>
> >>
> >> The blacklist is defined by the CTF specification here [1].
> >>
> >> Jérémie
> >>
> >> [1]
> >> http://git.efficios.com/?p=ctf.git;a=blob;f=common-trace-format-specification.txt;h=abe4fb70fff7f17f6e8242f313fb74bff44cf89a;hb=HEAD#l1477
> >
> > Is there any possibility that the someone expand the list?
> >
> 
> Good question. There is discussion around a v1.9 version of the CTF
> spec going on at the moment (which should not affect the Babeltrace
> API).
> 
> As far as I know, adding "__attribute__" has been discussed. CC'ing
> Mathieu Desnoyers who may have other extensions in mind.

I've had in mind adding an optional $ prefix to identifiers so they
don't clash with reserved keywords. This would have to go into a
CTF 1.9 though.

Meanwhile, validating that there are no identifier clash in babeltrace
seems like a good idea. Alternatively, prefixing all identifiers with
an underscore eliminates those clashes, and Babeltrace even strip those
underscore before printing, but since underscore is a character that
is allowed within keywords, this can bring interesting clash when
a keyword actually begins with an underscore, so I would like to
replace those by $.

Thoughts ?

Thanks,

Mathieu

> 
> Jérémie
> 
> >>
> >>> SNIP
> >>>
> >>>> +}
> >>>> +
> >>>>  static int add_tracepoint_fields_types(struct ctf_writer *cw,
> >>>>                                      struct format_field *fields,
> >>>>                                      struct bt_ctf_event_class
> >>>>                                      *event_class)
> >>>> @@ -577,6 +609,9 @@ static int add_tracepoint_fields_types(struct
> >>>> ctf_writer *cw,
> >>>>       for (field = fields; field; field = field->next) {
> >>>>               struct bt_ctf_field_type *type;
> >>>>               unsigned long flags = field->flags;
> >>>> +             struct bt_ctf_field_type *f = NULL;
> >>>> +             char *name;
> >>>> +             int dup = 1;
> >>>>
> >>>>               pr2("  field '%s'\n", field->name);
> >>>>
> >>>> @@ -595,14 +630,36 @@ static int add_tracepoint_fields_types(struct
> >>>> ctf_writer *cw,
> >>>>               if (flags & FIELD_IS_ARRAY)
> >>>>                       type = bt_ctf_field_type_array_create(type,
> >>>>                       field->arraylen);
> >>>>
> >>>> -             ret = bt_ctf_event_class_add_field(event_class, type,
> >>>> -                             field->name);
> >>>> +             /* Check name duplication */
> >>>> +             name = field->name;
> >>>
> >>> could you please put this in separated function like 'get_field_name(..)'
> >>> so we dont polute this function even more
> >>>
> >>>                 name == get_field_name(...)
> >>>                 if (!name)
> >>>                         error path
> >>>
> >>>
> >>> thanks,
> >>> jirka
> >>
> >>
> >>
> >
> >
> 
> 
> 
> --
> Jérémie Galarneau
> EfficiOS Inc.
> http://www.efficios.com
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
