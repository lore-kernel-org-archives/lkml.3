Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751011Ab3G0Ipl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 04:45:41 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60369 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888Ab3G0Ipg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 04:45:36 -0400
Date: Sat, 27 Jul 2013 10:45:28 +0200
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizefan@huawei.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] tracing: Shrink the size of struct
 ftrace_event_field
Message-ID: <20130727084528.GA6923@pd.tnic>
References: <51F08D1B.1080300@huawei.com>
 <51F08D4B.3010201@huawei.com>
 <1374851376.6580.34.camel@gandalf.local.home>
 <51F33F41.9040902@huawei.com>
 <1374896842.6580.44.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1374896842.6580.44.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 11:47:22PM -0400, Steven Rostedt wrote:
> On Sat, 2013-07-27 at 11:32 +0800, Li Zefan wrote:
>  
> >  struct event_filter {
> > diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> > index 7d85429..d72694d 100644
> > --- a/kernel/trace/trace_events.c
> > +++ b/kernel/trace/trace_events.c
> > @@ -106,6 +106,9 @@ trace_find_event_field(struct ftrace_event_call *call, char *name)
> >  	return __find_event_field(head, name);
> >  }
> >  
> > +/* detect bit-field overflow */
> > +#define VERIFY_SIZE(type) WARN_ON(type > field->type)
> > +
> 
> One small nit. Move this macro definition into the function itself,
> right above the macro usage. That way it will be much easier to review
> in the future, as people don't need to go search for VERIFY_SIZE(). It
> will be right there with the usage. The aesthetics may be a bit off, but
> at least the code will be obvious at first glance at what is happening,
> and I think that's more important than the "look" of the code.
> 
> Also, it will be obvious that the variable name must match the field
> name.
> 
> Thanks,
> 
> -- Steve
> 
> >  static int __trace_define_field(struct list_head *head, const char *type,
> >  				const char *name, int offset, int size,
> >  				int is_signed, int filter_type)
> > @@ -120,13 +123,16 @@ static int __trace_define_field(struct list_head *head, const char *type,
> >  	field->type = type;
> >  
> >  	if (filter_type == FILTER_OTHER)
> > -		field->filter_type = filter_assign_type(type);
> > -	else
> > -		field->filter_type = filter_type;
> > +		filter_type = filter_assign_type(type);
> >  
> > +	field->filter_type = filter_type;
> >  	field->offset = offset;
> >  	field->size = size;
> > -	field->is_signed = is_signed;
> > +	field->is_signed = !!is_signed;
> > +
> > +	VERIFY_SIZE(filter_type);
> > +	VERIFY_SIZE(offset);
> > +	VERIFY_SIZE(size);

Isn't this wrap-a-macro-with-another-more-obscure-macro not a bit too
much?

I mean,
  	WARN_ON(filter_type > field->filter_type)

is much more readable than VERIFY_SIZE IMO.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
