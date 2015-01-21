Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609AbbAUOLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 09:11:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269AbbAUOLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 09:11:25 -0500
Date: Wed, 21 Jan 2015 15:11:01 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Wang Nan <wangnan0@huawei.com>
Cc: jeremie.galarneau@efficios.com, bigeasy@linutronix.de, lizefan@huawei.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf: convert: fix duplicate field names and avoid
 reserved keywords.
Message-ID: <20150121141101.GA6835@krava.brq.redhat.com>
References: <20150120130609.GC15315@krava.brq.redhat.com>
 <1421810634-1373-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421810634-1373-1-git-send-email-wangnan0@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 11:23:54AM +0800, Wang Nan wrote:
> Some parameters of syscall tracepoints named as 'nr', 'event', etc.
> When dealing with them, perf convert to ctf meets some problem:
> 
>  1. If a parameter with name 'nr', it will duplicate syscall's
>     common field 'nr'. One such syscall is io_submit().
> 
>  2. If a parameter with name 'event', it is denied to be inserted
>     because 'event' is a babeltrace keywork. One such syscall is
>     epoll_ctl.

hum, so this problem 2 is detectable only via bt_ctf_event_class_add_field function?

how big is the blaklist?

SNIP

> +}
> +
>  static int add_tracepoint_fields_types(struct ctf_writer *cw,
>  				       struct format_field *fields,
>  				       struct bt_ctf_event_class *event_class)
> @@ -577,6 +609,9 @@ static int add_tracepoint_fields_types(struct ctf_writer *cw,
>  	for (field = fields; field; field = field->next) {
>  		struct bt_ctf_field_type *type;
>  		unsigned long flags = field->flags;
> +		struct bt_ctf_field_type *f = NULL;
> +		char *name;
> +		int dup = 1;
>  
>  		pr2("  field '%s'\n", field->name);
>  
> @@ -595,14 +630,36 @@ static int add_tracepoint_fields_types(struct ctf_writer *cw,
>  		if (flags & FIELD_IS_ARRAY)
>  			type = bt_ctf_field_type_array_create(type, field->arraylen);
>  
> -		ret = bt_ctf_event_class_add_field(event_class, type,
> -				field->name);
> +		/* Check name duplication */
> +		name = field->name;

could you please put this in separated function like 'get_field_name(..)'
so we dont polute this function even more

		name == get_field_name(...)
		if (!name)
			error path


thanks,
jirka
