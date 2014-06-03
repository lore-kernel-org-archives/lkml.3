Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100AbaFCDMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 23:12:16 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:17277 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752100AbaFCDMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 23:12:14 -0400
Date: Mon, 2 Jun 2014 23:12:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] tools lib traceevent: Add options to plugins
Message-ID: <20140602231205.56bf9312@gandalf.local.home>
In-Reply-To: <1400509775.1742.15.camel@leonhard>
References: <20140516140215.149535442@goodmis.org>
	<20140516140502.340008258@goodmis.org>
	<1400509775.1742.15.camel@leonhard>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2014 23:29:35 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> > - *   struct plugin_option PEVENT_PLUGIN_OPTIONS[] = {
> > + *   struct pevent_plugin_option PEVENT_PLUGIN_OPTIONS[] = {
> >   *	{
> >   *		.name = "option-name",
> >   *		.plugin_alias = "overide-file-name", (optional)
> > @@ -355,7 +355,7 @@ enum pevent_func_arg_type {
> >  enum pevent_flag {
> >  	PEVENT_NSEC_OUTPUT		= 1,	/* output in NSECS */
> >  	PEVENT_DISABLE_SYS_PLUGINS	= 1 << 1,
> > -	PEVENT_DISABLE_PLUGINS		= 1 << 2,
> > +	PEVENT_DISABLE_PLUGINS		= 1 << 2
> 
> Unnecessary change?

Hmm, no idea why I changed that.

 
> > +/**
> > + * traceevent_plugin_list_options - get list of plugin options
> > + *
> > + * Returns an array of char strings that list the currently registered
> > + * plugin options in the format of <plugin>:<option>. This list can be
> > + * used by toggling the option.
> > + *
> > + * Returns NULL if there's no options registered. On error it returns
> > + * an (char **)-1 (must check for that)
> 
> What about making it a macro like INVALID_OPTION_LIST?

Yeah, I could do this.

> 
> > + *
> > + * Must be freed with traceevent_plugin_free_options_list().
> > + */
> > +char **traceevent_plugin_list_options(void)
> > +{
> > +	struct registered_plugin_options *reg;
> > +	struct pevent_plugin_option *op;
> > +	char **list = NULL;
> > +	char *name;
> > +	int count = 0;
> > +
> > +	for (reg = registered_options; reg; reg = reg->next) {
> > +		for (op = reg->options; op->name; op++) {
> > +			char *alias = op->plugin_alias ? op->plugin_alias : op->file;
> > +
> > +			name = malloc(strlen(op->name) + strlen(alias) + 2);
> > +			if (!name)
> > +				goto err;
> > +
> > +			sprintf(name, "%s:%s", alias, op->name);
> > +			list = realloc(list, count + 2);
> > +			if (!list) {
> 
> This will lost the original list pointer.  Please use a temp variable.

Will fix.

> 
> 
> > +				free(name);
> > +				goto err;
> > +			}
> > +			list[count++] = name;
> > +			list[count] = NULL;
> > +		}
> > +	}
> > +	if (!count)
> > +		return NULL;
> > +	return list;
> 
> Isn't it enough to simply return the list?

Yep, will do.

> 
> > +
> > + err:
> > +	while (--count > 0)
> 
> Shouldn't it be >= instead of > ?
> 

Fixed.

Thanks,

-- Steve

> Thanks,
> Namhyung
> 
> 
> > +		free(list[count]);
> > +	free(list);
> > +
> > +	return (char **)((unsigned long)-1);
> > +}
> 

