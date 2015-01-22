Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846AbbAVN2B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 08:28:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832AbbAVN16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 08:27:58 -0500
Date: Thu, 22 Jan 2015 14:27:35 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Wang Nan <wangnan0@huawei.com>
Cc: rostedt@goodmis.org, jeremie.galarneau@efficios.com, bigeasy@linutronix.de,
        lizefan@huawei.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 2/2] perf: convert: fix duplicate field names and
 avoid reserved keywords.
Message-ID: <20150122132734.GB2473@krava.brq.redhat.com>
References: <1421904958-24106-1-git-send-email-wangnan0@huawei.com>
 <1421905003-24242-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1421905003-24242-1-git-send-email-wangnan0@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 01:36:43PM +0800, Wang Nan wrote:
> (If Steven Rostedt accept the previous patch which introduce a priv
>  field to 'struct format_field', we can use a relative simple method
>  for name conversion. If not , perf must track name conversion by
>  itself.)
> 
> Some parameters of syscall tracepoints named as 'nr', 'event', etc.
> When dealing with them, perf convert to ctf meets some problem:
> 
>  1. If a parameter with name 'nr', it will duplicate syscall's
>     common field 'nr'. One such syscall is io_submit().
> 
>  2. If a parameter with name 'event', it is denied to be inserted
>     because 'event' is a babeltrace keywork. One such syscall is
>     epoll_ctl.
> 
> This patch appends '_dupl_X' suffix to avoid problem 1, prepend a '_'
> prefix to avoid problem 2.

I've got compilation error:

util/data-convert-bt.c: In function ‘event_class_add_field’:
util/data-convert-bt.c:629:2: error: suggest parentheses around assignment used as truth value [-Werror=parentheses]
  while (t = bt_ctf_event_class_get_field_by_name(event_class, name)) {

what's your gcc version? mine's caught that..

[jolsa@krava perf]$ gcc --version
gcc (GCC) 4.8.3 20140911 (Red Hat 4.8.3-7)

SNIP

>  
> +/* If dup < 0, add a prefix. Else, add _dupl_X suffix. */
> +static char *change_name(char *name, char *orig_name, int dup)
> +{
> +	char *new_name = NULL;
> +	size_t len;
> +
> +	if (!name)
> +		name = orig_name;
> +
> +	if (dup >= 10)
> +		goto out;
> +
> +	if (dup < 0)
> +		len = strlen(name) + sizeof("_");
> +	else
> +		len = strlen(orig_name) + sizeof("_dupl_X");

if we allow for _dupl_10, should we use 'sizeof("_dupl_x")' ^^^ in here?

> +
> +	new_name = malloc(len);
> +	if (!new_name)
> +		goto out;
> +
> +	if (dup < 0)
> +		snprintf(new_name, len, "_%s", name);
> +	else
> +		snprintf(new_name, len, "%s_dupl_%d", orig_name, dup);
> +
> +out:
> +	if (name != orig_name)
> +		free(name);
> +	return new_name;

SNIP

> +
> +	name = field->name;
> +	while (t = bt_ctf_event_class_get_field_by_name(event_class, name)) {
> +		bt_ctf_field_type_put(t);
> +		name = change_name(name, field->name, dup++);
> +		if (!name) {
> +			pr_err("Failed to create dup name for '%s'\n", field->name);
> +			return -1;
> +		}
> +	}
> +
> +	ret = bt_ctf_event_class_add_field(event_class, type, name);
> +
> +	/* if failed, we may hit a keywork. try again with a '_' prefix */
> +	if (ret) {
> +		name = change_name(name, field->name, -1);
> +		if (!name) {
> +			pr_err("Failed to alloc name for '_%s'\n", field->name);
> +			return -1;
> +		}
> +		ret = bt_ctf_event_class_add_field(event_class, type, name);

so there's no other way on checking up with the blacklist right?

thanks,
jirka
