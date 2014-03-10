Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbaCJUBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 16:01:33 -0400
Received: from mail.efficios.com ([78.47.125.74]:41609 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbaCJUBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 16:01:31 -0400
Date: Mon, 10 Mar 2014 20:01:34 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Berg <johannes.berg@intel.com>
Message-ID: <241011797.35066.1394481694124.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140307151202.210588176@goodmis.org>
References: <20140307150920.881849073@goodmis.org> <20140307151202.210588176@goodmis.org>
Subject: Re: [for-next][PATCH 08/20] tracing: Warn if a tracepoint is not
 set via debugfs
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF27 (Linux)/8.0.5_GA_5839)
Thread-Topic: tracing: Warn if a tracepoint is not set via debugfs
Thread-Index: TGdXCPXNUKspyLS3EnyBSttBXw3/yg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Steven Rostedt" <rostedt@goodmis.org>
> To: linux-kernel@vger.kernel.org
> Cc: "Ingo Molnar" <mingo@kernel.org>, "Frederic Weisbecker" <fweisbec@gmail.com>, "Andrew Morton"
> <akpm@linux-foundation.org>, "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, "Johannes Berg"
> <johannes.berg@intel.com>
> Sent: Friday, March 7, 2014 10:09:28 AM
> Subject: [for-next][PATCH 08/20] tracing: Warn if a tracepoint is not set via debugfs
> 
> From: Steven Rostedt <rostedt@goodmis.org>
> 
> Tracepoints were made to allow enabling a tracepoint in a module before that
> module was loaded. When a tracepoint is enabled and it does not exist, the
> name is stored and will be enabled when the tracepoint is created.
> 
> The problem with this approach is that when a tracepoint is enabled when
> it expects to be there, it gives no warning that it does not exist.
> 
> To add salt to the wound, if a module is added and sets the FORCED flag,
> which
> can happen if it isn't signed properly, the tracepoint code will not enabled
> the tracepoints, but they will be created in the debugfs system! When a user
> goes to enable the tracepoint, the tracepoint code will not see it existing
> and will think it is to be enabled later AND WILL NOT GIVE A WARNING.
> 
> The tracing will look like it succeeded but will actually be doing nothing.
> This will cause lots of confusion and headaches for developers trying to
> figure out why they are not seeing their tracepoints.
> 
> Link: http://lkml.kernel.org/r/20140213154507.4040fb06@gandalf.local.home
> 
> Reported-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Reported-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/tracepoint.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> index 0d4ef26..0058f33 100644
> --- a/kernel/tracepoint.c
> +++ b/kernel/tracepoint.c
> @@ -62,6 +62,7 @@ struct tracepoint_entry {
>  	struct hlist_node hlist;
>  	struct tracepoint_func *funcs;
>  	int refcount;	/* Number of times armed. 0 if disarmed. */
> +	int enabled;	/* Tracepoint enabled */
>  	char name[0];
>  };
>  
> @@ -237,6 +238,7 @@ static struct tracepoint_entry *add_tracepoint(const char
> *name)
>  	memcpy(&e->name[0], name, name_len);
>  	e->funcs = NULL;
>  	e->refcount = 0;
> +	e->enabled = 0;
>  	hlist_add_head(&e->hlist, head);
>  	return e;
>  }
> @@ -316,6 +318,7 @@ static void tracepoint_update_probe_range(struct
> tracepoint * const *begin,
>  		if (mark_entry) {
>  			set_tracepoint(&mark_entry, *iter,
>  					!!mark_entry->refcount);
> +			mark_entry->enabled = !!mark_entry->refcount;
>  		} else {
>  			disable_tracepoint(*iter);
>  		}
> @@ -380,6 +383,8 @@ tracepoint_add_probe(const char *name, void *probe, void
> *data)
>  int tracepoint_probe_register(const char *name, void *probe, void *data)
>  {
>  	struct tracepoint_func *old;
> +	struct tracepoint_entry *entry;
> +	int ret = 0;
>  
>  	mutex_lock(&tracepoints_mutex);
>  	old = tracepoint_add_probe(name, probe, data);
> @@ -388,9 +393,13 @@ int tracepoint_probe_register(const char *name, void
> *probe, void *data)
>  		return PTR_ERR(old);
>  	}
>  	tracepoint_update_probes();		/* may update entry */
> +	entry = get_tracepoint(name);
> +	/* Make sure the entry was enabled */
> +	if (!entry || !entry->enabled)
> +		ret = -ENODEV;

Hi Steven,

Returning -ENODEV when the probe is still registered might come as a
surprise to the caller. For instance, a caller may dynamically allocate
name, probe, and/or data, it may want to free them when
tracepoint_probe_register returns an error. But this "-ENODEV" return value
is not really an error, and the parameters passed are still used.

If we go down this route, we might want at the very least to add documentation
of tracepoint_probe_register() return values and their meaning
in a comment on top of this function (perhaps also in the header). But
even if we do so, this weird return value semantic with respect to use of the
received parameters will likely cause memory corruption at some point.

Thoughts ?

Thanks,

Mathieu

>  	mutex_unlock(&tracepoints_mutex);
>  	release_probes(old);
> -	return 0;
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(tracepoint_probe_register);
>  
> --
> 1.8.5.3
> 
> 
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
